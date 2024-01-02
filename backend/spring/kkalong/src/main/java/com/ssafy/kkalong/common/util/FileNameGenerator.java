package com.ssafy.kkalong.common.util;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;
public class FileNameGenerator {
    //
    public static String generateFileName(String domain, String memberId, String extensionName) {
        // 현재 시간을 'yymmdd_hhmmss' 형식으로 포맷
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyMMdd_HHmmss");
        String currentTime = dateFormat.format(new Date());

        // 6자리의 무작위 숫자 생성
        Random random = new Random();
        int randomInt = random.nextInt(1000000);
        String randomString = String.format("%06d", randomInt);

        return domain + "_" + memberId + "_" + currentTime + "_" + randomString +
                "." + extensionName;
    }

    public static String generateFileNameNoExtension(String domain, String memberId) {
        // 현재 시간을 'yymmdd_hhmmss' 형식으로 포맷
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyMMdd_HHmmss");
        String currentTime = dateFormat.format(new Date());

        // 6자리의 무작위 숫자 생성
        Random random = new Random();
        int randomInt = random.nextInt(1000000);
        String randomString = String.format("%06d", randomInt);

        return domain + "_" + memberId + "_" + currentTime + "_" + randomString;
    }
}
