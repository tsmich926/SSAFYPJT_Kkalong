package com.ssafy.kkalong.domain.closet.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class SectionCreateRequest {

    @Schema(description = "옷장상세구역 리스트")
    private List<SectionCreateRequestItem> sectionItem;

}
