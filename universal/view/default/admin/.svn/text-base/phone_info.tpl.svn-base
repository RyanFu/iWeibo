<!--{include file="admin/header.tpl"}-->
<div class="itemtitle">
<h3>客户端设置</h3>
<ul class="tab1">
<li><a href="/admin/phone/theme"><span>主题设置</span></a></li>
<li class="current"><a href="javascript:;"><span>信息设置</span></a></li>
</ul>
</div>
<form action="/admin/phone/info" method="post" onsubmit="return $.checkForm(this)">
    <table class="tb tb2">
        <tr>
            <td class="td27" colspan="2">官方微博帐号：</td>
        </tr>
        <tr class="noborder">
            <td class="vtop rowform"><input type="text" class="txt" name="config[phone_basic][official]" value="<!--{TO->cfg key="official" group="phone_basic"}-->" datatype="Require" msg="请填写官方微博帐号"/></td>
            <td class="vtop tips2"><span info="config[phone_basic][official]"></span>将在客户端上使用，用于推广等</td>
        </tr>
        <tr>
            <td class="td27" colspan="2">网站基本介绍：</td>
        </tr>
        <tr class="noborder">
            <td class="vtop rowform">
                <textarea  rows="6" ondblclick="textareasize(this, 1)" onkeyup="textareasize(this, 0)" name="config[phone_basic][site_des]" id="site_des" cols="50" class="tarea"><!--{TO->cfg key="site_des" group="phone_basic" default=""}--></textarea>
            </td>
            <td class="vtop tips2">将用于客户端的站点详情页简介</td>
        </tr>
    </table>
    <div class="opt"><input type="submit" name="editsubmit" value="提交" class="btn" tabindex="3" /></div>
</form>
<!--{include file="admin/footer.tpl"}-->