from sqlalchemy import Column, Integer, String, SmallInteger, VARCHAR
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class Subject(Base):
    __tablename__ = 'subject'
    __table_args__ = {'schema': 'training'}

    subjectId = Column("id", SmallInteger, nullable= False, primary_key = True)
    subjectName = Column("name", VARCHAR, nullable= False)
    