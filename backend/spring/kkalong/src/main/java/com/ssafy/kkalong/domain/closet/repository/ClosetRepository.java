package com.ssafy.kkalong.domain.closet.repository;

import com.ssafy.kkalong.domain.closet.entity.Closet;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
//db연동
//repository
//jpa상속받아서 crud제공하는곳
public interface ClosetRepository extends JpaRepository<Closet, Integer> {


    Optional<Closet> findByClosetSeqAndIsClosetDeleted(int closetSeq, boolean isDeleted);

    List<Closet> findAllByMemberMemberSeqAndIsClosetDeleted(int memberSeq, boolean isDeleted);
}


