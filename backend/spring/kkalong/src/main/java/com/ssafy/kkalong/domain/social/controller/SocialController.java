package com.ssafy.kkalong.domain.social.controller;

import com.ssafy.kkalong.common.api.Api;
import com.ssafy.kkalong.common.error.ErrorCode;
import com.ssafy.kkalong.common.util.FileNameGenerator;
import com.ssafy.kkalong.domain.member.entity.Member;
import com.ssafy.kkalong.domain.member.service.MemberService;
import com.ssafy.kkalong.domain.social.dto.request.FashionSaveReq;
import com.ssafy.kkalong.domain.social.service.SocialService;
import com.ssafy.kkalong.s3.S3Service;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FilenameUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RequiredArgsConstructor
@RequestMapping("/api/social")
@RestController
@Slf4j
public class SocialController {
    private final MemberService memberService;
    private final SocialService socialService;
    private final S3Service s3Service;

    @Operation(summary = "팔로우 하기")
    @GetMapping("/follow/{nickName}")
    public Api<Object> followMember( @PathVariable String nickName){

        Member followingMember = memberService.getLoginUserInfo();
        Member followerMember = memberService.checkNickName(nickName);

        if(followingMember==null){
            return Api.ERROR(ErrorCode.BAD_REQUEST,"로그인된 회원 정보를 찾지 못했습니다.");
        }
        if (followerMember==null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST,String.format("해당 닉네임[%s]을/를 가진 회원을 찾지 못했습니다.", nickName));
        }

        return Api.OK(socialService.followMember(followingMember,followerMember));

    }

    @Operation(summary = "팔로우, 팔로잉 리스트 조회")
    @GetMapping("/follow/list/{nickName}")
    public Api<Object> getFollowList( @PathVariable String nickName){

        Member member = memberService.checkNickName(nickName);

        if (member==null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST,String.format("해당 닉네임[%s]을/를 가진 회원을 찾지 못했습니다.", nickName));
        }

        return Api.OK(socialService.getFollowList(member));

    }

    @Operation(summary = "팔로우 취소")
    @PutMapping("/follow/{nickName}")
    public Api<Object> deleteFollow( @PathVariable String nickName){
        Member followingMember = memberService.getLoginUserInfo();
        Member followerMember = memberService.checkNickName(nickName);

        if(followingMember==null){
            return Api.ERROR(ErrorCode.BAD_REQUEST,"로그인된 회원 정보를 찾지 못했습니다.");
        }
        if (followerMember==null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST,String.format("해당 닉네임[%s]을/를 가진 회원을 찾지 못했습니다.", nickName));
        }
        socialService.deleteFollow(followingMember,followerMember);
        return Api.OK("팔로우가 취소 되었습니다.");
    }

    @Operation(summary = "코디사진 저장")
    @PostMapping(value = "/save" )
    public Api<Object> saveFashion(@RequestParam("mFile") MultipartFile file, @ModelAttribute  FashionSaveReq request) {
        Member member = memberService.getLoginUserInfo();

        if (member == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "로그인된 회원 정보를 찾지 못했습니다.");
        }
        String imgUrl="";
        String fileName="";
        if (!file.isEmpty()) {

            if ("jpg".equalsIgnoreCase(FilenameUtils.getExtension(file.getOriginalFilename()))) {
                //1.사진 파일명 생성
                fileName= FileNameGenerator.generateFileName("fashion", member.getMemberId(), "jpg");
                String filePath = "fashion/" + fileName;
                try {
                    s3Service.uploadFile(filePath, file);
                    imgUrl = s3Service.generatePresignedUrl(filePath);

                } catch (IOException e) {

                    System.out.println(e.getMessage());
                    return Api.ERROR(ErrorCode.BAD_REQUEST, "이미지 처리 중 오류가 발생하였습니다: ");
                }
            }
            else {
                return Api.ERROR(ErrorCode.BAD_REQUEST, "지원하지 않는 파일 형식입니다.");
            }
        } else {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "업로드된 파일이 없습니다.");
        }

        return Api.OK(socialService.saveFashion(member, request, imgUrl,fileName ));
    }

    @Operation(summary = "코디 사진 잠금 설정")
    @PutMapping("/fashion/{fashionSeq}")
    public Api<Object> changePrivateFashion( @PathVariable int fashionSeq){
        Member member = memberService.getLoginUserInfo();
        if (member == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "로그인된 회원 정보를 찾지 못했습니다.");
        }

        socialService.changePrivateFashion(member.getMemberSeq(),fashionSeq);
        return Api.OK("잠금설정이 변경되었습니다.");
    }

    @Operation(summary = "저장한 코디 사진 목록 조회")
    @GetMapping("/list/fashion/{nickName}")
    public Api<Object> getListFashion(@PathVariable String nickName){
        Member loginMember = memberService.getLoginUserInfo();
        if (loginMember == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "로그인된 회원 정보를 찾지 못했습니다.");
        }

        Member member = memberService.checkNickName(nickName);
        if (member==null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST,String.format("해당 닉네임[%s]을/를 가진 회원을 찾지 못했습니다.", nickName));
        }
        if(loginMember.getMemberNickname().equals(nickName)){
            return Api.OK(socialService.getMyListFashion(member.getMemberSeq()));
        }
        else{
            return Api.OK(socialService.getListFashion(member.getMemberSeq()));
        }



    }

    @Operation(summary = "옷 사진 목록 조회")
    @GetMapping("/list/cloth/{nickName}")
    public Api<Object> getListCloth( @PathVariable String nickName){
        Member loginMember = memberService.getLoginUserInfo();
        if (loginMember == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "로그인된 회원 정보를 찾지 못했습니다.");
        }
        Member member = memberService.checkNickName(nickName);
        if (member==null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST,String.format("해당 닉네임[%s]을/를 가진 회원을 찾지 못했습니다.", nickName));
        }

        if(loginMember.getMemberNickname().equals(nickName)){
            return Api.OK(socialService.getMyListCloth(member.getMemberSeq()));
        }
        else{
            return Api.OK(socialService.getListCloth(member.getMemberSeq()));
        }
    }

    @Operation(summary = "사용자 프로필 조회")
    @GetMapping("/{nickName}")
    public Api<Object> getProfile( @PathVariable String nickName){
        Member loginMember = memberService.getLoginUserInfo();
        if (loginMember == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "로그인된 회원 정보를 찾지 못했습니다.");
        }
        Member member = memberService.checkNickName(nickName);
        if (member==null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST,String.format("해당 닉네임[%s]을/를 가진 회원을 찾지 못했습니다.", nickName));
        }

        if(loginMember.getMemberNickname().equals(nickName)){
            return Api.OK(socialService.getMyProfile(member));
        }
        else{
            return Api.OK(socialService.getListProfile(member));
        }
    }


}
