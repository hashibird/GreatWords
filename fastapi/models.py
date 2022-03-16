from sqlalchemy import Boolean, Column, ForeignKey, Integer, String
from sqlalchemy.orm import relationship
from sqlalchemy.sql.expression import false, null

from database import Base

class Speaker(Base):
    __tablename__ = "speakers"
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    speaker_name = Column(String(64), index=True)
    speaker_name_eng = Column(String(64), default="")
    speaker_detail = Column(String(256), default="")
    category_id = Column(Integer, ForeignKey("categories.id"), default=0)
    uuid = Column(String(64),  default=None)
    is_active = Column(Boolean, default=True)

    word = relationship("Great_word", back_populates="speaker")
    category = relationship("Category", back_populates="speaker")
    comments = relationship("Comment", back_populates="user")


class Great_word(Base):
    __tablename__ = "great_words"
    id = Column(Integer, primary_key=True, autoincrement=True)
    great_word = Column(String(256), nullable=false)
    speaker_id = Column(Integer, ForeignKey("speakers.id"), index=True,)

    speaker = relationship("Speaker", back_populates="word")
    comments = relationship("Comment", back_populates="great_word")


class Category(Base):
    __tablename__ = "categories"
    id = Column(Integer, primary_key=True, autoincrement=True)
    category_name = Column(String(64), index=True, nullable=false)
    category_detail = Column(String(256), nullable=false)

    speaker = relationship("Speaker", back_populates="category")


class Comment(Base):
    __tablename__ = "comments"

    id = Column(Integer, primary_key=True, autoincrement=True)
    comment = Column(String(256))
    uuid = Column(String(64), ForeignKey("speakers.uuid"))
    great_words_id = Column(Integer, ForeignKey("great_words.id"))

    user_name=""

    user = relationship("Speaker", back_populates="comments")
    great_word = relationship("Great_word", back_populates="comments")