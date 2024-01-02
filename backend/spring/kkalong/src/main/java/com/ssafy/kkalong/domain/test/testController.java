package com.ssafy.kkalong.domain.test;

import com.ssafy.kkalong.common.api.Api;
import com.ssafy.kkalong.common.error.ErrorCode;
import com.ssafy.kkalong.common.util.FileNameGenerator;
import com.ssafy.kkalong.domain.member.entity.Member;
import com.ssafy.kkalong.domain.member.service.MemberService;
import com.ssafy.kkalong.domain.photo.entity.Photo;
import com.ssafy.kkalong.domain.photo.service.PhotoService;
import com.ssafy.kkalong.fastapi.FastApiService;
import com.ssafy.kkalong.fastapi.dto.FastApiRequestGeneralRes;
import com.ssafy.kkalong.fastapi.dto.RequestRembgRes;
import com.ssafy.kkalong.s3.S3Service;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.FileOutputStream;
import java.io.IOException;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/test")
public class testController {
    @Autowired
    private S3Service s3Service;

    @Autowired
    private FastApiService fastApiService;
    @Autowired
    private MemberService memberService;
    @Autowired
    private PhotoService photoService;

    @Operation(summary = "test")
    @GetMapping("/test1")
    public Api<Object> testserver(){

        return Api.OK("test 성공");
    }

    @Operation(summary = "test 용")
    @GetMapping("/test2")
    public Api<Object> testserver2(){

        return Api.OK("test2 성공");
    }

    @PostMapping("/s3/test1")
    public Api<Object> testserver3(@RequestBody MultipartFile mFile){
        System.out.println("test1 called");
        String key = FileNameGenerator.generateFileName("photo/original/photo", "tester", "jpg");
        String res = null;
        try {
            res = s3Service.uploadFile(key, mFile);
        } catch (IOException e) {
            e.printStackTrace();
            return Api.ERROR(ErrorCode.SERVER_ERROR, "업로드 실패");
        }
        return Api.OK(res);
    }

    @PostMapping("/s3/test2")
    public Api<Object> testserver4(){
        System.out.println(("test2 called"));
        byte[] byteCode = null;
        try{
            byteCode = s3Service.downloadFile("photo/original/photo_tester_231102_225259_947295.jpg");
            if (byteCode == null){
                return Api.ERROR(ErrorCode.SERVER_ERROR, "다운로드 실패");
            }
            FileOutputStream fos = new FileOutputStream("tester.jpg");
            fos.write(byteCode);
            fos.close();
        } catch (Exception e) {
            e.printStackTrace();
            return Api.ERROR(ErrorCode.SERVER_ERROR, "변환 실패");
        }

        return Api.OK("test2 성공");
    }

    @GetMapping("/s3/test3")
    public Api<Object> testserver5(@RequestParam String key){
        System.out.println("test3 called");
        try{
            return Api.OK(s3Service.generatePresignedUrl(key));
        } catch (Exception e){
            e.printStackTrace();
            return Api.ERROR((ErrorCode.BAD_REQUEST), "파일을 찾을 수 없습니다");
        }
    }

    @PostMapping("/s3/fast/rembg")
    public Api<Object> testServer6(MultipartFile mFile){
        // 1. 파일을 받는다.
        // 2. 해당 파일을 FastApiService에게 보낸다.
        Api<Object> res = fastApiService.requestRembg("사용자아이디", mFile);

        // 3. 응답을 받은걸 변환한다.
        RequestRembgRes remRes = (RequestRembgRes) res.getBody();

        // 4. S3에 저장한다.
        s3Service.uploadFile(remRes.getYesBgName() + ".jpg", remRes.getYesBg());
        s3Service.uploadFile(remRes.getNoBgName() + ".png", remRes.getNoBg());

        // 5. URL을 생성하여 반환한다.
        String noBg = s3Service.generatePresignedUrl(remRes.getYesBgName() + ".jpg");
        String yesBg = s3Service.generatePresignedUrl(remRes.getNoBgName() + ".png");
        System.out.println(noBg);
        System.out.println(yesBg);

        return Api.OK(TempResDto.builder().yesBg(yesBg).noBg(noBg).build());
    }

    @PostMapping("/s3/fast/openpose")
    public Api<Object> testServer8(int photoSeq){
        System.out.println("testServer8 called");
        // 0. 요청자의 데이터를 받는다.
        Member member = memberService.getLoginUserInfo();
        if (member == null){
            return Api.ERROR(ErrorCode.BAD_REQUEST, "사용자 데이터가 없습니다");
        }
        // 1. photo의 데이터를 가져온다.
        Photo photo = photoService.getPhotoBySeq(photoSeq);

        // 2. openpose 서버에 처리를 요청한다.
        return fastApiService.requestOpenpose(member, photo.getPhotoImgName(), photo.getPhotoSeq());
    }

    @GetMapping("/fast/welcome")
    public Api<Object> testServer7(){
        return fastApiService.callWelcome();
    }

    @PostMapping("/s3/fast/u2net")
    public Api<Object> testServer8(MultipartFile mFile){
        // 1. 파일을 받는다.
        // 2. 해당 파일을 FastApiService에게 보낸다.
        Api<Object> res = null;
        try {
            res = fastApiService.requestU2Net("사용자아이디", mFile);
        } catch (IOException e) {
            return Api.ERROR(ErrorCode.BAD_REQUEST, "IOError 발생");
        }

        // 3. 응답을 받은걸 변환한다.
        FastApiRequestGeneralRes u2netRes = (FastApiRequestGeneralRes) res.getBody();

        // 4. S3에 저장한다.
        s3Service.uploadFile(u2netRes.getImgName() + ".jpg", u2netRes.getImg());

        // 5. URL을 생성하여 반환한다.
        u2netRes.setPath(s3Service.generatePresignedUrl("cloth/masking/" + u2netRes + ".jpg"));
        System.out.println(u2netRes.getPath());

        return Api.OK(u2netRes);
    }

    @GetMapping("/fast/welcome/viton")
    public Api<Object> testServer9(){
        return fastApiService.callWelcomeViton();
    }
}
