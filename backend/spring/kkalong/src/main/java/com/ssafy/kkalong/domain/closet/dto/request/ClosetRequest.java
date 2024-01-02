package com.ssafy.kkalong.domain.closet.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ClosetRequest {
    //클라이언트가 보낸 데이터를 서버가 받아 처리할 때 사용하는 객체가 Request DTO
    @Schema(description = "옷장이름")
    private String closetName ;

    @Schema(description =  "삭제할 옷장 일련번호")
    private int closetSeq;
}
