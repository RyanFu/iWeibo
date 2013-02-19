<?php
/**
 * 后台iPhone客户端管理模块
 * @author lololi
 */
class Controller_Admin_Phone extends Core_Controller_Action
{
    /* 记录图片的修改时间 */
    const MTIME_FILE = 'uploadfile/theme/mtime.php';
    /* 主题图片支持的后缀 */
    private $validEXT = array('png');

    public function themeAction()
    {
        $themelist = Core_Comm_Mobile::$THEME_LIST;
        foreach ($themelist as &$v)
        {
            $v['maxsize'] = Core_Fun::formatBytes($v['maxsize']);
        }
        $this->assign('ext', implode('、', $this->validEXT));
        $this->assign('themelist', $themelist);
        $this->display('admin/phone_theme.tpl');
    }

    public function infoAction()
    {
        if($this->getParam('config'))
        {
            $_config = $this->getParam('config');
            $this->configsave($_config);
            $this->showmsg('保存设置成功');
        }
        $this->display('admin/phone_info.tpl');
    }

    /**
     * 上传主题图片
     */
    public function uploadAction()
    {
        $extStr = implode('.', $this->validEXT);
        foreach(Core_Comm_Mobile::$THEME_LIST as $v)
        {
            $ret = Core_Util_Upload::upload($v['id'], $extStr, $v['maxsize'], 'theme', $v['id']);
            if($ret['code'] != 0  && $ret['code'] != UPLOAD_ERR_NO_FILE)
            {
                $this->showmsg('上传'.$v['text'].'错误：'.$ret['msg']);
            }
        }
        /* 版本控制 */
        $this->versionControl();
    }

    /**
     * 主题版本控制
     */
    private function versionControl()
    {
        if(!file_exists(Core_Comm_Mobile::THEME_DIR) || !is_dir(Core_Comm_Mobile::THEME_DIR))
        {
            $this->showmsg('文件夹'.Core_Comm_Mobile::THEME_DIR.'不存在');
        }
        $dirHandle = opendir(Core_Comm_Mobile::THEME_DIR);
        if(!$dirHandle)
        {
            $this->showmsg('打开文件夹'.Core_Comm_Mobile::THEME_DIR.'失败');
        }
        
        /*
         * VERSION_FILE主要是一个数组
         * 元素0记录所有图片列表
         * 元素i(i>0)记录从版本i-1升级到版本i的 修改动作，即需要更新的图片列表
         */
        if(file_exists(Core_Comm_Mobile::VERSION_FILE))
        {
            $versionData = include Core_Comm_Mobile::VERSION_FILE;
        }else{
            $versionData = array();
        }
        $curVer = count($versionData);    //更新至的当前版本

        /*
         * MTIME_FILE主要记录上个版本主题包中每个图片的最后修改时间
         */
        if(file_exists(self::MTIME_FILE))
        {
            $mtimeData = include self::MTIME_FILE;
        }else{
            $mtimeData = array();
        }

        /*
         * 主题包列表ID
         */
        $themeIds = array();
        foreach(Core_Comm_Mobile::$THEME_LIST as $v)
        {
            $themeIds []= $v['id'];
        }

        while(false != ($file=readdir($dirHandle)))
        {
            if($this->isValidFile($file, $themeIds))
            {
                $parts = explode('.', $file);
                $id = $parts[0];
                $mtime = filemtime(Core_Comm_Mobile::THEME_DIR.'/'.$file);    //获取文件的最后修改时间

                /* curVer=0,表示全新构造版本信息 */
                if($curVer != 0)
                {
                    /* 
                     * $mtimeData[$id]非空，若当前id文件的最后修改时间比MTIME_FILE记录的新，则更新MTIME_FILE中的记录，
                     * 同时VERSION_FILE中记录下升级版本需要更新这个文件；
                     * $mtimeData[$id]为空，则表示当前id文件新加入的文件。
                     */
                    if(!empty($mtimeData[$id]))
                    {
                        $oldtime = $mtimeData[$id];
                        if($oldtime < $mtime)
                        {
                            $mtimeData[$id] = $mtime;
                            $versionData[$curVer] []= $file;
                            $versionData[0][$id] = $file;
                        }
                    }else{
                        $mtimeData[$id] = $mtime;
                        $versionData[$curVer] []= $file;
                        $versionData[0][$id]= $file;
                    }
                }else{
                    $mtimeData[$id] = $mtime;
                    $versionData[$curVer][$id] = $file;
                }
            }
        }
        file_put_contents(Core_Comm_Mobile::VERSION_FILE, "<?php\r\n return ".var_export($versionData, true).";");
        file_put_contents(self::MTIME_FILE, "<?php\r\n return ".var_export($mtimeData, true).";");
        $this->showmsg('上传主题成功');
    }

    /**
     * 判断文件是否是有效的主题包图片文件
     * 主要检查文件后缀（目前只支持png）和文件名字是否是合法的主题包图片名字
     * @param string $filename
     * @param array $themeIds
     */
    private function isValidFile($filename, $themeIds)
    {
        if('.'==$filename || '..'==$filename)
        {
            return false;
        }
        $parts = explode('.', $filename);
        $parts[1] = strtolower($parts[1]);
        if(in_array($parts[1], $this->validEXT))
        {
            if(in_array($parts[0], $themeIds))
            {
                return true;
            }
        }else{
            return false;
        }
        return false;
    }
}