package com.ssafy.kkalong.domain.closet.dto.request;

import com.ssafy.kkalong.domain.sort.entity.Sort;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
@Getter
@Setter
@NoArgsConstructor

public class  SectionCreateRequestItem {


    @Schema(description = "옷장상세구역 이름")
    private String sectionName;


    @Schema(description = "옷장 상세 종류 인덱스")  //박스 행거 같은거
    private String sort;

    }
