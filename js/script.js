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

function handleIntNum(){
    const checkArr = document.querySelectorAll("input[type=checkbox]");
    let nums=[];
    for (let i = 0; i < checkArr.length; i++) {
        const checkElem = checkArr[i];
        nums.push(i+1+'');
        checkElem.addEventListener("change", function() {
            const numInput=this.closest('tr').querySelector('[name=int_number]');
            const nameInput=this.closest('tr').querySelector('[name=int_name]');
            if(this.checked){
             numInput.value=nums.sort().shift();
             nameInput.value="Port "+numInput.value;
            }else{
             nums.unshift(numInput.value);
             numInput.value="";
             nameInput.value="";
            }
        });
    }
}