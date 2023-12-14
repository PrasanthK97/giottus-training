<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Login</title>
    </head>
    <style>
        body{
            padding:100px;
            text-align: center;
        }

        input {
              height: 30px;
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
        <h1>Login</h1>
        <div>
            <input type="text" id="username" placeholder="Student Name" />
        </div>
        <div>
            <input type="password" id="password" placeholder="Password" />
            <p>Don't have an account ? Click  <a href="\registration">here</a></p>
        </div>
            <button id="loginbtn">Login</button>

        <script type="text/javascript">
            async function postData(url = "", data = {}) {
                const response = await fetch(url, {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: new URLSearchParams(data).toString()
                });

                return response.json();
            }

            document.getElementById('loginbtn').addEventListener('click', function() {
                let username = document.getElementById('username').value;
                let password = document.getElementById('password').value;
                postData("/dologin", { userName: username, password: password }).then((response) => {
                    if(response.status == 'success') {
                        console.log(response);
                        alert("success");
                        
                        window.location.href = '/home';
                    } else {
                        alert(response.message);
                        console.log(response);
                    }
                });
            });
        </script>
    </body>
</html>