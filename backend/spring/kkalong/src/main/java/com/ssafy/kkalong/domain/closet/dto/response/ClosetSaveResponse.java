package com.ssafy.kkalong.domain.closet.dto.response;

import com.ssafy.kkalong.domain.closet.dto.request.SectionCreateRequestItem;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;
@Data
public class ClosetSaveResponse
{
    @Schema(description = "옷장인덱스")
    private int closetSeq;

    @Schema(description = "옷장정보 조회하는 멤버 시퀀스")
    private String memberId;

    @Schema(description = "옷장이름")
    private String closetName ;

    //S3보류
    @Schema(description = "사진URL")
    private String closetPictureUrl;

    @Schema(description = "구역정보")
    private List<SectionSaveResponse> closetSectionList ;

    @Schema(description = "등록일")
    private LocalDateTime closetRegData;

    @Schema(description = "소유주 이름")
    private String membernickname;

}
