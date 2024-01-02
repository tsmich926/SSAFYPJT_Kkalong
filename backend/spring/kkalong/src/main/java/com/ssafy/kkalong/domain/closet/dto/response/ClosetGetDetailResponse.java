package com.ssafy.kkalong.domain.closet.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.util.List;

@NoArgsConstructor
@Getter
@Setter
@AllArgsConstructor
@ToString
@Builder

public class ClosetGetDetailResponse {
    //옷장 상세정보 및  소속구역 리스트 보기

    //옷장이름 STRING
    //사진URL
    //섹션리스트가 있는 response dto 를 만들기

    @Schema(description = "옷장이름")
    private String closetName ;

    @Schema(description = "사진URL")
    private String closetPictureUrl;

    @Schema(description = "섹션리스트")
    private List<SectionResponse> closetSectionList;

}
