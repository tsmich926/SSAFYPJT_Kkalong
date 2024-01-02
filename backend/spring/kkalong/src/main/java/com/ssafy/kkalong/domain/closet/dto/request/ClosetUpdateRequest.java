package com.ssafy.kkalong.domain.closet.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class ClosetUpdateRequest {
    @Schema(description = "옷장시퀀스")
    private int closetSeq;
    //클라이언트가 보낸 데이터를 서버가 받아 처리할 때 사용하는 객체가 Request DTO
    @Schema(description = "옷장이름")
    private String closetName;

    //수정용
    @Schema(description = "옷장구성 섹션 수정용")
    private List<SectionUpdateRequest> closetSectionUpdateList;

    //추가 name.list
    @Schema(description = "옷장구성 섹션 추가용")
    private List<SectionCreateRequestItem> closetSectionAddList ;

    //삭제 seq
    @Schema(description = "옷장구성 섹션 삭제용")
    private List<Integer> closetSectionDeleteList ;




}
