<?php
/**
 * 手机客户端模块相关常量值
 * @author lololi
 *
 */
class Core_Comm_Mobile
{
    /* 客户端模块控制器目录  */
    const MOBILE_DIR = 'application/Controller/Mobile/';
    /* 登录态失效时间  */
    const LOGIN_EXPIRE_TIME = 1209600;
    /* 重新下放登录态周期  */
    const COOKIE_CHANGE_INTERVAL = 7200;
    /* 主题包目录 */
    const THEME_DIR = 'uploadfile/theme';
    /* 主题包版本信息文件 */
    const VERSION_FILE = 'uploadfile/theme/version.php';

    /* 主题包文件 */
    public static $THEME_LIST = array( array('id' => 'logo@2x', 'text' => '站点logo', 'dim' => '127x127', 'maxsize' => 204800),
                                       array('id' => 'loginBg@2x', 'text' => '登录页背景', 'dim' => '640x960', 'maxsize' => 512000),
                                       array('id' => 'loading@2x', 'text' => '载入页', 'dim' => '640x960', 'maxsize' => 512000));

    /* 客户端模块功能接口汇总  */
    public static $MODULE_CLASS = array('Private', 'Statuses', 'T', 'User', 'Pexplore', 'Friends', 'Fav', 'Search', 'Info', 'Customized');
    public static $MODULE_FUNCTION  = array(array('login', 'check', 'authorize', 'reg', 'result', 'bind'), 
                                           array('home_timeline', 'broadcast_timeline', 'mentions_timeline', 'user_timeline', 'ht_timeline'),
                                           array('add', 're_add', 'reply', 'comment', 'add_pic', 'show', 're_list'),
                                           array('info', 'other_info', 'updatesummary'),
                                           array('latest_timeline', 'hot_topic', 'recommend_user'),
                                           array('fanslist', 'idollist', 'user_fanslist', 'user_idollist', 'add', 'del', 'check'),
                                           array('list_ht', 'addht', 'delht'),
                                           array('user', 't', 'ht'),
                                           array('update'),
                                           array('theme')
                                      );
}