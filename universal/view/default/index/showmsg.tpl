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
    		<span class="fleft"><a href="<!--{$site_url}-->"  title="<!--{TO->cfg key="site_name" group="basic" default="iWeibo2.0"}-->"><img src="<!--{TO->cfg key="site_logo" group="basic" default="/resource/images/iweibo.png"}-->" resource="<!--{$_resource}-->"/></a></span>
    		<span class="fright"></span>
    	</div>
    </div>
    
<!-- 自动注册页面-->
<!--{if $auto}-->
<!--[if lt IE 9]><div class="wrapper2 regcontenttop"></div><![endif]-->
<div class="wrapper2 regcontent">
<div class="infobox"  >
    <div class="infoicon fleft">
		<label class="result_ok"></label>
	</div>
	<div class="infoline fleft"></div>
   
    <div class="postbox fleft">
	    <table>
	    	<tr><th colspan="2" height="30">系统为您分配了一个本地帐号：</th></tr>
			<tr><th align="right" height="30" width="50">帐号：</th><td><font color="#3D91CC"><!--{$username}--></font></td></tr>
			<tr><th align="right" height="30" width="50">密码：</th><td><font color="#3D91CC"><!--{$pwd}--></font></td></tr>
			<tr><td align="center" height="30" colspan="2"><a href="<!--{$gourl}-->" class="button button_blue">进入我的微博</a></td></tr>
			<tr><td align="center" colspan="2"><a href="<!--{$downUrl}-->" class="gray"  target='_blank'>保存帐号密码至本地</a></td></tr>
		</table>
    </div>
</div>
</div>
<!--[if lt IE 9]><div class="wrapper2 regcontentbottom"></div><![endif]-->
 <!--{else}-->
<div class="errinfobox">
    <div class="postbox <!--{if $msg=="Api Error"||$msg=="系统繁忙"||$msg=="系统繁忙，请刷新或稍后再试"}-->postbox2<!--{else}-->postbox1<!--{/if}-->">
    	<h1><!--{$msg}--></h1>
        <!--{if $button}-->
	    <!--{if $btns}-->
	    <p class="marginbot">
	    <!--{foreach key=key item=btn from=$btns}-->
	    	<span class="bluebtn"><a href="<!--{$btn.link}-->"><!--{$btn.text}--></a></span>
		<!--{/foreach}-->
		</p>
	    <!--{else}-->
		<p class="marginbot"><a href="<!--{$seogourl}-->" class="returnbtn">点击返回</a></p>
	    <!--{/if}-->
        <!--{else}-->
            <!--<meta http-equiv="refresh" content="<!--{$time}-->; url=<!--{$seogourl}-->" />-->
        <p class="marginbot"><a href="<!--{$gourl}-->" class="returnbtn">点击返回</a></p>
        <!--{/if}-->
    </div>
</div>
 <!--{/if}-->
<!--{include file="common/footer.tpl"}-->