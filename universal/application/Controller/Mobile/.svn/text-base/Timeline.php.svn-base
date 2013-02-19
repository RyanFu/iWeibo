<?php
/**
 * 时间线控制器
 * @author lololi
 *
 */
class Controller_Mobile_Timeline extends Core_Controller_MobileAction {
    
    const TYPE_INDEX  = 0;  //我的主页
    const TYPE_MINE   = 1;  //我的广播
    const TYPE_AT     = 2;  //提到我的
    const TYPE_FAVOR  = 3;  //我的收藏, 暂不提供接口
    const TYPE_GUEST  = 4;  //其他用户时间线
    const TYPE_PUBLIC = 5;  //广播大厅, 暂不提供接口
    const TYPE_CITY   = 6;  //同城广播, 暂不提供接口
    const TYPE_TOPIC  = 7;  //话题

    
    /**
     * 从平台或者本地关系链拉取主页时间线
     * @param $p
     * @param $client
     * @param $name
     */
    protected function getIndexTimeline($p, $client, $name = '')
    {
        $friednSrc = Model_Friend::getFriendSrc();
        if ($friednSrc == Model_Friend::FRIEND_LOCAL)
        {
            if (strlen ($name) > 0) {
                $uname = $name;
            } else {
                $userObj = new Model_User_Member();
                $u = $userObj->onGetCurrentAccessToken ();
                $uname = $u['name'];
            }
            $namelist = Model_User_FriendLocal::getFolloweeNames ($uname);
            if (count ($namelist) > 0) {
                $p['names'] = implode (',', $namelist) . ',' . $uname;
                return $client->getUsersTimeline ($p);
            } else {
                $p['names'] = $uname;
            }
            return $client->getUsersTimeline($p);
        }
        else
        {
            return $client->getTimeline($p);
        }
    }
    
    /**
     * 获取话题时间线
     * @param $p
     * @param $client
     */
    protected function getTopicTimeline($p, $client)
    {
        $p['t'] = $this->getParam('httext');
        $p['p'] = $this->getParam('pageinfo');
        
        if(Model_Topic::isMasked($p['t']))
        {
            Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_ARG_ERR, 0, '此话题被屏蔽');
        }
        return $client->getTopic($p);
    }
    
    protected function getMsg($timelineType, $name = '') {
        $pageflag    = Core_Comm_Validator::getNumArg($this->getParam('pageflag'), 0, 4, 0);
        $reqnum      = Core_Comm_Validator::getNumArg($this->getParam('reqnum'), 1, 100, 30);
        $pagetime    = Core_Comm_Validator::getNumArg($this->getParam('pagetime'), 0, PHP_INT_MAX, 0);
        $type        = Core_Comm_Validator::getNumArg($this->getParam('type'), 0, 123, 0);
        $contenttype = Core_Comm_Validator::getNumArg($this->getParam('contenttype'), 0, 31, 0);
        $lastid = $this->getParam('lastid');

        $client = new Core_Open_ClientMobile();
        switch ($timelineType) {
            case self::TYPE_MINE:
                //type:0 提及我的, other 我广播的
                $p = array ('type' => 1, 'f' => $pageflag, 'n' => $reqnum, 't' => $pagetime, 'l' => $lastid, 'utype' => $type, 'ctype' => $contenttype);
                $openmsg = $client->getMyTweet($p);
                break;
            case self::TYPE_AT:
                //type:0 提及我的, other 我广播的
                $p = array ('type' => 0, 'f' => $pageflag, 'n' => $reqnum, 't' => $pagetime, 'l' => $lastid, 'utype' => $type, 'ctype' => $contenttype);
                $openmsg = $client->getMyTweet($p);
                Core_Lib_Base::clearNewMsgInfo(6);
                break;
            case self::TYPE_FAVOR:
                $p = array ('type' => 0, 'f' => $pageflag, 'n' => $reqnum, 't' => $pagetime, 'l' => 0);
                $openmsg = $client->getFav($p);
                //添加收藏标志
                if (is_array ( $openmsg ['data'] ['info'] )) {
                    foreach ( $openmsg ['data'] ['info'] as &$t ) {
                        $t ['isfav'] = true;
                    }
                }
                break;
            case self::TYPE_GUEST:
                $p = array ('name' => $name, 'f' => $pageflag, 'n' => $reqnum, 't' => $pagetime, 'l' => $lastid, 'utype' => $type, 'ctype' => $contenttype);
                $openmsg = $client->getTimeline($p);
                break;
            case self::TYPE_PUBLIC:
                $pos = Core_Comm_Validator::getNumArg($this->getParam ( 'pos' ), 0, PHP_INT_MAX, 0);
                $p = array ('p' => $pos, 'f' => $pageflag, 'n' => $reqnum );
                $openmsg = $client->getPublic ( $p );
                break;
            case self::TYPE_CITY:
                $pos = Core_Comm_Validator::getNumArg($this->getParam ( 'pos' ), 0, PHP_INT_MAX, 0);
                $p = array ('p' => $pos, 'f' => $pageflag, 'n' => $reqnum, 'city' => $this->userInfo ['city_code'], 'province' => $this->userInfo ['province_code'], 'country' => $this->userInfo ['country_code'] );
                $openmsg = $client->getArea ( $p );
                break;
            case self::TYPE_INDEX:
                $p = array ('f' => $pageflag, 'n' => $reqnum, 't' => $pagetime, 'l' => $lastid, 'utype' => $type, 'ctype' => $contenttype);
                $openmsg = $this->getIndexTimeline($p, $client);
                break;
            case self::TYPE_TOPIC:
                $p = array ('f' => $pageflag, 'n' => $reqnum);
                $openmsg = $this->getTopicTimeline($p, $client);
                break;
        }
        /* 当没有广播数据时，增加'data-hasnext'字段(前端需求) */
        if(empty($openmsg['data']['info']) && !isset($openmsg['data']['hasnext']))
        {
            $openmsg['data']['hasnext'] = 1;
        }
        $msglist = &$openmsg['data']['info'];
        $msglist and Core_Lib_UtilMobile::formatTArr($msglist);
        $userMap = &$openmsg['data']['user'];
        $userMap and Core_Lib_UtilMobile::formatUserMap($userMap);
        return $openmsg;
    }
}