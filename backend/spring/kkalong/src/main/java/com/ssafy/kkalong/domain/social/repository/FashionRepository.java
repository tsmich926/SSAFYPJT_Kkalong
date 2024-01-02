package com.ssafy.kkalong.domain.social.repository;

import com.ssafy.kkalong.domain.social.entity.Fashion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.Set;

public interface FashionRepository extends JpaRepository<Fashion,Integer> {
    Optional<Fashion> findByFashionSeqAndMemberMemberSeqAndIsFashionDeleted(int fashionSeq,int memberSeq,boolean isDeleted);
    List<Fashion> findAllByMemberMemberSeqAndIsFashionDeleted(int memberSeq,boolean isDeleted);

    List<Fashion> findAllByMemberMemberSeqAndIsFashionDeletedAndIsFashionPrivate(int memberSeq,boolean isDeleted,boolean isPrivate);

    @Query(value = "SELECT * FROM fashion WHERE is_fashion_deleted = false AND is_fashion_private = false AND fashion_seq NOT IN :assessFashionSeqList AND member_seq != :memberSeq ORDER BY RAND() LIMIT 1", nativeQuery = true)
    List<Fashion> findRandomFashion(@Param("assessFashionSeqList") Set<Integer> assessFashionSeqList, @Param("memberSeq") int memberSeq);

    @Query(value = "SELECT * FROM fashion WHERE is_fashion_deleted = false AND is_fashion_private = false AND member_seq != :memberSeq ORDER BY RAND() LIMIT 1", nativeQuery = true)
    List<Fashion> findRandomFashion(@Param("memberSeq") int memberSeq);
}
