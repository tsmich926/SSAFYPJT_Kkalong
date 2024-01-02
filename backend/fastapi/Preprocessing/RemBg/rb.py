from rembg import remove
from PIL import Image


def remove_yes_bg(original_file_path: str, output_yes_bg: str):
    original = Image.open(original_file_path)  # load image
    output_image_white_bg = remove(original, alpha=False)  # 흰색 배경의 JPG 이미지
    output_image_white_bg = output_image_white_bg.convert("RGB")  # RGBA를 RGB로 변환
    output_image_white_bg.save(output_yes_bg, format='JPEG')
    output_image_white_bg.close() #작업 끝나면 닫기


def remove_no_bg(original_file_path: str, output_no_bg: str):
    original = Image.open(original_file_path)  # load image
    output_image_transparent_bg = remove(original, alpha=True)  # 투명 배경의 PNG 이미지
    output_image_transparent_bg.save(output_no_bg, format='PNG')
    output_image_transparent_bg.close() #작업 끝나면 닫기


