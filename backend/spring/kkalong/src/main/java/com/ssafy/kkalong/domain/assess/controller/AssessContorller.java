package com.ssafy.kkalong.domain.assess.controller;

import com.ssafy.kkalong.common.api.Api;
import com.ssafy.kkalong.common.error.ErrorCode;
import com.ssafy.kkalong.domain.assess.dto.request.AssessReq;
import com.ssafy.kkalong.domain.assess.service.AssessService;
import com.ssafy.kkalong.domain.member.dto.request.SignUpReq;
import com.ssafy.kkalong.domain.member.entity.Member;
import com.ssafy.kkalong.domain.member.service.MemberService;
import com.ssafy.kkalong.domain.social.service.SocialService;
import com.ssafy.kkalong.s3.S3Service;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RequestMapping("/api/assess")
@RestController
@Slf4j
public class AssessContorller {
    private final MemberService memberService;
    private final AssessService assessService;

    @Operation(summary = "공개된 사진 랜덤 조회")
    @GetMapping("")
    public Api<Object> getOpenFashionList( ){

        Member member = memberService.getLoginUserInfo();
        if (member == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "로그인된 회원 정보를 찾지 못했습니다.");
        }

        return Api.OK(assessService.getOpenFashionList(member.getMemberSeq()));
    }

    @Operation(summary = "좋아요/싫어요 저장")
    @PostMapping("")
    public Api<Object> likeFashion( @RequestBody AssessReq request){

        Member member = memberService.getLoginUserInfo();
        if (member == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "로그인된 회원 정보를 찾지 못했습니다.");
        }

        return Api.OK(assessService.likeFashion(member, request));
    }

    @Operation(summary = "좋아요한 코디 사진 목록 조회")
    @GetMapping("/list")
    public Api<Object> getlikeFashionList(){

        Member member = memberService.getLoginUserInfo();
        if (member == null) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "로그인된 회원 정보를 찾지 못했습니다.");
        }

        return Api.OK(assessService.getlikeFashionList(member));
    }
}
