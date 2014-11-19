var secArray
var classBoxArray = []

function createScheduleView() {
  var scheduleDrop = document.getElementById("selectSchedule")
  scheduleDrop.options.length = 0;
  
  for(var i = 0; i < secArray.length; i++){
    scheduleDrop.options[scheduleDrop.options.length] = new Option("schedule " + (i+1) , i)
  }
    
    updateTable(0)
 // var c = document.getElementById("scheduleCanvas");
   // var ctx = c.getContext("2d");
    //ctx.rect(20, 20, 150, 100);
    //ctx.stroke();
    
    //return testObject[0].arrOfSections[0].name     
}

function updateTable(k){
    
     var bigTable = document.getElementById("largeTableSchedule")
     var smallTable = document.getElementById("smallTableSchedule")
     
     while (bigTable.rows.length > 0 )
     {
      bigTable.deleteRow(0)
     }
     
     for(var i = 0; i < secArray[k].arrOfSections.length; i++)
     {
         // Create an empty <tr> element and add it to the 1st position of the table:
        var row = bigTable.insertRow(i);
        
        // Insert new cells (<td> elements) at the 1st and 2nd position of the "new" <tr> element:
        var cell1 = row.insertCell(0);
        var cell2 = row.insertCell(1);
        var cell3 = row.insertCell(2);
      
        
        // Add some text to the new cells:
        cell1.innerHTML = secArray[k].arrOfSections[i].name + " - " + secArray[k].arrOfSections[i].section ;
        cell2.innerHTML = secArray[k].arrOfSections[i].classTime;
        cell3.innerHTML = secArray[k].arrOfSections[i].enrolled;
     }
    
    
    while (smallTable.rows.length > 0 )
     {
     smallTable.deleteRow(0)
     }
     
     for(var i = 0; i < secArray[k].arrOfSections.length; i++)
     {
         // Create an empty <tr> element and add it to the 1st position of the table:
        var row = smallTable.insertRow(i);
        
        // Insert new cells (<td> elements) at the 1st and 2nd position of the "new" <tr> element:
        var cell1 = row.insertCell(0);
        var cell2 = row.insertCell(1);
        
        // Add some text to the new cells:
        cell1.innerHTML = secArray[k].arrOfSections[i].name;
        cell2.innerHTML = secArray[k].arrOfSections[i].classTime;
     }
     
     var load = document.getElementById("loadingTag")
     load.innerHTML = ""
}


function loadSchedule(){
    var load = document.getElementById("loadingTag")
    load.innerHTML = "Loading..."
    var classesOB = {classes: []}
    
    for(var i = 0; i<classBoxArray.length; i++){
        classesOB.classes[i] = classBoxArray[i].value.toLowerCase()
    }
        var classes2 = {'classes': ['PHYS 2054','CHEM 1113','GNEG 1111','MATH 2554C','CSCE 2004']}
        console.log(classesOB)
        console.log(classes2)
        
    
   $.ajax({
        url: "/dashboard",
        data: classesOB,
        dataType: 'JSON',
        contentType: "application/json;charset=utf-8",
        context: this,
        success: function(data) {
            this.secArray = data
            this.createScheduleView()
        },
        error: function(xhr, status, error){
            alert("ERROR - xhr.status: " + xhr.status + '\nxhr.responseText: ' + xhr.responseText + '\nxhr.statusText: ' + xhr.statusText + '\nError: ' + error + '\nStatus: ' + status);
        }
    });
    
   
}

function addClassesBox(){

    var container = document.getElementById("classesBoxGroup")
    
    var inputDiv = document.createElement('div')
    
    inputDiv.className = "form-inline input-group form-group"
    
    var input = document.createElement('input')
    var connectSpan = document.createElement('span')
    var editButton = document.createElement('button')
    var optionsDiv = document.createElement('div')
    
    editButton.className = "btn btn-default"
    editButton.innerHTML = "<span class='glyphicon glyphicon-pencil'></span>"
    editButton["data-toggle"] = "collapse"
    editButton["data-target"] = "#testDiv"
    
    connectSpan.className = "input-group-btn"
    connectSpan.appendChild(editButton)
    
    optionsDiv.className = "collapse in"
    optionsDiv.innerHTML = "<h1>testing</h1>"
    optionsDiv.id = "testDiv"
    
    input.type = "text"
    input.className = "form-control"
    
    inputDiv.appendChild(input)
    inputDiv.appendChild(connectSpan)
    
    container.appendChild(inputDiv)
    //container.appendChild(optionsDiv)
    
    classBoxArray.push(input);
}