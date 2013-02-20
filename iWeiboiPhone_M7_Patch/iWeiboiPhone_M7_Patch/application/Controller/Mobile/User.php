<?php
/**
 * 用户相关接口控制器
 * @author lololi
 *
 */
class Controller_Mobile_User extends Core_Controller_MobileAction
{ 
    /**
     * 获取自己的详细资料 接口
     */
    public function infoAction()
    {
        $data = Model_User_Util::getInfo();
        if(empty($data))
        {
            Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_MOBILE_USERINFOERROR);
        }
        $authType = Core_Lib_UtilMobile::getAuthType();    //获取认证类型
        /* 结合平台认证信息开关 ，设定isvip字段*/
        if(!$authType['openAuth'] || empty($data['isvip']))
        {
            $data['isvip'] = 0;
        }
        $data['is_auth'] = $data['is_auth']?1:0;
        $data['verifyinfo'] = Core_Lib_UtilMobile::formatVerifyInfo($data['verifyinfo']);    //只取认证资料，筛掉相关链接
        $data['location'] = Core_Lib_UtilMobile::formatLocationInfo($data['location']);
        $res['ret'] = 0;
        $res['errcode'] = 0;
        $res['data'] = $data;
        $res['msg'] = 'ok';
        echo json_encode($res);
        exit;
    }
    
    /**
     * 获取他人的详细资料 接口
     */
    public function other_infoAction()
    {
        $name = $this->getParam('name');
        $data = Model_User_Util::getInfo($name);
        if(empty($data))
        {
            Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_MOBILE_USERINFOERROR);
        }
        $authType = Core_Lib_UtilMobile::getAuthType();    //获取认证类型
        /* 结合平台认证信息开关 ，设定isvip字段*/
        if(!$authType['openAuth'] || empty($data['isvip']))
        {
            $data['isvip'] = 0;
        }
        $data['is_auth'] = $data['is_auth']?1:0;
        $data['verifyinfo'] = Core_Lib_UtilMobile::formatVerifyInfo($data['verifyinfo']);    //只取认证资料，筛掉相关链接
        $data['location'] = Core_Lib_UtilMobile::formatLocationInfo($data['location']);
        $res['ret'] = 0;
        $res['errcode'] = 0;
        $res['data'] = $data;
        $res['msg'] = 'ok';
        echo json_encode($res);
        exit;
    }
    
    /**
     * 更新个人简介信息
     */
    public function updatesummaryAction()
    {
        $introduction = trim($this->getParam('introduction'));    //个人介绍
        $name = $_SESSION['name'];
        $memObj = new Model_User_MemberMobile();
        $info['uid'] = $memObj->getUidByName($name);
        /*检查个人介绍格式*/
        if(!Model_User_Validator::checkMbStrLength($introduction, 0, 140))
        {
            Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_USERINFO_SUMMARYFORMATERROR);
        }
        $info['summary'] = $introduction;
        /* 修改资料 */
        if($memObj->editUserInfo($info))
        {
            Core_Lib_UtilMobile::outputReturnData(0, 0, '成功');
        }
        else
        {
            Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_USERINFO_UPDATEFAILED);
        }
    }
}
