package com.ssafy.kkalong.domain.cloth.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.List;

@Data
public class ClothSaveReq {
    @Schema(description = "옷장 상세구역 인덱스")
    private int sectionSeq;

    @Schema(description = "옷장 종류")
    private String sort;

    @Schema(description = "옷이름")
    private String clothName;

    @Schema(description = "공개 여부")
    private boolean isPrivate;

    @Schema(description = "태그 목폭")
    private List<String> tagList;

}
