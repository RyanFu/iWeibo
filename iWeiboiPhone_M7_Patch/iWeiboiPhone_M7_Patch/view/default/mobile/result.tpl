<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>授权结果</title>
<!--{include file="mobile/common/style.tpl"}-->
</head>
<body>
    <div class="errmid">
        <!--{if $ret==0 }-->
            <span class="bind_ok"></span>
        <!--{else}-->
            <span class="bind_fail"></span>
        <!--{/if}-->
        <span><!--{$msg}--></span>
    </div>
</body>
</html>