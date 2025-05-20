function resizeIframe(obj) {    
    // console.log(obj);                                                                                                                                                                 
// obj.style.height = 400 + 'px';                                                                                                                                                                     
obj.style.height = obj.contentWindow.document.body.scrollHeight+200 + 'px';                                                                                                                  
// obj.style.width = obj.contentWindow.document.body.scrollWidth + 'px';  
// console.log(obj.contentWindow.document.body.scrollHeight);                                                                                                  
 }

function handleIntNum(){
    const elemArr = document.querySelectorAll("input[type=checkbox]");
    console.log(elemArr);
    let nums=[];
    for (let i = 0; i < elemArr.length; i++) {
        const elem = elemArr[i];
        nums.push(i+1+'');
        elem.addEventListener("change", function() {
            const intEl=this.closest('tr').querySelector('[name=int_number]');
            if(this.checked){
            //  console.log("checked");
             intEl.value=nums.sort().shift();
    // console.log(nums);

            }else{
            //  console.log("unchecked");
             nums.unshift(intEl.value);
             intEl.value="";
    // console.log(nums);

            }
         });
    }
    console.log(nums);
    // elemArr.forEach(function(elem) {
    //     elem.addEventListener("change", function() {
    //        if(this.checked){
    //         console.log("checked");
    //        }else{
    //         console.log("unchecked");
    //        }
    //     });
    // });
}