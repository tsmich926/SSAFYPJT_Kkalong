package com.ssafy.kkalong.domain.assess.dto.response;

import com.ssafy.kkalong.domain.assess.dto.request.AssessReq;
import com.ssafy.kkalong.domain.assess.entity.Assess;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AssessRes {

    @Schema(description = "코디 인덱스")
    private int fashionSeq ;

    @Schema(description = "좋아요,싫어요")
    private boolean isLike;

    @Schema(description = "좋아요/싫어요 누른 날짜")
    private LocalDateTime assessRegDate ;

    @Schema(description = "회원 닉네임")
    private String memberNickName;


    public static AssessRes toRes(Assess assess){
        return AssessRes.builder()
                .fashionSeq(assess.getAssessKey().getFashionSeq())
                .isLike(assess.isLike())
                .assessRegDate(assess.getAssessRegDate())
                .memberNickName(assess.getMember().getMemberNickname())
                .build();
    }
}
