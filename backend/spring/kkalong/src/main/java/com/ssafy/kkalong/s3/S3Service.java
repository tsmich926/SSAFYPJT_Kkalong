package com.ssafy.kkalong.s3;

import com.amazonaws.HttpMethod;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.util.IOUtils;
import com.ssafy.kkalong.common.util.MultipartFileToFile;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;

@Service
public class S3Service {
    private final AmazonS3 amazonS3;
    @Value("${aws.s3.bucket}")
    private String bucketName;

    @Autowired
    public S3Service(AmazonS3 amazonS3) {
        this.amazonS3 = amazonS3;
    }

    // Amazon S3에 파일 업로드1
    public String uploadFile(String key, MultipartFile multipartFile) throws IOException {
        File uploadFile = MultipartFileToFile.convert(multipartFile)
                .orElseThrow(() -> new IllegalArgumentException("MultipartFile -> File로 전환이 실패했습니다."));

        return uploadFile(key, uploadFile);
    }

    // Amazon S3에 파일 업로드2
    public String uploadFile(String key, File file) {
        String uploadImageUrl = putS3(file, key); // s3로 업로드
        removeNewFile(file);

        return "사진 저장 성공";
    }

    public byte[] downloadFile(String key) {
        try {
            // S3 버킷에서 파일 다운로드
            S3Object s3Object = amazonS3.getObject(bucketName, key);
            InputStream objectData = s3Object.getObjectContent();
            // 바이너리 데이터로 변환
            return IOUtils.toByteArray(objectData);
        } catch (Exception e) {
            // 예외 처리 로직 추가
            e.printStackTrace();
            return null;
        }
    }

    public String generatePresignedUrl(String key) {
        // 임시 URL 생성
        java.util.Date expiration = new java.util.Date();
        long msec = expiration.getTime();
        msec += 1000 * 60 * 60; // 1 hour
        expiration.setTime(msec);

        GeneratePresignedUrlRequest generatePresignedUrlRequest = new GeneratePresignedUrlRequest(bucketName, key)
                .withMethod(HttpMethod.GET)
                .withExpiration(expiration);
        return amazonS3.generatePresignedUrl(generatePresignedUrlRequest).toString();
    }

    private String putS3(File uploadFile, String key){
        amazonS3.putObject(new PutObjectRequest(bucketName, key, uploadFile).withCannedAcl(CannedAccessControlList.PublicRead));
        return amazonS3.getUrl(bucketName, key).toString();
    }

    // 이미지 지우기
    private void removeNewFile(File targetFile) {
        if (targetFile.delete()) {
//            log.info("File delete success");
            return;
        }
//        log.info("File delete fail");
    }
}
