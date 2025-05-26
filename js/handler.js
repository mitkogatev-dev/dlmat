
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
svg:{
    arr:[],
    polys:[],
    polyline:[],
    getRandomColor:function(){
        let letters = '0123456789ABCDEF';
        let color = '#';
        for (var i = 0; i < 6; i++) {
            color += letters[Math.floor(Math.random() * 16)];
        }
        return color;
    },
    test:function(e){
        let arr=handler.svg.arr;
        let polys=handler.svg.polys;
        let polyline=handler.svg.polyline;
        let x = 0;
        let y = 0;
        let c=0;

        x = e.offsetLeft + e.offsetWidth / 2 +10;
        y = e.offsetTop + e.offsetHeight / 2;

        console.log("x=" + x + ",y=" + y);
    
    
        arr.push([x, y]);
        if (arr.length > 1){
            var draw = SVG('svg-container');
            c++;
            console.log("start for");
            var array = new SVG.PointArray(arr);
            polyline[c] = draw.polyline(array).fill('none').stroke({ width: 4, color: handler.svg.getRandomColor() });
            //////store(polyline[c],"id=" +ids);
            console.log("end" +polyline[c]);
            handler.svg.arr=[];
            ids=[];
        }//end ifconet
        /////////////////////
        var le=polys.length;
        console.log("total lines:"+le);
        for (var i=0;i<polys.length;i++){
            console.log("test:"+polys[i].test+"name:"+polys[i]);
        }
    },
},

///
}
})();
