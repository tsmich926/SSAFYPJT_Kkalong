package com.ssafy.kkalong.domain.closet.dto.response;

import com.ssafy.kkalong.domain.closet.dto.request.SectionCreateRequestItem;
import com.ssafy.kkalong.domain.closet.entity.Section;
import com.ssafy.kkalong.domain.sort.entity.Sort;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class SectionSaveResponse {
    @Schema(description = "옷장 상세구역 인덱스")
    private int sectionSeq;

    @Schema(description = "옷장상세구역 이름")
    private String sectionName;


    @Schema(description = "옷장 상세 종류 인덱스")  //박스 행거 같은거
    private String sort;

    public SectionSaveResponse(Section item){
        this.sectionSeq = item.getSectionSeq();
        this.sectionName = item.getSectionName();
        this.sort = item.getSort().getSort();
    }
}
