package com.ssafy.kkalong.domain.social.service;

import com.ssafy.kkalong.domain.cloth.dto.response.ClothRes;
import com.ssafy.kkalong.domain.cloth.entity.Cloth;
import com.ssafy.kkalong.domain.cloth.repository.ClothRepository;
import com.ssafy.kkalong.domain.member.entity.Member;
import com.ssafy.kkalong.domain.social.dto.request.FashionSaveReq;
import com.ssafy.kkalong.domain.social.dto.response.*;
import com.ssafy.kkalong.domain.social.entity.Fashion;
import com.ssafy.kkalong.domain.social.entity.Follow;
import com.ssafy.kkalong.domain.social.entity.FollowKey;
import com.ssafy.kkalong.domain.social.repository.FashionRepository;
import com.ssafy.kkalong.domain.social.repository.FollowRepository;
import com.ssafy.kkalong.s3.S3Service;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class SocialService {
    private final FollowRepository followRepository;
    private final FashionRepository fashionRepository;
    private final ClothRepository clothRepository;

    private final S3Service s3Service;

    public FollowRes followMember(Member followingMember, Member followerMember){
        FollowKey followKey =FollowKey.builder()
                .followingMemberSeq(followingMember.getMemberSeq())
                .followerMemberSeq(followerMember.getMemberSeq())
                .build();

        Follow follow = Follow.builder()
                .followId(followKey)
                .regDate(LocalDateTime.now())
                .followingMember(followingMember)
                .followerMember(followerMember)
                .build();

        return FollowRes.toRes(followRepository.save(follow));

    }

    public FollowListRes getFollowList(Member member){
        //찾을 려는 회원을 구독한 회원 닉네임 리스트
        List<String> followingList = new ArrayList<>();
        List<Follow> following = followRepository.findAllByFollowerMemberMemberSeqAndIsFollowDeleted(member.getMemberSeq(),false);

        for(Follow follow : following){
            followingList.add(follow.getFollowingMember().getMemberNickname());
        }

        //찾을 려는 회원이 구독한 회원 닉네임 리스트
        List<String> followerList = new ArrayList<>();
        List<Follow> follower = followRepository.findAllByFollowingMemberMemberSeqAndIsFollowDeleted(member.getMemberSeq(),false);
        for(Follow follow : follower){
            followerList.add(follow.getFollowerMember().getMemberNickname());
        }

        return FollowListRes.builder()
                .ownerMemberNickName(member.getMemberNickname())
                .followingList(followingList)
                .followerList(followerList)
                .build();

    }

    public void deleteFollow(Member followingMember, Member followerMember){
        int followingSeq = followingMember.getMemberSeq();
        int followerSeq = followerMember.getMemberSeq();
        Optional<Follow> optionalValue = followRepository.findByFollowingMemberMemberSeqAndFollowerMemberMemberSeqAndIsFollowDeleted(followingSeq,followerSeq, false);
        optionalValue.ifPresentOrElse(
                value -> {
                    // Optional이 비어있지 않을 때 로직 수행
                    Follow follow =  optionalValue.get();
                    follow.setFollowDelDate(LocalDateTime.now());
                    follow.setFollowDeleted(true);
                    followRepository.save(follow);
                },
                () -> {
                    throw new NoSuchElementException("팔로우 내역을 찾을 수 없습니다.");
                }
        );
    }

    public FashionSaveRes saveFashion(Member member, FashionSaveReq request,String imgUrl,String fileName) {
        Fashion fashion = Fashion.builder()
                .fashionName(request.getFashionName())
                .fashionImgName(fileName)
                .isAi(request.isAi())
                .isFashionPrivate(request.isFashionPrivate())
                .fashionRegDate(LocalDateTime.now())
                .member(member)
                .build();

        return FashionSaveRes.toRes(fashionRepository.save(fashion),imgUrl);
    }

    public void changePrivateFashion(int memberSeq, int fashionSeq){

        Optional<Fashion> optionalValue = fashionRepository.findByFashionSeqAndMemberMemberSeqAndIsFashionDeleted(fashionSeq, memberSeq,false);
        optionalValue.ifPresentOrElse(value -> {
                    // Optional이 비어있지 않을 때 로직 수행
                    boolean prePrivate = value.isFashionPrivate();
                    value.setFashionPrivate(!prePrivate);
                    fashionRepository.save(value);
                },
                () -> {
                    throw new NoSuchElementException("사진을 찾을 수 없습니다.");
                }
        );
    }

    public List<FashionRes> getMyListFashion(int memberSeq){
        List<FashionRes>result = new ArrayList<>();
        List<Fashion> fashionList = fashionRepository.findAllByMemberMemberSeqAndIsFashionDeleted(memberSeq,false);
        for(Fashion fashion : fashionList){
            String imgUrl = s3Service.generatePresignedUrl("fashion/" + fashion.getFashionImgName());
            FashionRes fashionRes = FashionRes.toRes(fashion,imgUrl );
            result.add(fashionRes);
        }
        return result;
    }

    public List<FashionRes> getListFashion(int memberSeq){
        List<FashionRes>result = new ArrayList<>();
        List<Fashion> fashionList = fashionRepository.findAllByMemberMemberSeqAndIsFashionDeletedAndIsFashionPrivate(memberSeq,false,false);
        for(Fashion fashion : fashionList){
            String imgUrl = s3Service.generatePresignedUrl("fashion/" + fashion.getFashionImgName());
            FashionRes fashionRes = FashionRes.toRes(fashion,imgUrl );
            result.add(fashionRes);
        }
        return result;
    }

    public MyClothRes getMyListCloth(int memberSeq){
        List<ClothRes>clothOpenList = new ArrayList<>();
        List<ClothRes>clothPrivateList = new ArrayList<>();

        List<Cloth> clothList = clothRepository.findAllByMemberMemberSeqAndIsClothDeleted(memberSeq,false);
        for(Cloth cloth : clothList){
            String imgUrl = s3Service.generatePresignedUrl("cloth/no_bg" + cloth.getClothImgName()+".png");
            ClothRes clothRes = ClothRes.toRes(cloth,imgUrl);

            if(cloth.isPrivate()){
                clothPrivateList.add(clothRes);
            }
            else{
                clothOpenList.add(clothRes);
            }

        }
        return MyClothRes.builder()
                .clothOpenList(clothOpenList)
                .clothPrivateList(clothPrivateList)

                .build();
    }

    public List<ClothRes> getListCloth(int memberSeq){
        List<ClothRes>result = new ArrayList<>();

        List<Cloth> clothList = clothRepository.findAllByMemberMemberSeqAndIsClothDeletedAndIsPrivate(memberSeq,false,false);
        for(Cloth cloth : clothList){
            String imgUrl = s3Service.generatePresignedUrl("cloth/no_bg" + cloth.getClothImgName()+".png");
            ClothRes clothRes = ClothRes.toRes(cloth,imgUrl );
            result.add(clothRes);
        }
        return result;
    }

    public MyProfileRes getMyProfile(Member member){
        FollowListRes followListRes =  getFollowList(member);
        int followingCount = followListRes.getFollowingList().size();
        int followerCount = followListRes.getFollowerList().size();

        List<MyDtoRes> fashionList = new ArrayList<>();
        List<Fashion> fashions = fashionRepository.findAllByMemberMemberSeqAndIsFashionDeleted(member.getMemberSeq(),false);
        for(Fashion fashion : fashions){
            String imgUrl = s3Service.generatePresignedUrl("fashion/" + fashion.getFashionImgName());
            MyDtoRes dtoRes = new MyDtoRes(fashion.getFashionSeq(), imgUrl,fashion.isFashionPrivate());
            fashionList.add(dtoRes);
        }

        List<MyDtoRes> clothList = new ArrayList<>();
        List<Cloth> cloths = clothRepository.findAllByMemberMemberSeqAndIsClothDeletedAndIsPrivate(member.getMemberSeq(),false,false);
        for(Cloth cloth : cloths){
            String imgUrl = s3Service.generatePresignedUrl("cloth/no_bg" + cloth.getClothImgName()+".png");
            MyDtoRes dtoRes = new MyDtoRes(cloth.getClothSeq(), imgUrl,cloth.isPrivate());
            clothList.add(dtoRes);
        }

        return MyProfileRes.builder()
                .memberNickName(member.getMemberNickname())
                .followingCount(followingCount)
                .followerCount(followerCount)
                .fashionList(fashionList)
                .clothList(clothList)
                .build();
    }

    public ProfileRes getListProfile(Member member){
        FollowListRes followListRes =  getFollowList(member);
        int followingCount = followListRes.getFollowingList().size();
        int followerCount = followListRes.getFollowerList().size();

        List<DtoRes> fashionList = new ArrayList<>();
        List<Fashion> fashions = fashionRepository.findAllByMemberMemberSeqAndIsFashionDeletedAndIsFashionPrivate(member.getMemberSeq(),false,false);
        for(Fashion fashion : fashions){
            String imgUrl = s3Service.generatePresignedUrl("fashion/" + fashion.getFashionImgName());
            DtoRes dtoRes = new DtoRes(fashion.getFashionSeq(), imgUrl);
            fashionList.add(dtoRes);
        }

        List<DtoRes> clothList = new ArrayList<>();
        List<Cloth> cloths = clothRepository.findAllByMemberMemberSeqAndIsClothDeletedAndIsPrivate(member.getMemberSeq(),false,false);
        for(Cloth cloth : cloths){
            String imgUrl = s3Service.generatePresignedUrl("cloth/no_bg" + cloth.getClothImgName()+".png");
            DtoRes dtoRes = new DtoRes(cloth.getClothSeq(), imgUrl);
            clothList.add(dtoRes);
        }

        return ProfileRes.builder()
                .memberNickName(member.getMemberNickname())
                .followingCount(followingCount)
                .followerCount(followerCount)
                .fashionList(fashionList)
                .clothList(clothList)
                .build();
    }

}
