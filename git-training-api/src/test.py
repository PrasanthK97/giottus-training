# import smtplib

# sender = 'prasantheits@gmail.com'
# receivers = ['prasantheits@gmail.com']
# message = """Subject: SMTP email example
#              This is a test message."""

# try:
#     smtpObj = smtplib.SMTP('localhost')
#     smtpObj.sendmail(sender, receivers, message)         
#     print("Successfully sent email")
# except Exception as e:
#     pass


import mailtrap as mt

# create mail object
mail = mt.Mail(
    sender=mt.Address(email="prasantheits@gmail.com", name="Mailtrap Test"),
    to=[mt.Address(email="prasantheits@gmail.com")],
    subject="You are awesome!",
    text="Congrats for sending test email with Mailtrap!",
)

# create client and send
try :
    client = mt.MailtrapClient(token="ddbca8da67e7223cbbeb8bc799663ea7")
    client.send(mail)
except Exception as ex:
    print(client.api_port, client.api_host)
    print("The exception is:", ex)





