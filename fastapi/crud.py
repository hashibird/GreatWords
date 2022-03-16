from sqlalchemy.orm import Session
from sqlalchemy.sql.expression import false
from sqlalchemy.sql.functions import mode, user
import models, schemas


def get_speakers(db: Session, skip: int = 0, limit: int = 1000):
    res = db.query(models.Speaker).filter(models.Speaker.uuid == None).offset(skip).limit(limit).all()
    res += db.query(models.Speaker).filter(models.Speaker.uuid == "string").offset(skip).limit(limit).all()
    for r in res:
        # print(1)
        r.category_name=get_category_name(db, r.category_id)
    
    return res

def get_users(db: Session, skip: int = 0, limit: int = 1000):
    res = db.query(models.Speaker).filter(models.Speaker.uuid != None).offset(skip).limit(limit).all()
    ret = []
    for r in res:
        if len(r.word) >= 1:
            r.category_name=get_category_name(db, r.category_id)
            
            ret.append(r)
    return ret

def get_speaker_by_uuid(db: Session, uuid):
    res = db.query(models.Speaker).filter(models.Speaker.uuid == uuid).first()
    if res is not None:
        res.category_name=get_category_name(db, res.category_id)
        for c in res.comments:
            c.speaker_id = get_great_words_by_id(db, c.great_words_id).speaker_id
            c.user_name = get_speaker_by_id(db, c.speaker_id).speaker_name
    return res

def get_speaker_by_id(db: Session, speaker_id):
    res = db.query(models.Speaker).filter(models.Speaker.id == speaker_id).first()
    
    if res is not None:
        res.category_name=get_category_name(db, res.category_id)
    return res

def get_speaker_by_name(db: Session, speaker_name):
    res = db.query(models.Speaker).filter(models.Speaker.speaker_name.like(f"%{speaker_name}%")).all()
    for r in res:
        r.category_name=get_category_name(db, r.category_id)
    return res

def read_speaker_by_category_id(db: Session, category_id):
    res = db.query(models.Speaker).filter(models.Speaker.category_id == category_id).all()
    for r in res:
        r.category_name=get_category_name(db, r.category_id)
    return res

def get_great_words(db:Session, speaker_id: int):
    res = db.query(models.Great_word).filter(models.Great_word.speaker_id == speaker_id).all()
    for r in res:
        r.speaker_name = get_speaker_by_id(db, r.speaker_id).speaker_name
        for comment in r.comments:
            comment.user_name = get_speaker_by_uuid(db, comment.uuid).speaker_name
    return res

def get_great_words_by_id(db: Session, great_word_id: int):
    res = db.query(models.Great_word).filter(models.Great_word.id == great_word_id).first()
    return res

def get_great_words_by_seach_word(db: Session, search_word: str):
    ret = db.query(models.Great_word).filter(models.Great_word.great_word.like(f"%{search_word}%")).all()
    for r in ret:
        r.speaker_name = get_speaker_by_id(db, r.speaker_id).speaker_name
        for c in r.comments:
            c.user_name = get_speaker_by_uuid(db, c.uuid).speaker_name
    return ret

def get_categories(db: Session, skip: int = 0, limit: int = 100):
    res = db.query(models.Category).offset(skip).limit(limit).all()
    # print(res is None)
    return res

def read_great_word_comments(db: Session, great_word_id: int):
    ret = get_great_words_by_id(db, great_word_id)
    for r in ret.comments:
        r.user_name = get_speaker_by_uuid(db, r.uuid).speaker_name
    return ret.comments
    

def get_category_name(db:Session, category_id: int):
    res = db.query(models.Category).filter(models.Category.id == category_id).first()
    if res is not None:
        return res.category_name
    return None


def create_speaker(db: Session, speaker: schemas.Create_speaker):
    category_id = speaker.category_id
    if get_category_name(db, category_id) is None: #値が存在しているか検査
        category_id=0

    db_speaker = models.Speaker(speaker_name=speaker.speaker_name,
                    speaker_name_eng=speaker.speaker_name_eng,
                    speaker_detail=speaker.speaker_detail,
                    category_id=category_id,
                    uuid = speaker.uuid,
                    is_active = speaker.is_active
                    )
    try:
        db.add(db_speaker)
        db.flush()
        db.commit()
        db.refresh(db_speaker)
        print(12345678)
    except Exception as e:
        print(e)
    return get_speaker_by_id(db, db_speaker.id)

def create_great_word(db: Session, great_word: schemas.Create_great_word):
    speaker_name = get_speaker_by_id(db, great_word.speaker_id)
    if speaker_name is None:
        great_word.speaker_id = 0
    else:
        speaker_name = speaker_name.speaker_name
    db_great_word = models.Great_word(great_word=great_word.great_word,
                                    speaker_id=great_word.speaker_id)
    db_great_word.speaker_name = get_speaker_by_id(db, great_word.speaker_id).speaker_name
    db.add(db_great_word)
    db.flush()
    db.commit()
    db.refresh(db_great_word)
    if (great_word.uuid is not None) and great_word.uuid != "string":
        print("あああ")
        return get_speaker_by_uuid(db, great_word.uuid)
    print("あああああ")
    return get_great_words(db, great_word.speaker_id)

def create_comment(db: Session, comment: schemas.Create_comment):
    db_comment = models.Comment(comment=comment.comment,
                                uuid=comment.uuid,
                                great_words_id=comment.great_words_id)
    db.add(db_comment)
    db.flush()
    db.commit()
    db.refresh(db_comment)
    print(123)
    return read_great_word_comments(db, comment.great_words_id)

def check_uuid(db: Session, uuid: str):
    ret = db.query(models.Speaker).filter(models.Speaker.uuid == uuid).all()
    if len(ret) != 0:
        return {"message": False}
    return {"message": True}

def create_category(db: Session, category: schemas.Create_category):
    db_category = models.Category(category_name=category.category_name,
                                category_detail=category.category_detail)
    db.add(db_category)
    db.flush()
    db.commit()
    db.refresh(db_category)
    return get_categories(db)

def update_user(db: Session, user_info: schemas.Update_user):
    db_user = get_speaker_by_id(db, user_info.speaker_id)
    db_user.speaker_name = user_info.name
    db_user.speaker_detail = user_info.detail
    db.commit()
    db.refresh(db_user)
    return get_speaker_by_uuid(db, user_info.uuid)