<?php
/**
 * 数据收藏控制器
 * @author lololi
 *
 */
class Controller_Mobile_Fav extends Core_Controller_MobileAction
{
    const TYPE_T     = 0;    //收藏微博列表，暂不提供
    const TYPE_TOPIC = 1;    //收藏话题列表

    /**
     * 获取已订阅话题列表 接口
     */
    public function list_htAction()
    {
        $res = $this->getFav(self::TYPE_TOPIC);
        $topicList = &$res['data']['info'];
        /* 过滤本地锁定的话题  */
        Core_Lib_UtilMobile::filterTopics($topicList);
        echo json_encode($res);
        exit;
    }

    /**
     * 订阅话题 接口
     */
    public function addhtAction()
    {
        $p = array(
            'id' => $this->getParam('id')
        );
        $client = new Core_Open_ClientMobile();
        $res = $client->subscribeTopic($p);
        echo json_encode($res);
        exit;
    }

    /**
     * 取消订阅话题 接口
     */
    public function delhtAction()
    {
        $p = array(
            'id' => $this->getParam('id')
        );
        $client = new Core_Open_ClientMobile();
        $res = $client->unsubscribeTopic($p);
        echo json_encode($res);
        exit;
    }

    /**
     * 获取收藏列表
     * @param int $type 0:微博列表；1：话题列表
     */
    public function getFav($type)
    {
        $reqnum   = Core_Comm_Validator::getNumArg($this->getParam('reqnum'), 1, 15, 15);
        $pageflag = Core_Comm_Validator::getNumArg($this->getParam('pageflag'), 0, 2, 0);
        $pagetime = Core_Comm_Validator::getNumArg($this->getParam('pagetime'), 0, PHP_INT_MAX, 0);
        $lastid   = (int)$this->getParam('lastid');
        $p = array(
            'type' => $type,
            'n'    => $reqnum,
            'f'    => $pageflag,
            't'    => $pagetime,
            'l'    => $lastid
        );
        $client = new Core_Open_ClientMobile();
        $res = $client->getFav($p);
        return $res;
    }
}