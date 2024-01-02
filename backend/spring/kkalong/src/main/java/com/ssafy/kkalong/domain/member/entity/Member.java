package com.ssafy.kkalong.domain.member.entity;

import com.ssafy.kkalong.domain.member.dto.request.SignUpReq;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.LocalDateTime;
import java.util.Optional;

@AllArgsConstructor

@ToString
@NoArgsConstructor
@Builder
@Getter
@Entity
@Setter
@Table(name = "member")
public class Member {
    @Id
    @Column(name = "member_seq")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int memberSeq;

    @Column(nullable = false, unique = true, length = 20)
    private String memberNickname ;

    @Column(nullable = false, unique = true, length = 20)
    private String memberId;

    @Column(nullable = false, length = 100)
    private String memberPw ;

    @Column(nullable = false, unique = true, length = 40)
    private String memberMail ;

    @Column(length = 11)
    private String memberPhone ;

    private char memberGender;
    //(M-남자, F - 여자)

    private int memberBirthYear ;

    @Column(nullable = false)
    private LocalDateTime memberRegDate ;

    private boolean isMemberDeleted;

    private LocalDateTime memberWithdrawnDate;

    public static Member toEntity(SignUpReq request, PasswordEncoder encoder) {	// 파라미터에 PasswordEncoder 추가
        return Member.builder()
                .memberNickname(request.getMemberNickname())
                .memberId(request.getMemberId())
                .memberPw(encoder.encode(request.getMemberPw()))	// 수정
                .memberMail(request.getMemberEmail())
                .memberGender(Optional.ofNullable(request.getMemberGender()).orElse('\u0000'))
                .memberPhone(request.getMemberPhone())
                .memberBirthYear(request.getMemberBirthYear())
                .memberRegDate(LocalDateTime.now())
                .build();
    }

}
