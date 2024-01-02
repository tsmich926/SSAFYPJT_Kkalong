package com.ssafy.kkalong.domain.closet.repository;

import com.ssafy.kkalong.domain.closet.entity.Section;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface SectionRepository extends JpaRepository<Section, Integer> {

    List<Section> findAllByClosetClosetSeqAndIsSectionDeleted(int closetSeq, boolean isDeleted);

    Optional<Section> findBySectionSeqAndIsSectionDeleted(int sectionSeq, boolean isDeleted);
}
