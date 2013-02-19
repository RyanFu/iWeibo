
<?php
/**
 * 搜索相关接口控制器
 * @author lololi
 *
 */
class Controller_Mobile_Search extends Core_Controller_MobileAction
{
    const TYPE_USER  = 0;    //用户搜索
    const TYPE_T     = 1;    //广播搜索
    const TYPE_TOPIC = 2;    //话题搜索

    /**
     * 搜索用户 接口
     */
    public function userAction()
    {
        $authType = Core_Lib_UtilMobile::getAuthType();    //获取认证类型

        $res = $this->getSearch(self::TYPE_USER);
        $userList = &$res['data']['info'];
        if(!empty($userList))
        {
            foreach($userList as $k => $v)
            {
                $uInfo = Model_User_Util::getLocalInfo($v['name']);
                !empty($uInfo['nick']) && $userList[$k]['nick'] = $uInfo['nick'];//有本地昵称就覆盖
                /* 结合平台认证信息开关 ，设定isvip字段*/
                if(!$authType['openAuth'] || empty($v['isvip']))
                {
                    $userList[$k]['isvip'] = 0;
                }
                $userList[$k]['is_auth'] = Core_Lib_UtilMobile::getIsAuth($authType, $uInfo['localauth'], $v['isvip']);
            }
        }else{
            /*空数据时，添加hasnext字段；前端需求*/
            if(!isset($res['data']['hasnext']))
            {
                $res['data']['hasnext'] = 1;
            }
        }
        echo json_encode($res);
        exit;
    }

    /**
     * 搜索广播接口
     */
    public function tAction()
    {
        $res = $this->getSearch(self::TYPE_T);
        $msglist = &$res['data']['info'];
        if(empty($msglist))
        {
            /*空数据时，添加hasnext字段；前端需求*/
            if(!isset($res['data']['hasnext']))
            {
                $res['data']['hasnext'] = 1;
            }
        }else{
            Core_Lib_UtilMobile::formatTArr($msglist);
        }
        echo json_encode($res);
        exit;
    }

    /**
     * 搜索话题 接口
     */
    public function htAction()
    {
        $res = $this->getSearch(self::TYPE_TOPIC);
        $topicList = &$res['data']['info'];
        if(!empty($topicList))
        {
            /* 过滤本地锁定的话题  */
            Core_Lib_UtilMobile::filterTopics($topicList);
        }else{
            /*空数据时，添加hasnext字段；前端需求*/
            if(!isset($res['data']['hasnext']))
            {
                $res['data']['hasnext'] = 1;
            }
        }
        echo json_encode($res);
        exit;
    }

    /**
     * 获取搜索结果
     * @param int $type 搜索类型（用户;广播;话题）
     */
    public function getSearch($type)
    {
        $keyword = $this->getParam('keyword');
        $page     = Core_Comm_Validator::getNumArg($this->getParam('page'), 1, PHP_INT_MAX, 1);
        $pagesize = Core_Comm_Validator::getNumArg($this->getParam('pagesize'), 1, 30, 20);
        $p = array(
            'type' => $type,
            'p'    => $page,
            'n'    => $pagesize,
            'k'    => $keyword
        );
        $client = new Core_Open_ClientMobile();
        $res = $client->getSearch($p);
        return $res;
    }
}