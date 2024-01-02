package com.ssafy.kkalong.domain.social.dto.response;

import com.ssafy.kkalong.domain.cloth.entity.Cloth;
import com.ssafy.kkalong.domain.social.entity.Fashion;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Builder
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class ProfileRes {

    @Schema(description = "닉네임")
    private String memberNickName;

    @Schema(description = "팔로잉 수")
    private int followingCount;

    @Schema(description = "팔로워수 ")
    private int followerCount;

    @Schema(description = "저장한 코디 목록")
    private List<DtoRes> fashionList;

    @Schema(description = "공개한 옷 목록")
    private List<DtoRes> clothList;

}
