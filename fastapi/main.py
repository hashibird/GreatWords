from typing import List

from fastapi import Depends, FastAPI, HTTPException, encoders
from sqlalchemy.orm import Session
import crud, models, schemas
from database import SessionLocal, engine

from time import sleep


models.Base.metadata.create_all(bind=engine)

app = FastAPI()


# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/get/speakers/", response_model=List[schemas.Get_speaker])
def read_speakers(db: Session = Depends(get_db)):
    speakers = crud.get_speakers(db)
    
    print(len(speakers))
    return speakers

@app.get("/get/speaker/uuid/{uuid}/", response_model=schemas.Get_user)
def read_speaker(uuid: str, db: Session=Depends(get_db)):
    speaker = crud.get_speaker_by_uuid(db, uuid)
    return speaker

@app.get("/get/users", response_model=List[schemas.Get_users])
def read_users(db: Session=Depends(get_db)):
    users = crud.get_users(db)
    return users

@app.get("/get/speaker/id/{speaker_id}/", response_model=schemas.Get_speaker)
def read_speaker(speaker_id: int, db: Session=Depends(get_db)):
    speaker = crud.get_speaker_by_id(db, speaker_id)
    
    return speaker

@app.get("/get/speaker/name/{speaker_name}/", response_model=List[schemas.Get_speaker])
def read_speaker(speaker_name: str, db: Session=Depends(get_db)):
    speaker = crud.get_speaker_by_name(db, str(speaker_name))
    return speaker

@app.get("/get/speaker/category_id/{category_id}/", response_model=List[schemas.Get_speaker])
def read_speaker(category_id: int, db: Session = Depends(get_db)):
    speaker = crud.read_speaker_by_category_id(db, category_id)
    return speaker

@app.get("/get/speaker/id/{speaker_id}/great_words/", response_model=List[schemas.Get_great_word])
def read_great_words(speaker_id: int, db: Session = Depends(get_db)):
    great_words = crud.get_great_words(db, speaker_id)
    # sleep(2)
    
    return great_words

@app.get("/get/great_words/bySearchWord/{search_word}", response_model=List[schemas.Get_great_word])
def read_great_words_by_sarch_word(search_word: str, db: Session = Depends(get_db)):
    great_words = crud.get_great_words_by_seach_word(db, search_word)
    return great_words

@app.get("/get/categories/", response_model=List[schemas.Category])
def read_categories(db: Session = Depends(get_db)):
    categories = crud.get_categories(db)
    return categories

@app.get("/get/comments/great_word_id/{great_word_id}", response_model=List[schemas.Comment])
def read_great_word_comments(great_word_id: int, db: Session = Depends(get_db)):
    return crud.read_great_word_comments(db, great_word_id)

@app.post("/create/speaker/", response_model=schemas.Get_speaker)
def create_speaker(speaker: schemas.Create_speaker, db: Session = Depends(get_db)):
    return crud.create_speaker(db=db, speaker=speaker)

@app.post("/create/great_word/", response_model=List[schemas.Get_great_word])
def create_great_word(great_word: schemas.Create_great_word, db: Session = Depends(get_db)):
    return crud.create_great_word(db, great_word)

@app.post("/create/user/great_word/", response_model=schemas.Get_user)
def create_great_word(great_word: schemas.Create_great_word, db: Session = Depends(get_db)):
    return crud.create_great_word(db, great_word)

@app.post("/create/comment/", response_model=List[schemas.Comment])
def create_comment(comment: schemas.Create_comment, db: Session = Depends(get_db)):
    return crud.create_comment(db, comment)

@app.post("/create/category/", response_model=List[schemas.Category])
def create_category(category: schemas.Create_category, db:Session = Depends(get_db)):
    return crud.create_category(db, category)

@app.post("/update/user/name_detail/",response_model=schemas.Get_user)
def update_user(update_info: schemas.Update_user, db: Session = Depends(get_db)):
    return crud.update_user(db, update_info)

@app.get("/check/uuid/{uuid}")
def check_uuid(uuid: str, db: Session = Depends(get_db)):
    return crud.check_uuid(db, uuid)