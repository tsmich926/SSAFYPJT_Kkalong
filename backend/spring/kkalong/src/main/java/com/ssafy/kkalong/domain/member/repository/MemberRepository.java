package com.ssafy.kkalong.domain.member.repository;

import com.ssafy.kkalong.domain.member.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;


public interface MemberRepository extends JpaRepository<Member,Integer> {
    Optional<Member> findByMemberIdAndIsMemberDeleted(String memberId, boolean isDeleted);

    Optional<Member> findByMemberNicknameAndIsMemberDeleted(String Nickname, boolean isDeleted);

    Optional<Member> findByMemberNickname(String nickName);
}
