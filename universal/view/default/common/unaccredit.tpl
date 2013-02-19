<div class="setform fleft">
	<div class="unaccredit"></div>
	<div class="unaccredit2">
		<div>
			<p>
			当前授权设置的腾讯微博帐号是：<strong><!--{$username}--></strong><br/>
			取消授权后微博帐号将与本地帐号解除绑定
			</p>
			<div class="fright">
				<div>
					<a href="/setting/accredit/change/do" class="button button_blue" id="unaccreditbtn">取消授权
						<label class="tooltip">
							一旦取消授权，微博账号将不再与本地账号进行绑定，您需要重新登录进行绑定授权。
						</label>
					</a> &nbsp; 
				</div>
			</div>
		</div>
		<form class="bindform unbindform" onsubmit="return checkform();" style="display:none;">
			<table>
				<tr><th colspan="2" height="50" align="left"><div  class="tit" align="left">取消微博授权后，需要设置一个本地密码来登录本地帐号</div></th></tr>
				<tr><th height="50"><span>*</span>密码：</th>
					<td>
						<input type="password" class="input_text" maxlength="15" placeholder="密码长度为3~15字符" name="pwd"/>
						<span class="emsg gray">密码长度为3~15字符</span>
					</td>
				</tr>
				<tr><th height="50"><span>*</span>重复密码：</th>
					<td>
						<input type="password" class="input_text" data-validator="required pwd" maxlength="15" placeholder="重复密码必须与密码一致" name="pwdconfirm"/>
						<span class="emsg"></span>
					</td>
				</tr>
				<tr><th height="70"></th><td><div class="bluebtn"><input type="submit" value="完成"/></div></td></tr>
			</table>
		</form>
	</div>
</div>
<script>
$(function(){/*
	$("#unaccreditbtn").click(function(){
		if(confirm("是否确定取消授权？")){
			$(".bindform").removeAttr("style");
		}
		return false;
	});
	$(".bindform").find("input[name='pwd']").bind("focusout",function(){
		var that=$(this),val=that.val();
		if (/^.{3,15}$/.test(val)){
		that.nextAll(".emsg").removeClass("errormsg").html("<em class=\"icon_ok\"></em>");
		}else{
		var t="";
		if (val.length>0&&val.length<3) {
			t="密码不能太短！";
		}else if(val.length>15) {
		    t="密码不能太长！";
		}else {
			t="密码不能为空！";
		}
		that.nextAll(".emsg").html("<b></b>"+t).addClass(" errormsg");
		}
	}).end().find("input[name='pwdconfirm']").bind("focusout",function(){
		var that=$(this),val=that.val(),pwd=$(".bindform").find("input[name='pwd']").val();
		if(val!=pwd){
			var t="两次输入的密码不一致";
			that.nextAll(".emsg").html("<b></b>"+t).addClass(" errormsg");
		} else {
			that.nextAll(".emsg").removeClass("errormsg").html("<em class=\"icon_ok\"></em> <span class=\"gray\">密码一致</span>");
		}
	});
});

function checkform(){
	var f=$(".bindform");
	var p1=f.find("input[name='pwd']");
	var p2=f.find("input[name='pwdconfirm']");
	if (/^.{3,15}$/.test(p1.val())) {
		if (p1.val()==p2.val()) {
		return true;
		}else {
		p2.trigger("focusout");
		return false;
		}
	}else{
		p1.trigger("focusout");
	}
}*/
</script>
