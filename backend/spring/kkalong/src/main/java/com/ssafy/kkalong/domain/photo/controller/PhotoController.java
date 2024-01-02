package com.ssafy.kkalong.domain.photo.controller;

import com.ssafy.kkalong.common.api.Api;
import com.ssafy.kkalong.common.api.Result;
import com.ssafy.kkalong.common.error.ErrorCode;
import com.ssafy.kkalong.common.util.FileNameGenerator;
import com.ssafy.kkalong.domain.cloth.entity.Cloth;
import com.ssafy.kkalong.domain.cloth.service.ClothService;
import com.ssafy.kkalong.domain.member.entity.Member;
import com.ssafy.kkalong.domain.member.service.MemberService;
import com.ssafy.kkalong.domain.photo.dto.request.PhotoMixRequestReq;
import com.ssafy.kkalong.domain.photo.dto.response.PhotoMixRequestRes;
import com.ssafy.kkalong.domain.photo.dto.response.PhotoRes;
import com.ssafy.kkalong.domain.photo.dto.response.SavePhotoRes;
import com.ssafy.kkalong.domain.photo.entity.Photo;
import com.ssafy.kkalong.domain.photo.service.PhotoService;
import com.ssafy.kkalong.fastapi.FastApiCallerService;
import com.ssafy.kkalong.fastapi.FastApiService;
import com.ssafy.kkalong.fastapi.dto.RequestRembgRes;
import com.ssafy.kkalong.fastapi.dto.RequestVitonRes;
import com.ssafy.kkalong.s3.S3Service;
import io.swagger.v3.oas.annotations.Parameter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.*;

@RestController
@Slf4j
@RequestMapping("/api/photo")
public class PhotoController {
    @Autowired
    private S3Service s3Service;
    @Autowired
    private FastApiService fastApiService;
    @Autowired
    private FastApiCallerService fastApiCallerService;
    @Autowired
    private MemberService memberService;
    @Autowired
    private PhotoService photoService;
    @Autowired
    private ClothService clothService;

    // 1. 사용자 인증 정보를 확인한다.
    // 2. 사진을 저장한다.
    // 3. Rembg를 호출한다.
    // 4. 성공을 반환한다.
    @PostMapping("")
    @Operation(summary = "AI용 원본 사진 저장")
    public Api<Object> savePhotoOriginal(
            @Parameter(description = "전송할 파일", required = true) @RequestPart MultipartFile multipartFile) {
        // 사용자 유효성 검사
        Member member = memberService.getLoginUserInfo();
        if (member == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "유효하지 않은 사용자 정보입니다");
        }

        // 파일 유효성 검사
        if (multipartFile == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "파일을 보내주십시오");
        }
        // 확장자 유효성 검사
        String extension = multipartFile.getContentType();
        if (extension != null && !extension.equals("image/jpeg") && !extension.equals("image/jpg")) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "유효한 확장자가 아닙니다");
        }
        System.out.println("유효성 검사 완료");
        // key 생성
        // photo_소유자아이디_현재시간_무작위숫자6개
        String fileName = FileNameGenerator.generateFileNameNoExtension("photo", member.getMemberId());
        System.out.println("fileName: " + fileName);
        // 저장할 장소 지정
        String path = "photo/original/";

        // S3서버에 사진을 저장
        try {
            String res = s3Service.uploadFile(path + fileName + ".jpg", multipartFile);
            System.out.println(res);
        } catch (IOException e) {
            return Api.ERROR(ErrorCode.SERVER_ERROR, "업로드 실패");
        }
        System.out.println("저장 완료");
        // rembg 호출
        Api<Object> rembgRes = fastApiService.requestRembg(member.getMemberId(), multipartFile);
        if (!Objects.equals(rembgRes.getResult().getResultCode(), Result.OK().getResultCode())) {
            return Api.ERROR(ErrorCode.SERVER_ERROR, "내부 처리중 문제가 발생 했습니다.(Rembg)");
        }
        // rembg 결과 저장
        RequestRembgRes res;
        try {
            res = (RequestRembgRes) rembgRes.getBody();
            s3Service.uploadFile("photo/yes_bg/" + fileName + ".jpg", res.getYesBg());
            s3Service.uploadFile("photo/no_bg/" + fileName + ".png", res.getNoBg());
        } catch (Exception e) {
            return Api.ERROR(ErrorCode.SERVER_ERROR, "저장 중 문제가 발생 했습니다.(Rembg)");
        }
        System.out.println("rembg 완료");

        Photo photo = new Photo();
        photo.setMember(member);
        photo.setPhotoImgName(fileName);
        photo.setPhotoImgYesBg(true);
        photo.setPhotoImgNoBg(true);
        photo.setPhotoImgMasking(true);
        photo.setPhotoImgOpenpose(false);
        photo.setPhotoJsonOpenpose(false);

        // DB에 저장
        Photo photoResult = photoService.savePhoto(photo);
        System.out.println("DB 저장 완료");

        // 비동기로 openpose, cihp 호출
        fastApiCallerService.callOpenpose(member, photoResult);
        fastApiCallerService.callCihp(member, photoResult);
        System.out.println("비동기 호출 완료");

        return Api.OK(new SavePhotoRes("저장 성공", photoResult.getPhotoSeq()));
    }

    // 1. 사용자 인증 정보를 확인한다
    // 2. DB에서 사용자의 모든 사진 정보를 가져온다
    // 3. 사진별로 s3에서 사진용 url을 받아온다
    // 4. 반환한다
    @GetMapping("")
    @Operation(summary = "AI용 내 사진 리스트 조회")
    public Api<Object> getPhotoList() {
        // 사용자 유효성 검사
        Member member = memberService.getLoginUserInfo();
        if (member == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "유효하지 않은 사용자 정보입니다");
        }

        // DB에서 사용자의 모든 삭제되지 않은 사진 정보 가져오기
        List<Photo> photoList = photoService.getPhotoList(member);
        // s3에서 사진별 url 가져오기
        List<PhotoRes> photoResList = new ArrayList<>();
        if (photoList == null) {
            return Api.OK(photoResList);
        }
        for (Photo p : photoList) {
            String url = s3Service.generatePresignedUrl("photo/no_bg/" + p.getPhotoImgName() + ".png");
            boolean isPreprocessed = p.isPhotoJsonOpenpose() && p.isPhotoImgOpenpose() && p.isPhotoImgMasking();
            PhotoRes pRes = PhotoRes.toRes(p, url, isPreprocessed);
            photoResList.add(pRes);
        }
        return Api.OK(photoResList);
    }

    // 1. 사용자의 인증 정보를 확인한다
    // 2. DB에서 해당 사진의 데이터를 가져온다.
    // 3. s3에서 사진의 url을 받아온다
    // 4. 반환한다.
    @GetMapping("/{photoSeq}")
    @Operation(summary = "AI용 특정 사진 조회")
    public Api<Object> getPhotoListBySeq(
            @Parameter(description = "요청할 photo의 Seq값", required = true) @PathVariable int photoSeq) {
        // 사용자 유효성 검사
        Member member = memberService.getLoginUserInfo();
        if (member == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "유효하지 않은 사용자 정보입니다");
        }

        Photo photo = photoService.getPhotoBySeq(photoSeq);
        System.out.println(photo);
        if (photo == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "해당하는 번호의 옷이 존재하지 않습니다.");
        }
        // 전처리가 되어 있는지 확인
        boolean isPreprocessed = photo.isPhotoJsonOpenpose() && photo.isPhotoImgOpenpose() && photo.isPhotoImgMasking();

        String url = s3Service.generatePresignedUrl("photo/no_bg/" + photo.getPhotoImgName() + ".png");
        PhotoRes photoRes = PhotoRes.toRes(photo, url, isPreprocessed);

        return Api.OK(photoRes);
    }

    // 1. 사용자의 인증정보를 확인한다.
    // 2. DB에서 해당 사진을 삭제됨을 1로 한다.
    // 3. 성공을 반환한다.
    @PutMapping("/{photoSeq}")
    @Operation(summary = "AI용 내 사진 삭제")
    public Api<Object> deletePhotoBySeq(
            @Parameter(description = "삭제할 photo의 Seq", required = true) @PathVariable int photoSeq) {
        // 사용자 유효성 검사
        Member member = memberService.getLoginUserInfo();
        if (member == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "유효하지 않은 사용자 정보입니다");
        }
        // 사진 존재 유무 확인
        Photo photo = photoService.getPhotoBySeq(photoSeq);
        if (photo == null || photo.getMember().getMemberSeq() != member.getMemberSeq()) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "유효하지 않은 사진 정보입니다");
        }

        // 사진 삭제 요청
        if (!photoService.deletePhotoBySeq(photo)) {
            return Api.ERROR(ErrorCode.DENIED_ERROR, "요청이 거부 되었습니다");
        }

        return Api.OK("성공");
    }

    // 1. 사용자의 인증정보를 확인한다.
    // 2. DB에서 전처리 여부를 확인한다.
    // 2.1. 전처리가 되어 있지 않다면 전처리 api를 호출하고 실패를 반환한다.
    // 3. viton를 호출한다.
    // 4. viton이 완료 되면 성공을 반환한다.
    @PostMapping("/mix")
    @Operation(summary = "합성 요청")
    public Api<Object> PhotoMixRequest(PhotoMixRequestReq req) {
        System.out.println("PhotoMixRequest called");
        // 1. 사용자 및 요청 파일 유효성 검사
        Member member = memberService.getLoginUserInfo();
        if (member == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "유효하지 않은 사용자 정보입니다");
        }
        Photo photo = photoService.getPhotoBySeq(req.getPhotoSeq());
        Cloth cloth = clothService.getCloth(req.getClothSeq());

        // photo가 존재하는지와 요청자와 같은 아이디인지 체크
        if (photo == null || !member.getMemberId().equals(photo.getMember().getMemberId())) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "요청자의 소유한 사진이 아니거나 사진이 존재하지 않습니다");
        }
        // cloth가 존재하는지, 접근 가능한 옷(내 옷이거나 공개된 옷)인지 체크
        if (cloth == null || !(cloth.getMember().getMemberId().equals(member.getMemberId()) || !cloth.isPrivate())) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "해당 옷에 접근 권한이 없거나 옷이 존재하지 않습니다");
        }
        System.out.println("요청 인증 확인 완료");

        // 2. DB에서 전처리 여부 가져와서 확인하기
        boolean returnFlag = false;
        if (!photo.isPhotoImgMasking()) {
            returnFlag = true;
            fastApiCallerService.callCihp(member, photo);
        }
        if (!photo.isPhotoImgOpenpose() || !photo.isPhotoJsonOpenpose()) {
            returnFlag = true;
            fastApiCallerService.callOpenpose(member, photo);
        }
        if (!cloth.isClothImgMasking()) {
            returnFlag = true;
            fastApiCallerService.callU2Net(member, cloth);
        }

        if (returnFlag) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "아직 전처리가 완료되지 않았습니다. 잠시 기다려주세요.");
        }

        // 3. 필요한 파일 다운로드 후 VITON 호출
        byte[] clothImg = s3Service.downloadFile("cloth/original/" + cloth.getClothImgName() + ".jpg");
        byte[] clothMaskingImg = s3Service.downloadFile("cloth/masking/" + cloth.getClothImgName() + ".jpg");
        byte[] photoImg = s3Service.downloadFile("photo/original/" + photo.getPhotoImgName() + ".jpg");
        byte[] photoParsingImg = s3Service.downloadFile("photo/masking/" + photo.getPhotoImgName() + ".png");
        byte[] photoOpenposeImg = s3Service
                .downloadFile("photo/openpose/img/" + photo.getPhotoImgName() + "_rendered.png");
        byte[] photoOpenposeJson = s3Service
                .downloadFile("photo/openpose/json/" + photo.getPhotoImgName() + "_keypoints.json");
        if (clothImg == null || clothMaskingImg == null || photoImg == null || photoParsingImg == null
                || photoOpenposeImg == null || photoOpenposeJson == null) {
            System.out.println("하나 이상의 이미지 다운로드에 실패했습니다.");
            return Api.ERROR(ErrorCode.SERVER_ERROR, "하나 이상의 이미지 다운로드에 실패했습니다.");
        }
        System.out.println("모든 전처리 이미지 다운로드 완료");

        Api<Object> vitonResult = fastApiService.requestViton(member, cloth.getClothImgName(), clothImg,
                clothMaskingImg, photo.getPhotoImgName(), photoImg, photoParsingImg,
                photoOpenposeImg, photoOpenposeJson);
        // 4. VITON 성공 여부에 따라 결과 출력
        if (!Objects.equals(vitonResult.getResult().getResultCode(), Result.OK().getResultCode())) {
            return Api.ERROR(ErrorCode.SERVER_ERROR, "내부 처리중 문제가 발생 했습니다.(VITON)");
        }
        // VITON 결과 저장
        RequestVitonRes res;
        String fileName = FileNameGenerator.generateFileNameNoExtension("temp", member.getMemberId());
        try {
            res = (RequestVitonRes) vitonResult.getBody();
            s3Service.uploadFile("temp/" + fileName + ".jpg", res.getViton());
        } catch (Exception e) {
            return Api.ERROR(ErrorCode.SERVER_ERROR, "저장 중 문제가 발생 했습니다.(VITON)");
        }
        System.out.println("VITON 완료");

        // 5. S3에서 URL 획득
        String url = s3Service.generatePresignedUrl("temp/" + fileName + ".jpg");

        return Api.OK(new PhotoMixRequestRes(url, "성공"));
    }
}
