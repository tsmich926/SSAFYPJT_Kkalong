package com.ssafy.kkalong.domain.cloth.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.List;

@Data
public class ClothInputSectionReq {
    @Schema(description = "옷장 상세구역 인덱스")
    private int sectionSeq;

    @Schema(description = "옷 인덱스 리스트")
    private List<Integer> clothSeqList;

}
