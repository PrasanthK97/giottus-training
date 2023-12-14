<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body id="bodyCont">
    <h1>
        Admin Portal
    </h1>
   
    <input id="student_id" type="search"/>
    <div id="nameContainer">
    </div>
    <div id="details-container">
        <div id="student_container">

        </div>
        <table id="table_id">

        </table>
    </div>
   
    
    <script>

        async function getStudentDetails(url=""){
                let response = await fetch(url);
                return response.json();
        }

        let bodyEl = document.getElementById("bodyCont")
        let studentNameSpanEl = document.getElementById("student_name");
        let bodyCont = document.getElementById("details-container");
        let clickCount = 0;
        function createListofStudents(data){   
            console.log(data);
            let tableEl = document.createElement("table");
            bodyCont.appendChild(tableEl)
            // tableElCreation.setAttribute("id", "table_id")
            //let tableEl = document.getElementById("table_id");

            let rowEl2 = document.createElement("tr");
            tableEl.appendChild(rowEl2);
            
            let hd1El = document.createElement("th");
            hd1El.textContent = "S.No"
            rowEl2.appendChild(hd1El)

            let hd2El = document.createElement("th");
            hd2El.textContent = "Subject Name"
            rowEl2.appendChild(hd2El)

            let hd3El = document.createElement("th");
            hd3El.textContent = "Subject Id"
            rowEl2.appendChild(hd3El)

            let hd4El = document.createElement("th");
            hd4El.textContent = "Subscription Time"
            rowEl2.appendChild(hd4El)

            let sNo = 0;
            for (let i of data){
                console.log(i)
                var rowEl = document.createElement("tr");
                tableEl.appendChild(rowEl);
                
                var serialEl = document.createElement("td");
                sNo = sNo + 1;
                serialEl.textContent = sNo
                rowEl.append(serialEl);

                var subjectNameEl = document.createElement("td");
                subjectNameEl.textContent = i.subject_name
                rowEl.append(subjectNameEl);

                var subjectIdEl = document.createElement("td");
                subjectIdEl.textContent = i.subject_id
                rowEl.append(subjectIdEl);

                var subscriptionTimeEl = document.createElement("td");
                subscriptionTimeEl.textContent = i.joined_time
                rowEl.append(subscriptionTimeEl);
            }
        }

        let studentIdSearchElement = document.getElementById("student_id")
      
        studentIdSearchElement.addEventListener("keydown", function(event){
            
            bodyCont.innerHTML = "";
            let isSearchClicked = false
            if(event.key === "Enter"){
                    isSearchClicked = true;
            }
            if(event.target.value != "" && isSearchClicked === true){   
                holder = event.key.value; 
                clickCount = clickCount + 1
                console.log("key"+ event.key);    
                console.log("value"+event.target.value);
                let nameContainerEl=document.getElementById("nameContainer")
                nameContainerEl.innerHTML=""
                getStudentDetails("/student/subjects/"+ event.target.value).then((response)=>{
                    console.log(response.data.subjects);
                    if(studentIdSearchElement.value !== ""){                    
                            studentIdSearchElement.value=""
                            let nameEl = document.createElement("p");
                            nameEl.textContent = "Student Name:"
                            let spanEl = document.createElement("span");
                            spanEl.textContent = response.data.student_name;
                            nameEl.appendChild(spanEl);
                        
                            // let nameElContainer = document.getElementById("student_container");
                            // nameElContainer.appendChild(nameEl);
                            
                            // bodyEl.appendChild(nameElContainer);    

                            nameContainerEl.appendChild(nameEl);
                            createListofStudents(response.data.subjects);
                    }
                })
                


            }   
                
        })
    </script>
</body>
</html>