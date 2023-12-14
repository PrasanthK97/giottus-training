<%@page import= "com.training.TrainingUiApplication"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Home</title>
    </head>
    <style>
        li{
            display: flex;
            flex-direction: row;
            justify-content: space-around;     
            padding-right:10px;
        }

        button{
            height:35px;
            width: 100px;
            border-radius: 5px;
            background-color: blue;
            color: white;
        }

        #table-container{
            /* margin-left: 40px; */
            display: flex;
            justify-content: center;
            text-align:center;  
        }

        #subject_table{
            margin:5px;
            width: 70vw;
        }

        #opted_table_container{
            display: flex;
            justify-content: center;
            text-align:center;        
        }

        #opted_subjects_table{
            margin:5px;
            width: 70vw;
        }

        tr{
            margin-top:10px;
        }

    </style>
    <body id ="ff">
        <!-- <div class="home-div">This is the home page</div> -->
       
        <div>
            <div>
               
               <p>This is the userID fetched from the Session setAttribute</p> ${user_id}
                <span>Student Name:</span> <span id="studentNameElem"></span>
            </div>
            
            <!-- <div>
                <span>Joined Time:</span> <span id="studentJoinedTimeElem"></span>
            </div> -->
        </div>
        <h2>COURSES ENROLLED:</h2>
        
        <div id="opted_table_container">
            <ul id="opted_subjects_list" class="opted_subjects_list">

            </ul>
            <table id="opted_subjects_table">
                <tr>
                    <th>SUBJECT ID</th>
                    <th>SUBJECT NAME</th>
                    <th>STATUS</th>
                </tr>  
            </table>
        </div>
        <h2>COURSES AVAILABLE:</h2>
        <div id="table-container">
            <table id="subject_table">
                <tr>
                    <th>SUBJECT ID</th>
                    <th>SUBJECT NAME</th>
                    <th>STATUS</th>
                </tr>
            </table>
        </div>
        <div>
            <ul class = "ul1" id = "ul1"></ul>
        </div>
        <script type="text/javascript">
            let bodyElement = document.getElementById("ff");

            async function getData(url = "") {
                const response = await fetch(url);

                return response.json();
            }

            async function subscribeData(url = "", data = {}) {
                const response = await fetch(url, {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/x-www-form-urlencoded"
                        },
                        body: new URLSearchParams(data).toString()
                });

                
                return response.json();
            }
            
            async function selectedSubjects(url = ""){
                const response = await fetch(url);
                return response.json()
            }

            async function subjectDetails(url = "") {
                const response = await fetch(url);
                return response.json();
            }


            // async function getSubjectCount(url="", data= {}) {
            //                     const response = await fetch(url, {
            //                         method: "POST",
            //                         headers: {"Content-Type": "application/x-www-form-urlencoded"}   ,
            //                         body: new URLSearchParams(data).toString()
            //                     });

            //                     return response.json();
            //                }

            getData("/details").then((data) => {
                if(data.status == 'success') {
                    document.getElementById('studentNameElem').innerText = data.data.name;
                    document.getElementById('studentJoinedTimeElem').innerText = data.data.joined_time;
                } else {
                    alert(data.message);
                }
            });

            

            selectedSubjects("/subjects/selected").then((response) => {
                
                let selectedSubjectsListElement = document.getElementById("opted_subjects_list");
                for (let i of response["data"]["subjects"]){


                    let tableEl = document.getElementById("opted_subjects_table");
                    let tableRowEl = document.createElement("tr");
                    tableEl.appendChild(tableRowEl);

                    var tableDataEl = document.createElement("td");
                    tableDataEl.textContent = i["subject_id"];
                    tableRowEl.appendChild(tableDataEl);

                    var tableDataEl = document.createElement("td");
                    tableDataEl.textContent = i["subject_name"];
                    tableRowEl.appendChild(tableDataEl);



                    var buttonElement = document.createElement("button");
                    buttonElement.id = "delete_button" + i["subject_name"];
                    console.log(buttonElement.id);
                    buttonElement.textContent = "UnSubscribe";

                    var tableDataEl = document.createElement("td");
                    tableDataEl.appendChild(buttonElement);
                    tableRowEl.appendChild(tableDataEl);


                      
                    // let listElement = document.createElement("li");
                    // //listElement.id = i["subject_id"];
                    // selectedSubjectsListElement.appendChild(listElement);
                    
                    // let subjectIdElement = document.createElement("p");
                    // subjectIdElement.textContent = i["subject_id"];
                    // listElement.appendChild(subjectIdElement);

                    // let subjectNameElement = document.createElement("p");
                    // subjectNameElement.textContent = i["subject_name"];
                    // listElement.appendChild(subjectNameElement);

                    // let joiningTimeElement = document.createElement("p");
                    // joiningTimeElement.textContent = i["joined_time"];
                    // listElement.appendChild(joiningTimeElement);

                    // let buttonElement = document.createElement("button");
                    // buttonElement.id = "delete_button" + i["subject_name"];
                    // console.log(buttonElement.id);
                    // buttonElement.textContent = "UnSubscribe";
                    // listElement.appendChild(buttonElement);
                    
                    document.getElementById("delete_button"+ i["subject_name"]).onclick = function(){
                        console.log(buttonElement.id);
                        
                        let subject_id_int = parseInt(i["subject_id"]);
                        
                        async function deleteStudentSubject(url = "", data={}) {
                            
                            const response2 = await fetch(url, {
                                method: "POST",
                                headers: {
                                    "Content-Type": "application/x-www-form-urlencoded"
                                },
                                body: new URLSearchParams(data).toString()
                            });

                            return response2.json();
                        }
                        
                        deleteStudentSubject("/student/subject/delete", data={"subject_id": subject_id_int, "student_id": Number(1)}).then((response2)=> {
                            console.log(response2);   
                            alert(response2);     
                            window.location.href='/home';
                        })
                    }

 

                console.log("ss",response["data"]);
                }
            })

            
        

            function createSubject(eachSubject){
                
                for (let i of eachSubject){
                    console.log(i["subject_id"]+i);

                    let tableEl = document.getElementById("subject_table");
                    let tableRowEl = document.createElement("tr");
                    tableEl.appendChild(tableRowEl);

                    var tableDataEl = document.createElement("td");
                    tableDataEl.textContent = i["subject_id"];
                    tableRowEl.appendChild(tableDataEl);

                    var tableDataEl = document.createElement("td");
                    var subjectAnchorEl = document.createElement("a");
                    subjectAnchorEl.textContent = i["subject_name"];
                    // subjectAnchorEl.setAttribute("href","/details");

                    // async function getSubjectCount(url="") {
                    //             const response = await fetch(url, {
                    //                 method: "POST",
                    //                 // headers: {"Content-Type": "application/x-www-form-urlencoded"}   ,
                    //                 // body: new URLSearchParams(data).toString()
                    //             });

                    //             return response.json();
                    //        }

                    // subjectAnchorEl.addEventListener("click",function(){
                    //     console.log("clicked");



                    // //     getSubjectCount("/subject/count").then((response)=> {
                    // //                console.log("dfdsnvjn");
                    // //                console.log(response);
                    // // })
                    // }
                    
                    // );

                    async function getSubjectCount(url="", data={"subject_id": i["subject_id"]}){
                       
                        const res = await fetch(url, {
                                    method: "POST",
                                    headers: {"Content-Type": "application/x-www-form-urlencoded"}   ,
                                    body: new URLSearchParams(data).toString()
                                });
                        console.log("rereererer",res);
                        return res.json();
                    }

                    subjectAnchorEl.addEventListener("click",function(){
                        console.log("clicked")
                        getSubjectCount("/subject/count", data={"subject_id": i["subject_id"]}).then((res)=>{
                            console.log(res)
                            if(res.status === "success"){
                                window.location.href = "/countPage"
                                console.log("details-repsonse",res);
                            }
                        })
                    })
        
                    tableDataEl.appendChild(subjectAnchorEl);
                    tableRowEl.appendChild(tableDataEl);


                    // let listElement = document.createElement("li");
                    // listElement.id = i["subject_id"];
                    // unordered_list.appendChild(listElement);
                    
                    // let subjectIdElement = document.createElement("p");
                    // subjectIdElement.textContent = i["subject_id"];
                    // listElement.appendChild(subjectIdElement);
                    
                    // let subjectNameElement = document.createElement("p");
                    // subjectNameElement.textContent = i["subject_name"];
                    // listElement.appendChild(subjectNameElement);

                    let buttonElement = document.createElement("button");
                    buttonElement.id = "button" + i["subject_name"];
                    console.log(buttonElement.id);
                    buttonElement.textContent = "Subscribe";
                    

                    var tableDataEl = document.createElement("td");
                    tableDataEl.appendChild(buttonElement);
                    tableRowEl.appendChild(tableDataEl);



                    //listElement.appendChild(buttonElement);


                    document.getElementById("button"+ i["subject_name"]).onclick = function(){
                        console.log(buttonElement.id);
                        console.log(i["subject_id"]);
                        async function subscribeData(url = "", data = {}) {
                        const response = await fetch(url, {
                                method: "POST",
                                headers: {
                                    "Content-Type": "application/x-www-form-urlencoded"
                                },
                                body: new URLSearchParams(data).toString()
                        });
                        return response.json();
                        }
                            
                        subscribeData("/subscribe/subject", { "subject_id": parseInt(i["subject_id"]), "student_id": Number(1)}).then((response) => {
                            if(response.status == 'success') {
                                console.log(response)
                                alert("Subscribed Successfully");
                                window.location.href='/home';
                            } else {
                                console.log(response)
                                alert(response.message);   
                            }
                        });
            

                    };


                }
            }

            // subjectDetails("/subjects").then((response) => {
            //     console.log("data"+response);
            //     createSubject(response.data);
            //     for (let each of response.data){
            //                 console.log(each);  
            //     }
            // });

            
                 //let d = document.createElement("p");
                 
                 //bodyElement.appendChild(d);
                 //d.textContent = "fffffffffffffffff";

                
                 
            let unordered_list = document.getElementById("ul1");

                 

              
                 
                 /*let elementCount = 0;
                 let unordered_list = document.createElement("ul");
                 unordered_list.setAttribute("id", "id_unordered_list")
                 ff.appendChild(id_unordered_list)
                 let dd = document.createElement("p");
                 dd.textContent = "efjfsfkflksmf";
                 body.appendChild(dd);


                 let c = document.createElement("li");
                 c.textContent = "response"; 
                 c.textContent = response["data"][0]["subject_id"];
                 ff.appendChild(c);
                 */

              

            function populateSubjects(subjectResponse){
                console.log("sdhfjhdsfhjg",subjectResponse);
                // for (let each of subjectResponse.data){
                //         console.log(each);
                        createSubject(subjectResponse.data);
                //}
            }
         populateSubjects(<%=TrainingUiApplication.getSubjects()%>);
        </script>
    </body>
</html>