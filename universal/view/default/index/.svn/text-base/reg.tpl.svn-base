<!doctype html>
<html>
    <head>
        <title><!--{TO->cfg key="site_name" group="basic" default="iWeibo2.0"}--> - 注册 <!--{if $_title}--> -  <!--{$_title}--><!--{/if}--> - Powered by iWeibo</title>
        <!--{include file="common/style.tpl"}-->
    </head>
    <body>
    <div class="usernav2">
    	<div class="wrapper2">
    		<span class="fleft"><a href="<!--{$_resource}-->"  title="<!--{TO->cfg key="site_name" group="basic" default="iWeibo2.0"}-->"><img src="<!--{TO->cfg key="site_logo" group="basic" default="/resource/images/iweibo.png"}-->"  resource="<!--{$_resource}-->"/></a></span>
    		<span class="fright"></span>
    	</div>
    </div>
    <!--[if lt IE 9]><div class="wrapper2 regcontenttop"></div><![endif]-->
    <div class="wrapper2 regcontent">
        <!--{if $type==1}-->
        <div class="regtit">欢迎注册成为会员，使用会员登录会员分享精彩内容给微博好友</div>
        <!--
        <div class="forlogin">
        	<div class="innerlogin">
        	如果已有应用网站帐号，请直接登录<br/>
        	<div class="bluebtn"><a href="/login/"> &nbsp;&nbsp;&nbsp;登录&nbsp;&nbsp;&nbsp; </a></div><br/><br/>
        	已有腾讯微博帐号，一键登录<br/>
        	<em class="icon_login"></em> <a href="/login/r">腾讯微博帐号登录</a>
        	</div>
        </div>
        -->
        <form name="form1" method="post" action="/reg/r" class="regform iwbFormValidatorControl">
            <table border="0" align="left" cellpadding="0" cellspacing="0" width="620">
                <tr>
                    <th width="70" height="50" align="right" valign="top"><span>*</span>帐号</th>
                    <td align="left" valign="top"><input type="text" class="input_text" data-label="帐号" value="<!--{$uInfo.name}-->" data-validator="required uname" name="username" id="username" maxlength="15"><span class="emsg hide"><em class="icon_ok"></em></span>
                        <cite class="tipmsg"><b></b>3 到 15 个字符组成,不能含有"|&lt;&gt;</cite>
                    </td>
                </tr>
                <tr>
                    <th height="50" align="right" valign="top"><span>*</span>密码</th>
                    <td align="left" valign="top">
                        <input type="password" data-label="密码" data-name="password" data-validator="required pwd" name="pwd" id="pwd" class="pwd input_text" maxlength="15"><span class="emsg hide"><em class="icon_ok"></em></span>
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
                <tr>
                    <th height="50" align="right" valign="top"><span>*</span>Email</th>
                    <td align="left" valign="top">
                        <input type="text" data-label="邮箱" data-validator="required email" name="email"  value='<!--{$uInfo.email}-->'   id="email" class="email input_text"><span class="emsg hide"><em class="icon_ok"></em></span>
                        <cite class="tipmsg"></cite>
                    </td>
                </tr>
                <!--{if $isCode}-->
                     <tr>
                        <th align="right" valign="top" height="43"><span>*</span>附加码</th>
                        <td align="left" valign="top">
                            <input type="text" class="input_text" id="gdkey" name="gdkey" data-label="附加码" data-validator="required" onfocus="reloadgd(document.getElementById('gdField'))" maxlength="4"/>
                            <img id="gdField" src="" gd="<!--{$_resource}--><!--{$_gdurl}-->" onclick="reloadgd(this, true)" alt="看不清？换一张" title="看不清？换一张" style="display: none;cursor: pointer;margin:5px 0;" />
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
                    <td align="left"><div class="bluebtn"><input type="submit" name="button" id="button" value="注册" hidefocus/></div></td>
                </tr>
                <tr>
                	<th height="100" colspan="2"></th>
                </tr>
            </table>
        </form>
        <!--{elseif $type==3}-->
        <div class="wrapper2 whitebg">
            <form name="form1" method="post" action="/login/l" class="iwbFormValidatorControl bindform">
                <table border="0" align="center" cellpadding="0" cellspacing="0" width="220" vspace="10">
                	<tr>
                		<th colspan="2" align="left" height="80"><strong>已有本地帐号</strong></th>
                	</tr>
                    <tr>
                        <th height="30" width="45" align="left">帐号：</th>
                        <td align="left"><input type="text" class="input_text" name="username" id="username" data-label="帐号" data-validator="required uname" /><!--<span class="emsg"><em class="icon_ok"></em>格式不正确</span>-->
                        </td>
                    </tr>
                    <tr>
                        <th height="60" align="left">密码：</th>
                        <td align="left"><input type="password" class="input_text" name="pwd" id="pwd" data-label="密码" data-validator="required pwd"></td>
                    </tr>
                    <!--{if $isCode}-->
                    <tr>
                        <th align="right" valign="top">附加码</th>
                        <td align="left" valign="top">
			    			<span style="position:relative;">
                            <input type="text" class="input_text" id="gdkey" name="gdkey" data-label="附加码" data-validator="required" onfocus="reloadgd(document.getElementById('gdField'))" maxlength="4" />
                            <img id="gdField" src="" gd="<!--{$_resource}--><!--{$_gdurl}-->" onclick="reloadgd(this, true)" alt="看不清？换一张" title="看不清？换一张" style="display: none;cursor: pointer;" />
			    			</span>
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
                        <th height="43" align="left" valign="top"></th>
                        <td align="left">
                            <input type="submit" value="绑定本地帐号" class="button button_blue"/>
                        </td>
                    </tr>
                    <tr>
                	<th height="100" colspan="2"></th>
                	</tr>
                </table>
            </form>
            <div class="fastreg">
            	<!--{if $allowReg}-->
        		<h2>15秒注册本站帐号，分享精彩内容！</h2>
        		<div><a href="/reg" class="button button_blue" target="parent">立即注册</a></div>
        		<!--{/if}-->
        	</div>
        </div>
        
        <!--{elseif $type==6}-->
        <div class="crumb">
            <span class="fleft">找回密码 &gt; 选择密码找回方式</span>
        </div>
        <div align="center" class="usermsg"><br/><br/><br/><br/>
            <a href="/login/qqfindpwd" class="findpaswbtn">通过腾讯微博帐号找回</a><br/><br/>
            <a href="/login/findpwd" class="findpaswbtn">通过本站注册的邮箱找回</a>
        </div>
        <!--{elseif $type==7}-->
        <div class="crumb">
                <span class="fleft">找回密码 &gt; 通过腾讯微博帐号找回</span>
        </div>
        <form name="form1" method="post" action="/login/qqfindpwd" class="regform iwbFormValidatorControl">
            <input type="hidden" name="op" value="qqfind" />
            <table align="center" class="usermsg" vspace="20">
                <tr>
                    <th height="50">帐号：</th>
                    <td><input type="text" class="input_text" data-label="帐号" data-validator="required uname" name="username" id="username"></td>
                </tr>
                <tr>
                    <th height="50"></th><td><input type="submit" value="下一步" class="save"/></td>
                </tr>
                <tr>
                	<th height="100" colspan="2"></th>
                </tr>
            </table>
        </form>
        <!--{elseif $type==4}-->
        <div class="crumb">
                <span class="fleft">找回密码 &gt; 通过本站邮箱找回</span>
        </div>
        <form name="form1" method="post" action="/login/findpwd" class="regform iwbFormValidatorControl">
            <input type="hidden" name="op" value="find" />
            <table align="center" class="usermsg" vspace="20">
                <tr>
                    <th height="50">帐号：</th>
                    <td><input type="text" class="input_text" data-label="帐号" data-validator="required uname" name="username" id="username"></td>
                </tr>
                <tr>
                    <th height="50">邮箱：</th>
                    <td><input type="text" class="input_text" data-label="邮箱" data-validator="required email" name="email" id="email"></td>
                </tr>
                <tr>
                    <th height="50"></th><td><input type="submit" value="下一步" class="save"/></td>
                </tr>
                <tr>
                	<th height="100" colspan="2"></th>
                </tr>
            </table>
        </form>
        <!--{elseif $type==5}-->
        <div class="crumb">
                <span class="fleft">找回密码 &gt; 设置新密码</span>
        </div>
        <form name="form1" method="post" action="/login/changepwd" class="regform iwbFormValidatorControl">
            <input type="hidden" name="op" value="change" />
            <table align="center" class="usermsg" vspace="20">
                <tr>
                    <th height="50">帐号：</th>
                    <td><!--{$changeuser}--></td>
                </tr>
                <tr>
                    <th height="50">新密码：</th>
                    <td><input type="password" class="input_text" data-label="密码" data-name="password" data-validator="required pwd" name="pwd" id="pwd"></td>
                </tr>
                <tr>
                    <th height="50">确认新密码：</th>
                    <td><input type="password" class="input_text" data-label="确认密码" data-name="password" data-validator="required pwd" name="pwdconfirm" id="pwdconfirm"></td>
                </tr>
                <tr>
                    <th height="50"></th>
                    <td><input type="submit" value="提交" class="save"/></td>
                </tr>
                <tr>
                	<th height="100" colspan="2"></th>
                </tr>
            </table>
        </form>
        <!--{else}-->
        <div class="wrapper2 whitebg">
            <div class="result">
                <h2><!--{$message}--></h2>
                <div><a href="<!--{$url}-->" class="bindingbtn"><!--{$btntext}--></a></div>
                <!--meta http-equiv="refresh" content="3; url=<!--{$url}-->" /-->
            </div>
        </div>
        <!--{/if}-->
    </div>
    <!--[if lt IE 9]><div class="wrapper2 regcontentbottom"></div><![endif]-->
    <!--{include file="common/footer.tpl"}-->
    <script>
        $(function () {
            $(".regform").find("input").blur(function () {
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
            $(".regform").find(".email").blur(function () { //邮箱出错提示使用配置的出错信息
                var self = $(this);
                var error = self.fivalidate();
                if (error) {
                    self.parent().find(".tipmsg").html("<b></b>"+error);
                } else {
                    self.parent().find(".tipmsg").text("");
                }
            });
            $(".regform").submit(function(){
            	var sessionReg=[];
            	$(this).find("input[type='text']").each(function(){
            		sessionReg.push([$(this).attr("name"),encodeURIComponent($(this).val())].join(":"));
            	});
            	IWB_SESSION.set("sessionReg",sessionReg.join(","));
            });
            if (IWB_SESSION.get("sessionReg")){
            	var arr=IWB_SESSION.get("sessionReg").split(",");
            		for (var i in arr){
            			if (typeof arr[i]!="string"){
            			continue;
            			}
            			var a=((arr[i]!="")&&arr[i]||"").split(":");
            				if (a[1]&&a[1]!=""&&a[0]!="gdkey"){
            					$(".regform").find("input[type='text'][name='"+a[0]+"']").val(decodeURIComponent(a[1]));
            				}
            		}
            }
        });
    </script>
</body>
<!--{if $showmsg}-->
<script type="text/javascript">
    alert('<!--{$showmsg}-->');
</script>
<!--{/if}-->
</html>
