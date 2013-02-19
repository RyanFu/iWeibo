<?php
/**
 * 手机客户端后台部分私有接口类
 * @author lololi
 */
class Controller_Mobile_Private extends Core_Controller_MobileAction
{
    /**
     * 后台部署检查接口
     */
    public function checkAction()
    {
        $main = Core_Comm_Mobile::$MODULE_CLASS;
        $sub  = Core_Comm_Mobile::$MODULE_FUNCTION;
        $dir  = Core_Comm_Mobile::MOBILE_DIR;

        $data = array();
        foreach($main as $k=>$class)
        {
            $file = $dir.$class.'.php';
            $className = 'Controller_Mobile_'.$class;
            if(!file_exists($file))
            {
                $data []= 'File('.$file.') not exists!';
            }else if(!class_exists($className, true))
            {
                $data []= 'Class('.$className.') not exists!';
            }else{
                $fns = $sub[$k];
                foreach($fns as $func)
                {
                    $funcName = $func.'Action';
                    if(!method_exists($className, $funcName))
                    {
                        $data []= 'Function('.$funcName.') in class('.$className.') not exists!';
                    }
                }
            }
        }
        if(empty($data))
        {
            $ret = 0;
            $msg = '后台部署成功';
        }else{
            $ret = 1;
            $msg = '服务器部署错误';
            Core_Lib_UtilMobile::logs("deployment error:\r\n".print_r($data, true));
        }
        Core_Lib_UtilMobile::outputReturnData($ret, 0, $msg, $data);
    }

    /**
     * 登录接口
     */
    public function loginAction()
    {
        $user = $this->getParam('user');
        $password = $this->getParam('pwd');
        /* vmode=0, 返回access_token,access_token_secret;
         * vmode=1, 下发登录态.
         */
        $verifyMode = (int)$this->getParam('vmode');

        $data = null;
        $errcode = 0; 
        $action = 'login';
        $usrModel = new Model_User_MemberMobile();
        /*捕捉数据库异常*/
        try
        {
            if(Core_Config::get('useuc', 'basic', false))
            {
                list($uid, $user, $password, $email) = Core_Outapi_Uc::call('user_login', $user, $password);
                if($uid <= 0){
                    if($uid == -1)
                    {
                        $ret = 1;
                        $msg = '帐号不存在'; 
                    }else if($uid == -2){
                        $ret = 2;
                        $msg = '密码不正确'; 
                    }else{
                        $ret = 10;
                        $msg = '登录失败';
                    }
                    Core_Lib_UtilMobile::bossLog($action, $ret, $msg, $errcode);
                    Core_Lib_UtilMobile::outputReturnData($ret, $errcode, $msg, $data);
                }else{
                    //本地用户不存在，则自动注册本地用户
                    if(!$usrModel->checkUsernameExists($user))
                        $usrModel->onAutoRegister($uid, $user, $email);
                    $userInfo = $usrModel->getUserInfoByUid($uid);
                    $accessToken = $userInfo['oauthtoken'];
                    $accessTokenSecret = $userInfo['oauthtokensecret'];
                }
            }else{
                    /*检查用户名是否存在*/
                    if(!$usrModel->checkUsernameExists($user))
                    {
                        $ret = 1;
                        $msg = '本地帐号不存在'; 
                        Core_Lib_UtilMobile::bossLog($action, $ret, $msg, $errcode);
                        Core_Lib_UtilMobile::outputReturnData($ret, $errcode, $msg, $data);
                    }
                    
                    /*密码是否正确*/
                    /*checkUserOldPassword是用于检查密码是否正确*/
                    if(!$usrModel->checkUserOldPassword($user, $password))
                    {
                        $ret = 2;
                        $msg = '密码不正确';
                        Core_Lib_UtilMobile::bossLog($action, $ret, $msg, $errcode);
                        Core_Lib_UtilMobile::outputReturnData($ret, $errcode, $msg, $data);
                    }
                    /*检查帐号是否绑定腾讯微博*/
                    /*access token 和  access token secret 必须均不为空*/
                    $tokens = $usrModel->getAccessTokensByUsername($user);
                    $accessToken = $tokens['oauth_token'];
                    $accessTokenSecret = $tokens['oauth_token_secret'];
            }
            if(empty($accessToken) || empty($accessTokenSecret))
            {
                $ret = 3;
                $msg = '未绑定腾讯帐号';
                Core_Lib_UtilMobile::bossLog($action, $ret, $msg, $errcode);
                Core_Lib_UtilMobile::outputReturnData($ret, $errcode, $msg, $data);
            }
            /* 实名验证限制 */
            $usrModel->onSetCurrentAccessToken($accessToken);
            if(Core_Lib_UtilMobile::getIsRealName() == 2)
            {
                $ret = 7;
                $msg = '未通过实名验证';
                Core_Lib_UtilMobile::bossLog($action, $ret, $msg, $errcode);
                Core_Lib_UtilMobile::outputReturnData($ret, $errcode, $msg, $data);
            }
        }catch (Core_Db_Exception $e){
            $ret = 4;
            $msg = $e->getMessage();
            $msg = empty($msg)?'系统错误':$msg;
            $errcode = $e->getCode();
            Core_Lib_UtilMobile::bossLog($action, $ret, $msg, $errcode);
            Core_Lib_UtilMobile::outputReturnData($ret, $errcode, $msg, $data);
        }

        if(empty($verifyMode))
        {
            /*返回用户tokens信息*/
            $data = array();
            $data['oauth_token'] = $accessToken;
            $data['oauth_token_secret'] = $accessTokenSecret;
        }else{
            /*下发登录态*/
            $curTime = time();
            Core_Lib_UtilMobile::issueLoginCookie($user, $curTime, $accessToken, $accessTokenSecret);
        }

        /*通过检查，返回数据*/
        $ret = 0;
        $msg = '登录成功';
        Core_Lib_UtilMobile::bossLog($action, $ret, $msg, $errcode);
        Core_Lib_UtilMobile::outputReturnData($ret, $errcode, $msg, $data);
    }

    /**
     * 本地注册接口
     */
    public function regAction()
    {
        $username = $this->getParam('user');
        $pwd = $this->getParam('pwd');
        $email = $this->getParam('email');

        //用户名格式不正确
        if (!Model_User_Validator::checkUsername($username))
        {
            Core_Lib_UtilMobile::logs("ret=".Core_Comm_Modret::RET_USERNAME_FORMATERROR.";user=".$username);
            Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_USERNAME_FORMATERROR);
        }
        //密码格式不正确
        if (!Model_User_Validator::checkPassword($pwd))
        {
            Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_PASSWORD_FORMATERROR);
        }
        //邮箱格式不正确
        if (!Core_Comm_Validator::isEmail($email))
        {
            Core_Lib_UtilMobile::logs("ret=".Core_Comm_Modret::RET_EMAIL_FORMATERROR.";email=".$email);
            Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_EMAIL_FORMATERROR);
        }

        $userModel = new Model_User_Member();
        if (Core_Config::get('useuc', 'basic', false)) {
            $uccfg = Core_Config::get(null, 'uc', array());
            //过滤掉不能顺利转成gbk的utf8中文
            if ("gbk" == $uccfg['charset']) {
                $gbkusername = iconv("utf-8//ignore", "gbk//ignore", $username);
                $utfusername = iconv("gbk//ignore", "utf-8//ignore", $gbkusername);
                if ($utfusername == $username) {
                    $uid = Core_Outapi_Uc::call('user_register', $username, $pwd, $email);
                } else {
                    $uid = -3;
                }
            } else {
                $uid = Core_Outapi_Uc::call('user_register', $username, $pwd, $email);
            }

            if ($uid > 0) {
                //自动注册到本地失败
                if (!$userModel->onAutoRegister($uid, $username, $email))
                {
                    Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_USER_REGISTERFAILED);
                }
            } else {
                //用户名已被使用
                if ($uid == - 3)
                {
                    Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_USERNAME_USED);
                }
                //邮箱已被使用
                if ($uid == - 6)
                {
                    Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_EMAIL_USED);
                }
                //用户名不合ucenter规则
                if ($uid==-1 || $uid==-2)
                {
                    Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_USERNAME_FORMATERROR);
                }
                //注册失败
                Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_USER_REGISTERFAILED);
            }
        } else {
            //用户名已被使用
            if ($userModel->checkUsernameExists($username))
            {
                Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_USERNAME_USED);
            }
            //邮箱已被使用
            if ($userModel->checkEmailExists($email))
            {
                Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_EMAIL_USED);
            }
            $uid = $userModel->onRegister($username, $pwd, $email);
        }
        //注册成功
        if ($uid) {
            try {Model_Stat::addStat('reg');} catch (Exception $e) {}
            Core_Lib_UtilMobile::outputReturnData(0, 0, 'OK', null);
        }
        Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_USER_REGISTERFAILED);
    }

    /**
     * 绑定帐号接口
     * 前端在WebView调用此接口，完成本地帐号（传参user）绑定一个腾讯微博帐号
     */
    public function authorizeAction()
    {
        $username = $this->getParam('user');
        if(empty($username))
        {
            Core_Lib_UtilMobile::logs("ret=".Core_Comm_Modret::RET_API_OAUTH_ERR.";errcode=3;username:".$username);
            $this->showmsg("", "mobile/private/result?ret=".Core_Comm_Modret::RET_API_OAUTH_ERR."&errcode=3", 0);
        }
        $userModel = new Model_User_MemberMobile();
        $uInfo = $userModel->getUserInfoByUsername($username);
        $uid = (int)$uInfo['uid'];

        /*启动授权流程，获取临时request_token*/
        $oauth = new Core_Open_Opent(Core_Config::get('appkey', 'basic', false),
                                     Core_Config::get('appsecret', 'basic', false));
        $callbackUrl = Core_Fun::getPathroot() . 'mobile/private/bind';    //设置回调地址
        '?'==Core_Fun::getPathinfoPre() && $callbackUrl .='?a=a';
        $reqTokens = $oauth->getRequestToken($callbackUrl);
        /*获取临时request_token失败，在结果页展示*/
        if(empty($reqTokens['oauth_token']) || empty($reqTokens['oauth_token_secret']))
        {
            $logContent .= "ret=".Core_Comm_Modret::RET_API_OAUTH_ERR.";errcode=1\r\n";
            $logContent .= "rq_token=".$reqTokens['oauth_token'].";rq_secret=".$reqTokens['oauth_token_secret'];
            Core_Lib_UtilMobile::logs($logContent);
            $this->showmsg("", "mobile/private/result?ret=".Core_Comm_Modret::RET_API_OAUTH_ERR."&errcode=1", 0);
        }
        /* 因为来至手机端的请求不开启session，而授权过程需要session辅助，故这里需要调session_start */
        /* session主要保存token信息和uid */
        Core_Fun::session_start();
        $_SESSION["request_token"] = $reqTokens['oauth_token'];
        $_SESSION["request_token_secret"] = $reqTokens['oauth_token_secret'];
        $_SESSION["uid"] = $uid;
        if(empty($_SESSION["request_token"]) || empty($_SESSION["request_token_secret"]) || empty($_SESSION["uid"]))
        {
            $logContent .= "ret=".Core_Comm_Modret::RET_API_OAUTH_ERR.";errcode=2\r\n";
            $logContent .= "rq_token=".$_SESSION['oauth_token'].";rq_secret=".$_SESSION['oauth_token_secret'].";uid=".$_SESSION["uid"];
            Core_Lib_UtilMobile::logs($logContent);
            $this->showmsg("", "mobile/private/result?ret=".Core_Comm_Modret::RET_API_OAUTH_ERR."&errcode=2", 0);
        }

        /* 调用授权页，让用户授权 */
        $authUrl = $oauth->getAuthorizeURL($reqTokens['oauth_token'], false);
        $mobileUrl = str_replace("mini=1", "wap=2", $authUrl);    //调用wap2.0的授权页
        Core_Comm_Util::location($mobileUrl);
    }

    /**
     * 结果展示页
     */
    public function resultAction()
    {
        $ret = (int)$this->getParam('ret');
        if($ret == Core_Comm_Modret::RET_USER_BOUND)
        {
           $user = $this->getParam('user');
           $msg = "此腾讯微博帐号已绑定其他用户。<a href=\"authorize?user=".$user."\">请使用别的帐号授权</a>";
        }else{
            $msg = Core_Comm_Modret::getMsg($ret)."。请点击返回。";
        }
        $this->assign("ret", $ret);
        $this->assign("msg", $msg);
        $this->display('mobile/result.tpl');
    }

    /**
     * 授权回调接口
     * 获取access_token, 并将腾讯微博帐号和本地帐号绑定
     */
    public function bindAction()
    {
        if($this->getParam("oauth_token") && $this->getParam("oauth_verifier") && $this->getParam("oauth_token") == $_SESSION["request_token"])
        {
            /* 请求access_token */
            $oauth = new Core_Open_Opent(Core_Config::get('appkey', 'basic', false), Core_Config::get('appsecret', 'basic', false), 
                                         $_SESSION["request_token"], $_SESSION["request_token_secret"]);
            $oauthKeys = $oauth->getAccessToken($this->getParam("oauth_verifier"));
            $oauthToken = $oauthKeys["oauth_token"];
            $oauthTokenSecret = $oauthKeys["oauth_token_secret"];
            $name = $oauthKeys["name"];

            /* 判断库是否已有相同的access_token信息的用户 */
            $userModel = new Model_User_MemberMobile();
            $user = $userModel->getUserInfoByAccessToken($oauthToken, $oauthTokenSecret);
            $uid = $_SESSION['uid'];
            /* 用户已绑定 */
            if($user)
            {
                $logContent .= "ret=".Core_Comm_Modret::RET_USER_BOUND."\r\n";
                $logContent .= "local_name=".$user['username'].";open_name=".$name;
                Core_Lib_UtilMobile::logs($logContent);
                $user = $userModel->getUserInfoByUid($uid);
                $this->showmsg("", "mobile/private/result?ret=".Core_Comm_Modret::RET_USER_BOUND."&user=".$user['username'], 0);
                exit;
            }

            if($uid)
            {
                $userModel->onBindAccessToken($uid, $oauthToken, $oauthTokenSecret, $name);    //绑定帐号 
                $userModel->onSetCurrentAccessToken($oauthToken, $oauthTokenSecret, $name);    //设置ac_token信息，拉平台数据
                $name && Model_User_Local::delCache ($name);    //绑定后清除本地缓存

                $user = $userModel->getUserInfoByUid($uid);    //从数据库取得用户信息
                /* 如果本地用户昵称为空则将平台用户信息赋给本地 */
                if(empty($user['nickname']))
                {
                    /* 遇到执行错误或API调用错误，不能直接反馈错误信息给前端，需要屏蔽错误输出 */
                    Core_Lib_UtilMobile::turnOnSkipOuputFlag();
                    $client = new Core_Open_ClientMobile();
                    $uInfo = $client->getUserInfo();
                    Core_Lib_UtilMobile::turnOffSkipOuputFlag();
                    if(!empty($uInfo))
                    {
                        $userInfo['uid'] = $user['uid'];
                        $userInfo['nickname'] = $uInfo['data']['nick'];
                        $userInfo['gender'] = $uInfo['data']['sex'];
                        $userInfo['birthyear'] = $uInfo['data']['birth_year'];
                        $userInfo['birthmonth'] = $uInfo['data']['birth_month'];
                        $userInfo['birthday'] = $uInfo['data']['birth_day'];
                        $userInfo['nation'] = $uInfo['data']['country_code'];
                        $userInfo['province'] = $uInfo['data']['province_code'];
                        $userInfo['city'] = $uInfo['data']['city_code'];
                        $userInfo['summary'] = $uInfo['data']['introduction'];
                        $userInfo['fansnum'] = Model_User_FriendLocal::getFollowerCountByName($name, true);
                        $userInfo['idolnum'] = Model_User_FriendLocal::getFolloweeCountByName($name, true);
                        $userInfo['nickname'] = empty($userInfo['nickname']) ? $user['username'] : $userInfo['nickname'];
                        $userModel->editUserInfo($userInfo);
                    }else{
                        Core_Lib_UtilMobile::logs("uid=".$uid.":get userinfo fail");
                    }
                }
                $this->showmsg("", "mobile/private/result?ret=0", 0);
            }else{
                Core_Lib_UtilMobile::logs("ret=".Core_Comm_Modret::RET_API_OAUTH_ERR.";errcode=4");
                $this->showmsg("", "mobile/private/result?ret=".Core_Comm_Modret::RET_API_OAUTH_ERR."&errcode=4", 0);
            }
        }else {
            Core_Lib_UtilMobile::logs("ret=".Core_Comm_Modret::RET_API_OAUTH_ERR.";errcode=3");
            $this->showmsg("", "mobile/private/result?ret=".Core_Comm_Modret::RET_API_OAUTH_ERR."&errcode=3", 0);
        }
    }
}
?>
