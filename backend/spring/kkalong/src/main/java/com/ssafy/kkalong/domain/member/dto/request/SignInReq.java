package com.ssafy.kkalong.domain.member.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class SignInReq {
    @Schema(description = "회원 아이디")
    String memberId;
    @Schema(description = "회원 비밀번호")
    String memberPw;
}
