package com.ssafy.kkalong.domain.assess.dto.request;

import com.ssafy.kkalong.domain.member.entity.Member;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.Column;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class AssessReq {

    @Schema(description = "코디 인덱스")
    private int fashionSeq ;

    @Schema(description = "좋아요,싫어요")
    private boolean isLike;

}
