package com.ssafy.kkalong.common.util;

import org.springframework.web.multipart.MultipartFile;
import java.io.*;

public class ByteArrayToMultipartFile implements MultipartFile {
    private final byte[] fileContent;

    public ByteArrayToMultipartFile(byte[] fileContent) {
        this.fileContent = fileContent;
    }

    @Override
    public String getName() {
        // 구현은 요구 사항에 따라 달라집니다.
        return null;
    }

    @Override
    public String getOriginalFilename() {
        // 구현은 요구 사항에 따라 달라집니다.
        return null;
    }

    @Override
    public String getContentType() {
        // 구현은 요구 사항에 따라 달라집니다.
        return null;
    }

    @Override
    public boolean isEmpty() {
        return fileContent == null || fileContent.length == 0;
    }

    @Override
    public long getSize() {
        return fileContent.length;
    }

    @Override
    public byte[] getBytes() throws IOException {
        return fileContent;
    }

    @Override
    public InputStream getInputStream() throws IOException {
        return new ByteArrayInputStream(fileContent);
    }

    @Override
    public void transferTo(File dest) throws IOException, IllegalStateException {
        new FileOutputStream(dest).write(fileContent);
    }
}
