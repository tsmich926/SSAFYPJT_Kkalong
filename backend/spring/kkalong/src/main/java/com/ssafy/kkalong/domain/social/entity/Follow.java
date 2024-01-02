package com.ssafy.kkalong.domain.social.entity;

import com.ssafy.kkalong.domain.member.entity.Member;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@ToString
@Getter
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Setter
@Table(name = "follow")
public class Follow {
    @Schema(description = "팔로우, 팔로워의 회원 일련번호")
    @EmbeddedId
    private FollowKey followId;

    @Column(name = "is_follow_deleted")
    @Schema(description = "삭제여부")
    private boolean isFollowDeleted;

    @Column(name = "follow_del_date")
    @Schema(description = "삭제일시")
    private LocalDateTime followDelDate;

    @Column(nullable = false, name = "reg_date")
    @Schema(description = "등록일")
    private LocalDateTime regDate ;

    @ManyToOne
    @JoinColumn(name = "following_member_seq", referencedColumnName = "member_seq", insertable = false, updatable = false)
    @Schema(description = "팔로잉")
    private Member followingMember;

    @ManyToOne
    @JoinColumn(name = "follower_member_seq", referencedColumnName = "member_seq", insertable = false, updatable = false)
    @Schema(description = "팔로워")
    private Member followerMember;


}
