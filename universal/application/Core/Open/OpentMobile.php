<?php
/**
 * 开放平台鉴权类手机客户端后台子类
 * @author lololi
 *
 */
class Core_Open_OpentMobile extends Core_Open_Opent {

    /**
     * 重写jsonDecode, 不作错误码异常处理
     * @param $response
     * @param $assoc
     */
    function jsonDecode($response, $assoc = true) {
        $response = preg_replace('/[^\x20-\xff]*/', "", $response);
        $jsonArr = json_decode($response, $assoc);
        if(!is_array($jsonArr))
        {
            Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_API_ERR);
        }
        /* errcode 用于细分定位错误 */
        $jsonArr['errcode'] = $jsonArr['ret']*1000 + $jsonArr['errcode'];
        switch($jsonArr['ret'])
        {
            case 0:
                $jsonArr['msg'] = '成功';
                return $jsonArr;
                break;
            case 1:
                $jsonArr['msg'] = '参数错误';
                break;
            case 2:
                $jsonArr['msg'] = '频率受限';
                break;
            case 3:
                $jsonArr['msg'] = '鉴权失败';
                break;
            case 4:
                if($jsonArr['errcode'] == 4009)
                {
                    $jsonArr['msg'] = '请您不要发表无用信息';
                }else if($jsonArr['errcode'] == 4010){
                    $jsonArr['msg'] = '发表太快，请您稍后再试';
                }else if($jsonArr['errcode'] == 4011){
                    $jsonArr['msg'] = '源消息已删除';
                }else if($jsonArr['errcode'] == 4013){
                    $jsonArr['msg'] = '请您不要发表重复内容';
                }else{
                    $jsonArr['msg'] = '服务异常';
                }
                break;
            case 7:
                $jsonArr['msg'] = '实名验证错误';
                break;
            default:
                $jsonArr['msg'] = '调用API错误';
                break;
        }
        Core_Lib_UtilMobile::logs("ret=".$jsonArr['ret'].";errcode=".$jsonArr['errcode'], true);
        Core_Lib_UtilMobile::outputReturnData($jsonArr['ret'], $jsonArr['errcode'], $jsonArr['msg'], $jsonArr['data']);
    }

    /**
     * 重写http， 去掉异常抛出，改数据吐出
     * @see Core_Open_Opent::http()
     */
    function http($url, $method, $postfields = NULL, $multi = false) {
        Core_Util_Log::$apiRequstUrl = $url;
        $tmp = '<hr>' . $url . '<hr>' . $method . '<hr>' . $postfields . '<hr>';
        //判断是否是https请求
        if (strrpos ( $url, 'https://' ) === 0) {
            $port = 443;
            $version = '1.1';
            $host = 'ssl://' . $this->host;
        
        } else {
            $port = 80;
            $version = '1.0';
            $host = $this->host;
        }
        $header = "$method $url HTTP/$version\r\n";
        $header .= "Host: " . $this->host . "\r\n";
        
        if ($multi) {
            $header .= "Content-Type: multipart/form-data; boundary=" . Core_Open_OAuthUtil::$boundary . "\r\n";
        } else {
            $header .= "Content-Type: application/x-www-form-urlencoded\r\n";
        }
        if (strtolower ( $method ) == 'post') {
            $header .= "Content-Length: " . strlen ( $postfields ) . "\r\n";
            $header .= "Connection: Close\r\n\r\n";
            $header .= $postfields;
        } else {
            $header .= "Connection: Close\r\n\r\n";
        }
        
        if (!function_exists ( 'fsockopen' )) {
            Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_MOBILE_SYSTEMERROR, 0, '不支持函数fsockopen');
        }
        
        $ret = '';
        $fp = fsockopen ( $host, $port, $errno, $errstr, 10 );
        
        if (!$fp) {
            Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_NET_CONNECTERROR);
        } else {
            fwrite ( $fp, $header );
            while ( ! feof ( $fp ) ) {
                $ret .= fgets ( $fp, 4096 );
            }
            fclose ( $fp );
            if (strrpos ( $ret, 'Transfer-Encoding: chunked' )) {
                $info = explode ( "\r\n\r\n", $ret );
                $response = explode ( "\r\n", $info [1] );
                $t = array_slice ( $response, 1, - 1 );
                
                $returnInfo = implode ( '', $t );
            } else {
                $response = explode ( "\r\n\r\n", $ret );
                $returnInfo = $response [1];
            }
            return iconv ( "utf-8", "utf-8//ignore", $returnInfo );
        }
    }

}
?>