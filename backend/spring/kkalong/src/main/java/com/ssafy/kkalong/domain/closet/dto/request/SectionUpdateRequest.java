package com.ssafy.kkalong.domain.closet.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class SectionUpdateRequest {
    @Schema(description = "옷장 상세구역 시퀀스")
    private int sectionSeq;

    @Schema(description = "옷장상세구역 이름")
    private String sectionName;

    @Schema(description = "옷장 상세 종류 인덱스")  //박스 행거 같은거
    private String sort;
}
