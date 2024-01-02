package com.ssafy.kkalong.domain.cloth.repository;

import com.ssafy.kkalong.domain.closet.entity.Section;
import com.ssafy.kkalong.domain.cloth.entity.Cloth;
import com.ssafy.kkalong.domain.member.entity.Member;
import com.ssafy.kkalong.domain.sort.entity.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ClothRepository extends JpaRepository<Cloth, Integer> {

    List<Cloth> findAllByMemberMemberSeqAndIsClothDeleted(int memberSeq, boolean isDeleted);

    List<Cloth> findAllByMemberMemberSeqAndIsClothDeletedAndIsPrivate(int memberSeq, boolean isDeleted,
            boolean isPrivate);

    List<Cloth> findAllByMemberAndSortAndIsClothDeleted(Member member, Sort sort, boolean isDeleted);

    List<Cloth> findAllByMemberAndSectionAndIsClothDeleted(Member member, Section section, boolean isDeleted);

    Optional<Cloth> findByClothSeqAndIsClothDeleted(int clothSeq, boolean isDeleted);

    @Query(value = "SELECT c.* FROM cloth c " +
            "JOIN tag_relation tr ON c.cloth_seq = tr.cloth_seq " +
            "JOIN tag t ON t.tag_seq = tr.tag_seq " +
            "JOIN member m ON c.member_seq = m.member_seq " +
            "WHERE m.member_seq = :memberId AND t.tag_seq = :tagId AND tr.is_tag_relation_delete = false AND c.is_cloth_deleted = false", nativeQuery = true)
    List<Cloth> findClothsByMemberAndTag(@Param("memberId") int memberId, @Param("tagId") int tagId);
}
