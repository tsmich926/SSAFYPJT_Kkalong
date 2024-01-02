from fastapi import FastAPI
from fastapi import HTTPException
from decouple import config
import subprocess
import pymysql
import boto3
import botocore
import os

from openpose_request_body import orb

app = FastAPI()

# DB 설정
connection = pymysql.connect(
    host=config('MYSQL_HOST'),
    user=config('MYSQL_USER'),
    password=config('MYSQL_PASSWORD'),
    database=config('MYSQL_DB'),
    autocommit=True
)

# DB 커서 생성
cursor = connection.cursor()

# AWS 자격 증명 및 S3 클라이언트 생성
s3 = boto3.client('s3',
                  aws_access_key_id=config('AWS_ACCESS_KEY'),
                  aws_secret_access_key=config('AWS_SECRET_KEY'),
                  region_name=config('AWS_REGION')  # AWS 리전 설정
                  )
bucket_name = config('AWS_BUCKET')


@app.get("/")
def welcome():
    print("welcome called")
    return "welcome to server for openpose"


@app.get("/dummy")
def get_dummy():
    print("get_dummy called")
    s3.download_file(bucket_name, "dummy.png", r"./examples/dummy.png")
    return "download succeed"

## Openpose를 돌려주는 API
@app.post("/openpose")
async def run_openpose(rb: orb):
    print("run_openpose called")
    print(rb)
    # 1. 요청한 계정에 요청받은 파일명이 존재하는지 DB에서 확인한다
    sql = ("select photo_img_name, member_seq "
           "from member join photo using (member_seq) "
           "where member_id = %s and photo_seq = %s ")
    cursor.execute(sql, (rb.member_id, rb.photo_seq))

    # 2. 없다면 에러 보내고, 있다면 해당 파일을 다운 받는다.
    results = cursor.fetchall()
    if len(results) == 0:
        return "검색결과 없음"
    member_seq = results[0][1]
    s3.download_file(bucket_name, r"photo/original/" + rb.photo_img_name + ".jpg", r"./examples/" + rb.photo_img_name + ".png")

    # 3. 해당 파일에 대해서 openpose를 돌린다.
    command = r".\bin\OpenPoseDemo.exe --image_dir examples --hand --write_json output_jsons --write_images output_images --disable_blending"

    try:
        # 외부 exe 파일 실행
        process = subprocess.Popen(['powershell', '-command', command], stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE, text=True)

        # 실행이 완료될 때까지 대기
        process.wait()

        # 실행 결과를 반환
        stdout, stderr = process.communicate()
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

    # 4. 작업이 끝나면 파일을 S3서버에 올린다
    # try:
    s3.upload_file(r"./output_images/" + rb.photo_img_name + "_rendered.png", bucket_name,
                   "photo/openpose/img/" + rb.photo_img_name + "_rendered.png")
    s3.upload_file(r"./output_jsons/" + rb.photo_img_name + "_keypoints.json", bucket_name,
                   "photo/openpose/json/" + rb.photo_img_name + "_keypoints.json")
    # except botocore.exceptions.NoCredentialsError:
    #     return "AWS 자격 증명을 찾을 수 없습니다. 자격 증명을 설정하세요."
    # except botocore.exceptions.EndpointConnectionError:
    #     return "S3 엔드포인트에 연결할 수 없습니다. 리전을 확인하세요."

    # 5. DB에 작업이 되어 있음으로 업데이트 한다.
    sql = ("update photo "
           "set photo_img_openpose = 1, photo_json_openpose = 1 "
           "where photo_seq = %s and member_seq = %s ")
    cursor.execute(sql, (rb.photo_seq, member_seq))
    affected_rows = cursor.rowcount
    print(f"결과: {affected_rows}")

    # 6. 다운 받았던 파일과 결과 파일을 삭제한다.
    try:
        os.remove(r"./examples/" + rb.photo_img_name + ".png")
        os.remove(r"./output_images/" + rb.photo_img_name + "_rendered.png")
        os.remove(r"./output_jsons/" + rb.photo_img_name + "_keypoints.json")
    except FileNotFoundError:
        return f"파일이 존재하지 않습니다"
    except Exception as e:
        return f"파일 삭제 중 오류 발생: {e}"

    # 7. 호출자에게 완료를 반환한다.
    return "success"

# if __name__ == "__main__":
#     import uvicorn
#     uvicorn.run(app, host="0.0.0.0", port=4051)
