package com.ssafy.kkalong.domain.member.controller;

import com.ssafy.kkalong.common.api.Api;
import com.ssafy.kkalong.common.error.ErrorCode;
import com.ssafy.kkalong.domain.member.dto.request.MemberProfileUpdateReq;
import com.ssafy.kkalong.domain.member.dto.request.MemberUpdateReq;
import com.ssafy.kkalong.domain.member.dto.request.SignInReq;
import com.ssafy.kkalong.domain.member.dto.request.SignUpReq;
import com.ssafy.kkalong.domain.member.dto.response.MemberInfoRes;
import com.ssafy.kkalong.domain.member.entity.Member;
import com.ssafy.kkalong.domain.member.service.MemberService;
import com.ssafy.kkalong.security.TokenProvider;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.*;
import java.time.*;

@RequiredArgsConstructor
@RequestMapping("/api/member")
@RestController
@Slf4j
public class MemberController {

    private final MemberService memberService;
    private final TokenProvider tokenProvider;
    private final RedisTemplate<String, String> redisTemplate;

    @Operation(summary = "회원가입")
    @PostMapping("/sign-up")
    public Api<Object> signUp(@RequestBody SignUpReq request){
        //닉네임 체크 검사
        String nickName = request.getMemberNickname();
        String nickNameRegex = "^[a-zA-Z가-힣0-9]{2,10}$";
        if(!nickName.matches(nickNameRegex)){
            return Api.ERROR(ErrorCode.BAD_REQUEST, String.format("[%s]은/는 유효하지 않는 닉네임입니다. 영어와 한글, 숫자만 가능하고 최소 2자에서 10자이내로 작성해주세요", nickName));
        }
        if(memberService.checkNickName(nickName)!=null){
            return Api.ERROR(ErrorCode.BAD_REQUEST, String.format("[%s]은/는 중복된 닉네임입니다.", nickName));
        }

        //아이디 검사
        String memberId = request.getMemberId();
        String idRegex = "^(?=.*[a-zA-Z])[a-zA-Z0-9]{5,20}$";
        if(!memberId.matches(idRegex)){
            return Api.ERROR(ErrorCode.BAD_REQUEST, String.format("[%s]은/는 유효하지 않는 아이디입니다. 영어와, 숫자만 가능하고 최소 5자에서 20자 이내로 작성해주세요. 최소 1개의 영어가 포함되어야 합니다.", memberId));
        }
        if(memberService.checkId(memberId)!=null){
            return Api.ERROR(ErrorCode.BAD_REQUEST, String.format("[%s]은/는 중복된 아이디입니다.", memberId));
        }

        //비밀 번호 검사
        String memberPw = request.getMemberPw();
        String pwRegex = "^(?=.*[a-zA-Z])(?=.*\\d)[a-zA-Z\\d]{8,20}$";
        if(!memberPw.matches(pwRegex)){
            return Api.ERROR(ErrorCode.BAD_REQUEST, "유효하지 않는 비밀번호입니다. 영어와, 숫자만 가능하고 최소 8자에서 20자 이내로 작성해주세요. 영어와 숫자는 최소 한번 이상 포함되어야 합니다.");
        }

        //이메일 검사
        String memberMail = request.getMemberEmail();
        String mailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        if(!memberMail.matches(mailRegex)){
            return Api.ERROR(ErrorCode.BAD_REQUEST, String.format("[%s]은/는 유효하지 안는 이메일 형식입니다.", memberMail));
        }

        //전화번호 검사
        String memberPhone = request.getMemberPhone();
        String phoneRegx = "^\\d{9,11}$";
        if(!memberPhone.isEmpty() && !memberPhone.matches(phoneRegx)){
            return Api.ERROR(ErrorCode.BAD_REQUEST, String.format("[%s]은/는 유효하지 안는 전화번호 형식입니다. 숫자만 작성해주세요", memberPhone));
        }

        //성별 검사
        Character  memberGender = request.getMemberGender();
        if (memberGender != null && memberGender != 'F' && memberGender != 'M' && memberGender != '\u0000' && !Character.toString(memberGender).trim().isEmpty()) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, String.format("[%s]은/는 유효하지 안는 성별 형식입니다. M,F,공백만 작성해주세요", memberGender));
        }


        //생년 검사
        int memberBirthYear = request.getMemberBirthYear();

        // 현재 연도
        LocalDate currentDate = LocalDate.now();
        int currentYear = Year.from(currentDate).getValue();

        if(memberBirthYear<0 && memberBirthYear>currentYear){
            return Api.ERROR(ErrorCode.BAD_REQUEST, String.format("[%s]은/는 유효하지 안는 연도입니다.", memberGender));
        }
        return Api.OK(memberService.registMember(request));
    }
    @Operation(summary = "회원 로그인")
    @PostMapping("/login")
    public Api<Object> signIn(@RequestBody SignInReq request ){
        return Api.OK(memberService.signIn(request));
    }

    @Operation(summary = "회원 정보 조회")
    @GetMapping("")
    public Api<Object> getMember( ){
        return Api.OK(MemberInfoRes.toRes(memberService.getLoginUserInfo()));
    }

    @Operation(summary = "아이디 중복확인 : 중복이면 false")
    @GetMapping("/id/{memberId}")
    public Api<Object> checkId(@PathVariable String memberId){

        return Api.OK(memberService.checkId(memberId)==null);
    }

    @Operation(summary = "닉네임 중복확인 : 중복이면 false")
    @GetMapping("/nickname/{nickName}")
    public Api<Object> checkNickName(@PathVariable String nickName){
        return Api.OK(memberService.checkNickNameEvenIfDeleted(nickName)==null);
    }

//    @GetMapping("/verifyToken")
//    public Api<String> verifyToken(@RequestHeader("Authorization") String auth){
//        log.info(auth);
//        var result = tokenProvider.validateTokenAndGetSubject(auth);
//        return Api.OK(result);
//    }
    @Operation(summary = "로그아웃")
    @DeleteMapping("/logout")
    public Api<Object> logout(){
        Member member = memberService.getLoginUserInfo();
        if(member==null){
            return Api.ERROR(ErrorCode.BAD_REQUEST,"로그인된 회원 정보를 찾지 못했습니다.");
        }

        memberService.logout(member);
        return Api.OK("로그아웃 되었습니다.");
    }

    @Operation(summary = "회원 정보 수정")
    @PutMapping("/profile")
    public Api<Object> updateMemberProfile(@RequestBody MemberProfileUpdateReq request){
        Member member = memberService.getLoginUserInfo();
        if(member==null){
            return Api.ERROR(ErrorCode.BAD_REQUEST,"로그인된 회원 정보를 찾지 못했습니다.");
        }

        //닉네임 체크 검사
        String nickName = request.getMemberNickname();
        String nickNameRegex = "^[a-zA-Z가-힣0-9]{2,10}$";
        if(!nickName.matches(nickNameRegex)){
            return Api.ERROR(ErrorCode.BAD_REQUEST, String.format("[%s]은/는 유효하지 않는 닉네임입니다. 영어와 한글, 숫자만 가능하고 최소 2자에서 10자이내로 작성해주세요", nickName));
        }
        if(!nickName.equals(member.getMemberNickname())&&memberService.checkNickName(nickName)!=null){
            return Api.ERROR(ErrorCode.BAD_REQUEST, String.format("[%s]은/는 중복된 닉네임입니다.", nickName));
        }

        //비밀 번호 검사
        String memberNewPw = request.getNewPassword();
        String pwRegex = "^(?=.*[a-zA-Z])(?=.*\\d)[a-zA-Z\\d]{8,20}$";
        String memberNewPwcheck = request.getNewPasswordCheck();

        if(!memberNewPw.isEmpty()){
            if ( !memberNewPw.equals(memberNewPwcheck)){
                return Api.ERROR(ErrorCode.BAD_REQUEST, "비밀번호와 비밀번호확인이 다릅니다.");
            }
            if(!memberNewPw.matches(pwRegex)){
                return Api.ERROR(ErrorCode.BAD_REQUEST, "유효하지 않는 비밀번호입니다. 영어와, 숫자만 가능하고 최소 8자에서 20자 이내로 작성해주세요. 영어와 숫자는 최소 한번 이상 포함되어야 합니다.");
            }
        }


        //이메일 검사
        String memberMail = request.getMemberEmail();
        String mailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        if(!memberMail.matches(mailRegex)){
            return Api.ERROR(ErrorCode.BAD_REQUEST, String.format("[%s]은/는 유효하지 안는 이메일 형식입니다.", memberMail));
        }

        //전화번호 검사
        String memberPhone = request.getMemberPhone();
        String phoneRegx = "^\\d{9,11}$";
        if(!memberPhone.isEmpty() && !memberPhone.matches(phoneRegx)){
            return Api.ERROR(ErrorCode.BAD_REQUEST, String.format("[%s]은/는 유효하지 안는 전화번호 형식입니다. 숫자만 작성해주세요", memberPhone));
        }

        //성별 검사
        Character  memberGender = request.getMemberGender();
        if (memberGender != null && memberGender != 'F' && memberGender != 'M' && memberGender != '\u0000' && !Character.toString(memberGender).trim().isEmpty()) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, String.format("[%s]은/는 유효하지 안는 성별 형식입니다. M,F,공백만 작성해주세요", memberGender));
        }

        //생년 검사
        int memberBirthYear = request.getMemberBirthYear();

        // 현재 연도
        LocalDate currentDate = LocalDate.now();
        int currentYear = Year.from(currentDate).getValue();

        if(memberBirthYear<0 && memberBirthYear>currentYear){
            return Api.ERROR(ErrorCode.BAD_REQUEST, String.format("[%s]은/는 유효하지 안는 연도입니다.", memberGender));
        }

        return Api.OK(memberService.updateMemberProfile(member.getMemberId(), request));
    }

    @Operation(summary = "닉네임, 비밀번호 수정")
    @PutMapping("")
    public Api<Object> updateMember(@RequestBody MemberUpdateReq request){
        Member member = memberService.getLoginUserInfo();
        if(member==null){
            return Api.ERROR(ErrorCode.BAD_REQUEST,"로그인된 회원 정보를 찾지 못했습니다.");
        }

        //닉네임 체크 검사
        String nickName = request.getMemberNickname();
        String nickNameRegex = "^[a-zA-Z가-힣0-9]{2,10}$";
        if(!nickName.matches(nickNameRegex)){
            return Api.ERROR(ErrorCode.BAD_REQUEST, String.format("[%s]은/는 유효하지 않는 닉네임입니다. 영어와 한글, 숫자만 가능하고 최소 2자에서 10자이내로 작성해주세요", nickName));
        }
        if(!nickName.equals(member.getMemberNickname())&&memberService.checkNickName(nickName)!=null){
            return Api.ERROR(ErrorCode.BAD_REQUEST, String.format("[%s]은/는 중복된 닉네임입니다.", nickName));
        }

        //비밀 번호 검사
        String memberNewPw = request.getNewPassword();
        String memberNewPwcheck = request.getNewPasswordCheck();
        if(!memberNewPw.isEmpty()){
            if ( !memberNewPw.equals(memberNewPwcheck)){
                return Api.ERROR(ErrorCode.BAD_REQUEST, "비밀번호와 비밀번호확인이 다릅니다.");
            }
            String pwRegex = "^(?=.*[a-zA-Z])(?=.*\\d)[a-zA-Z\\d]{8,20}$";
            if(!memberNewPw.matches(pwRegex)){
                return Api.ERROR(ErrorCode.BAD_REQUEST, "유효하지 않는 비밀번호입니다. 영어와, 숫자만 가능하고 최소 8자에서 20자 이내로 작성해주세요. 영어와 숫자는 최소 한번 이상 포함되어야 합니다.");
            }
        }



        return Api.OK(memberService.updateMember(member, request));
    }


    @Operation(summary = "회원 탈퇴")
    @PutMapping("/delete")
    public Api<Object> deleteMember(){
        Member member = memberService.getLoginUserInfo();
        if(member==null){
            return Api.ERROR(ErrorCode.BAD_REQUEST,"로그인된 회원 정보를 찾지 못했습니다.");
        }

        memberService.deleteMember(member);
        return Api.OK("탈퇴 되었습니다.");
    }

    @PostMapping("/auth/checktoken")
    @Operation(summary = "토큰 유효성 검사 메서드", description = "토큰 정보를 주면 유효성을 검사한다.", tags = "유저 API")
    public Api<Object> checkToken(@RequestHeader("Authorization") String tokenWithPrefix) {
        try {
            String memberId = tokenProvider.validateTokenAndGetSubject(tokenWithPrefix.substring(7));
            if (memberId!=null)
            {
                if (redisTemplate.opsForValue().get(memberId) != null) {
                    return Api.OK("success");
                }
                return Api.OK("fail");

            } else {
                return Api.ERROR(ErrorCode.BAD_REQUEST,"fail");
            }
        } catch (Exception e) {
            return Api.ERROR(ErrorCode.BAD_REQUEST,"fail");
        }
    }


}
