<?php
/**
 * 关系链相关接口控制器
 * @author lololi
 *
 */
class Controller_Mobile_Friends extends Core_Controller_MobileAction
{
    const TYPE_FANS = 0;
    const TYPE_IDOLS = 1;
    
    const TYPE_DEL = 0;
    const TYPE_ADD = 1;
    
    /**
     * 获取听众列表接口
     */
    public function fanslistAction()
    {
        $res = $this->getFriends(self::TYPE_FANS);
        echo json_encode($res);
        exit;
    }
    
    /**
     * 获取收听列表接口
     */
    public function idollistAction()
    {
        $res = $this->getFriends(self::TYPE_IDOLS);
        echo json_encode($res);
        exit;
    }
    
    /**
     * 获取其他用户听众列表接口
     */
    public function user_fanslistAction()
    {
        $name = $this->getParam('name');
        $res = $this->getFriends(self::TYPE_FANS, $name);
        echo json_encode($res);
        exit;
    }
    
    /**
     * 获取其他用户收听列表接口
     */
    public function user_idollistAction()
    {
        $name = $this->getParam('name');
        $res = $this->getFriends(self::TYPE_IDOLS, $name);
        echo json_encode($res);
        exit;
    }
    
    /**
     * 收听 接口
     */
    public function addAction()
    {
        $this->setIdol(self::TYPE_ADD);
    }
    
    /**
     * 取消收听  接口
     */
    public function delAction()
    {
        $this->setIdol(self::TYPE_DEL);
    }
    
    /**
     * 检测收听关系  接口
     */
    public function checkAction()
    {
        $this->checkFriend();
    }
    
    /**
     * 检测收听关系 
     */
    protected function checkFriend()
    {
        $names = $this->getParam('names');
        $flag = Core_Comm_Validator::getNumArg($this->getParam('flag'), 0, 2, 2);
        if(Model_Friend::getFriendSrc())
        {
            $p = array(
            'n' => $names,
            'type' => $flag
            );
            $client = new Core_Open_ClientMobile();
            $res = $client->checkFriend($p);
            echo json_encode($res);
            exit;
        }else{
            $data = Model_User_FriendLocal::checkFriend($names, $flag);
            if(empty($data))
            {
                Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_MOBILE_CHECKFRIENDERROR);
            }else{
                $res['ret'] = 0;
                $res['msg'] = 'ok';
                $res['errcode'] = 0;
                $res['data'] = $data;
                echo json_encode($res);
                exit;
            }

        }
    }
    
    /**
     * 收听或取消收听
     * @param  $type
     */
    protected function setIdol($type)
    {
        /* 统计代码 */
        try
        {
            Model_Stat::addStat('addfans');
        }
        catch (Exception $e)
        {}
        
        $name = $this->getParam('name');
        $client = new Core_Open_ClientMobile();
        $p = array(
            'n' => $name,
            'type' => $type
        );
        
        /*同步收听/取消收听 到open平台*/
        $res = $client->setMyidol($p);
        if($res['ret'] != 0)
        {
            echo json_encode($res);
            exit;
        }
        /*同步收听/取消收听 到本地*/
        $uname = $_SESSION['name'];
        $r = Model_User_FriendLocal::followLocalFriend($uname, $name, $type);
        if (Model_Friend::getFriendSrc())
        {
            /*open关系链，直接返回平台数据*/
            echo json_encode($res);
            exit;
        }else{ 
            if($r)
            {
                /*本地关系链，删除我和被收听者的本地缓存*/
                $users = array($uname, $name);
                Model_User_Local::delCache($users);
                Core_Lib_UtilMobile::outputReturnData(0, 0, 'ok');
            }else{
                /*本地失败，open平台回滚*/
                $p['type'] ^= 1;
                $client->setMyidol($p);
                Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_MOBILE_DELFRIENDERROR-$type);
            }
        }
    }
    
    /**
     * 获取收听或者听众列表
     * @param $type 
     */
    protected function getFriends($type, $name='')
    {
        $reqnum     = Core_Comm_Validator::getNumArg($this->getParam('reqnum'), 1, 30, 30);
        $startIndex = Core_Comm_Validator::getNumArg($this->getParam('startindex'), 0, PHP_INT_MAX, 0);
        $p = array(
            'type' => $type,
            'n' => $name,
            'num' => $reqnum,
            'start' => $startIndex
        );
        
        $friednSrc = Model_Friend::getFriendSrc();
        if ($friednSrc == Model_Friend::FRIEND_LOCAL)
        {
            return $this->getFriendsLocal($p);
        }
        else
        {
            return $this->getFriendsOpen($p);
        }
    }
    
    /**
     * 从本地关系链获取用户列表
     * @param $p
     */
    protected function getFriendsLocal($p)
    {
        $res = Model_User_FriendLocal::getMyfriend($p);
        /*保持与open平台返回数据结构相同*/
        $authType = Core_Lib_UtilMobile::getAuthType();
        $infoList = &$res['data']['info'];
        foreach($infoList as $k => $v)
        {
            /* 暂时不提供tweet字段 */
            $infoList[$k]['tweet'] = '';
            /* 结合平台认证信息开关 ，设定isvip字段*/
            if(!$authType['openAuth'] || empty($infoList[$k]['isvip']))
            {
                $infoList[$k]['isvip'] = 0;
            }
            $infoList[$k]['is_auth'] = Core_Lib_UtilMobile::getIsAuth($authType, $v['localauth'], $v['isvip']);
        }
        if(empty($infoList))
        {
            $infoList = null;
        }else{
            $infoList = array_values($infoList);
        }
        unset($res['uname']);
        $res['errcode'] = 0;
        return $res;
    } 
    
    /**
     * 从平台关系链获取用户列表
     * @param $p
     */
    protected function getFriendsOpen($p)
    {
         $client = new Core_Open_ClientMobile();
         $userInfo = $client->getMyfans($p);
         if (!empty($userInfo['data']['info']) && is_array($userInfo['data']['info']))
         {
             $authType = Core_Lib_UtilMobile::getAuthType();    //获取认证类型
             $unsetFlag = false;
             foreach($userInfo['data']['info'] AS $k=>$v)
             {
                 $t=&$userInfo['data']['info'][$k];
                 //过滤掉屏蔽掉的用户
                 if(empty($t['name']) && empty($t['nick']))
                 {
                     unset($userInfo['data']['info'][$k]);
                     $unsetFlag = true;
                     continue;
                 }
                 $uInfo = Model_User_Util::getLocalInfo($t['name']);
                 !empty($uInfo['nick']) && $t['nick'] = $uInfo['nick'];//有本地昵称就覆盖
                 /* 结合平台认证信息开关 ，设定isvip字段*/
                 if(!$authType['openAuth'] || empty($t['isvip']))
                 {
                     $t['isvip'] = 0;
                 }
                 $t['is_auth'] = Core_Lib_UtilMobile::getIsAuth($authType, $uInfo['localauth'], $t['isvip']);
             }
             
             /* 如果有用户被屏蔽， 则需要调整数组索引 ，如:
             * array(0=>'a', 2=>'b', 3=>'c') 调整成
             * array(0=>'a', 1=>'b', 2=>'c')
             * 目的是json_encode的数据不带数组索引
             * */
             if($unsetFlag)
             {
                 $userInfo['data']['info'] = array_values($userInfo['data']['info']);
             }
        }
        /* 当没有数据时，增加'data-hasnext'字段(前端需求) */
        if(empty($userInfo['data']['info']) && !isset($userInfo['data']['hasnext']))
        {
            $userInfo['data']['info'] = null;
            $userInfo['data']['hasnext'] = 1;
        }
        return $userInfo;
    }
}

?>