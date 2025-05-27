
let handler = (() => {
    return {
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
perlPost:function(args){
    let json=JSON.stringify(args);
    fetch("router.cgi", {
     method: "POST",
     body: `js_vals=${json};from_js=true;`,
     headers: {
     "Content-type": "application/x-www-form-urlencoded; charset=UTF-8"
     }
    })
    .then((response)=>{
      if(200==response.status){
        console.log("post OK");
      }
    })
},
svg:{
    currPoints:[],
    polylines:[],
    i2i:[],
    currIds:[],
    getRandomColor:function(){
        let letters = '0123456789ABCDEF';
        let color = '#';
        for (var i = 0; i < 6; i++) {
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
        //TODO
        /**
         * since it js, best way to save ids is via perlPost
         * then? refresh or reset arrays?
         */
        alert("TODO");
        handler.perlPost(handler.svg.i2i);
    },
    drawLine:function(e){
        let currPoints=handler.svg.currPoints;
        let polylines=handler.svg.polylines;
        let currIds=handler.svg.currIds;
        let x = 0;
        let y = 0;

        x = e.offsetLeft + e.offsetWidth / 2 +10;
        y = e.offsetTop + e.offsetHeight / 2;

        console.log("x=" + x + ",y=" + y);
        currIds.push(e.id);
    
    
        currPoints.push([x, y]);
        if (currPoints.length > 1){
            var draw = SVG('svg-container');
            console.log("start for");
            var array = new SVG.PointArray(currPoints);
            polylines.push(draw.polyline(array).fill('none').stroke({ width: 4, color: handler.svg.getRandomColor() }));
            handler.svg.i2i.push(currIds);
            handler.svg.currIds=[];
            handler.svg.currPoints=[];
        }//end ifconet
        /////////////////////
       
    },
},

///
}
})();
