<?php
/**
 * 
 * Log 日志处理方法
 *
 * @author Icehu
 * 
 */
require_once dirname(__FILE__). DIRECTORY_SEPARATOR . "bossapi.php";
class Core_Util_Log
{
    /**
     * 日志存放目录
     * 以根目录为起点
     */
    const LOGDIR = 'logs';


    public static $apiRequstUrl = '';

    /**
     * 文件日志方法
     * @param string $filename 日志文件，会自动按日期分卷
     * @param string $logs 日志内容
     * @author Icehu
     */
    public static function file($filename,$logs)
    {
        $dir = ROOT . self::LOGDIR.'/';
        if (!is_dir ($dir)) {
            @mkdir ($dir, 0777);
        }
        $file = $dir . $filename . date('Ymd');
        $handle = fopen($file, 'a');
        flock($handle, LOCK_EX);
        fwrite($handle, $logs . "\r\n");
        flock($handle, LOCK_UN);
        fclose($handle);
    }

    public static function bossLog()
    {
        $param = func_get_args();
        $ip = gethostbyname('btrace.qq.com');
        $port = 6578;
        loginit($ip,$port);
        return call_user_func_array("logprintf",$param);
    }

    public static function httpBossLog()
    {
        $ret   = "";
        $param = func_get_args();
        $arrKey=array("sIp","iQQ","sBiz","sOp","iSta","iTy","iFlow","apiName","ret","msg","errCode","costTime","appKey","serverIp","value1","value2","value3","value4");
        array_shift($param);
        $param = array_combine($arrKey,$param);
        $param = http_build_query($param); 
        $host="btrace.qq.com";
        $url = "http://btrace.qq.com/collect?" . $param;
        //echo "<script></script>";
        $header = "GET $url HTTP/1.1\r\n";
        $header .= "Host: " . $host . "\r\n";
        $header .= "Connection: Close\r\n\r\n";
    
        $fp = fsockopen($host, 80, $errno, $errstr, 10);
        if(! $fp)
        {
            $error = '建立sock连接失败';
        //    throw new Core_Api_Exception($error);
        }
        else
        {
            fwrite($fp, $header);
            while(! feof($fp))
            {
                $ret .= fgets($fp, 4096);
            }
            fclose($fp);
            if(strrpos($ret, 'Transfer-Encoding: chunked'))
            {
                $info = explode("\r\n\r\n", $ret);
                $response = explode("\r\n", $info[1]);
                $t = array_slice($response, 1, - 1);
                $returnInfo = implode('', $t);
            }
            else
            {
                $response = explode("\r\n\r\n", $ret);
                $returnInfo = $response[1];
            }
        }
        return $returnInfo;
    }
}
