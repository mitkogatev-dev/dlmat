function resizeIframe(obj) {    
    // console.log(obj);                                                                                                                                                                 
// obj.style.height = 400 + 'px';                                                                                                                                                                     
obj.style.height = obj.contentWindow.document.body.scrollHeight+200 + 'px';                                                                                                                  
// obj.style.width = obj.contentWindow.document.body.scrollWidth + 'px';  
// console.log(obj.contentWindow.document.body.scrollHeight);                                                                                                  
 }
