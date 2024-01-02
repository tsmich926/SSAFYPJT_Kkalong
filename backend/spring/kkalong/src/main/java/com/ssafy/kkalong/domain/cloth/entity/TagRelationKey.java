package com.ssafy.kkalong.domain.cloth.entity;

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
@Embeddable
@Data
public class TagRelationKey implements Serializable {

    @Column(name = "cloth_seq")
    @Schema(description = "옷 인덱스")
    private int clothSeq;
    @Column(name = "tag_seq")
    @Schema(description = "태그 인덱스")
    private int tagSeq;
}
