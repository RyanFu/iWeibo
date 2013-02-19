<!doctype html>
<html>
    <head>
    <title>微直播 - <!--{$tlive.title}--> - <!--{$tlive.tname}--> - <!--{TO->cfg key="site_name" group="basic" default="iWeibo2.0"}--></title>
    <script> var iwbAddUrl = "tlive/add/id/<!--{$tlive.id}-->";</script>
    <!--{include file="common/style.tpl"}-->
    <style>
    <!--{if $tlive.style.linkcolor}-->
    a{color:<!--{$tlive.style.linkcolor}-->;}
    <!--{/if}-->
    <!--{if $tlive.style.background||$tlive.style.bgcolor}-->
	body{background:url(<!--{$tlive.style.background}-->) <!--{if !$tlive.style.repeat}--> no-repeat<!--{/if}--> <!--{if $tlive.style.bgcolor}--><!--{$tlive.style.bgcolor}--><!--{/if}-->;}
	.footer{background:none;}
	<!--{/if}-->
    </style>
    
    <!--{if ($u == 'all' ) || ($role == '2' && $u == '0') || ($role == '3' && $u == '1')}-->
    <script> var iwbInstantTimeline = true; </script>
    <!--{/if}-->
    </head>
    <body>
    <!--{include file="common/header.tpl"}-->
    <div class="wrapper content">
        <!--{if $tlive.style.outward}-->
        <div><img src="<!--{$tlive.style.outward}-->" width="800" height="100"/></div>
        <!--{/if}-->
        <div class="contentleft fleft">
            <!--{if $tlive.statusText != '已结束'}-->
            <div class="nobg"><!--{include file="common/sendbox.tpl"}--></div>
            <!--{/if}-->
            <div class="tabbar">
                <ul class="tabs">
                    <li class="tab <!--{if isset($actives.all)}--><!--{$actives.all}--><!--{/if}-->" >
                        <!--{if empty($actives.all)}--><a href="/tlive/view/id/<!--{$tlive.id}-->"><!--{else}--><strong><!--{/if}-->直播内容
                    <!--{if $actives.all != ''}--><small>(共<!--{$tps.total}-->条)</small><!--{/if}--><!--{if empty($actives.all)}--></a><!--{else}--></strong><!--{/if}--></li>
                    <li class="tab <!--{if isset($actives.0)}--><!--{$actives.0}--><!--{/if}-->"><!--{if empty($actives.0)}--><a href="/tlive/view/id/<!--{$tlive.id}-->/u/0"><!--{else}--><strong><!--{/if}-->主持人
                    <!--{if isset($actives.0) && $actives.0 != ''}--><small>(共<!--{$tps.total}-->条)</small><!--{/if}--><!--{if empty($actives.0)}--></a><!--{else}--></strong><!--{/if}--></li>
                    <li class="tab <!--{if isset($actives.1)}--><!--{$actives.1}--><!--{/if}-->"><!--{if empty($actives.1)}--><a href="/tlive/view/id/<!--{$tlive.id}-->/u/1"><!--{else}--><strong><!--{/if}-->嘉宾
                    <!--{if isset($actives.1) && $actives.1 != ''}--><small>(共<!--{$tps.total}-->条)</small><!--{/if}--><!--{if empty($actives.1)}--></a><!--{else}--></strong><!--{/if}--></li>
                </ul>
                <div class="fright">
                </div>
            </div>
            <div class="tcontainer">
                <!--{include file="common/tbody.tpl"}-->
            </div>
            <!--{if $tps.total > 0 }-->
                <div class="norecord"><!--{include file="common/multipage1.tpl"}--></div>
            <!--{/if}-->
            </div>
        <div class="contentright fright"><br/>
        <div class="textlisttit" title="<!--{$tlive.tname}-->"><big>&#10075;</big><label><!--{$tlive.tname}--></label><big>&#10076;</big></div>
        <div class="textlisttit" title="直播简介">直播简介&nbsp;
        <!--{if $tlive.statusText == '进行中'}-->
            <em class="icon_living"></em>
        <!--{elseif $tlive.statusText == '未开始'}-->
            <em class="icon_liver"></em>
        <!--{else}-->
            <em class="icon_lived"></em>
        <!--{/if}-->
        </div>
        <div class="livedes">
        <em class="icon_angle"></em>
        <strong>直播时间：</strong>
        <p class="gray"><!--{$tlive.sdate|idate:"Y年m月d日 H:i"}--> 至 <!--{$tlive.edate|idate:"Y年m月d日 H:i"}--></p>
        <strong>直播内容：</strong>
        <p class="gray"><!--{$tlive.desc}--></p>
        <center><a data-text="#微直播#<!--{$tlive.desc}-->" href="javascript:void(0);" class="iwbAddBtn commendbtn"></a></center>
        </div>
        <div class="toggle" title="主持人">主持人</div>
        <ul class="userlist">
            <!--{foreach name=user item=user key=i from=$join.0}-->
            <li>
            <p><a href="/u/<!--{$user.name}-->" target="_blank"><img src="<!--{$user.head}-->" title="<!--{$user.nick}-->(@<!--{$user.name}-->)" /></a></p>
            <h3><a href="/u/<!--{$user.name}-->" target="_blank" title="<!--{$user.nick}-->(@<!--{$user.name}-->)"><!--{$user.nick}--></a></h3>
            <div>
            <!--{if $user.name != $username}-->
                <!--{if $user.isidol}-->
                <a data-name="<!--{$user.name}-->" href="javascript:void(0);" data-type="0" data-styleid="1" class="iwbFollowControl follow unfollow"></a>
                <!--{else}-->
                <a data-name="<!--{$user.name}-->" href="javascript:void(0);" data-type="1" data-styleid="1" class="iwbFollowControl follow"></a>
                <!--{/if}-->
            <!--{/if}-->
            </div>
            </li>
            <!--{/foreach}-->
        </ul>
        <div class="toggle" title="嘉宾">嘉宾</div>
        <ul class="userlist">
            <!--{foreach name=user item=user key=i from=$join.1}-->
            <li>
            <p><a href="/u/<!--{$user.name}-->" target="_blank" title="<!--{$user.nick}-->"><img src="<!--{$user.head}-->"></a></p>
            <h3><a href="/u/<!--{$user.name}-->" target="_blank" title="<!--{$user.nick}-->(@<!--{$user.name}-->)"><!--{$user.nick}--></a></h3>
            <div>
            <!--{if $user.name != $username}-->
                <!--{if $user.isidol}-->
                <a data-name="<!--{$user.name}-->" href="javascript:void(0);" data-type="0" data-styleid="1" class="iwbFollowControl follow unfollow"></a>
                <!--{else}-->
                <a data-name="<!--{$user.name}-->" href="javascript:void(0);" data-type="1" data-styleid="1" class="iwbFollowControl follow"></a>
                <!--{/if}-->
            <!--{/if}-->
            </div>
            </li>
            <!--{/foreach}-->
        </ul>
        </div>
    </div>
     <!--{include file="common/footcontrol.tpl"}-->
    <!--{include file="common/footer.tpl"}-->
    <script>
        $(document).ready(function(){
        <!--{if $tlive.statusText != '已结束'}-->
            $("#sendTweet").attr('action',window.iwbRoot + 'tlive/add/id/<!--{$tlive.id}-->');
            $(".sendboxtitle").html("关于<a href='javascript:void(0);'><!--{$tlive.title}--></a>的讨论");
            $("#msgTxt").bind("keydown",function(){
                if(!(/^\#.*\#/).test(this.value)){
                    this.value = '#<!--{$tlive.title}-->#' + this.value;
                }
            });
        <!--{/if}-->
        });
    </script>
    <script src="/resource/js/live.js"></script>
    </body>
</html>