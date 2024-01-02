package com.ssafy.kkalong.domain.member.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;
import com.ssafy.kkalong.domain.member.entity.Member;

import java.time.LocalDateTime;
import java.util.Optional;

@Builder
@Getter
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class SignUpRes {
    @Schema(description = "회원 고유일련번호")
    private int memberSeq;
    @Schema(description = "별명")
    private String memberNickname ;
    @Schema(description = "회원 아이디")
    private String memberId;
    @Schema(description = "이메일")
    private String memberMail ;
    @Schema(description = "전화번호")
    private String memberPhone ;
    @Schema(description = "성별")
    private Character memberGender;
    @Schema(description = "생년")
    private int memberBirthYear ;
    @Schema(description = "등록일")
    private LocalDateTime memberRegDate ;
    @Schema(description = "탈퇴여부")
    private boolean isMemberDeleted;


    public static SignUpRes toRes (Member member) {
        return SignUpRes.builder()
                .memberSeq(member.getMemberSeq())
                .memberNickname(member.getMemberNickname())
                .memberId(member.getMemberId())
                .memberMail(member.getMemberMail())
                .memberPhone(member.getMemberPhone())
                .memberGender(member.getMemberGender())
                .memberBirthYear(member.getMemberBirthYear())
                .memberRegDate(member.getMemberRegDate())
                .isMemberDeleted(member.isMemberDeleted())
                .build();
    }
}
