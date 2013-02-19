//登录页
//show login form in top frame
if (top != self){
window.top.location.href=location;
}

$.each($("#tmain").find("a"),function (i,node) {
    var node = $(node);
    var text = node.text();
    if (!/^http/.test(text)) {
        node.addClass("nopermission");
    }
});
$(".nopermission").live({
    click: function (event) {
        event.preventDefault(); // 不跳转网页
        IWB_DIALOG.modaltipbox("error", "请先登录" ,function () {
            $('#username').focus();
        });
    }
});

var scrollMsg = function () {
$("#tmain").find("li:hidden")
		   .last()
		   .clone()
		   .prependTo("#tmain")
		   .css("opacity",0)
		   .slideDown("fast")
		   .animate({"opacity":1},"slow",function(){
		   	    $(this).removeAttr("style");
				$("#tmain").find("li:hidden").last().remove();
				$("#tmain").find("li:visible").last().fadeOut("fast");
				setTimeout(function(){scrollMsg()},3000);
			})
			.next().find(".extra").show();
};
var createBindBox = function () {
var boxId;
var boxWidth = 600;
var boxHeight = 500;
var boxLeft = ($("body").width() - boxWidth) / 2;
var boxTop = (document.documentElement.scrollTop || document.body.scrollTop) + 1 /*0.618*/ * (document.documentElement.clientHeight - boxHeight) / 2;
var frameUrl = (window.iwbRoot ? iwbRoot : "index.php") + "/reg/b";
boxId = IWB_DIALOG._init({
    modal: true
   ,showClose: true
   ,width: boxWidth
   ,height: boxHeight
   ,top: boxTop
   ,left: boxLeft
   ,getDOM: function () {
       var jubao = "<iframe src=\"" + frameUrl + "\" frameBorder=\"0\"></iframe>";
       jubao = $(jubao);
       jubao.css({
            width: boxWidth
           ,height:boxHeight
           ,border:0
       });
       return jubao;
   } 
}); 
};

var initSlider = function () {
if (window.sliderBanner && IWB_SILDEWARE && IWB_SESSION.get("showSlideAdv")==null) {
    // 格式化数据
    for (var i=0; i<sliderBanner.length; i++) {
        if(sliderBanner[i].description) {
            sliderBanner[i].title = sliderBanner[i].description;
        }
        if(sliderBanner[i].picture) {
            sliderBanner[i].pic = sliderBanner[i].picture;
        }
    }
    $("#sliderBanner").append(IWB_SILDEWARE(sliderBanner,663,190));
}
}

var initplaceholder = function (o) {
    o.find("input[placeholder]").each(function(){
    	var t=$(this),d=t.attr("placeholder"),p=t.parent().find(".placeholder");
    	t.focusin(function(){
    		p.addClass("hide");
    	}).focusout(function(){
    		if(t.val()==""||t.val()==d)
    		p.removeClass("hide");
    	}).parent().find(".placeholder").html(d.replace(/\s/g,"&nbsp;"));
    });
}

$(function(){
setTimeout(function(){scrollMsg();},3000);
initSlider();
initplaceholder($(".loginform"));
});
