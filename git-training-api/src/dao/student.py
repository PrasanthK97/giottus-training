from sqlalchemy import text
from model import student
from operator import and_
from datetime import datetime

def get_student_by_id(id, connection):
    query = text("select id, name, joined_time from training.student where id = :student_id")
    result = connection.execute(query, {'student_id': id})

    for row in result:
        return {
            'id': row.id,
            'name': row.name,
            'joined_time': str(row.joined_time)
        }

    return None

def studentIsThere(connection, student_name):
    rowObj = connection.query(student.Student).filter(student.Student.name== student_name).first()
    print("isthere", rowObj)
    if(rowObj == None):
        return False
    else:
        return True
    
def verifyDetailsDao(connection, student_name, password):
    rowObj = connection.query(student.Student).filter(and_(student.Student.name== student_name, student.Student.password == password)).first()
    print("verifyDao", rowObj)
    res = {
        "student_id": None,
        "status": None
    }
    if(rowObj == None):
        res["status"] = False
        return res 
    else:
        print("student_id", rowObj.id)
        res["status"] = True
        res["student_id"] = rowObj.id
        return res

def studentRegistration(connection, student_name, password):
    rowObj = student.Student(name= student_name, password=password, joined_time= datetime.now() )
    connection.add(rowObj)
    connection.commit()

    return "Successfully Registered"

def get_student_by_id_model(id, connection):
    row = connection.query(student.Student).filter(student.Student.id == id).first()
    if row is not None:
        return {
            'id': row.id,
            'name': row.name,
            'joined_time': str(row.joined_time)
        }

    return None
