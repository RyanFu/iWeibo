<?php
/**
 * 时间线相关接口控制器
 * @author lololi
 *
 */
class Controller_Mobile_Statuses extends Controller_Mobile_Timeline
{ 
    /**
     * 主页时间线 接口
     */
    public function home_timelineAction()
    {
        $uname = $_SESSION['name'];
        $res = $this->getMsg(self::TYPE_INDEX, $uname);
        echo json_encode($res);
        exit();
    }
    
    /**
     * 我的广播 接口
     */
    public function broadcast_timelineAction()
    {
        $res = $this->getMsg(self::TYPE_MINE);
        echo json_encode($res);
        exit();
    }
    
    /**
     * 提及我的 接口
     */
    public function mentions_timelineAction()
    {
        $res = $this->getMsg(self::TYPE_AT);
        echo json_encode($res);
        exit();
    }
    
    /**
     * 其他用户时间线 接口
     */
    public function user_timelineAction()
    {
        $name = $this->getParam('name');
        $res = $this->getMsg(self::TYPE_GUEST, $name);
        echo json_encode($res);
        exit();
    }
    
    /**
     * 话题时间线 接口
     */
    public function ht_timelineAction()
    {
        $res = $this->getMsg(self::TYPE_TOPIC);
        echo json_encode($res);
        exit();
    }
    /*
    public function testAction()
    {
        $client = new Core_Open_ClientMobile();
        $p = array ("p" => 0, "f" => 1, "n" => 20);
        $openmsg = $client->getPublic ( $p );
        echo json_encode($openmsg);
    }*/
}
?>