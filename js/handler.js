
let handler = (() => {
    return {
virtUpdate:{
    add:[],
    remove:[]
},
saveVirt:function(){
    if (this.virtUpdate.remove.length==0 && this.virtUpdate.add.length==0){return;}
    let form=document.createElement('form');
    
    this.virtUpdate.remove.forEach(pair=>{
        let inp=document.createElement('input');
        inp.setAttribute('name',`rem_virt[${pair.virt_id}]`);
        inp.setAttribute('value',pair.member);
        form.append(inp);
    });
    this.virtUpdate.add.forEach(pair=>{
        let inp=document.createElement('input');
        inp.setAttribute('name',`add_virt[${pair.virt_id}]`);
        inp.setAttribute('value',pair.member);
        form.append(inp);
    });
    let dev=document.createElement("input");
    dev.setAttribute("name","devices");
    dev.setAttribute("value","devices");
    let devId=document.getElementsByName("device_id")[0];
    form.append(devId.cloneNode(true))
    let sav=document.createElement("input");
    sav.setAttribute("name","update_virt");
    sav.setAttribute("value","update_virt");
    form.append(dev);
    form.append(sav);
    form.setAttribute("method","post");
    form.setAttribute("action","router.cgi");
    document.getElementById("bottom").append(form);
    form.submit();
},
zoom: {
    get: function () {
        let container=document.getElementById('svg-container');
        let scale = container.style.transform;
        scale = scale.split(" ");
        scale = parseFloat(scale[0].substring(7, scale[0].length - 1)) || 1;
        return scale;
    },
    in: function () {
        let container=document.getElementById('svg-container');
        let val = handler.zoom.get() + 0.1;
        container.style.transform='scale(' + val + ')';
        // container.style.transform-origin='top left';

    },
    out: function () {
        let container=document.getElementById('svg-container');


        let val = handler.zoom.get() - 0.1;
        container.style.transform= 'scale(' + val + ')';
        // container.style('transform-origin', 'top left');


    }
},
hoverEffect:{
    add:function(elem){
        elem.addEventListener("mouseenter",this.event);
        elem.addEventListener("mouseleave",this.event);
    },
    remove:function(elem){
        elem.removeEventListener("mouseenter",this.event);
        elem.removeEventListener("mouseleave",this.event);
        elem.style.background = "";
    },
    event:(e)=>{
        let color="";
        const elem=e.target;
        if ("mouseenter" === e.type) color="purple";
        elem.style.background = color;
          const pairedElem=document.getElementById(elem.getAttribute("pair"));
          pairedElem.style.background = color;
    },
},
hoverEffectOL:function(elem){
    elem.addEventListener(
        "mouseenter",
        (event) => {
          event.target.style.background = "purple";
          let pairedElem=document.getElementById(event.target.getAttribute("pair"));
          pairedElem.style.background = "purple";
        },
        false,
      );
      elem.addEventListener(
        "mouseleave",
        (event) => {
          event.target.style.background = "";
          let pairedElem=document.getElementById(event.target.getAttribute("pair"));
          pairedElem.style.background = "";
        },
        false,
      );
},
perlPost:function(args,action){
    let json=JSON.stringify(args);
    fetch("router.cgi", {
     method: "POST",
     body: `js_vals=${json};from_js=true;action=${action};`,
     headers: {
     "Content-type": "application/x-www-form-urlencoded; charset=UTF-8"
     }
    })
    .then((response)=>{
      if(200==response.status){
        console.log("post OK");
        if("add" == action){
        handler.svg.empty();
        }
        if("remove" == action){
            handler.svg.unlinkPairs=[];
        }
      }
    })
},
menuListener:function(){
    const elements=document.querySelectorAll(".dev_title > span");
    for (let i = 0; i < elements.length; i++) {
        elements[i].addEventListener("click",handler.menuToggle);
    }
},
menuToggle:function(event){
    const elem=event.target.parentElement;
    elem.querySelector(".inline_menu").classList.toggle("show");
},
addClickListener:function(handlerName){
    const elements=document.querySelectorAll("div.interfaces >*");
    let func;
    if("draw" === handlerName){
        func=handler.svg.drawLine;
    }
    else if ("unlink" === handlerName){
        func=handler.svg.unlink;
    }
    else if ("virt" === handlerName){
        const virt_int=document.getElementById("virt_id");
        virt_int.addEventListener("change",function(){handler.displayMembers(this.value);})
        this.displayMembers(virt_int.value);
        func=handler.virtMembers;
    }
    for (let i = 0; i < elements.length; i++) {
        elements[i].addEventListener("click",func);
    }
},
displayMembers:function(virt_id){
    const elements=document.querySelectorAll("div.interfaces >*");
    const members=document.querySelectorAll(`div[member-of="${virt_id}"]`);
    elements.forEach(element => {
        element.classList.remove("virt_member","selected","disabled");
        if (element.getAttribute("member-of")!=""){
            element.classList.add("disabled");
        }
        if(element.classList.contains("int_virt")){
            element.classList.add("disabled");
        }
    });
    document.getElementById("i"+virt_id).classList.add("selected");
    members.forEach(member => {
        member.classList.add("virt_member");
        member.classList.remove("disabled");
    });
},
virtMembers:function(event){
    const elem=event.target;
    if (elem.classList.contains("disabled")){return;}
    const virtId=document.getElementById("virt_id").value;
    const isVirtual=elem.getAttribute("int-type") == "3";
    const memberAttr=elem.getAttribute("member-of");
    const isMember= memberAttr !=="" && memberAttr !== virtId ;
    if (isVirtual || isMember){
        printMsg("This interface can't be selected");
        return;
    }
    elem.classList.toggle("virt_member");
    let memberId=elem.id.substring(1);

    if (elem.classList.contains("virt_member")){
        //add member
        handler.virtUpdate.add.push({'virt_id':virtId,'member':memberId});
    }else{
        handler.virtUpdate.remove.push({'virt_id':virtId,'member':memberId});
    }


},
removeClickListener:function(){
    // const elements=document.querySelectorAll("div.interface");
    const elements=document.querySelectorAll("div.interfaces >*");
    for (let i = 0; i < elements.length; i++) {
        elements[i].removeEventListener("click",handler.svg.drawLine);
        elements[i].removeEventListener("click",handler.svg.unlink);
    }
},
svg:{
    currPoints:[],
    polylines:[],
    i2i:[],
    unlinkPairs:[],
    currIds:[],
    linkMode:1,
    unlinkMode:0,
    enableLinking:function(){
        const btn=document.getElementById("svgEnBtn");
        if(handler.svg.linkMode){
            handler.removeClickListener();
            handler.svg.linkMode=0;
            btn.innerHTML="enable linking";
        }else{
            if (handler.svg.unlinkMode) handler.svg.enableUnLinking();
            handler.addClickListener("draw");
            handler.svg.linkMode=1;
            btn.innerHTML="disable linking";
        }
    },
    enableUnLinking:function(){
        const btn=document.getElementById("unlinkEnBtn");
        if(handler.svg.unlinkMode){
            handler.removeClickListener();
            handler.svg.unlinkMode=0;
            btn.innerHTML="enable unlinking";
        }else{
            if (handler.svg.linkMode) handler.svg.enableLinking();
            handler.addClickListener("unlink");
            handler.svg.unlinkMode=1;
            btn.innerHTML="disable unlinking";
        }
    },
    empty:function(){
        handler.svg.currPoints=[];
        handler.svg.polylines=[];
        handler.svg.i2i=[];
        handler.svg.currIds=[];
        handler.svg.linkMode=0;
        handler.removeClickListener();
    },
    redraw:function(json){
        json.forEach(pair => {
            let elemA=document.getElementById("i"+pair.int_a);
            let elemB=document.getElementById("i"+pair.int_b);
            elemA.setAttribute("pair","i"+pair.int_b);
            elemB.setAttribute("pair","i"+pair.int_a);
            elemA.click();
            elemB.click();
            handler.hoverEffect.add(elemA);
            handler.hoverEffect.add(elemB);
        });
        handler.svg.empty();
    },
    getRandomColor:function(){
        let letters = '0123456789ABCDEF';
        let color = '#';
        for (let i = 0; i < 6; i++) {
            color += letters[Math.floor(Math.random() * 16)];
        }
        return color;
    },
    undo:function(){
        if (handler.svg.polylines.length ===0){return;}
        let lastElem=handler.svg.polylines.pop();
        lastElem.remove();
        console.log("undo done");
    },
    save:function(){
        if(handler.svg.i2i.length > 0){
        handler.perlPost(handler.svg.i2i,"add");
        }
        if(handler.svg.unlinkPairs.length >0){
            handler.perlPost(handler.svg.unlinkPairs,"remove");
        }
    },
    unlink:function(event){
        const elem=event.target;
        let toElemId=elem.getAttribute("pair");
        const toElem=document.getElementById(toElemId);
        if (!elem || !toElem) return;
        let line=document.getElementById(elem.getAttribute("line"));
        let remPair=[];
        remPair.push(toElemId.substring(1));
        remPair.push(elem.id.substring(1));
        line.remove();
        _reset([elem,toElem]);
        // console.log(remPair);
        handler.svg.unlinkPairs.push(remPair);
        function _reset(elements){
            elements.forEach((el)=>{
                handler.hoverEffect.remove(el);
                el.classList.remove("selected");
                el.removeAttribute("pair");
                el.removeAttribute("line");
            })
        }
    },
    drawLine:function(event){
        if (!handler.svg.linkMode) return; 
        const elem=event.target;
        let currPoints=handler.svg.currPoints;
        let polylines=handler.svg.polylines;
        let currIds=handler.svg.currIds;
        let x = 0;
        let y = 0;

        x = elem.offsetLeft + elem.offsetWidth / 2 +10;
        y = elem.offsetTop + elem.offsetHeight / 2;
        elem.classList.add('selected');

        // console.log("x=" + x + ",y=" + y);
        currIds.push(elem.id);
    
    
        currPoints.push([x, y]);
        if (currPoints.length > 1){
            let draw = SVG('svg-container');
            let array = new SVG.PointArray(currPoints);
            let currLine=draw.polyline(array).fill('none').stroke({ width: 4, color: handler.svg.getRandomColor() });
            polylines.push(currLine);
            handler.svg.i2i.push(currIds);
            currIds.forEach(id => {
                document.getElementById(id).setAttribute("line",currLine.id());
            });
            handler.svg.currIds=[];
            handler.svg.currPoints=[];
            // console.log(currLine.id());
        }//end ifconet
        /////////////////////
       
    },
},

///
}
})();
