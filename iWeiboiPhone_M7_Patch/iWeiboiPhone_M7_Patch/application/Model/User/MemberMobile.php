<?php
/**
 * 手机客户端后台用户操作子类
 * @author lololi
 */
class Model_User_MemberMobile extends Model_User_Member
{
    /**
     * 重写formatPassword, 避免前端请求时密码明文
     * @param string $password  经过一次md5的密码值
     * @param string $salt
     * @see Model_User_Member::formatPassword()
     */
    public function formatPassword($password, $salt)
    {
        return md5($password.$salt);
    }
    
    /**
     * 根据本地用户名获得access_token和access_token_secret
     * @param string $username  本用户名
     */
    public function getAccessTokensByUsername($username)
    {
        $uinfo = $this->getUserInfoByUsername($username);
        return array('oauth_token' => $uinfo['oauthtoken'], 'oauth_token_secret' => $uinfo['oauthtokensecret']);
    }
    
    /**
     * 重写本函数，使得只需根据access_token就能完成当前用户的Session设置
     * @param $oauthToken 即access_token
     * @see Model_User_Member::onSetCurrentAccessToken()
     */
    public function onSetCurrentAccessToken($oauthToken)
    {
        $uinfo = $this->memberTableObj->queryOne ('*', array (array ('oauthtoken', $oauthToken)));
        $_SESSION['access_token'] = $oauthToken;
        $_SESSION['access_token_secret'] = $uinfo['oauthtokensecret'];
        $_SESSION['name'] = $uinfo['name'];
    }
}
?>
