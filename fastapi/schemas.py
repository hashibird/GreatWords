from typing import List, Optional

from pydantic import BaseModel


class Great_word(BaseModel):
    great_word: str
    
    class Config:
        orm_mode = True

class Create_comment(BaseModel):
    comment: str
    great_words_id: int
    uuid: str
    class Config:
        orm_mode = True

class Comment(BaseModel):
    id: int
    comment: str
    great_words_id: int
    uuid: str
    user_name: str
    speaker_id: Optional[int] = None
    class Config:
        orm_mode = True

class Get_great_word_user(Great_word):
    id: int
    class Config:
        orm_mode = True

class Get_great_word(Great_word):
    id: int
    speaker_name: Optional[str] = None
    comments: List[Comment] = []

    class Config:
        orm_mode = True
    


class Create_great_word(Great_word):
    speaker_id: int
    uuid: Optional[str] = None
    class Config:
        orm_mode = True



class Speaker(BaseModel):
    speaker_name: str
    speaker_name_eng: Optional[str] = None
    speaker_detail: str
    category_id: int
    uuid: Optional[str] = None
    class Config:
            orm_mode = True

class Get_user_speaker(Speaker):
    id: int
    is_active: bool
    word: List[Get_great_word]
    class Config:
            orm_mode = True

class Get_users(Speaker):
    id: int
    is_active: bool
    class Config:
        orm_mode = True
class Get_user(Speaker):
    id: int
    is_active: bool
    word: List[Get_great_word] = []
    comments: List[Comment] = []

class Get_speaker(Speaker):
    id: int
    category_name: Optional[str] = []
    class Config:
        orm_mode = True

    # word: List[Great_word] = []

    class Config:
            orm_mode = True
        
class Update_user(BaseModel):
    speaker_id: int
    name: str
    detail: str
    uuid: str
    class Config:
        orm_mode = True
    
class Create_speaker(Speaker):
    is_active: Optional[bool] = True
    class Config:
        orm_mode = True

class Create_category(BaseModel):
    category_name: str
    category_detail: Optional[str] = ""

class Category(BaseModel):
    id: int
    category_name: str
    category_detail: str

    # speaker: List[Speaker] = []
    
    class Config:
        orm_mode = True

