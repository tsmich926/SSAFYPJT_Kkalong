package com.ssafy.kkalong.domain.member.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@ToString
public class MemberUpdateReq {
    @Schema(description = "별명")
    private String memberNickname ;

    @Schema(description = "비밀번호")
    private String newPassword ;

    @Schema(description = "비밀번호 확인")
    String newPasswordCheck;
}
