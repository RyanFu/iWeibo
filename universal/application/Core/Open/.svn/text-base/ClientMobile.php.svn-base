<?php
/**
 * iweibo3.0
 *
 * 开放平台操作类手机客户端后台子类
 *
 * @author lololi
 */
class Core_Open_ClientMobile extends Core_Open_Client
{
    /**
     * 重写构造函数
     */
    public function __construct()
    {
        $access_token = $_SESSION['access_token'];
        $access_token_secret = $_SESSION['access_token_secret'];
        $wbakey = Core_Config::get('appkey', 'basic');
        $wbskey = Core_Config::get('appsecret', 'basic');
        if(empty($wbakey) || empty($wbskey) || empty($access_token) || empty($access_token_secret))
        {
            $logContent .= "ret=".Core_Comm_Modret::RET_API_KEYMISS."\r\n";
            $logContent .= "ac_token:".$access_token.";appkey:".$wbakey.";appsecret:".$wbskey;    //ac_secret敏感信息不记录
            Core_Lib_UtilMobile::logs($logContent);
            Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_API_KEYMISS);
        }
        $this->oauth = new Core_Open_OpentMobile($wbakey, $wbskey, $access_token, $access_token_secret);
    } 

    /*
     * 获取多条微博数据
     * @p 数组,包括以下:
     * @ids: 微博id列表用“,”隔开
     * @return array
     * *********************/
    public function getBlogList($p)
    {
        $url = self::OPEN_HOST . '/api/t/list';
        $params = array('format' => self::RETURN_FORMAT, 'ids' => $p['ids']);
        return $this->oauth->get($url, $params);
    }
    
    /*
     * 获取多个话题数据
     * @p 数组,包括以下:
     * @httexts: 话题名称列表用“,”隔开
     * @return array
     * *********************/
    public function getTopicInfo($p)
    {
        $url = self::OPEN_HOST . '/api/ht/ids';
        $params = array('format' => self::RETURN_FORMAT, 'httexts' => $p['httexts']);
        return $this->oauth->get($url, $params);
    }
    
    /*
     * 订阅话题
     * @p 数组,包括以下:
     * @id: 话题id
     * @return array
     * *********************/
    public function subscribeTopic($p)
    {
        $url = self::OPEN_HOST . '/api/fav/addht';
        $params = array('format' => self::RETURN_FORMAT, 'id' => $p['id']);
        return $this->oauth->post($url, $params);
    }
    
    /*
     * 取消订阅话题
     * @p 数组,包括以下:
     * @id: 话题id
     * @return array
     * *********************/
    public function unsubscribeTopic($p)
    {
        $url = self::OPEN_HOST . '/api/fav/delht';
        $params = array('format' => self::RETURN_FORMAT, 'id' => $p['id']);
        return $this->oauth->post($url, $params);
    }
}
?>