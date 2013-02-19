<?php
$agentIP = "127.0.0.1";
$agentPort = 6578;

/**********error log api****************************/
function SEND_LOG_EMERG($module, $uin, $cmd, $errcode, $msg)
{
	sendError($module, $uin, $cmd, "H", $errcode, $msg);
}
function SEND_LOG_ERROR($module, $uin, $cmd, $errcode, $msg)
{
	sendError($module, $uin, $cmd, "M", $errcode, $msg);
}
function SEND_LOG_WARN($module, $uin, $cmd, $errcode, $msg)
{
	sendError($module, $uin, $cmd, "L", $errcode, $msg);
}

/**********access log api****************************/
function SEND_LOG_ACCESS($uin, $module, $oper, $retcode, $iflow, $msg)
{
	sendAccessLog($uin, $module, $oper, $retcode, $iflow, $msg);
}
//与printf的用法相似
//logprintf(format, data1, data2, ....);
//至少要包含8个参数，其中第一个为格式串，其余为对应的数据内容(至少7个必填字段。请参考接口文档说明)
//return 0:成功 -1:失败
function logprintf()
{
	global $agentIP, $agentPort;
	$num = func_num_args();

	//7个必填的字段，再加一个格式串
	if($num < 8)
	{
		return -1;
	}
	$args = func_get_args();
	$log = vsprintf($args[0], array_slice($args, 1));
    //echo $log,"<br/>";
	$socket = socket_create(AF_INET, SOCK_DGRAM, SOL_UDP);
	if($socket < 0)
	{
		return -1;
	}

	socket_set_nonblock($socket);
	if(!socket_connect($socket, $agentIP, $agentPort))
	{
		return -1;
	}
	$len = strlen($log);
	$ret = socket_write($socket, $log, strlen($log));
	if($ret != $len)
	{
		socket_close($socket);
		return -1;
	}
	socket_close($socket);
	return 0;
}

function sendAccessLog($uin, $module, $oper, $retcode, $iflow, $msg)
{
    $localip = IP2LONG($_SERVER['SERVER_ADDR']);
	$e = new Exception("");
	$trace = $e->getTrace();
	if(isset($trace[2]))
	{
		$func = $trace[2]["function"];
		$srcfile = $trace[1]["file"];
		$srcline = $trace[1]["line"];
	}
	else
	{
        $func = $trace[0]["function"];
		$srcfile = $trace[0]["file"];
        $srcline = $trace[0]["line"];
	}

    $errmsg2 = substr($msg, 0, min(1024, strlen($msg)));
    $len = strlen($errmsg2);
    for($i = 0; $i < $len; $i++)
    {
		if($errmsg2[$i] == '&') {$errmsg2[$i] = ' ';}
        if($errmsg2[$i] == ',') {$errmsg2[$i] = '&';}
    }

    $rc = logprintf("%u,%u,%s,%s,%d,%d,%u,%s,%s,%d,%s",
            $localip, $uin, $module, $oper, $retcode, 534, $iflow, $srcfile, $func, $srcline, $errmsg2);
    return $rc;
}

function sendError($module, $uin, $cmd, $level, $errcode, $msg)
{
	$localip = IP2LONG($_SERVER['SERVER_ADDR']);
	$pid = posix_getpid();
	$e = new Exception("");
	$trace = $e->getTrace();
	if(isset($trace[2]))
	{
		$func = $trace[2]["function"];
		$srcfile = $trace[1]["file"];
		$srcline = $trace[1]["line"];
	}
	else
	{
        $func = $trace[0]["function"];
		$srcfile = $trace[0]["file"];
        $srcline = $trace[0]["line"];
	}

	$errmsg2 = substr($msg, 0, min(1024, strlen($msg)));
    $len = strlen($errmsg2);
    for($i = 0; $i < $len; $i++)
    {
		if($errmsg2[$i] == '&') {$errmsg2[$i] = ' ';}
        if($errmsg2[$i] == ',') {$errmsg2[$i] = '&';}
    }

    $ret = logprintf("%u,%u,%s,%s,%d,%d,%d,%s,%d,%s,%s,%d,%s,%s",
            $localip, $uin, $module, $cmd, $errcode, 479, 0, $srcfile, $srcline,
            $func, "httpd", $pid, $level, $errmsg2);

	return $ret;
}

//ip:通常就是本机ip
function loginit($ip, $port)
{
	global $agentIP, $agentPort;
	$agentIP = $ip;
	$agentPort = $port;
}

/*$ip = "192.168.1.1";
$qq = 12345;
$biz = "finance.stock.dpfx";
$op = "login";
$status = 0;
$logid = 1001;
$flowid = 345678;
$custom = "custom message from php";
loginit("127.0.0.1", 6578);
if(logprintf("%s,%d,%s,%s,%d,%d,%d,%s", $ip, $qq, $biz, $op, $status, $logid, $flowid, $custom) < 0)
{
	echo "logprintf failed\n";
}*/
//**********************/
?>
