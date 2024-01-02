from u2net_test import main as u2test
from decouple import config
import pymysql
import boto3
import os


def run_u2net():
    # 1. 요청 받은 파일의 존재 여부를 DB에서 확인한다.
    # 2. 존재할 경우, 해당 파일을 S3서버에서 다운로드 받는다
    # 3. 다운을 받았으면, u2test를 돌린다.
    # 4. 모델이 끝났으면 파일을 업로드 한다
    # 5. DB를 업데이트 한다.
    # 6. 다운 받은 파일과 결과물을 지운다.
    print()