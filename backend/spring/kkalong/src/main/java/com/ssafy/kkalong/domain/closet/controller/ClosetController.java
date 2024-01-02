package com.ssafy.kkalong.domain.closet.controller;

import com.ssafy.kkalong.common.api.Api;
import com.ssafy.kkalong.common.error.ErrorCode;
import com.ssafy.kkalong.common.util.FileNameGenerator;
import com.ssafy.kkalong.domain.closet.dto.request.ClosetCreateRequest;
import com.ssafy.kkalong.domain.closet.dto.request.ClosetUpdateRequest;
import com.ssafy.kkalong.domain.closet.dto.request.SectionCreateRequestItem;
import com.ssafy.kkalong.domain.closet.dto.response.*;
import com.ssafy.kkalong.domain.closet.entity.Closet;
import com.ssafy.kkalong.domain.closet.entity.Section;
import com.ssafy.kkalong.domain.closet.service.ClosetService;
import com.ssafy.kkalong.domain.member.entity.Member;
import com.ssafy.kkalong.domain.member.service.MemberService;
import com.ssafy.kkalong.domain.sort.entity.Sort;
import com.ssafy.kkalong.domain.sort.service.SortService;
import com.ssafy.kkalong.fastapi.FastApiService;
import com.ssafy.kkalong.fastapi.dto.RequestRembgRes;
import com.ssafy.kkalong.s3.S3Service;
import io.swagger.v3.oas.annotations.Operation;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/closet")
public class ClosetController {
    //    http://localhost:8761/api/closet
    @Autowired
    private ClosetService closetService;
    @Autowired
    private MemberService memberService;
    @Autowired
    private S3Service s3Service;
    @Autowired
    private FastApiService fastApiService;

    @Autowired
    private SortService sortService;



    //옷장 상세정보 및 소속구역 리스트 보기
    @GetMapping("/{closetSeq}")
    @Operation(summary = "옷장 상세정보 및 소속구역 리스트 보기")
    public Api<Object> getClosetDetail(@PathVariable int closetSeq) {
        //0.회원확인
        Member member = memberService.getLoginUserInfo();
        if (member == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "회원이아닙니다!");
        }
        //1.유효성검사를하기(옷장이있는지 확인하기)
        Closet closet = closetService.findCloset(closetSeq);
        if (closet == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "유효하지않은 옷장일련번호입니다!");
        }

        //2.찾은옷장이랑 옷장 주인이 맞는지,로그인된 회원이랑 옷장주인이 맞는지 확인하기
        int memberSeq = member.getMemberSeq();
        if (memberSeq != closet.getMember().getMemberSeq()) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "로그인된회원이 옷장 소유주와 다릅니다!");
        }

        //3.리스트(섹션)가지고오기
        List<Section> sections = closetService.findSection(closetSeq);
        List<SectionResponse> result = new ArrayList<>();

//        List<ClosetGetDetailResponse> closetGetDetailResponses = new ArrayList<>();

        for (Section section : sections) {
            SectionResponse sectionResponse = SectionResponse.builder()
                    .sectionSeq(section.getSectionSeq())
                    .sectionName(section.getSectionName())
                    .sortSeq(section.getSort().getSortSeq())
                    .sort(section.getSort().getSort())
                    .build();
            result.add(sectionResponse);

        }
        ClosetGetDetailResponse closetGetDetailResponse = new ClosetGetDetailResponse();
        closetGetDetailResponse.setClosetName(closet.getClosetName());

        String filepath = "closet/" + closet.getClosetImgName();

        String imgUrl = s3Service.generatePresignedUrl(filepath);

        closetGetDetailResponse.setClosetPictureUrl(imgUrl);

        closetGetDetailResponse.setClosetSectionList(result);

        return Api.OK(closetGetDetailResponse);

    }


    @GetMapping("")
    @Operation(summary = "옷장 목록 보기")
    public Api<Object> getCloset() {
        Member member = memberService.getLoginUserInfo(); //멤버를 반환해주는거(서비스에서 작성된것)
        if (member == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "회원이아닙니다!");
        }
        int memberSeq = member.getMemberSeq();  //멤버의 일련번호 받아오는 과정

        List<Closet> closets = closetService.findClosetsByMemberSeq(memberSeq); //이게 클로셋 리스폰스
        List<ClosetResponse> result = new ArrayList<>();       //클로젯의 리스트 반환해줄 리스트

        for (Closet closet : closets) {
            String fileName = closet.getClosetImgName();
            if (fileName != null && !fileName.isEmpty()) {
                // 파일 경로를 정확히 지정해야 합니다. "closet/"는 가정한 폴더 경로입니다.
                String filePath = "closet/" + fileName;
                String url = s3Service.generatePresignedUrl(filePath);
                ClosetResponse closetResponse = ClosetResponse.builder()
                        .closetSeq(closet.getClosetSeq()) // 옷장인덱스
                        .closetPictureUrl(url) // 옷장사진 url
                        .build();
                result.add(closetResponse);
            } else {
                // 파일 이름이 없는 경우에 대한 처리
                ClosetResponse closetResponse = ClosetResponse.builder()
                        .closetSeq(closet.getClosetSeq()) // 옷장인덱스
                        .closetPictureUrl(null) // 혹은 적절한 기본 이미지 URL을 설정
                        .build();
                result.add(closetResponse);
            }
        }
        return Api.OK(result);

    }



    @PostMapping("")
    @Operation(summary = "옷장등록")
    public Api<Object> createClosetPrac(MultipartFile file, ClosetCreateRequest closetCreateRequest){ //ClosetCreateRequest 타입의 객체를 매개변수로 받아 처리
        System.out.println(closetCreateRequest.toString());
        Member member = memberService.getLoginUserInfo(); //현재 로그인한 사용자의 정보를 가져오기 위해 memberService의 getLoginUserInfo 메소드를 호출

        if (member == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "회원이아닙니다!");
        }
        String s3imgUrl="";
        String fileName="";
        //옷장 사진파일에 대한 유효성검사 해주기(1)
        if (!file.isEmpty()) {

            if ("jpg".equalsIgnoreCase(FilenameUtils.getExtension(file.getOriginalFilename()))) {
                // S3에 저장할 파일 이름을 생성
                fileName= FileNameGenerator.generateFileName("closet", member.getMemberId(), "png");
                String filePath = "closet/" + fileName;

                // 배경 제거 API에 요청을 보내 처리된 이미지를 받습니다.
                Api<Object>result = fastApiService.requestRembg(member.getMemberId(),file);
                RequestRembgRes reRes = (RequestRembgRes)result.getBody();

                // S3에 배경이 제거된 이미지를 업로드합니다.
                s3Service.uploadFile(filePath,reRes.getNoBg());

                // 프론트엔드에서 접근 가능한 S3 이미지 URL을 생성합니다.
                s3imgUrl = s3Service.generatePresignedUrl(filePath);

            }
            else {
                return Api.ERROR(ErrorCode.BAD_REQUEST, "지원하지 않는 파일 형식입니다.");
            }
        } else {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "업로드된 파일이 없습니다.");
        }

        //옷장 상세종류 인덱스 유효성검사(2)
        List<SectionCreateRequestItem> list = closetCreateRequest.getClosetSectionList();
        for (SectionCreateRequestItem closetList : list){
            Sort sort = sortService.getSort(closetList.getSort());
            if (sort == null){
                return Api.ERROR(ErrorCode.BAD_REQUEST, String.format("[%s]은/는 유호하지 않는 옷장섹션 종류입니다. 선반,행거,박스,수납장 중에서 보내주세요.", closetList.getSort()));
            }
        }
        //1.옷장 엔티티를 만들어서 db에 넣는작업(로직은 service에서 만들기)
        Closet closetSave = closetService.createCloset(closetCreateRequest,member,fileName);

        //2.섹션 db 넣기
        List<Section> sectionList = closetService.createSection(closetCreateRequest.getClosetSectionList(),closetSave);
        List<SectionSaveResponse> sectionSaveResponseList = new ArrayList<>();
        for (Section item : sectionList){
            sectionSaveResponseList.add(new SectionSaveResponse(item));
        }

        ClosetSaveResponse closetSaveResponse = new ClosetSaveResponse();
        closetSaveResponse.setClosetSeq(closetSave.getClosetSeq());
        closetSaveResponse.setMemberId(closetSave.getMember().getMemberId());
        closetSaveResponse.setClosetName(closetSave.getClosetName());
        closetSaveResponse.setClosetPictureUrl(s3imgUrl);
        closetSaveResponse.setClosetSectionList(sectionSaveResponseList);
        closetSaveResponse.setClosetRegData(closetSave.getClosetRegData());
        closetSaveResponse.setMembernickname(closetSave.getMember().getMemberNickname());

        return Api.OK(closetSaveResponse);

    }


    // 옷장 정보 수정
    @PutMapping("")
    @Operation(summary = "옷장 정보 수정")
    public Api<Object> putCloset(@RequestParam(required = false) MultipartFile file,@ModelAttribute ClosetUpdateRequest closetUpdateRequest) {
        //사용자 정보가 없으면 에러 메시지를 반환합니다.
        Member member = memberService.getLoginUserInfo();
        if (member == null) {

            return Api.ERROR(ErrorCode.BAD_REQUEST, "로그인이 필요합니다.");
        }
        //00

        //1.유효성검사를하기(옷장이있는지 확인하기)
        Closet closet = closetService.findCloset(closetUpdateRequest.getClosetSeq());
        if (closet == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "유효하지않은 옷장일련번호입니다!");
        }
        //00

        //2.찾은옷장이랑 옷장 주인이 맞는지,로그인된 회원이랑 옷장주인이 맞는지 확인하기
        int memberSeq = member.getMemberSeq();
        if (memberSeq != closet.getMember().getMemberSeq()) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "로그인된회원이 옷장 소유주와 다릅니다!");
        }



        // 옷장 이름 변경 처리
        if (!closet.getClosetName().equals(closetUpdateRequest.getClosetName())) {
            closet.setClosetName(closetUpdateRequest.getClosetName());
        }


        String fileName="";
        //옷장 사진파일에 대한 유효성검사 해주기(1)
        if (file != null && !file.isEmpty()) {

            if ("jpg".equalsIgnoreCase(FilenameUtils.getExtension(file.getOriginalFilename()))) {
                // S3에 저장할 파일 이름을 생성
                fileName= FileNameGenerator.generateFileName("closet", member.getMemberId(), "png");
                String filePath = "closet/" + fileName;

                // 배경 제거 API에 요청을 보내 처리된 이미지를 받습니다.
                Api<Object>result = fastApiService.requestRembg(member.getMemberId(),file);
                RequestRembgRes reRes = (RequestRembgRes)result.getBody();

                // S3에 배경이 제거된 이미지를 업로드합니다.
                s3Service.uploadFile(filePath,reRes.getNoBg());

                // 프론트엔드에서 접근 가능한 S3 이미지 URL을 생성합니다.

                closet.setClosetImgName(fileName);

            }
            else {
                return Api.ERROR(ErrorCode.BAD_REQUEST, "지원하지 않는 파일 형식입니다.");
            }
        }
        String filePath = "closet/" + closet.getClosetImgName();
        String s3imgUrl = s3Service.generatePresignedUrl(filePath);


        // 옷장 정보를 업데이트하는 로직을 호출합니다.
        Closet updatedCloset = closetService.updateCloset(closet);
        //추가
        closetService.createSection(closetUpdateRequest.getClosetSectionAddList(),updatedCloset);
        closetService.deleteSection(closetUpdateRequest.getClosetSectionDeleteList(),updatedCloset,member);
        closetService.updateSection(closetUpdateRequest.getClosetSectionUpdateList(),updatedCloset);

        List<Section>sectionList = closetService.findSection(updatedCloset.getClosetSeq());
        List<SectionSaveResponse> sectionSaveResponseList = new ArrayList<>();
        for (Section item : sectionList){
            SectionSaveResponse sectionSaveResponse = new SectionSaveResponse(item);
            sectionSaveResponseList.add(sectionSaveResponse);
        }
        ClosetSaveResponse closetSaveResponse = new ClosetSaveResponse();

        closetSaveResponse.setClosetSeq(updatedCloset.getClosetSeq());
        closetSaveResponse.setMemberId(updatedCloset.getMember().getMemberId());
        closetSaveResponse.setClosetName(updatedCloset.getClosetName());
        closetSaveResponse.setClosetPictureUrl(s3imgUrl);
        closetSaveResponse.setClosetSectionList(sectionSaveResponseList);
        closetSaveResponse.setClosetRegData(updatedCloset.getClosetRegData());
        closetSaveResponse.setMembernickname(updatedCloset.getMember().getMemberNickname());


        return Api.OK(closetSaveResponse);
    }

    // 옷장 삭제
    @PutMapping("/{closetSeq}")
    @Operation(summary = "옷장 삭제")
    public Api<Object> deleteCloset(@PathVariable int closetSeq) {
        Member member = memberService.getLoginUserInfo();
        if (member == null) {

            return Api.ERROR(ErrorCode.BAD_REQUEST, "로그인이 필요합니다.");
        }
        //1.유효성검사를하기(옷장이있는지 확인하기)
        Closet closet = closetService.findCloset(closetSeq);
        if (closet == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "유효하지않은 옷장일련번호입니다!");
        }

        //2.찾은옷장이랑 옷장 주인이 맞는지,로그인된 회원이랑 옷장주인이 맞는지 확인하기
        int memberSeq = member.getMemberSeq();
        if (memberSeq != closet.getMember().getMemberSeq()) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "로그인된회원이 옷장 소유주와 다릅니다!");
        }

        closetService.deleteCloset(closet);


        return Api.OK(String.format("옷장(%s)이/가 삭제 되었습니다",closet.getClosetName()));

    }

    @GetMapping("/list")
    @Operation(summary = "옷장 목록 보기")
    public Api<Object> getClosetList() {
        //1. 유효성검사 (로그인된 회원인지)
        Member member = memberService.getLoginUserInfo(); //멤버를 반환해주는거(서비스에서 작성된것)
        if (member == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "회원이아닙니다!");
        }
        int memberSeq = member.getMemberSeq();  //멤버의 일련번호 받아오는 과정

        //2. reponse로 전달해야한게 list인 seq,name <=이것만 들어가는 response dto를 생성
        List<ClosetListResponse> result = new ArrayList<>();

        //3. service에서 조회를 해야함
        List<Closet> closets = closetService.findClosetsByMemberSeq(memberSeq);

        for (Closet closet : closets){
            String closetName = closet.getClosetName();
            int closetSeq = closet.getClosetSeq();
            ClosetListResponse closetListResponse = ClosetListResponse.builder()
                    .seq(closetSeq)
                    .name(closetName)
                    .build();
            result.add(closetListResponse);

        }

        return Api.OK(result);

    }

    @GetMapping("/list/{closetSeq}")
    @Operation(summary = "해당 옷장 소속구역 보기")
    public Api<Object> getClosetSectionList(@PathVariable int closetSeq) {
        // 위에랑 똑같은데 유효성 검사 하나더 해줘야함
        // closet seq에 대한 유효성 검사를 해줘야함 총 2개
        Member member = memberService.getLoginUserInfo(); //멤버를 반환해주는거(서비스에서 작성된것)
        if (member == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "회원이아닙니다!");
        }
        int memberSeq = member.getMemberSeq();  //멤버의 일련번호 받아오는 과정

        Closet closet = closetService.findCloset(closetSeq);
        if (closet == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "유효하지않은 옷장일련번호입니다!");
        }

        if (memberSeq != closet.getMember().getMemberSeq()) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "로그인된회원이 옷장 소유주와 다릅니다!");
        }

        // service 41번줄을 사용해서 리스트를 섹션을 가지고오면
        List<Section> sections = closetService.findSection(closetSeq);
        List<ClosetListResponse> result = new ArrayList<>();

        for (Section section : sections){
            int seq = section.getSectionSeq();
            String name = section.getSectionName();
            ClosetListResponse closetListResponse = ClosetListResponse.builder()
                    .seq(seq)
                    .name(name)
                    .build();
            result.add(closetListResponse);

        }

        return Api.OK(result);

    }



}
