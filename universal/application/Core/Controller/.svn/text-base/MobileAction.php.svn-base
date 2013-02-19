<?php
/**
 * Mobile模块后台控制器基类
 * @author lololi
 */
class Core_Controller_MobileAction extends Core_Controller_Action {

    public function preDispatch() {

        /*站点关闭*/
        if(Core_Config::get('site_closed','basic',false))
        {
            Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_SITE_CLOSED);
        }
        /*请求不是来至iPhone客户端*/
        if(!Core_Lib_UtilMobile::isFromClient() && 0)
        {
            Core_Lib_UtilMobile::logs("Requests not from iPhone\r\nagent=".$_SERVER['HTTP_USER_AGENT']);
            Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_AGENT_NOTIPHONE);
        }
        //除了登录等接口外，其他接口调用需要验证；设置相关session
        //设置session是为了复用pc侧的代码,实际没有调用session_start,session只当作全局变量来用
        $ctrlName = $this->getControllerName();
        $actionName = $this->getActionName();
        /* private/login, private/check, customized/theme, customized/siteinfo这几个接口不需要做验证 */
        if(($ctrlName!='private') &&
           ($ctrlName!='customized' || ($actionName!='theme' && $actionName!='siteinfo')))
        {
            $params = $this->getParams();
            /* verifyMode=0，走oauth协议，需要验证签名;verifyMode=1, 走登录态验证 */
            $verifyMode = (int) $params['vmode'];

            if(!empty($verifyMode))
            {
                $username = $_COOKIE['user'];
                $skey     = $_COOKIE['skey'];
                $setTime  = $_COOKIE['set_time'];
                //echo $username.'-'.$skey.'-'.$setTime.'<br>';
                if(empty($username) || empty($skey) || empty($setTime))
                {
                    Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_LOGINSTATE_INVALID);
                }
                
                $checkFlag = Core_Lib_UtilMobile::verifyLogin($username, $setTime, $skey);
                if(!$checkFlag)
                {
                    $logContent .= "ret=".Core_Comm_Modret::RET_LOGINSTATE_FAIL."\r\n";
                    $logContent .= "user=".$username.";skey=".$skey.";set_time=".$setTime;
                    Core_Lib_UtilMobile::logs($logContent);
                    Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_LOGINSTATE_FAIL);
                }
                /*大于cookie改变间隔， 重新下发cookie*/
                $curTime = time();
                if($curTime-$setTime > Core_Comm_Mobile::COOKIE_CHANGE_INTERVAL)
                {
                    Core_Lib_UtilMobile::issueLoginCookie($username, $curTime);
                }
            }else{
                $accessToken = $params['oauth_token'];
                $usrModel = new Model_User_MemberMobile();
                $usrModel->onSetCurrentAccessToken($accessToken);
                $akey = Core_Config::get('appkey', 'basic');
                $skey = Core_Config::get('appsecret', 'basic');
                if(empty($akey) || empty($skey))
                {
                    Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_API_KEYMISS);
                }
                $accessTokenSecret = $_SESSION['access_token_secret'];
                $signature = $params['oauth_signature'];
                $url = $this->getParam('request_api');
                $url = urldecode($url).'?';
                $method = $_SERVER['REQUEST_METHOD'];
                //生成签名中不需要以下参数
                unset($params['vmode']);
                unset($params['oauth_signature']);
                unset($params['__Model']);
                unset($params['__Controller']);
                unset($params['__Action']);
                $isSignCorrect = 0;
                if(!empty($signature))
                {
                    $isSignCorrect = Core_Lib_UtilMobile::checkSignature($signature, $url, $method, $params,
                                                                     $akey, $skey, $accessToken, $accessTokenSecret);
                }
                //验证签名失败
                if(!$isSignCorrect)
                {
                    Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_MOBILE_CHECKSIGNATUREFAIL);
                }
            }
        }
    }

    public function dispatch($action) {
        try {
            parent::dispatch ( $action );
        } catch ( Exception $e ) {
            /* 记录本地log */
            $logContent .= "Exception:code=".$e->getCode().";msg= ".$e->getMessage();
            Core_Lib_UtilMobile::logs($logContent);
            Core_Lib_UtilMobile::outputReturnData( Core_Comm_Modret::RET_MOBILE_SYSTEMERROR, 0, '发生了意外。请重试' );
        }
    }

}