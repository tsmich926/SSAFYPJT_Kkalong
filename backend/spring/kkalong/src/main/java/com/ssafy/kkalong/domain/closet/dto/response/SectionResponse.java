package com.ssafy.kkalong.domain.closet.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@NoArgsConstructor
@Getter
@AllArgsConstructor
@ToString
@Builder
public class SectionResponse {
    @Schema(description = "옷장상세구역 인덱스")
    private int sectionSeq;

    @Schema(description = "상세구역이름")
    private String sectionName;

    @Schema(description = "옷장상세종류 인덱스")
    private int sortSeq;

    @Schema(description = "종류테이블에 있는 종류")
    private String sort;


}
