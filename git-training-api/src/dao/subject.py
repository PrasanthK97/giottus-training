from model import subject

def all_subject(connection):

    obj= connection.query(subject.Subject.subjectId,subject.Subject.subjectName).all()

    data=[]
    for row in obj:

        data.append({
            'subject_id':row.subjectId,
            'subject_name':row.subjectName,
        })

    return data 