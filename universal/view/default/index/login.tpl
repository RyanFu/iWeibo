<!doctype html>
<html>
    <head>
        <title><!--{TO->cfg key="site_name" group="basic" default="iWeibo2.0"}--> - 登录 <!--{if $_title}--> -  <!--{$_title}--><!--{/if}--> - Powered by iWeibo</title>
        <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
        <link rel="shortcut icon" href='/favicon.ico'/>
        <!--{include file="common/style.tpl"}-->
    </head>
    <body>
    <div class="usernav2">
    	<div class="wrapper2">
    		<span class="fleft"><a href="<!--{$site_url}-->"  title="<!--{TO->cfg key="site_name" group="basic" default="iWeibo2.0"}-->"><img src="<!--{TO->cfg key="site_logo" group="basic" default="/resource/images/iweibo.png"}-->"  resource="<!--{$_resource}-->"/></a></span>
    		<span class="fright"></span>
    	</div>
    </div>
    <div class="wrapper2 content wrapper3 logincontent">
    	<div class="contenttop"></div>
        <div class="contentleft fleft">
        	<!--单页广告模式-->
        	<div class="adv2"><a href="http://open.t.qq.com/iweibo/" target="_blank"><img src="<!--{$_resource}-->resource/images/banner.jpg"/></a></div>
        	<!--单页广告模式-->
        	<!--多页广告模式-->
        	<!--
        	<div class="slider" id="sliderBanner"></div>
        	<script>
			var sliderBanner  = [{"name": "iWeibo2.0","url": "http://t.qq.com/api_iweibo","picture": "http://app.qpic.cn/mblogpic/78df20b4ccfb47d4d6cc/2000","description": "iWeibo2.0与DISCUZ强强合作"},{"name": "南方暴雨","url": "http://t.qq.com/search/index.php?k=%E5%8D%97%E6%96%B9%E6%9A%B4%E9%9B%A8&pos=101","picture": "http://app.qpic.cn/mblogpic/92bd3ac1147de75114f6/2000","description": "南方暴雨洪灾已致175人死 或将再迎又一轮强降雨"}];
			</script>
			-->
			<!--多页广告模式-->
            <div class="moduletitle5"><strong class="fleft">大家都在说</strong></div>
            <div class="tcontainer" style="overflow:hidden;">
                <ul class="tmain" id="tmain">
                    <!--{foreach key=key item=msg from=$msglist}-->
                    <li class="tmessage"<!--{if $key>18}--> style="display:none;"<!--{/if}-->>
                        <div class="extra"></div>
                        <div class="ttouxiang"><a href="javascript:void(0);"><img src="<!--{$msg.head}-->"/></a></div>
                        <div class="tbody">
                            <a href="javascript:void(0);"><!--{$msg.nick}--></a>
                            <!--{if $msg.isvip}-->
                                <span class="icon_vip"></span>
                            <!--{/if}-->
                            <span class="colon">:</span>
                            <span><!--{$msg.text}--></span>
                            <div class="tbottom">
                              来自<!--{$msg.from}-->
                            </div>
                        </div>
                    </li>
                    <!--{/foreach}-->
                </ul>
            </div>
        </div>
        <!--{TO->cfg key="login_local" group="basic" assign="_login_local" default="1"}-->
        <!--{TO->cfg key="login_tencent" group="basic" assign="_login_tencent" default="1"}-->
        <div class="contentright fright<!--{if $_login_local == 1}--> locallogin<!--{/if}--><!--{if $isCode}--> loginhascode<!--{/if}-->">
            <form name="form1" method="post" action="/login/l" class="loginform iwbFormValidatorControl">
            	<!--{if $allowReg}-->
            	<div align="center"><a href="/reg" title="<!--{TO->cfg key='regurltip' group='loginface' default='立即开通微博'}-->" class="regbtn"><!--{TO->cfg key='regurltip' group='loginface' default='立即开通微博'}--></a></div>
            	<div class="splitline"></div>
            	<!--{/if}-->
                <ul><!--{if $_login_local == 1}-->
                    <li><input type="text" id="username" name="username" data-label="用户名" data-validator="required" autocorrect="off" autocapitalize="off" autocomplete="off" spellcheck="false" class="input_text" placeholder="<!--{TO->cfg key='nametip' group='loginface' default='用户名：'}-->" maxlength="15" unshowplaceholder="true"/>
                    <div class="placeholder gray"></div>
                    </li>
                    <li><input type="password" name="pwd" data-label="密码" data-validator="required" autocorrect="off" autocapitalize="off" autocomplete="off" spellcheck="false" class="input_text" placeholder="<!--{TO->cfg key='passwdtip' group='loginface' default='密   码：'}-->" maxlength="15"/>
                    <div class="placeholder gray"></div>
                    </li>
                    <!--{if $isCode}-->
                    <li><span class="gdcode"><input type="text" id="gdkey" name="gdkey" data-label="验证码" data-validator="required" onfocus="reloadgd(document.getElementById('gdField'))" class="input_text" placeholder="<!--{TO->cfg key='capchatip' group='loginface' default='验证码：'}-->" maxlength="4" unshowplaceholder="true"/><div class="placeholder gray"></div><br/>
                        <img id="gdField" src="" gd="<!--{$_resource}--><!--{$_gdurl}-->" onclick="reloadgd(this, true)" alt="看不清？换一张" title="看不清？换一张"/>
                        </span>
                    </li>
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
                    <li><input type="submit" class="loginbtn" title="<!--{TO->cfg key='logintip' group='loginface' default='登录微博'}-->" value="<!--{TO->cfg key='logintip' group='loginface' default='登录微博'}-->"/></li>
                    <li class="space1">
                        <input type="checkbox" name="autologin" id="autologin" value="1" /><label for="autologin">自动登录</label>
                        <a href="<!--{if $mailOpen}-->/login/findnav<!--{else}-->/login/qqfindpwd<!--{/if}-->">忘记密码?</a>
                    </li>
                    <!--{if $_login_tencent == 1}-->
                    <li class="space2"><a href="/login/r"><!--{TO->cfg key='wblogintip' group='loginface' default='腾讯微博帐号登录'}--></a></li>
                    <!--{/if}-->
                    
                    <!--{else}-->
                        <!--{if $_login_tencent == 1}-->
                        <li align="center" class="space2"><a href="/login/r"><!--{TO->cfg key='wblogintip' group='loginface' default='腾讯微博帐号登录'}--></a></li>
                        <!--{/if}-->
                    <!--{/if}-->
                </ul>
                <div class="splitline"></div>
            </form>
            <h3 class="moduletitle6">您可以通过如下方式使用iWeibo</h3>
            <div><img src="/resource/images/p1.gif" hspace="15"/></div>
        </div>
        <div class="contentbottom"></div>
    </div>
    <!--{include file="common/footer.tpl"}-->
    <!--{$ucsynlogout}-->
    <script src="/resource/js/login.js"></script>
    <script type="text/javascript">
        <!--{if $showmsg}-->
        	<!--{if $msgCode==-153}-->
			$(function () {
			    createBindBox();
			});
        	<!--{else}-->
        	//alert('<!--{$showmsg}-->');
        	
        		//alert(rect.top);
        	showAlertTip('<!--{$showmsg}-->',{},$("#username"),2000);
        	<!--{/if}-->
        <!--{/if}-->
    </script>
    </body>
</html>
