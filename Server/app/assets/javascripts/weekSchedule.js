var secArray
var classBoxArray = []
var currentSel
var availableTags 
var currentModal
var sectionsArray

function addData(tags){
    availableTags = tags;
    console.log(availableTags);
}

function createScheduleView() {
  var scheduleDrop = document.getElementById("selectSchedule")
  scheduleDrop.options.length = 0;
  
  for(var i = 0; i < secArray.length; i++){
    scheduleDrop.options[scheduleDrop.options.length] = new Option("schedule " + (i+1) , i)
  }
    
    updateTable(0)
    
        
}

function updateTable(k){
    currentSel = k;
    createWeekcalendar();
    
     var smallTable = document.getElementById("smallTableSchedule")
     
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
        cell1.innerHTML = secArray[currentSel].arrOfSections[i].name;
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

function loadSections(className){
    
    className = className.replace(/\s/g,'')
    
    var classNameOB = {
        classID: className
    }
    
    console.log(classNameOB);
        
   $.ajax({
        url: "/dashboard",
        data: classNameOB,
        dataType: 'JSON',
        contentType: "application/json;charset=utf-8",
        context: this,
        success: function(data) {
            modalDisplay(data);
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
    var deleteButton = document.createElement('button')
    var optionsDiv = document.createElement('div')
    
    editButton.className = "btn btn-default"
    editButton.innerHTML = "<span class='glyphicon glyphicon-pencil'></span>"
    editButton.dataset.toggle = "modal"
    editButton.dataset.target = "#testDiv"
    
    deleteButton.className = "btn btn-default"
    deleteButton.innerHTML = "<span class='glyphicon glyphicon-remove'></span>"
    deleteButton.onclick = function(){ removeClassesBox(input)}
    
    connectSpan.className = "input-group-btn"
    connectSpan.appendChild(editButton)
    connectSpan.appendChild(deleteButton)
    
    optionsDiv.className = "modal fade"
    optionsDiv.id = "testDiv"
    optionsDiv.role = "dialog"
    modalSet(optionsDiv);
    
    input.type = "text"
    input.className = "form-control"
    //input.onchange = function(){alert('HEY')}
    
    inputDiv.appendChild(input)
    inputDiv.appendChild(optionsDiv)
    inputDiv.appendChild(connectSpan)
    
    
    container.appendChild(inputDiv)
    
    
    classBoxArray.push(input);
}


function modalSet(optionsDiv){
    var dialog = document.createElement('div')
    var inter = document.createElement('div')
    
    
    dialog.className = "modal-dialog"
    inter.className = "modal-content"
    
    
    $(optionsDiv).on('show.bs.modal', function (e) {
     console.log(e.target.firstChild.firstChild.children[1])  
     if(e.target.firstChild.firstChild.children[1] != null)
        e.target.firstChild.firstChild.removeChild(e.target.firstChild.firstChild.children[1])
    $(e.target.firstChild.firstChild).append("<h4 class='modal-title' style='font-weight: 400; padding: 10px 10px 10px 10px'>Loading...</h4>")
     
    })
    
    $(optionsDiv).on('shown.bs.modal', function (e) {
        var className = e.relatedTarget.parentNode.parentNode.firstChild.value
        var sectionArray = 
         currentModal = e.target.children[1].firstChild
         loadSections(className);
    });
    
    $(inter).append("<div class='modal-header'><button type='button' class='close' data-dismiss='modal'><span aria-hidden='true'>&times;</span><span class='sr-only'>Close</span></button><h4 class='modal-title' style='font-weight: 400'>Sections</h4></div>")
    dialog.appendChild(inter);
    optionsDiv.appendChild(dialog);
    
}

function modalDisplay(sections){
    if(currentModal.children[1] != null)
            currentModal.removeChild(currentModal.children[1])
    
    if(sections.length != 0)
    {
        var table = document.createElement('table')
        table.className = "table"
        var tableBody = document.createElement('tbody');
        
        for(var i = 0; i < sections.length; i++)
        {var row = document.createElement('tr');
            
            var check = document.createElement('input');
            var cell1 = document.createElement('td');
            var cell = document.createElement('td');
            var cell2 = document.createElement('td');
            var cell3 = document.createElement('td');
            check.type = "checkbox"
            check.checked = true
            cell1.appendChild(check);
            cell.appendChild(document.createTextNode(sections[i].courseID));
            cell2.appendChild(document.createTextNode(sections[i].classTime));
            cell3.appendChild(document.createTextNode(sections[i].location));
            row.appendChild(cell1);
            row.appendChild(cell);
            row.appendChild(cell2);
            row.appendChild(cell3);
         
            tableBody.appendChild(row);
        }
        
    
        table.appendChild(tableBody);
        currentModal.appendChild(table);
    }
    else {
        $(currentModal).append("<h4 class='modal-title' style='font-weight: 400; padding: 10px 10px 10px 10px'>No Valid Course</h4>")
    }
}

function removeClassesBox(box){
    classBoxArray.splice(classBoxArray.indexOf(box), 1);
    
    box.parentNode.parentNode.removeChild(box.parentNode);
}


function createWeekcalendar(){
    
    var colors = ['#F44336','#673AB7','#00BCD4','#4CAF50','#FFC107','#00BCD4','#FF5722','#673AB7','#00BCD4','#00BCD4']
    var days = ['Sunday','Monday','Tuesday','Wensday','Thursday','Friday','Saturday']
    
    
    var c = $('#c');
    var ct = c.get(0).getContext('2d');
    var ctx = document.getElementById("c").getContext("2d");
   
    
    c.attr('width', jQuery("#canCol").width());

    var totalLen = jQuery("#canCol").width()
    var xLen =  totalLen - 75
    var xSpace = xLen / 7
    
    var c_canvas = document.getElementById("c");
    var context = c_canvas.getContext("2d");

   
    context.font="20px Roboto";
    
    context.moveTo(0, 50.5);
    context.lineTo(0, 901);
    
    var index = 0;
    for (var x = 75; x < totalLen + 1; x += xSpace) {
      context.fillText(days[index],x + 5,40)  
      context.moveTo(x, 50.5);
      context.lineTo(x, 901);
      index ++
    }
    
    
    context.font="14px Roboto";
    index = 6;
    for (var y = 50.5; y < 901; y += 50) {
      context.moveTo(0, y);
      context.lineTo(jQuery("#canCol").width(), y);
      context.dashedLine(75, y + 25, jQuery("#canCol").width(), y + 25, 2);
      context.fillText(militaryToStandard(100 * index),5, y + 20)
      index ++
    }
    
    context.strokeStyle = "#aaa";
    context.stroke();


    var classTimes = [] 
    if(secArray){
    
        for(var i = 0; i < secArray[currentSel].arrOfSections.length; i++)
        {
            classTimes = timestringToMilitaryDay(secArray[currentSel].arrOfSections[i].classTime);
            for(var j = 0; j<classTimes.length; j++){
                context.classBlock(classTimes[j].day * xSpace, militaryToPixel(classTimes[j].sMTime), xSpace, militaryToPixel(classTimes[j].eMTime), colors[i], secArray[currentSel].arrOfSections[i], classTimes[j]);
            }
        }
        
    }
}


CanvasRenderingContext2D.prototype.classBlock = function (x1, y1, x2, y2, color, obj, timeObj) {
    y2 = y2-y1
    
    this.beginPath();
    this.rect(x1 + 75, y1 + 50, x2, y2);
    
    this.fillStyle = "rgba(" + hexToRgb(color).r + "," + hexToRgb(color).g + ","+ hexToRgb(color).b +", 0.5)";
    this.fill();
    
    this.fillStyle = 'black';
    this.font="14px Roboto";
    this.fillText(obj.name ,x1 + 80, y1 + 65)
    this.font="10px Roboto";
    this.fillText(timeObj.sTime ,x1 + 80, y1 + 80)
    this.fillText(timeObj.eTime ,x1 + 130, y1 + 80)
}

 CanvasRenderingContext2D.prototype.dashedLine = function (x1, y1, x2, y2, dashLen) {
        if (dashLen == undefined) dashLen = 2;
        this.moveTo(x1, y1);
    
        var dX = x2 - x1;
        var dY = y2 - y1;
        var dashes = Math.floor(Math.sqrt(dX * dX + dY * dY) / dashLen);
        var dashX = dX / dashes;
        var dashY = dY / dashes;
    
        var q = 0;
        while (q++ < dashes) {
            x1 += dashX;
            y1 += dashY;
            this[q % 2 == 0 ? 'moveTo' : 'lineTo'](x1, y1);
        }
        this[q % 2 == 0 ? 'moveTo' : 'lineTo'](x2, y2);
    };
    
    function hexToRgb(hex) {
        var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
        return result ? {
            r: parseInt(result[1], 16),
            g: parseInt(result[2], 16),
            b: parseInt(result[3], 16)
        } : null;
    }
    
    function militaryToStandard(time) {
        if(time > 1200){
            var n = time - 1200
            var stringN = n.toString()
            var flag = "PM"
        }
        else {
            var  stringN = time.toString()
            var flag = "AM"
        }
        
        if(stringN.length != 4 )
            stringN = stringN.slice(0,1) + ":" + stringN.slice(1);
        else
            stringN = stringN.slice(0,2) + ":" + stringN.slice(2);
        
        return stringN + " " + flag;
    }
    function standardToMilitary(time) {
        var re = /\s*[:]\s*/;
        var n = time.split(" ");
        var k = n[0].split(re);
        
        
        k[1] = k[1]/60 * 100;

        
        if(k[1] < 10)
            n[0] = k[0].toString() + "0" + k[1].toString();
        else
            n[0] = k[0].toString() + k[1].toString();
            
        
        var nFinal = parseInt(n[0])
        
        if(n[1] == "PM" && nFinal < 1200)
           nFinal += 1200
        return nFinal
    }
    
    function militaryToPixel(time) {
        var pixelN = time - 600;
        pixelN = pixelN / 2;
        
        return pixelN;
    }
    
    function timestringToMilitaryDay(timeString) {
        var re = /\s*[;,-]\s*/;
        var n = timeString.split(re);
        
        var MD = []
        var location = 0;
        var end = false;
        
        for(var i = 0; i < n.length; i++)
        switch(n[i]) {
            case "Sun":
                MD[MD.length] = {day: 0};
                break;
            case "Mon":
                MD[MD.length] = {day: 1};
                break;
            case "Tue":
                MD[MD.length] = {day: 2};
                break;
            case "Wed":
                MD[MD.length] = {day: 3};
                break;
            case "Thu":
                MD[MD.length] = {day: 4};
                break;
            case "Fri":
                MD[MD.length] = {day: 5};
                break;
            case "Sat":
                MD[MD.length] = {day: 6};
                break;
            default:
                if(end == false){
                    for(var j = location; j < MD.length; j++ ){
                        MD[j].sTime = n[i];
                        MD[j].sMTime = standardToMilitary(n[i]);
                          
                    }
                    end = true;
                }
                else{
                    for(var k = location; k < MD.length; k++ ){
                        MD[k].eTime = n[i];
                        MD[k].eMTime = standardToMilitary(n[i]);
                        location ++;   
                    } 
                    end = false;
                }
               break;
        }
        return MD;
    }
    
    
    $('head').append('<link rel="stylesheet" type="text/css" href="http://jquery-ui-bootstrap.github.io/jquery-ui-bootstrap/css/custom-theme/jquery-ui-1.10.3.custom.css" />')
    
    function jqueryLoaded() {
      $.each($(classBoxArray), function() {
        $(this).autocomplete({
          source: availableTags
        });
      });
    }