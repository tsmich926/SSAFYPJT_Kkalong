package com.ssafy.kkalong.domain.assess.entity;

import com.ssafy.kkalong.domain.member.entity.Member;
import com.ssafy.kkalong.domain.social.entity.Fashion;
import com.ssafy.kkalong.domain.social.entity.FollowKey;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "assess")
public class Assess {
    @Schema(description = "코디 일련번호, 회원 일련번호")
    @EmbeddedId
    private AssessKey assessKey;

    @Column(name = "is_like")
    @Schema(description = "좋아요,싫어요")
    private boolean isLike;

    @Column(nullable = false, name = "assess_reg_date")
    @Schema(description = "좋아요/싫어요 누른 날짜")
    private LocalDateTime assessRegDate ;

    @ManyToOne
    @JoinColumn(name = "fashion_seq", referencedColumnName = "fashion_seq", insertable = false, updatable = false)
    @Schema(description = "코디")
    private Fashion fashion;

    @ManyToOne
    @JoinColumn(name = "member_seq", referencedColumnName = "member_seq", insertable = false, updatable = false)
    @Schema(description = "좋아요를 누른 회원")
    private Member member;
}
