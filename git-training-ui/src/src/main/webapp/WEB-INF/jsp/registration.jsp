<!DOCTYPE html>
<html lang="en">
<head>
    <title>Document</title>
</head>
<style>
    body{
        padding: 100px;
        text-align: center;
    }

    input{
       
        height:30px;
        margin:20px;
        border-radius: 8px;
    }

    button {
            height:40px;
            width:80px;
            border-radius: 8px;
            color: white;
            background-color: blue;
            margin:20px;
            font-weight: bold;
        }

</style>
<body>
    <h1>Registration</h1>
    <div>
        <input id="inputStudentName" placeholder="Student Name" type="text"/>
    </div>
    <div>
        <input id="inputPassword" placeholder="Password" type="text"/>
        <p>Already have an account? Click here to <a href="\login">Login</a></p>
    </div>
        <button type="button" id="registrationButton">Register</button>
    
    <script type="text/javascript">

        async function registrationCall(url="", data={}) {
            const response = await fetch(url, {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                body: new URLSearchParams(data).toString()
            });

            return response.json();
        
        }

        //  document.getElementById("LoginPageButton").addEventListener("click", function(){
        //     console.log("login page button clicked");
        //     window.location.href = '/login';
        //  })

         document.getElementById("registrationButton").addEventListener("click", function(){
            console.log("register button clicked");
            let studentNameValue = document.getElementById("inputStudentName").value;
            let passwordValue = document.getElementById("inputPassword").value;
            document.getElementById("inputStudentName").value = "";
            document.getElementById("inputPassword").value = "";
            console.log(studentNameValue + passwordValue);
            
            if(studentNameValue === "" || passwordValue === ""){
                alert ("Enter Valid UserName or Password")
            }
            else{
            
                registrationCall("/doregistration", {"student_name": studentNameValue, "password": passwordValue}).then((response)=>{
                        console.log(response);
                        
                        if(response["status"] === "success"){
                            alert(response["status"]);
                            window.location.href  = "/login";
                        }
                        else{
                            alert(response["message"]);    
                        }
                });
            }
         })    
    </script>
</body>
</html>