<!doctype html>
<html>
    <head>
    <title>我的听众 - <!--{TO->cfg key="site_name" group="basic" default="iWeibo2.0"}--></title>
    <!--{include file="common/style.tpl"}-->
    </head>
    <body>
    <!--{include file="common/header.tpl"}-->
<div class="wrapper content">
        <div class="fleft contentleft">
        <!--主栏组件-->
        <!--{$mainComponent}-->
        <div class="tabbar">
        <ul class="tabs">
        <li class="tab"><a href="/friend/following/">我收听的人</a></li>
        <li class="tab active"><strong>我的听众</strong></li>
        </ul>
        <div class="fright">听众<!--{$unum}-->人</div>
        </div>
        <!--{include file="friend/comm_idolfans.tpl"}-->
        <!--{include file="common/pagerwrapper3.tpl"}-->
    </div>
    <div class="fright contentright">
        <!--{include file="common/profile.tpl"}-->
        <div class="rightsp" ></div>
        <!--{include file="common/menus.tpl"}-->
        <div class="rightsp"></div>
        <!--右栏组件-->
        <!--{$rightComponent}-->
    </div>
</div>
    <!--{include file="common/footcontrol.tpl"}-->
    <!--{include file="common/footer.tpl"}-->
    <script src="/resource/js/useridolfans.js"></script>
    </body>
</html>