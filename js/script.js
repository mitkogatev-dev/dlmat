function resizeIframe(obj) {    
    // console.log(obj);                                                                                                                                                                 
// obj.style.height = 400 + 'px';                                                                                                                                                                     
obj.style.height = obj.contentWindow.document.body.scrollHeight+200 + 'px';                                                                                                                  
// obj.style.width = obj.contentWindow.document.body.scrollWidth + 'px';  
// console.log(obj.contentWindow.document.body.scrollHeight);                                                                                                  
 }

function selAll(){
    const checkArr = document.querySelectorAll("input[type=checkbox]");
    checkArr.forEach(function(elem) {
        elem.click();
    });
}
function selRow(input){
    let sel=input.closest('tr').querySelector('[name=sel]');
    if(!sel.checked){
    sel.click();
    }
}
function confirmDel(e){
    if (confirm("sure to delete?")) {
    return 1;
    }else{
      e.preventDefault();
      return 0;
    }
  }

function handleIntNum(){
    const checkArr = document.querySelectorAll("input[type=checkbox]");
    let nums=[];
    for (let i = 0; i < checkArr.length; i++) {
        const checkElem = checkArr[i];
        nums.push(i+1+'');
        checkElem.addEventListener("change", function() {
            const numInput=this.closest('tr').querySelector('[name^=int_number]');
            const nameInput=this.closest('tr').querySelector('[name^=int_name]');
            const numVal=this.closest('tr').querySelector('.num_val');
            if(this.checked){
             numInput.value=nums.sort().shift();
             nameInput.value="Port "+numInput.value;
             numVal.innerHTML=numInput.value;
            }else{
             nums.unshift(numInput.value);
             numInput.value="";
             nameInput.value="";
             numVal.innerHTML="";
            }
        });
    }
}
function printMsg(msg){
    // if(!msg || "" == msg){
    //   msg="<h4>Loading graphs... please wait</h4>";
    // }
    const msgBox=parent.document.getElementById("infobox");
    msgBox.innerHTML=msg;
    setTimeout(() => {
        // console.log("Delayed for 1 second.");
        msgBox.innerHTML="";
      }, 2000);
      
    return 1;
  }