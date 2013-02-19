<!doctype html>
<html>
    <head>
        <title><!--{TO->cfg key="site_name" group="basic" default="iWeibo2.0"}--> - 注册 <!--{if $_title}--> -  <!--{$_title}--><!--{/if}--> - Powered by iWeibo</title>
        <!--{include file="common/style.tpl"}-->
        <style type="text/css">
        	html,body{display:block;height:100%;}
        </style>
    </head>
    <body class="bindpage">
    	<ul class="regtab">
    		<li data-for="reg" style="margin-left:100px;"><div>完善帐号信息</div></li>
    		<li data-for="bind" class="active"><div>已有帐号？绑定我的帐号</div></li>
    	</ul>
    		<form name="form1" method="post" action="/reg/j" class="regform hide" style="margin:30px 0 0" id="reg" onsubmit="return regformcheck();">
    		<h1>您将使用腾讯微博帐号<strong><!--{if $name}--><!--{$name}--><!--{/if}--></strong>注册本站，<a href="/login/r" target="_top">更换微博帐号？</a></h1>
            <table border="0" cellpadding="0" cellspacing="0" width="500" align="left">
                <tr>
                    <th width="75" height="50" align="right" valign="top"><span>*</span>帐号</th>
                    <td align="left" valign="top">
                    <input type="text" class="input_text" data-label="帐号" value="<!--{$uInfo.name}-->" data-validator="required uname" name="username" id="username" maxlength="15"/>
                    <span class="emsg hide"><em class="icon_ok"></em></span>
                        <cite class="tipmsg"><b></b>3到15个字符组成</cite>
                    </td>
                </tr>
                <tr>
                    <th height="50" align="right" valign="top"><span>*</span>Email</th>
                    <td align="left" valign="top">
                        <input type="text" data-label="邮箱" data-validator="required email" value="<!--{$uInfo.email}-->" name="email" id="email" class="email input_text"><span class="emsg hide"><em class="icon_ok"></em></span>
                        <cite class="tipmsg"></cite>
                    </td>
                </tr>
                <tr>
                    <th height="50" align="right" valign="top"><span>*</span>密码</th>
                    <td align="left" valign="top">
                        <input type="password" data-label="密码" data-name="password" data-validator="required pwd" name="pwd" id="pwd" class="pwd input_text" maxlength="15"/><span class="emsg hide"><em class="icon_ok"></em></span>
                        <cite class="tipmsg"><b></b>密码长度为3~15字符</cite>
                    </td>
                </tr>
                <tr>
                    <th height="50" align="right" valign="top"><span>*</span>确认密码</th>
                    <td align="left" valign="top">
                        <input type="password" data-label="确认密码" data-name="password" data-validator="required pwd" name="pwdconfirm" class="pwdconfirm input_text" maxlength="15"><span class="emsg hide"><em class="icon_ok"></em></span>
                        <cite class="tipmsg"></cite>
                   </td>
                </tr>
                <!--{if $isCode}-->
                     <tr>
                        <th align="right" valign="top" height="43"><span>*</span>附加码</th>
                        <td align="left" valign="top">
                            <input type="text" class="input_text" id="gdkey" name="gdkey" data-label="附加码" data-validator="required" onfocus="reloadgd(document.getElementById('gdField'))" maxlength="4"/><span class="emsg hide"><em class="icon_ok"></em></span>
                            <cite class="tipmsg"><b></b>请输入附加码</cite>
                            <img id="gdField" src="" gd="<!--{$_resource}--><!--{$_gdurl}-->" onclick="reloadgd(this, true)" alt="看不清？换一张" title="看不清？换一张" style="display: none;cursor: pointer;margin:5px 0 5px;" />
  
                        </td>
                    </tr>
                    <script>
                        function reloadgd(el,f){
                            if(f || !el.gdloaded){
                                el.src=el.getAttribute('gd') + '?' + +new Date();
                                el.style.display='block';
                                el.gdloaded = true;
                            }
                        }
                    </script>
                <!--{/if}-->
                <tr>
                    <th height="43" align="right">&nbsp;</th>
                    <td align="left"><div class="bluebtn"><input type="submit" name="button" id="button" value="提交" hidefocus/></div></td>
                </tr>
            </table>
        </form>
        
            <form name="form1" method="post" action="/login/l" class="iwbFormValidatorControl bindform hide" id="bind">
            	<h1>您将使用腾讯微博帐号<strong><!--{if $name}--><!--{$name}--><!--{/if}--></strong>注册本站，<a href="/login/r" target="_top">更换微博帐号？</a></h1>	
                <table border="0" cellpadding="0" cellspacing="0" align="left">
                    <tr>
                        <th align="right" height="30" width="75" align="left"><span>*</span> 帐号：</th>
                        <td align="left"><input type="text" class="input_text" name="username" id="username" data-label="帐号" data-validator="required uname" maxlength="15"<!--{if $name}--> value="<!--{$name}-->"<!--{/if}-->/><!--<span class="emsg"><em class="icon_ok"></em>格式不正确</span>-->
                        </td>
                    </tr>
                    <tr>
                        <th align="right" height="60" align="left"><span>*</span> 密码：</th>
                        <td align="left"><input type="password" class="input_text" name="pwd" id="pwd" data-label="密码" data-validator="required pwd" maxlength="15"/></td>
                    </tr>
                    <!--{if $isCode}-->
                    <tr>
                        <th align="right" valign="top" style="padding-top:6px;"><span>*</span> 附加码：</th>
                        <td align="left" valign="top">
                            <input type="text" class="input_text" id="gdkey" name="gdkey" data-label="附加码" data-validator="required" onfocus="reloadgd(document.getElementById('gdField2'))" maxlength="4"/>
                            <img id="gdField2" src="" gd="<!--{$_resource}--><!--{$_gdurl}-->" onclick="reloadgd(this, true)" alt="看不清？换一张" title="看不清？换一张" style="display: none;cursor: pointer;margin:10px 0;" />
                        </td>
                    </tr>
                    <script>
                        function reloadgd(el,f){
                            if(f || !el.gdloaded){
                                el.src=el.getAttribute('gd') + '?' + +new Date();
                                el.style.display='block';
                                el.gdloaded = true;
                            }
                        }
                    </script>
                    <!--{/if}-->
                    <tr>
                        <th height="53" align="left" valign="bottom"></th>
                        <td align="left">
                            <div class="bluebtn"><input type="submit" value="登录" hidefocus/></div>
                            <input type="checkbox" checked id="autologin"/>
                            <label for="autologin">自动登录</label>
                        </td>
                    </tr>
                </table>
            </form>
            
            <!--
            <div class="fastreg" <!--{if !$isCode}-->style="padding-top:40px;"<!--{/if}-->>
            	<!--{if $allowReg}-->
        		<div class="gray">没有网站帐户？</div>
        		<div class="bluebtn"><a href="/reg">立即注册</a></div>
        		<!--{/if}-->
        	</div>
        	-->
</body>
<script src="/resource/js/iwbFramework/iwb.js"></script>
<script>var  path=location.href.match(/\/reg\/.*/).toString();
	function tabUI(s){
		$(".regtab").find("li").removeClass("active");
		$(".regtab").find("li[data-for='"+s+"']").addClass("active");
		$("form").addClass("hide");
		$("#"+s).removeClass("hide");
	}
	$(".regtab").find("li").click(function(){
		tabUI($(this).attr("data-for"));
	});
<!--{if $type}-->
	$(function(){
		var u=["","reg","","bind"];
		tabUI(u[<!--{$type}-->]);
	});
<!--{/if}-->

$(".regform").find("input[name!='username']").blur(function () {
    var self = $(this);
    var error = self.fivalidate();
    if (error) {
        // 提示错误
        self.parent().find(".emsg").hide();
        self.parent().find(".tipmsg").addClass("errormsg");
    } else {
        // 打勾
        self.parent().find(".emsg").show();
        self.parent().find(".tipmsg").removeClass("errormsg");
    }
});
$(".regform").find(".pwd").blur(function (){
    if ($(".regform").find(".pwdconfirm").val().length > 0) {
        $(".regform").find(".pwdconfirm").trigger("blur"); //修改密码同时进行一致性检查
    }
});
$(".regform").find(".pwdconfirm").blur(function () { // 密码输入框一致性检查
    var self = $(this);
    var error = self.fivalidate(); // 先检查自身规则
    var val1,val2;
    self.parent().find(".emsg").hide();
    if (error) {
        self.parent().find(".emsg").hide();
        self.parent().find(".tipmsg").html("<b></b>密码长度为3~15字符").addClass("errormsg");
        return;
    }
    val1 = $(".regform").find(".pwd").val();
    val2 = self.val();
    if (val1==val2) { // 密码相同
        self.parent().find(".emsg").show();
        self.parent().find(".tipmsg").text("").removeClass("errormsg");
    } else {
        self.parent().find(".emsg").hide();
        self.parent().find(".tipmsg").html("<b></b>两次输入的密码不一致").addClass("errormsg");
    }
});
$(".regform").find("input[name='username']").blur(function () { //邮箱出错提示使用配置的出错信息
    var self = $(this),val=self.val(),reg=/[\"\|<>]/g;
    var error = reg.test(val)||self.fivalidate();
    if (error) {
    	if (typeof error=="boolean") {
    		error = "不能含有非法字符"+val.match(reg);
    	} else {
    	if(val.length>0){
    		if(val.length<3) {
	    		error = "用户名不能小于3个字符";
	    	}else if(val.length>15) {
	    		error = "用户名不能多于15个字符";
	    	}
	    	}else{
	    		error = "用户名不能为空";
	    	}
    }
    self.parent().find(".emsg").hide();
    self.parent().find(".tipmsg").html("<b></b>"+error).addClass("errormsg");
    } else {
        self.parent().find(".tipmsg").text("").removeClass("errormsg");
        self.parent().find(".emsg").show();
        return;
    }
    
})
$(".regform").find("input[name='email']").blur(function () { //邮箱出错提示使用配置的出错信息
    var self = $(this);
    var error = self.fivalidate();
    if (error) {
        self.parent().find(".tipmsg").html("<b></b>"+error);
    } else {
        self.parent().find(".tipmsg").text("");
    }
})

function regformcheck(){
	var f=$(".regform"),p=[];
		f.find("input[type='text'],input[type='password']").each(function(){
			$(this).trigger("blur");
			p.push($(this).attr("name")+"="+$(this).val());
		});
	if(f.find(".errormsg").size()==0){
	 	$.ajax({
		   url:location.href.replace(path,"/reg/j"),
		   type:"post",
		   data: p.join("&"),
		   success:function(d){
		   	 var ret=d.match(/(\-\d+):(.*)/);
		   	 if (ret&&ret.length==3){
		   	 	if(parseInt(ret[1],10)==0) {
		   	 		IWB_DIALOG.modaltipbox("success","个人信息保存成功！",function () {
		   	 		//top.location.href="/";
                	});
                	setTimeout(function(){top.location.href=location.href.replace(path,"");},1000);
		   	 	}else {
		   	 		IWB_DIALOG.modaltipbox("error","出错提示："+ret[2]+"("+ret[1]+")",function () {
                	});
		   	 	}
		   	 }else if(parseInt(d)==0){
		   	 	IWB_DIALOG.modaltipbox("success","个人信息保存成功！",function () {
		   	 		//top.location.href="/";
                });
                setTimeout(function(){top.location.href=location.href.replace(path,"");},1000);
		   	 }
		   },
		   error:function(){
		   		IWB_DIALOG.modaltipbox("error","连接服务器失败！",function () {
		   		});
		   }
		 });
	}
	return false;
}
</script>
<!--{if $showmsg}-->
<script type="text/javascript">
    //alert('<!--{$showmsg}-->');
    showAlertTip('<!--{$showmsg}-->',{"top":"182px","left":"165px"},null,2000);
</script>
<!--{/if}-->
</html>
