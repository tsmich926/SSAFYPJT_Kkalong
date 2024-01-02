package com.ssafy.kkalong.domain.social.repository;

import com.ssafy.kkalong.domain.social.entity.Follow;
import com.ssafy.kkalong.domain.social.entity.FollowKey;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface  FollowRepository extends JpaRepository <Follow, FollowKey> {
    Optional<Follow> findByFollowingMemberMemberSeqAndFollowerMemberMemberSeqAndIsFollowDeleted(int followingId, int followerId, boolean isDeleted);
    List<Follow> findAllByFollowingMemberMemberSeqAndIsFollowDeleted(int followingId, boolean isDeleted);
    List<Follow> findAllByFollowerMemberMemberSeqAndIsFollowDeleted(int followerId, boolean isDeleted);

}
