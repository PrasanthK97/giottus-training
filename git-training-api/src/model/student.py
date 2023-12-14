from sqlalchemy import Column, Integer, String, TIMESTAMP
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class Student(Base):
    __tablename__ = 'student'
    __table_args__ = {'schema': 'training'}

    id = Column('id', Integer, nullable=False, primary_key=True)
    name = Column('name', String, nullable=False)
    password = Column('password', String, nullable=False)
    joined_time = Column('joined_time', TIMESTAMP, nullable=False)
