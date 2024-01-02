
from fastapi import FastAPI
import base64
import os
import json
import tempfile
from test import main as viton

app = FastAPI()


@app.get("/")
def welcome():
    print("welcome called")
    return "welcome to server for viton"


@app.post("/")
async def run_viton_hd(file: dict):
    print("run_viton_hd called")
    # 1. 바이트 코드를 임시 저장한다.
    file_path = r"./datasets/test/"
    cloth_name = file["cloth_name"]
    print(cloth_name)

    cloth_path = file_path + r"cloth/" + cloth_name + ".jpg"
    cloth_mask_path = file_path + r"cloth-mask/" + cloth_name + ".jpg"

    image_name = file["image_name"]
    print(image_name)

    image_path = file_path + r"image/" + image_name + ".jpg"
    image_parse_path = file_path + r"image-parse/" + image_name + ".png"
    openpose_img_path = file_path + r"openpose-img/" + image_name + "_rendered.png"
    openpose_json_path = file_path + r"openpose-json/" + image_name + "_keypoints.json"

    # 1.1. 옷 사진 저장
    with open(cloth_path, "wb") as temp_file:
        temp_file.write(base64.b64decode(file["cloth"]))
    # with tempfile.NamedTemporaryFile(prefix="", suffix=".jpg", delete=False, dir=cloth_path) as temp_file:
    #     temp_file.write(base64.b64decode(file["cloth"]))

    # 1.2. 옷 마스킹 사진 저장
    with open(cloth_mask_path, "wb") as temp_file:
        temp_file.write(base64.b64decode(file["cloth_mask"]))
    # with tempfile.NamedTemporaryFile(suffix=".jpg", delete=False, dir=cloth_mask_path) as temp_file:
    #     temp_file.write(base64.b64decode(file["cloth_mask"]))

    # 1.3. 사람 사진 저장
    with open(image_path, "wb") as temp_file:
        temp_file.write(base64.b64decode(file["image"]))
    # with tempfile.NamedTemporaryFile(suffix=".jpg", delete=False, dir=image_path) as temp_file:
    #     temp_file.write(base64.b64decode(file["image"]))

    # 1.4. 사람 파싱 이미지 저장
    with open(image_parse_path, "wb") as temp_file:
        temp_file.write(base64.b64decode(file["image_parse"]))
    # with tempfile.NamedTemporaryFile(suffix=".png", delete=False, dir=image_parse_path) as temp_file:
    #     temp_file.write(base64.b64decode(file["image_parse"]))

    # 1.5. 사람 openpose 사진 저장
    with open(openpose_img_path, "wb") as temp_file:
        temp_file.write(base64.b64decode(file["openpose_img"]))
    # with tempfile.NamedTemporaryFile(suffix=".png", delete=False, dir=openpose_img_path) as temp_file:
    #     temp_file.write(base64.b64decode(file["openpose_img"]))

    # 1.6. 사람 openpose json 저장
    with open(openpose_json_path, "wb") as temp_file:
        temp_file.write(base64.b64decode(file["openpose_json"]))
    # with tempfile.NamedTemporaryFile(suffix=".json", delete=False, dir=openpose_json_path) as temp_file:
    #     temp_file.write(base64.b64decode(file["openpose_json"]))

    print("전처리 파일 저장 완료")

    # 1.7. test_pairs.txt를 수정한다.
    with open(r"./datasets/test_pairs.txt", 'w') as file:
        file.write(f"{cloth_name} {image_name}")
    print("test_pairs 수정 완료")

    # 2. 해당 파일에 대해 CIHP를 돌린다.
    viton()
    print("viton 처리 완료")

    # 3. Json으로 변환하여 반환한다.
    result_file = ""
    temp_path = "./results/test/" + cloth_name + "_" + image_name + ".jpg"
    try:
        if os.path.exists(temp_path):
            with open(temp_path, "rb") as file:
                result_file = base64.b64encode(file.read()).decode('utf-8')
        return json.dumps({"result": "성공", "viton": result_file})
    finally:
        # 4. 파일을 삭제한다.
        os.remove(temp_path)
        os.remove(cloth_path)
        os.remove(cloth_mask_path)
        os.remove(image_path)
        os.remove(image_parse_path)
        os.remove(openpose_img_path)
        os.remove(openpose_json_path)




    # # 1. DB에 모든 전처리가 되어 있는지 확인한다.
    # sql_photo = ("select member_seq, cloth_img_yes_bg, cloth_img_masking"
    #              "from member join photo using member_seq"
    #              "where member_id = %s and photo_img_name = %s")
    # cursor.execute(sql_photo, (body.member_id, body.photo_img_name))
    # result_photo = cursor.fetchall()
    #
    # sql_cloth = ("select member_seq, cloth_img_yes_bg, cloth_img_masking"
    #              "from member join cloth using member_seq"
    #              "where member_id = %s and cloth_img_name = %s")
    # cursor.execute(sql_cloth, (body.member_id, body.cloth_img_name))
    # result_cloth = cursor.fetchall()
    #
    # # 1.1. 전처리가 하나라도 안되어 있으면 종료한다
    # if len(result_cloth) == 0 or len(result_photo) == 0:
    #     return "전처리 안되어 있음"
    #
    # # 2. S3서버에서 전처리 파일들을 전부 받아온다
    # input_path_prefix = r"./datasets/test/"
    # try:
    #     # 옷 사진
    #     s3.download_file(bucket_name, r"cloth/yes_bg/" + rb.cloth_img_name + ".jpg",
    #                      input_path_prefix + r"cloth/" + rb.cloth_img_name + ".jpg")
    #     # 옷 마스킹 사진
    #     s3.download_file(bucket_name, r"cloth/masking/" + rb.cloth_img_name + ".jpg",
    #                      input_path_prefix + r"cloth-mask/" + rb.cloth_img_name + ".jpg")
    #     # 사람 사진
    #     s3.download_file(bucket_name, r"photo/yes_bg/" + rb.photo_img_name + ".jpg",
    #                      input_path_prefix + r"image/" + rb.photo_img_name + ".jpg")
    #     # 사람 사진 파싱
    #     s3.download_file(bucket_name, r"photo/masking/" + rb.photo_img_name + ".png",
    #                      input_path_prefix + r"image-parse/" + rb.photo_img_name + ".png")
    #     # 사람 사진 openpose 이미지
    #     s3.download_file(bucket_name, r"photo/openpose/img/" + rb.photo_img_name + ".png",
    #                      input_path_prefix + r"openpose-img/" + rb.photo_img_name + "_rendered.png")
    #     # 사람 사진 openpose json
    #     s3.download_file(bucket_name, r"photo/openpose/json/" + rb.photo_img_name + ".json",
    #                      input_path_prefix + r"openpose-json/" + rb.photo_img_name + "_keypoints.json")
    # except boto3.exceptions.NoCredentialsError:
    #     return "AWS 자격 증명을 찾을 수 없습니다. 자격 증명을 설정하세요."
    # except boto3.exceptions.EndpointConnectionError:
    #     return "S3 엔드포인트에 연결할 수 없습니다. 리전을 확인하세요."
    #
    # # 2.1. 서버 소통 실패하면 다운 받은 파일 지우고 종료
    #
    # # 3. test_pairs.txt를 수정하고 viton을 돌린다
    # with open(input_path_prefix + "test_pairs.txt", "w") as file:
    #     file.write(f"{rb.photo_img_name} {rb.cloth_img_name}\n")
    # viton()
    #
    # # 4. 임시용 S3서버에 저장한다.
    # try:
    #     # 현재 시간을 YYMMDD_HHMMSS 형식으로 가져오기
    #     current_time = datetime.now().strftime("%y%m%d_%H%M%S")
    #
    #     # 6자리의 무작위 난수 생성
    #     random_number = str(random.randint(0, 999999)).zfill(6)
    #
    #     temp_file_name = f"fashion_{body.member_id}_{current_time}_{random_number}.jpg"
    #
    #     s3.upload_file(r"./results/test/" + f"{rb.photo_img_name}_{rb.cloth_img_name}.jpg", bucket_name,
    #                    f"fashion_temp/{temp_file_name}")
    # except boto3.exceptions.NoCredentialsError:
    #     return "AWS 자격 증명을 찾을 수 없습니다. 자격 증명을 설정하세요."
    # except boto3.exceptions.EndpointConnectionError:
    #     return "S3 엔드포인트에 연결할 수 없습니다. 리전을 확인하세요."
    #
    # # 5. 사용자에게 성공을 반환 한다.
    # url = s3.generate_presigned_url(
    #     ClientMethod='get_object',
    #     Params={'Bucket': bucket_name, 'Key': r"fashion_temp/" + temp_file_name},
    #     ExpiresIn=3600
    # )
    # return {"message": "success", "url": url}