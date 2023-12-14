import pathlib, sys
#print("This is the Sys.path before append", sys.path)
root_path = pathlib.Path(__file__).parent.resolve().parent.resolve()
# print("This is before root path", pathlib.Path(__file__))
# print("This is the root path",root_path)
# print("This is the downgraded root path", root_path.parent.resolve())


sys.path.append(str(root_path)) 
''' 1) Initially, the python interpreter searches for the user-defined
modules like "dao" which it will not find and throws an error. 
                                   
    2  So, the collective folder which has all the  modules(folders)
is included in the PYTHONPATH through sys.path.append(str(root_path))
                                   
    3  Now, upon printing the sys.path, we get a list which has
all the required modules(folder) along with the parent folder which has all the other folders(modules) like
like dao, model and services.'''

#print("This is the Sys.path", sys.path)


import os
from flask import Flask, request
import json, yaml
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from dao import student, student_subject, subject
import re,  threading, time
from threading import Thread
import redis


app = Flask(__name__)

def get_db_connection():
    # The bind keyword in the sessionmaker factory is optional.
    Session = sessionmaker(bind=db_engine)
    return Session()

@app.route('/student/<int:id>', methods=['GET'])
def get_student_details(id):
    res = {
        'status': 'success',
        'message': None,
        'data': None
      }
    print("student")
    try:
        connection = get_db_connection()
        res['data'] = student.get_student_by_id_model(id, connection)
    except Exception as e:
        print(str(e))

        res['status'] = 'failure1'
        res['message'] = 'Unable to get the student details'

    return json.dumps(res)


@app.route('/student/subjects/<int:student_id>', methods=["GET"])
def studentOptedSubjects(student_id):
    print('/student/subjects/<int:student_id>', student_id)
    res = {
        "status": "success",
        "message" : None,
        "data" : None 
    }
    
    connection = get_db_connection()
    res['data'] = student_subject.optedSubjects(student_id, connection)

    return json.dumps(res)


#@app.route('/student/subscribe/<int:subject_id>', methods=['POST'])

@app.route('/student/subscribe/', methods=['POST'])
def student_subscribe():
    res = {
        'status': 'success',
        'message': None,
        'data': None
    }
    #print([input["student_id"], input["student_name"]])
    try:
        input = request.get_json(force=True)
        print([input["student_id"], input["subject_id"]])
        if 'student_id' not in input:
            res['status'] = 'failure'
            res['message'] = 'No student id given'
        elif not re.match('^\d{1,9}$', str(input['student_id'])):
            res['status'] = 'failure'
            res['message'] = 'Invalid student id given'
        elif 'subject_id' not in input:
            res['status'] = 'failure'
            res['message'] = 'No subject id given'
        elif not re.match('^\d{1,4}$', str(input['subject_id'])):
            res['status'] = 'failure'
            res['message'] = 'Invalid subject id given'
        else:
            connection = get_db_connection()
            if(student_subject.isAlreadyThere(
                student_id=int(input['student_id']),
                subject_id=int(input['subject_id']),
                connection=connection
            )):
                res["status"] = "failure"
                res['message'] = "The selected subject is registered already"
            else:
                res['data'] = student_subject.subscribe_to_subject(
                    student_id=int(input['student_id']),
                    subject_id=int(input['subject_id']),
                    connection=connection
            )
    except Exception as e:
        print(str(e))
        res['data'] = None
        res['status'] = 'failureeeeeeeeeeeeee'
        res['message'] = 'Unable to subscribe the student to the subject'

    res['data'] = [input["student_id"], input["subject_id"]]
    return json.dumps(res)

@app.route("/subject/count/", methods= ["POST"])
def subjectCount():
    input = request.get_json(force=True)
    res ={
        "status": "success",
        "message": input["subject_id"],
        "data": None
    }
    connection = get_db_connection()
    response=  student_subject.subjectSubscribedCount(input["subject_id"], input["order"],connection )
    res['status'] = response["status"]
    res['data'] = response["data"]    
    print(res)
    return json.dumps(res)


@app.route('/student/register/', methods=['POST'])
def student_registration():
    res = {
        'status': 'success',
        'message': None,
        'data': None
    }
    #print( input["student_name"])
    try:
            input = request.get_json(force=True)
            
            print([input["student_name"], input["password"]])
        # if 'student_name' not in inpu:
        #     res['status'] = 'failure'
        #     res['message'] = 'No student id given'
        # elif not re.match('^\d{1,9}$', str(input['student_id'])):
        #     res['status'] = 'failure'
        #     res['message'] = 'Invalid student id given'
        # elif 'subject_id' not in input:
        #     res['status'] = 'failure'
        #     res['message'] = 'No subject id given'
        # elif not re.match('^\d{1,4}$', str(input['subject_id'])):
        #     res['status'] = 'failure'
        #     res['message'] = 'Invalid subject id given'
        # else:
            connection = get_db_connection()
            # if(student_subject.isAlreadyThere(
            #     student_id=int(input['student_id']),
            #     subject_id=int(input['subject_id']),
            #     connection=connection
            # )):
            #     res["status"] = "failure"
            #     res['message'] = "The selected subject is registered already"
            # else:

            isThere = student.studentIsThere(
                    connection = connection,
                    student_name = input["student_name"]
        )
            
            if(isThere == False):
                res['data'] = student.studentRegistration(
                        student_name= input['student_name'],
                        password = input['password'],
                        connection=connection
                        )
                
            else:
                res["message"] = "User already exists"
                res['status'] = 'failure'
                
    except Exception as e:
        print(str(e))
        res['data'] = [input["student_name"]]
        res['status'] = 'failureeeeeeeeeeeeee'
        res['message'] = 'Unable to register'

   # res['data'] = [input["student_id"], input["subject_id"]]
    return json.dumps(res)


@app.route('/student/verify', methods= ['POST'])
def verifyDetails():
    connection = get_db_connection()
    res = {
        "status": None,
        "message": None,
        "data": None
    }
    input = request.get_json(force= True)

    response = student.verifyDetailsDao(connection=connection, student_name = input["student_name"], password = input["password"])
    if(response["status"]):
        res["status"] = "success"
        res["message"] = "Successfully Verified"
        res['student_id'] =  response["student_id"]
        return json.dumps(res) 
    else:
        res["status"] = "failure"
        res["message"] = "Invalid Credentials"
        return json.dumps(res)


@app.route('/student/subscribe/change', methods=['POST'])

def increment(n=0):
      while True: 
       n = n+1
       print(n)
       time.sleep(1)
       
def student_subscribe_change():
    res = {
        'status': 'success',
        'message': None,
        'data': None
    }

    try:
        input = request.get_json(force=True)
        if 'student_id' not in input:
            res['status'] = 'failure'
            res['message'] = 'No student id given'
        elif not re.match('^\d{1,9}$', str(input['student_id'])):
            res['status'] = 'failure'
            res['message'] = 'Invalid student id given'
        elif 'old_subject_id' not in input:
            res['status'] = 'failure'
            res['message'] = 'No old subject id given'
        elif not re.match('^\d{1,4}$', str(input['old_subject_id'])):
            res['status'] = 'failure'
            res['message'] = 'Invalid old subject id given'
        elif 'new_subject_id' not in input:
            res['status'] = 'failure'
            res['message'] = 'No new subject id given'
        elif not re.match('^\d{1,4}$', str(input['new_subject_id'])):
            res['status'] = 'failure'
            res['message'] = 'Invalid new subject id given'
        else:
            connection = get_db_connection()
            res['data'] = student_subject.change_student_subject(
                student_id=int(input['student_id']),
                old_subject_id=int(input['old_subject_id']),
                new_subject_id=int(input['new_subject_id']),
                connection=connection
            )
    except Exception as e:
        print(str(e))

        res['status'] = 'failure3'
        res['message'] = 'Unable to subscribe the student to the subject'

    return json.dumps(res)

@app.route("/delete/subject", methods= ["POST"])
def deleteStudentSubject():
    res = {
        'status' : None,
        'message': None,
        'data':None
    }
    print("delete initiated")
    input = request.get_json(force=True)
    print(input['student_id'])
    print(input['subject_id'])
    connection = get_db_connection()
    
    res["message"] = student_subject.deleteStudentSubjectDao(
        student_id=int(input['student_id']),
        subject_id=int(input['subject_id']),
        connection=connection)
    
    return json.dumps(res["message"])
    


@app.route('/subject',methods=['GET'])
def subject_details():
    res= {
        'status' : 'success',
        'message': None,
        'data':None
    }
    print("subject")
    try:
        connection=get_db_connection()
        res['data'] = subject.all_subject(connection)

    except Exception as e:
        print(str(e))
        res['status']='failure4'
        res['message']= 'Unable to get the subject detail'

    return json.dumps(res)



file_config = yaml.load(open(os.path.join(root_path, "..", "conf", "config.yml")))
#print("the yaml mehthod", file_config)
db_engine = create_engine(file_config['db_connection_string'], pool_size=50, isolation_level="READ COMMITTED")

redisConn = redis.Redis(host="localhost", port=6379)
# redisConn.set("today", "nov23")
# print(redisConn.get("today"))

# while True:
#      time.sleep(1)
#      redisConn.publish("Gio", "Welcome to Gio")


# def increment(n=0):
#     while True:
#         time.sleep(1)
#         n = n+1
#         print(n)
#         redisConn.publish("mychannel", str(n))
       

# t= Thread(target=increment, args=(100,))
# t.daemon =True
# t.start()



app.run('localhost', 8000)
