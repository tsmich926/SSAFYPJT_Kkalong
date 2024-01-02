package com.ssafy.kkalong.domain.social.entity;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;

import java.io.Serializable;
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Embeddable
public class FollowKey implements Serializable {
    @Column(name = "following_member_seq")
    @Schema(description = "구독하는  회원 인덱스")
    private int followingMemberSeq;
    @Column(name = "follower_member_seq")
    @Schema(description = "구독자 회원 인덱스")
    private int followerMemberSeq;

}
