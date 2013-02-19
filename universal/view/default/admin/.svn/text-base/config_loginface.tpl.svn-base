<!--{include file="admin/header.tpl"}-->
<div class="itemtitle">
<h3>站点设置</h3>
<ul class="tab1">
<li><a href="/admin/config/site"><span>常规设置</span></a></li>
<li class="current"><a href="javascript:;"><span>外观设置</span></a></li>
</ul>
</div>
<form action="/admin/config/loginface" method="post" onsubmit="return $.checkForm(this)" enctype="multipart/form-data" class="loginform2">
	<p><strong>修改以下红色方框内的文字内容</strong></p>
	<div class="loginface">
		<input type="text" class="t1" name="config[loginface][regurltip]" value="<!--{TO->cfg key='regurltip' group='loginface' default='立即开通微博'}-->"/>
		<input type="text" class="t2" name="config[loginface][nametip]" value="<!--{TO->cfg key='nametip' group='loginface' default='用户名：'}-->"/>
		<input type="text" class="t3" name="config[loginface][passwdtip]" value="<!--{TO->cfg key='passwdtip' group='loginface' default='密  码：'}-->"/>
		<input type="text" class="t4" name="config[loginface][capchatip]" value="<!--{TO->cfg key='capchatip' group='loginface' default='验证码：'}-->"/>
		<input type="text" class="t5" name="config[loginface][logintip]" value="<!--{TO->cfg key='logintip' group='loginface' default='登录微博'}-->"/>
		<input type="text" class="t6" name="config[loginface][wblogintip]" value="<!--{TO->cfg key='wblogintip' group='loginface' default='腾讯微博帐号登录}-->"/>
	</div>
	<p><input type="submit" value="保存" class="btn"/></p>
</form>
<!--{include file="admin/footer.tpl"}-->
