</div></body></html>
<script>
var s=new Image(1,1);
var u=["<!--{$_footCountMes.ip}-->",
"",
"weibo.open.iweibo",
"adminvisit",
"0",
"566",
"",
"<!--{$_footCountMes.appKey}-->",
encodeURIComponent(location.href),
"<!--{$_footCountMes.accessToken}-->",
"iweibo<!--{$_footCountMes.version}-->",
encodeURIComponent(document.referrer),
encodeURIComponent(navigator.userAgent),
"",
"<!--{$_footCountMes.name}-->"
];
s.src="http://btrace.qq.com/collect?sIp="+u[0]
	+"&iQQ="+u[1]+"&sBiz="+u[2]+"&sOp="+u[3]+"&iSta="+u[4]+"&iTy="
	+u[5]+"&iFlow="+u[6]+"&sAppkey="+u[7]+"&sUrl="+u[8]+"&sToken="
	+u[9]+"&sVersion="+u[10]+"&sReferer="+u[11]+"&sAgent="+u[12]
	+"&iReserve="+u[13]+"&sReserve="+u[14];
</script>