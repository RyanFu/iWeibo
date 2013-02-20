<?php
/**
 *
 * 手机客户端后台模块工具函数库
 *
 * @author lololi
 */
class Core_Lib_UtilMobile{
    
    const BOSS_LOG_ID = 1160;
    const BIZ_NAME = 'weibo.open.iWeiboMobile';

    /**
    * 这个开关用于屏蔽Core_Lib_UtilMobile::outputReturnData输出信息和结束执行的操作
    * 默认情况下，$skipOutput=0，遇到执行错误，在输出相关信息后，结束执行，把结果反馈给前端
    * 但比如某些情况下遇到执行错误并不希望把输出的错误信息反馈给前端或者有容错处理
    * 可打开此开关即设$skipOutput=1。
    */ 
    private static $skipOutput = 0;

    public static function turnOnSkipOuputFlag()
    {
        self::$skipOutput = 1;
    }

    public static function turnOffSkipOuputFlag()
    {
        self::$skipOutput = 0;
    }
    
    /**
     * 格式化后台吐出的数据（json格式)
     * @param $ret      返回码
     * @param $errcode  二级错误码
     * @param $msg      返回信息
     * @param $data     数据
     */
    public static function outputReturnData($ret, $errcode = 0, $msg = null, $data = null)
    {
        $return = array();
        $return['ret'] = $ret;
        $return['errcode'] = $errcode;
        $msg = empty($msg)?Core_Comm_Modret::getMsg($ret):$msg;
        $msg = urlencode($msg);
        $return['msg'] = $msg;
        $return['data'] = $data;
        /* 是否吐出数据 */
        if(!self::$skipOutput)
        {
            echo json_encode($return);
            exit;
        }
        return;
    }
    
    /**
     * 记录本地log
     * @param $content    log内容
     * @param $logParams  是否log请求参数
     * @param $filename   log文件名
     * @param $header     每条记录的meta信息，如接口名，时间等
     */
    public static function logs($content, $logParams=false, $filename='mobile-error-log_', $header='')
    {
        if(empty($header))
        {
            $controller = Core_Controller_Front::getInstance()->getControllerName();
            $action = Core_Controller_Front::getInstance()->getActionName();
            $header .= $controller."/".$action;
            $header .= "   ".date('H:i:s')."\r\n";
        }
        if($logParams)
        {
            $header .= "request params:\r\n";
            $params = Core_Controller_Front::getInstance()->getParams();
            /* 删除无记录意义的 参数 */
            unset($params['__Model']);
            unset($params['__Controller']);
            unset($params['__Action']);
            unset($params['request_api']);
            /* 不记录oauth标准参数 */
            foreach($params as $k=>$v)
            {
                if(strpos($k, 'oauth') !== false)
                {
                    unset($params[$k]);
                }
            }
            $header .= print_r($params, true);
        }
        Core_Util_Log::file($filename, $header.$content."\r\n");
    }
    
    /**
     * 判断请求是否来至手机客户端
     * 手机客户端的请求均带有request_api参数，可以用于区分
     */
    public static function isFromClient()
    {
        $agent = strtolower($_SERVER['HTTP_USER_AGENT']);
        $flagGet = $_GET['request_api'];
        $flagPost = $_POST['request_api'];
        $flagAgent = strpos($agent, 'iphone');    //包括iPad, iTouch, iPhone等
        if((!empty($flagGet) || !empty($flagPost)) && $flagAgent!==false)
        {
            return true;
        }
        return false;
    }
    
    /**
     * 验证签名正确性
     * @param $signature 待验证签名值（手机客户端生成）
     * @param $url
     * @param $method
     * @param $params
     * @param $consumer_key
     * @param $consumer_secret
     * @param $oauth_token
     * @param $oauth_token_secret
     */
    public static function checkSignature($signature, $url, $method, $params, $consumer_key,$consumer_secret
                                          , $oauth_token = NULL, $oauth_token_secret = NULL)
    {
        $consumer = new Core_Open_Oauth($consumer_key, $consumer_secret);
        if(!empty($oauth_token) && !empty($oauth_token_secret))
        {
            $token = new Core_Open_Oauth($oauth_token, $oauth_token_secret);
        }
        else
        {
            $token = NULL;
        }
        $request = new Core_Open_OAuthRequest($method, $url, $params);
        $judge = new Core_Open_OAuthSignatureMethodHmacSha1();
        return $judge->check_signature($request, $consumer, $token, $signature);
    }
    
    /**
     * 去除认证信息中的html标签（包含链接名等）
     * @param $input
     */
    public static function formatVerifyInfo($input)
    {
        $pattern = '/(>)[^(<\/)]*(<\/[a-z]+>)/i';
        $input = preg_replace($pattern, "\\1\\2", $input);
        $input =  strip_tags($input);
        return $input;
    }
    
    /**
     * 提取城市名（即去掉省份;前端需求）
     * @param $input
     */
    public static function formatLocationInfo($input)
    {
        $parts = explode(' ', $input, 2);
        $c = count($parts);
        return $parts[($c-1)];
    }

    /**
     * 获取认证类型
     * @return array localAuth:本地认证开关；openAuth:平台认证开关
     */
    public static function getAuthType()
    {
        $localAuth = Core_Config::get('localauth', 'certification.info');   //本地认证信息开关
        $openAuth  = Core_Config::get('platformauth', 'certification.info');//平台认证信息开关
        $authType = array(
            'localAuth' => $localAuth,
            'openAuth'  => $openAuth
        );
        return $authType;
    }
    
    /**
     * 获取认证字段：is_auth
     * @param array $authType 认证类型开关
     * @param int $isLocalAuth
     * @param int $isOpenAuth
     */
    public static function getIsAuth($authType, $isLocalAuth, $isOpenAuth)
    {
        if(($authType['localAuth']&&!empty($isLocalAuth)) || ($authType['openAuth']&&!empty($isOpenAuth)))
        {
            return 1;
        }
        return 0;
    }
    
    /**
     * 数据上报函数
     * @param $action   要记录的操作（行为），如'login'等
     * @param $ret      操作返回码
     * @param $msg      返回的信息
     * @param $errCode  二级错误码
     * @param $costTime 耗时
     */
    public static function bossLog($action, $ret=0, $msg='ok', $errCode=0, $costTime=0)
    {
        $ip     =   Core_Comm_Util::getClientIp();
        $qq     =   12345;
        $biz    =   self::BIZ_NAME;
        $op     =   $action;
        $status =   $ret;
        $logid  =   self::BOSS_LOG_ID;
        $flowid =   $errCode;
        $apiName = '';
        $appKey =   Core_Config::get('appkey', 'basic');
        $serverIp =  $_SERVER['SERVER_ADDR'];
        $value1=0;
        $value2=0;
        $value3='';
        $value4='';
        
        $ret = Core_Util_Log::httpBossLog("%s,%u,%s,%s,%d,%u,%u,%s,%d,%s,%d,%d,%s,%s,%d,%d,%s,%s",
                                          $ip,$qq,$biz,$op,$status,$logid,$flowid, $apiName, $ret,
                                          $msg,$errCode,$costTime,$appKey,$serverIp,$value1,$value2,
                                          $value3,$value4);
        return ;
    }
    
    /**
     * 获取身份认证字段
     * @param $name 用户名 ：空表示本人
     */
    public static function getIsRealName($name='')
    {
        $p = array('n' => $name);
        $client = new Core_Open_ClientMobile();
        $res = $client->getUserInfo($p);
        return $res['data']['isrealname'];
    }
    
    /**
     * 过滤锁定话题
     * @param array $topicList 话题列表数组
     */
    public static function filterTopics(&$topicList)
    {
        if(!empty($topicList))
        {
            $unsetFlag = false;
            foreach($topicList as $k => $v)
            {
                if(isset($v['text']) && Model_Topic::isMasked($v['text']))
                {
                    unset($topicList[$k]);
                    $unsetFlag = true;
                }
            }
            
            /* 如果有话题被锁定， 则需要调整数组索引 ，如:
             * array(0=>'a', 2=>'b', 3=>'c') 调整成
             * array(0=>'a', 1=>'b', 2=>'c')
             * 目的是json_encode的数据不带数组索引
             * */
            if($unsetFlag)
            {
                $topicList = array_values($topicList);
            }
        }
        return $topicList;
    }
    
    /**
     * 构造帐号与本地昵称映射对
     * @param  $userMap 帐号与昵称映射对
     */
    public static function formatUserMap(&$userMap)
    {
        foreach($userMap as $k => $v)
        {
            $user = Model_User_Util::getLocalInfo($k);
            /*有本地昵称则覆盖*/
            if(!empty($user['nick']))
            {
                $userMap[$k] = $user['nick'];
            }
        }
    }

    /**
     * 
     * 下放登录态
     * @param $user    用户名
     * @param $curTime    时间戳
     * @param $accessToken    用户对应的access_token
     * @param $accessTokenSecret    用户对应的access_token_secret
     */
    public static function issueLoginCookie($user, $curTime=0, $accessToken='', $accessTokenSecret='')
    {
        if(empty($curTime))
        {
            $curTime = time();
        }

        if(empty($accessToken) || empty($accessTokenSecret))
        {
            $userModel = new Model_User_MemberMobile();
            $uInfo = $userModel->getUserInfoByUsername($user);
            $accessToken = $uInfo['oauthtoken'];
            $accessTokenSecret = $uInfo['oauthtokensecret'];
        }

        $expireTime = $curTime + Core_Comm_Mobile::LOGIN_EXPIRE_TIME;
        $sKey = Core_Lib_UtilMobile::genLoginCookie($accessToken, $accessTokenSecret, $curTime);
        setcookie('user', $user, $expireTime, '/');
        setcookie('skey', $sKey, $expireTime, '/');
        setcookie('set_time', $curTime, $expireTime, '/');
    }

    /**
     * 
     * token信息和时间戳混合加密成skey值
     * @param $accessToken
     * @param $accessTokenSecret
     * @param $time
     */
    public static function genLoginCookie($accessToken, $accessTokenSecret, $time)
    {
        return md5(md5($accessToken.$time).$accessTokenSecret.$time);
    }

    /**
     * 
     * 验证登录态有效性
     * @param $username
     * @param $setTime
     * @param $skeyToCheck
     */
    public static function verifyLogin($username, $setTime, $skeyToCheck)
    {
        /* 登录态是否超时失效 */
        if(time()-$setTime>Core_Comm_Mobile::LOGIN_EXPIRE_TIME)
        {
            return false;
        }
        $userModel = new Model_User_MemberMobile();
        $uInfo = $userModel->getUserInfoByUsername($username);
        $accessToken = $uInfo['oauthtoken'];
        $accessTokenSecret = $uInfo['oauthtokensecret'];
        $skey = Core_Lib_UtilMobile::genLoginCookie($accessToken, $accessTokenSecret, $setTime);
        if($skey == $skeyToCheck)
        {
            /* 若登录态有效，则设置当前登录信息 */
            $userModel->onSetCurrentAccessToken($accessToken);
            return true;
        }else{
            return false;
        }
        return false;
    }

    /**
     * 批量格式化微博广播
     * @param $tArr
     * @
     */
    public static function formatTArr (&$tArr, $filterDeleted = false)
    {
        //用户屏蔽名单
        $userMemObj = new Model_User_MemberMobile();
        $userBlacklist = $userMemObj->onGetBlacklist ();
        $authType = Core_Lib_UtilMobile::getAuthType();    //获取认证类型
        
        $unsetFlag = false;  //是否有微博被屏蔽
        //遍历
        foreach ($tArr as $k => &$t)
        {
            //屏蔽用户
            if ($userBlacklist && in_array ($t['name'], $userBlacklist)) {
                unset ($tArr[$k]);
                $unsetFlag = true;
                continue;
            }

            //过滤已删除的广播，如搜索页
            if ($filterDeleted && self::isDeletedTweet ($t)) {
                unset ($tArr[$k]);
                $unsetFlag = true;
                continue;
            }
            !empty ($tArr['box']) && $t['box'] = true; //检验是否是私信，不过滤
            $t = self::formatT ($t, $authType);

            //删除不展现的微博，减少数据传送
            if(!empty($t['visiblecode']))
            {
                unset($tArr[$k]);
                $unsetFlag = true;
            }
        }
        
        /* 如果有微博被屏蔽， 则需要调整数组索引 ，如:
         * array(0=>'a', 2=>'b', 3=>'c') 调整成
         * array(0=>'a', 1=>'b', 2=>'c')
         * 目的是json_encode的数据不带数组索引
         * */
        if($unsetFlag)
        {
            $tArr = array_values($tArr);
        }
        
        return;
    }
    
    /**
     * 格式化单条微博广播(from api)
     * @param $t
     * @
     */
    public static function formatT($t, $authType) 
    {
        //本地过滤，确定是否能显示(私信不过滤)
        if (empty ( $t['box'] )) {
            $t['visiblecode'] = 0;
            if (!Model_User_MemberMobile::isTrustUser ( $t['name'] )) {
                if (! Core_Lib_Base::isVisibleT ( $t["id"] )) {
                    $t['visiblecode'] = 1;
                    return $t;
                } elseif (Model_Filter::checkContent ( $t["text"] ) > 1) {
                    $t ['visiblecode'] = 1;
                    return $t;
                } elseif (isset ( $t["source"]["text"] ) && Model_Filter::checkContent ( $t["source"]["text"] ) > 1) {
                    $t['visiblecode'] = 1;
                    return $t;
                }
            }
        }   
        //转播内容处理
        if (! empty ( $t["source"] )) {
            if (self::isDeletedTweet ( $t["source"] )) { //转播的消息已在微博平台上被删除
                $t["source"]["text"] = "此消息已被删除";
                $t["source"]["origtext"] = "此消息已被删除";
                $t["source"]["video"] = null;
                $t["source"]["music"] = null;
                $t["source"]["image"] = null;
            }else{
                /*emoji表情处理*/
                $t["source"]["origtext"] = Core_Comm_Emoji::formatEmoji($t["source"]["origtext"]);
                $t["source"]["text"] = Core_Comm_Emoji::formatEmoji($t["source"]["text"]);
            }
        }
        //原创内容处理
        if (self::isDeletedTweet ( $t )) {
            $t["text"] = "此消息已被删除";
            $t["origtext"] = "此消息已被删除";
            $t["video"] = null;
            $t["music"] = null;
            $t["image"] = null;
        }else{
            /*emoji表情处理*/
            $t["origtext"] = Core_Comm_Emoji::formatEmoji($t["origtext"]);
            $t["text"] = Core_Comm_Emoji::formatEmoji($t["text"]);
        }
        if (empty($t['box'])) //私信已经处理过用户了
        {
            //本地化
            $user = Model_User_Util::getLocalInfo ( $t["name"] );
            ! empty ( $user['nick'] ) && $t["nick"] = $user['nick'];
            $t["localauth"] = empty ( $user['localauth'] ) ? 0 : 1;
            
            /* 结合平台认证信息开关 ，设定isvip字段*/
            if(!$authType['openAuth'] || empty($t['isvip']))
            {
                $t['isvip'] = 0;
            }
            $t['is_auth'] = Core_Lib_UtilMobile::getIsAuth($authType, $t['localauth'], $t['isvip']);
            if (isset ( $t["source"] ) && $t['source']) {
                $sourceuser = Model_User_Util::getLocalInfo ( $t['source']["name"] );
                ! empty ( $sourceuser['nick'] ) && $t['source']["nick"] = $sourceuser['nick'];
                $t['source']["localauth"] = empty ( $sourceuser['localauth'] ) ? 0 : 1;
                /* 结合平台认证信息开关 ，设定isvip字段*/
                if(!$authType['openAuth'] || empty($t['source']['isvip']))
                {
                    $t['source']['isvip'] = 0;
                }
                $t['source']['is_auth'] = Core_Lib_UtilMobile::getIsAuth($authType, $t['source']['localauth'], $t['source']['isvip']);
            }
        }        
        return $t;
    }
    
    /**
     * 是否是已删除的广播
     * @param $taArr
     * @
     */
    protected static function isDeletedTweet ($tArr)
    {
        $deletedFlag = !empty ($tArr["status"]) && ($tArr["status"] != 0 && $tArr["status"] != 2);
        $trimText = trim ($tArr["text"]);
        $hasSource = array_key_exists ("source", $tArr);
        $emptyContent = empty ($trimText) && !$hasSource; //转播内容允许为空
        return $deletedFlag || $emptyContent;
    }
    
    
}
?>