package com.ssafy.kkalong.domain.social.dto.response;

import com.ssafy.kkalong.domain.social.entity.Follow;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Builder
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class FollowRes {
    @Schema(description = "following")
    private String following ;
    @Schema(description = "follower")
    private String follower ;
    @Schema(description = "등록일")
    private LocalDateTime regDate ;

    public static FollowRes toRes(Follow follow){
        return FollowRes.builder()
                .following(follow.getFollowingMember().getMemberNickname())
                .follower(follow.getFollowerMember().getMemberNickname())
                .regDate(follow.getRegDate())
                .build();
    }
}
