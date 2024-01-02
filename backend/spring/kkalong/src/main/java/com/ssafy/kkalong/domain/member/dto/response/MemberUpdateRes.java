package com.ssafy.kkalong.domain.member.dto.response;

import com.ssafy.kkalong.domain.member.entity.Member;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@NoArgsConstructor
@Getter
@AllArgsConstructor
@ToString
@Builder
public class MemberUpdateRes {
    @Schema(description = "별명")
    private String memberNickname ;
    @Schema(description = "이메일")
    private String memberMail ;
    @Schema(description = "전화번호")
    private String memberPhone ;
    @Schema(description = "성별")
    private Character memberGender;
    @Schema(description = "생년")
    private int memberBirthYear ;

    public static MemberUpdateRes toRes (Member member) {
        return MemberUpdateRes.builder()
                .memberNickname(member.getMemberNickname())
                .memberMail(member.getMemberMail())
                .memberPhone(member.getMemberPhone())
                .memberGender(member.getMemberGender())
                .memberBirthYear(member.getMemberBirthYear())
                .build();
    }
}
