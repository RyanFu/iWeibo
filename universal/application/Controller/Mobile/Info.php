<?php
/**
 * 数据更新数目控制器
 * @author lololi
 *
 */
class Controller_Mobile_Info extends Core_Controller_MobileAction
{
    /**
     * 数据更新数目接口
     */
    public function updateAction()
    {
        $op   = Core_Comm_Validator::getNumArg($this->getParam('op'), 0, 1, 0);
        $type = Core_Comm_Validator::getNumArg($this->getParam('type'), 0, 9, 0);
        $client = new Core_Open_ClientMobile();
        $res = $client->getUpdate(array('op'=>$op, 'type'=>$type));
        /*如果是有本地化关系 好友数覆盖本地数字*/
        if (!Model_Friend::getFriendSrc ()) {
            $userObj = new Model_User_MemberMobile();
            $user = $userObj->getUserInfoByName ($_SESSION['name']);
            $res["data"]["fans"] = intval ($user['newfollowers']);
            $res["data"]["home"] = 0; //api不支持，先清0
        }
        echo json_encode($res);
        exit;
    }
}