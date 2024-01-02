package com.ssafy.kkalong.domain.assess.repository;

import com.ssafy.kkalong.domain.assess.entity.Assess;
import com.ssafy.kkalong.domain.assess.entity.AssessKey;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface AssessRepository  extends JpaRepository<Assess, AssessKey> {
    List<Assess> findByMemberMemberSeq(int memberSeq);
    Optional<Assess>findByAssessKey(AssessKey assessKey);

}
