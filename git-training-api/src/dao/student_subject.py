from model import student_subject, student, subject

from operator import and_
from sqlalchemy import text, desc

def isAlreadyThere(student_id, subject_id, connection):
    is_there_obj = connection.query(student_subject.StudentSubject).filter(student_subject.StudentSubject.student_id == student_id)
    is_there = False
    for i in is_there_obj:
      print("checking_object",i.subject_id)
      if(i.subject_id == subject_id):
          is_there = True
          break 
    return is_there
        

def subscribe_to_subject(student_id, subject_id, connection):
    
   
    obj = student_subject.StudentSubject(student_id=student_id, subject_id=subject_id)
    connection.add(obj)
    connection.commit()
   

    return {
       'id': obj.id
          
    }

def deleteStudentSubjectDao(student_id, subject_id, connection):
    obj = connection.query(student_subject.StudentSubject).filter(
        and_( student_subject.StudentSubject.subject_id == subject_id,
              student_subject.StudentSubject.student_id == student_id)
       
    ).first()
    

    connection.delete(obj)
    connection.commit()

    return "Successfully deleted"

    # print(student_id, subject_id)

    # for i in obj:
    #      print(i.student_id, i.subject_id)

def subjectSubscribedCount(subject_id, order, connection):
    descp="desc"
    obj2 = connection.query(student_subject.StudentSubject).filter(student_subject.StudentSubject.subject_id == subject_id).all()
    print("==============================>", order)
    if(order == "dsc"):
        obj = connection.query(student_subject.StudentSubject.student_id,
                            subject.Subject.subjectName,
                            student_subject.StudentSubject.subject_id,
                            student_subject.StudentSubject.subscription_time,
                            student.Student.name).join(
                            student.Student, 
                            student_subject.StudentSubject.student_id == student.Student.id).join(
                                subject.Subject, student_subject.StudentSubject.subject_id==subject.Subject.subjectId
                            ).filter(student_subject.StudentSubject.subject_id == subject_id).order_by(desc(student.Student.name)).all()
    
    elif(order == "asc"):
        obj = connection.query(student_subject.StudentSubject.student_id,
                            subject.Subject.subjectName,
                            student_subject.StudentSubject.subject_id,
                            student_subject.StudentSubject.subscription_time,
                            student.Student.name).join(
                            student.Student, 
                            student_subject.StudentSubject.student_id == student.Student.id).join(
                                subject.Subject, student_subject.StudentSubject.subject_id==subject.Subject.subjectId
                            ).filter(student_subject.StudentSubject.subject_id == subject_id).order_by(student.Student.name).all()
   
    else:
        obj = connection.query(student_subject.StudentSubject.student_id,
                            subject.Subject.subjectName,
                            student_subject.StudentSubject.subject_id,
                            student_subject.StudentSubject.subscription_time,
                            student.Student.name).join(
                            student.Student, 
                            student_subject.StudentSubject.student_id == student.Student.id).join(
                                subject.Subject, student_subject.StudentSubject.subject_id==subject.Subject.subjectId
                            ).filter(student_subject.StudentSubject.subject_id == subject_id).all()
   

    res = {
        "status": "Failure",
        "data": None,
        
    }
    print("obj2",obj2)
    print(obj)
    print(obj[1].student_id)
    responseList = []
    for i in obj:
        print("This line prints the id of the elements in the list")
        responseList.append({"student_id": i[0], "student_name": i[4], "subject_name": i[1], "subject_id": i[2], "subscription_time": str(i[3])} )
    # "subject_name": i.subjectName,
    # obj2 = connection.query(student_subject.StudentSubject.student_id,
    #                         subject.Subject.subjectName,
    #                         student_subject.StudentSubject.subject_id,
    #                         student.Student.name).join(
    #                         student.Student, 
    #                         student_subject.StudentSubject.student_id == student.Student.id).join(
    #                             subject.Subject, student_subject.StudentSubject.subject_id==subject.Subject.subjectId
    #                         ).all()
    # print(obj2)

    # if obj is not None:
        
    res["status"] = "success"
    res["data"] = responseList

    return res
    

def optedSubjects(student_id, connection):
    query = text("select tt.name as student_name, tt.id as student_id, tt.subject_id, subject.name as subject_name,tt.subscription_time from (select student.name, student.id, student_subject.subject_id, student_subject.subscription_time  from training.student inner join training.student_subject on student.id = student_subject.student_id)  as tt  inner join training.subject  on tt.subject_id = subject.id having tt.id = :student_id;")
    result = connection.execute(query, {'student_id': student_id})
    res = {}
 

    #res["student_name"] = result[0].student_name
    #res["student_id"] = result["student_id"]
    res["subjects"] = []
    for row in result:
        if("student_name" not in res):
            res["student_name"] = row.student_name
        elif("student_id" not in res):
            res["student_id"] = row.student_id
    
        res["subjects"].append(
            {    
                "subject_id" : row.subject_id,
                "subject_name" : row.subject_name,
                'joined_time': str(row.subscription_time)
            })
    
    return res


def change_student_subject(student_id, old_subject_id, new_subject_id, connection):
    obj = connection.query(student_subject.StudentSubject).filter(
        and_(
            student_subject.StudentSubject.student_id == student_id,
            student_subject.StudentSubject.subject_id == old_subject_id
        )
    ).first()

    if obj is not None:
        obj.subject_id = new_subject_id
        connection.commit()

        return True

    return False

# obj=connection.query(employee.Employee.employee_id,employee.Employee.employee_name,
#                          employee.Employee.joined_time,         employer.Employer.employer_id,employer.Employer.employer_name).join(employee_employer.EmployeeEmployer,employee.Employee.employee_id==employee_employer.EmployeeEmployer.employee_id).join(
#                              employer.Employer,employer.Employer.employer_id==employee_employer.EmployeeEmployer.employer_id
#                          )

