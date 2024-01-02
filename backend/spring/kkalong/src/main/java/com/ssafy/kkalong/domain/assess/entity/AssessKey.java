package com.ssafy.kkalong.domain.assess.entity;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
@Embeddable
public class AssessKey implements Serializable {
    @Column(name = "fashion_seq")
    @Schema(description = "코디 인덱스")
    private int fashionSeq;
    @Column(name = "member_seq")
    @Schema(description = "좋아요를 누른 회원 인덱스")
    private int memberSeq;
}
