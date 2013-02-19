<?php

/**
 * 全局设置
 *
 * @author Gavin <yaojungang@comsenz.com>
 *
 */
class Controller_Admin_Config extends Core_Controller_Action
{

    /**
     * 基础设置
     */
    public function basicAction ()
    {
        if ($this->getParam ('config')) {
            $this->configsave ();
            $this->showmsg ('保存设置成功');
        }
        $this->assign ('righttime', Core_Fun::time ());
        $this->display ('admin/config_basic.tpl');
    }

    /**
     * 站点设置
     */
    public function siteAction ()
    {
        if ($this->getParam ('config')) {
            $_config = $this->getParam ('config');
            $site_logo = Core_Util_Upload::upload ('site_logo', 'jpg,png,gif,jpeg');
            if ($site_logo['code'] == 0) {
                $_config['basic']['site_logo'] = $site_logo['link'];
            }
            $this->configsave ($_config);  
            if($site_logo['code'] == 0 || $site_logo['code'] == UPLOAD_ERR_NO_FILE) { //设置时  可以不上传LOGO图片
              $this->showmsg ('保存设置成功');
            } else {
              $this->showmsg ('上传LOGO错误:'.$site_logo['msg']);
            }      
        } else {
        	//从表单post过来
            if(isset($_GET[postFlag]))
            {
                $this->showmsg('上传LOGO大小可能超过'.Core_Fun::formatBytes(2097152).'的限制', '/admin/config/site');
            }
        }
        $this->display ('admin/config_site.tpl');
    }
    
    public function loginfaceAction ()
    {
        if($this->getParam('config'))
        {
            $_config = $this->getParam('config');
            $this->configsave($_config);
            $this->showmsg ('保存设置成功');
        }
        $this->display ('admin/config_loginface.tpl');
    }

    /**
     * 登录授权
     */
    public function loginAction ()
    {
        if ($this->getParam ('config')) {
            $_config = $this->getParam ('config');
            if ($_config['basic']['login_local'] == 0 && $_config['basic']['login_tencent'] == 0) {
                $this->showmsg ('保存失败:必须至少选择一种站点登录方式', '-1', 10);
            } else {
                Model_Componentprocessunit::cleanupAllComponentCache ();  //触发清除组件缓存.
                $this->configsave ();
                $this->showmsg ('保存设置成功');
            }
        }
        $this->display ('admin/config_login.tpl');
    }

    /**
     * 手机版设置
     */
    public function wapAction ()
    {
        if ($this->getParam ('config')) {
            $_config = $this->getParam ('config');
            $_wapOn = $_config['basic']['wap_on'];
            if (isset ($_wapOn)) {
                Model_Nav::changeWapNav ($_wapOn);
            }
            $this->configsave ();
            $this->showmsg ('保存设置成功');
        }
        $this->display ('admin/config_wap.tpl');
    }

    /**
     * 防灌水设置
     */
    public function secAction ()
    {
        if ($this->getParam ('config')) {
            $_config = $this->getParam ('config');
            if (isset ($_config['basic']['code_on_reg'])
                    || isset ($_config['basic']['code_on_login'])
                    || isset ($_config['basic']['code_on_adminlogin'])) {
                if (!Core_Lib_Seccode::checkFunction ()) {
                    $this->showmsg ('所需的函数库不满足要求,验证码开启失败');
                } else {
                    $this->configsave ();
                    $this->showmsg ('保存设置成功');
                }
            }
        }
        $this->display ('admin/config_sec.tpl');
    }

    /**
     * 个性化域名设置
     */
    public function domainAction ()
    {
        if ($this->getParam ('config')) {
            $this->configsave ();
            $this->showmsg ('保存设置成功');
        }
        $this->display ('admin/config_domain.tpl');
    }

    /**
     * 国际化设置
     */
    public function i18nAction ()
    {
        $_i18ns = array (
            'zh_CN' => '中文简体',
            'zh_TW' => '中文繁体'
        );

        $this->assign ('i18ns', $_i18ns);
        if ($this->getParam ('config')) {
            $this->configsave ();
            $this->showmsg ('保存设置成功');
        }

        $this->display ('admin/config_i18n.tpl');
    }

    /**
     * 搜索管理
     */
    public function searchAction ()
    {
        if ($this->getParam ('config')) {
            $_config = $this->getParam ('config');
            if (strlen ($_config['basic']['hot_words']) > 25) {
                $this->showmsg ('保存失败:热词总长度不能超过25个字节，一个汉字3个字节');
            } else {
                $this->configsave ();
                $this->showmsg ('保存设置成功');
            }
        }
        $this->display ('admin/config_search.tpl');
    }

    /**
     * 微博功能
     */
    public function blogAction ()
    {
        if ($this->getParam ('config')) {
            $this->configsave ();
            $this->showmsg ('保存设置成功');
        }
        $this->display ('admin/config_blog.tpl');
    }

    /**
     * 邮件设置
     */
    public function mailAction ()
    {
        if ($this->getParam ('config')) {
            $this->configsave ();
            $this->showmsg ('保存设置成功');
        }
        $this->display ('admin/config_mail.tpl');
    }

}
