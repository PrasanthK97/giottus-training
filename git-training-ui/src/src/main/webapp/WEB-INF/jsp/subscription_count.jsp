<%@page import= "com.training.controller.TrainingController"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<style>
    #student_table{
        width:80%;
        margin-top: 30px;
    }
    td{
        text-align: center;
    }
    .filter-container{
        display: flex;
        flex-direction: column;
        margin-right:20px;
    }
    .all-filters-container{
        display: flex;
    }
    label{
        font-weight: bold;
    }
</style>

<body>
    <h1 id="main-heading">Details</h1>
    <div class="all-filters-container">
        <div class="filter-container">
            <div>
                <label for="filter">Student Name Filter</label>
            </div>
            <div>
                <select name="filter" id="filter">
                    <option value="no_filter">No Filter</option>
                    <option value="asc">ASC</option>
                    <option value="dsc">DSC</option>
                </select>
            </div>
        </div>
        </br>
        <div class="filter-container">
            <div>
                <label for="idFilter">Student Id Filter</label>
            </div>
            <div>
                <select name="idFilter" id="idFilter">
                    <option value="no_filter">No Filter</option>
                    <option value="asc">ASC</option>
                    <option value="dsc">DSC</option>
                </select>
            </div>
        </div>
    </div>
    

    <table id="student_table">
        
    </table>

    <script>
               
        let d = (<%=TrainingController.getSubjectCountMethod()%>);
        console.log(d.data);

        

        
       
       
        // function compareNumbers(a, b) {
        //      return a - b;
        // }
        // array1.sort(compareNumbers)
        // console.log(array1)
        // for (let j of array1){
        //         array2.push(d.data[j])
        // }
        // console.log(array2)

        let idFilterEl = document.getElementById("idFilter");


        let tableEl = document.getElementById("student_table");
        let sNo = 0;

        var filterEl = document.getElementById("filter");
        console.log(filterEl.value);
        

        function createListofStudents(data){   
            sNo = 0;
            let rowEl2 = document.createElement("tr");
            tableEl.appendChild(rowEl2);
            
            let hd1El = document.createElement("th");
            hd1El.textContent = "S.No"
            rowEl2.appendChild(hd1El)

            let hd2El = document.createElement("th");
            hd2El.textContent = "Student Name"
            rowEl2.appendChild(hd2El)

            let hd3El = document.createElement("th");
            hd3El.textContent = "Student Id"
            rowEl2.appendChild(hd3El)

            let hd4El = document.createElement("th");
            hd4El.textContent = "Subscription Time"
            rowEl2.appendChild(hd4El)

            for (let i of data){
                var rowEl = document.createElement("tr");
                tableEl.appendChild(rowEl);
                
                var serialEl = document.createElement("td");
                sNo = sNo + 1;
                serialEl.textContent = sNo
                rowEl.append(serialEl);

                var studentNameEl = document.createElement("td");
                studentNameEl.textContent = i.student_name
                rowEl.append(studentNameEl);

                var studentIdEl = document.createElement("td");
                studentIdEl.textContent = i.student_id
                rowEl.append(studentIdEl);

                var subscriptionTimeEl = document.createElement("td");
                subscriptionTimeEl.textContent = i.subscription_time
                rowEl.append(subscriptionTimeEl);
            }
        }

        document.getElementById("main-heading").textContent = d.data[0].subject_name;
        createListofStudents(d.data);
        

        async function getSubjectCount(url="", data={"subject_id": i["subject_id"]}){
                       
                       const res = await fetch(url, {
                                   method: "POST",
                                   headers: {"Content-Type": "application/x-www-form-urlencoded"}   ,
                                   body: new URLSearchParams(data).toString()
                               });
                       console.log("rereererer",res);
                       return res.json();
                   }
        
        filterEl.addEventListener("change", function(){
            idFilterEl.value = "no_filter"
            console.log(filterEl.value);
            sNo = 0
            getSubjectCount("/subject/count", data={"subject_id": d.data[0].subject_id, "order" : filterEl.value}).then((response) =>{
                        tableEl.innerHTML = "";
                        console.log(response.data);
                        createListofStudents(response.data);
            })
        })

        idFilterEl.addEventListener("change", function(){
            let dataObject = d.data
            if(idFilterEl.value === "asc"){
                filterEl.value = "no_filter"
                dataObject.sort((a, b) => (
                a.student_id > b.student_id ? 1 : b.student_id > a.student_id ? -1 : 0));
                console.log(dataObject);
                tableEl.innerHTML = "";
                createListofStudents(dataObject);
            } 
               
            else if(idFilterEl.value === "dsc"){
                filterEl.value = "no_filter"
                dataObject.sort((a, b) => (
                a.student_id < b.student_id ? 1 : b.student_id < a.student_id ? -1 : 0));
                console.log(dataObject);
                tableEl.innerHTML = "";
                createListofStudents(dataObject);
            }

        })

        

    </script>
</body>
</html>