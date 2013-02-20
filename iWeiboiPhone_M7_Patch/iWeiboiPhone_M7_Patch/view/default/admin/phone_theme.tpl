<!--{include file="admin/header.tpl"}-->
<div class="itemtitle">
<h3>客户端设置</h3>
<ul class="tab1">
<li class="current"><a href="javascript:;"><span>主题设置</span></a></li>
<li><a href="/admin/phone/info"><span>信息设置</span></a></li>
</ul>
</div>
<form action="/admin/phone/upload" method="post" onsubmit="return $.checkForm(this)" enctype="multipart/form-data" >
    <table class="tb tb2">
        <!--{foreach from=$themelist item=node}-->
            <tr>
                <td class="td27" colspan="2"><!--{$node.text}--></td>
            </tr>
            <tr class="noborder">
                <td class="vtop rowform">
                    <input type="file" class="txt" id="<!--{$node.id}-->" name="<!--{$node.id}-->" /></td>
                <td class="vtop tips2">仅支持<!--{$ext}-->格式，<!--{$node.dim}-->尺寸，大小不要超过<!--{$node.maxsize}--></td>
            </tr>
        <!--{/foreach}-->
    </table>
    <div class="opt"><input type="submit" name="editsubmit" value="提交" class="btn" tabindex="3" /></div>
</form>
<!--{include file="admin/footer.tpl"}-->