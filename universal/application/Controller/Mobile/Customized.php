<?php
/**
 * 第三方定制化相关接口
 * @author lololi
 *
 */
class Controller_Mobile_Customized extends Core_Controller_MobileAction
{
    /**
     * 拉取主题包图片列表
     * 采取版本控制，增量更新机制
     * 如客户端的主题版本为1，服务器最新的主题版本为3，那么返回升级到版本3所需要更新的图片列表；
     * 第一次拉取版本参数ver填-1
     */
    public function themeAction()
    {
        $ver = (int) $this->getParam('ver');    //客户端的主题版本
        $res = array();
        $versionData = array();
        $data = array();
        $list = array();
        /*检查主题包文件夹*/
        if(!file_exists(Core_Comm_Mobile::THEME_DIR) || !is_dir(Core_Comm_Mobile::THEME_DIR))
        {
            Core_Lib_UtilMobile::outputReturnData(1, 1, '获取主题包列表失败', NULL);
        }

        /*
         * version文件的格式如下：
         * 元素0记录所有图片列表
         * 元素i(i>0)记录从版本i-1升级到版本i的 修改动作，即需要更新的图片列表
         */
        if(file_exists(Core_Comm_Mobile::VERSION_FILE))
        {
            $versionData = include Core_Comm_Mobile::VERSION_FILE;
            $curVersion = count($versionData)-1;    //服务器当前版本号
            
            /*版本号相同， 则不需要更新*/
            if($curVersion == $ver)
            {
                $data['version'] = $curVersion;
                $data['list'] = array();
                Core_Lib_UtilMobile::outputReturnData(0, 1, '主题已是最新', $data);
            }else if($curVersion > $ver){
                /*客户端版本号比服务器小，合并升级到当前版本号的历史动作*/
                for($i=$ver+1;$i<=$curVersion;$i++)
                {
                    foreach((array)$versionData[$i] as $incs)
                    {
                        $parts = explode('.', $incs);
                        if(!array_key_exists($parts[0], $list))
                        {
                            if(file_exists(Core_Comm_Mobile::THEME_DIR.'/'.$incs))
                            {
                                $list[$parts[0]] = Core_Comm_Mobile::THEME_DIR.'/'.$incs;
                            }
                        }
                    }
                }
            }else{
                /*
                 * 客户端版本号比服务器大，则拉取全部列表
                 * 这种情况是可能存在，比如服务器重新构建版本信息等
                 */
                /* $versionData[0]:当前version的所有文件列表 */
                foreach((array)$versionData[0] as $incs)
                {
                    $parts = explode('.', $incs);
                    if(!array_key_exists($parts[0], $list))
                    {
                        if(file_exists(Core_Comm_Mobile::THEME_DIR.'/'.$incs))
                        {
                            $list[$parts[0]] = Core_Comm_Mobile::THEME_DIR.'/'.$incs;
                        }
                    }
                }
            }
            $data['version'] = $curVersion;
            $data['list'] = $list;
            Core_Lib_UtilMobile::outputReturnData(0, 0, '成功', $data);
        }else{
            Core_Lib_UtilMobile::outputReturnData(1, 2, '获取主题包列表失败', NULL);
        }
    }

    /**
     * 获取站点相关信息接口
     * 返回 name:网站名称;url:网站地址;official:官方微博;description:站点介绍.
     */
    public function siteinfoAction()
    {
        $configs = Core_Config::get(null, 'basic');
        $phone_configs = Core_Config::get(null, 'phone_basic');
        $data = array();
        $data['name'] = $configs['site_name'];
        $data['url'] = $configs['site_url'];
        $data['official'] = $phone_configs['official'];
        $data['description'] = $phone_configs['site_des'];
        Core_Lib_UtilMobile::outputReturnData(0, 0, '成功', $data);
    }
}