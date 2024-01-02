package com.ssafy.kkalong.domain.social.dto.response;

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
public class FollowListRes {
    @Schema(description = "찾을 려는 회원 닉네임")
    String ownerMemberNickName;
    
    @Schema(description = "찾을 려는 회원을 구독한 회원 닉네임 리스트")
    List<String> followingList;

    @Schema(description = "찾을 려는 회원이 구독한 회원 닉네임 리스트")
    List<String> followerList;
}
