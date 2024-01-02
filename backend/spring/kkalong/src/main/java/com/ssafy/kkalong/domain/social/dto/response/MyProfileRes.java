package com.ssafy.kkalong.domain.social.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Builder
@Data
public class MyProfileRes {
    @Schema(description = "닉네임")
    private String memberNickName;

    @Schema(description = "팔로잉 수")
    private int followingCount;

    @Schema(description = "팔로워수 ")
    private int followerCount;

    @Schema(description = "저장한 코디 목록")
    private List<MyDtoRes> fashionList;

    @Schema(description = "공개한 옷 목록")
    private List<MyDtoRes> clothList;
}
