package com.ssafy.kkalong.common.exception;

import com.ssafy.kkalong.common.error.ErrorCodeIfs;

public interface ApiExceptionIfs {

    ErrorCodeIfs getErrorCodeIfs();

    String getErrorDescription();


}
