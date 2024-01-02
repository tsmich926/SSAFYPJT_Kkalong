package com.ssafy.kkalong.domain.member.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;

@Getter
public class SignInRes {
    @Schema(description = "별명")
    private String memberNickname ;
    @Schema(description = "회원 아이디")
    private String memberId;
    String accessToken;
    String refreshToken;
    public SignInRes (String memberId, String memberNickname, String accessToken, String refreshToken) {
        this.memberId = memberId;
        this.memberNickname = memberNickname;
        this.accessToken = accessToken;
        this.refreshToken = refreshToken;
    }
}
