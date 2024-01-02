from pydantic import BaseModel

class orb(BaseModel):
    member_id: str
    photo_seq: int
    photo_img_name : str