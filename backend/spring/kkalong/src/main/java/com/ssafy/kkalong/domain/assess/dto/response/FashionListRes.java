package com.ssafy.kkalong.domain.assess.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FashionListRes {
    @Schema(description = "좋아요한 패션 리스트")
    private List<FashionAssessRes> listLikeFashion;

    @Schema(description = "싫어요한 패션 리스트")
    private List<FashionAssessRes> listHateFashion;

}
