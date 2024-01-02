package com.ssafy.kkalong.domain.cloth.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.List;

@Data
public class ClothUpdateReq {
    @Schema(description = "수정할 옷 인덱스")
    private int clothSeq;

    @Schema(description = "옷장 상세구역 인덱스")
    private int sectionSeq;

    @Schema(description = "옷장 종류")
    private String sort;

    @Schema(description = "옷이름")
    private String clothName;

    @Schema(description = "공개 여부")
    private boolean isPrivate;

    @Schema(description = "추가할 태그 목폭")
    private List<String> tagAddList;


    @Schema(description = "삭제할 태그 목폭")
    private List<Integer> tagSegDeleteList;
}
