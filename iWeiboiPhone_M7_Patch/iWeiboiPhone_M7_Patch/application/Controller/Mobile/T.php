<?php
/**
 * 微博相关控制器
 * @author lololi
 *
 */
class Controller_Mobile_T extends Core_Controller_MobileAction
{ 
    const APITYPE_ADD = 1;
    const APITYPE_RE_ADD = 2;
    const APITYPE_REPLY = 3;
    const APITYPE_COMMENT = 4;
    const APITYPE_ADD_PIC = 5;
    const APITYPE_ADD_MUSIC = 6;  //暂不提供接口
    const APITYPE_ADD_VIDEO = 7;  //暂不提供接口
    
    static $ACTION_NAME = array(
        self::APITYPE_ADD     => 'add',
        self::APITYPE_RE_ADD  => 're_add',
        self::APITYPE_REPLY   => 'reply',
        self::APITYPE_COMMENT => 'comment',
        self::APITYPE_ADD_PIC => 'add_pic'
    );
    /**
     * 发表一条微博 接口
     */
    public function addAction()
    {
        $this->postMsg(self::APITYPE_ADD);
    }
    
    /**
     * 发表一条图片微博 接口
     */
    public function add_picAction()
    {
        $this->postMsg(self::APITYPE_ADD_PIC);
    }
    
    /**
     * 转播一条微博 接口
     */
    public function re_addAction()
    {
        $this->postMsg(self::APITYPE_RE_ADD);
    }
    
    /**
     * 评论一条微博 接口
     */
    public function commentAction()
    {
        $this->postMsg(self::APITYPE_COMMENT);
    }
    
    /**
     * 对话一条微博 接口
     */
    public function replyAction()
    {
        $this->postMsg(self::APITYPE_REPLY);
    }
    
    /**
     * 获取一条微博数据 接口
     */
    public function showAction()
    {
        $tid = $this->getParam('id');
        $client = new Core_Open_ClientMobile();
        $tInfo = $client->getOne(array('id' => $tid));
        $r = Core_Lib_UtilMobile::formatT($tInfo['data']);
        if(!empty($r['visiblecode']))
        {
            Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_T_UNVISIBLE);
        }
        echo json_encode($tInfo);
        exit;
    }
    
    /**
     * 删除一条微博 接口
     */
    public function delAction()
    {
        $tid = $this->getParam('id');
        $p = array(
            'id' => $tid
        );
        $client = new Core_Open_ClientMobile();
        $res = $client->delOne($p);
        Model_Blog::deleteBlogByOpentid($tid); //删除本地消息
        echo json_encode($res);
        exit;
    }
    
    /**
     * 获取单条微博的转发或点评列表 接口
     */
    public function re_listAction()
    {
        $flag      = Core_Comm_Validator::getNumArg($this->getParam('flag'), 0, 2, 0);
        $pageflag  = Core_Comm_Validator::getNumArg($this->getParam('pageflag'), 0, 2, 0);
        $pagetime  = Core_Comm_Validator::getNumArg($this->getParam('pagetime'), 0, PHP_INT_MAX, 0);
        $reqnum    = Core_Comm_Validator::getNumArg($this->getParam('reqnum'), 1, 100, 100);
        $twitterid = $this->getParam('twitterid');
        $rootid = $this->getParam('rootid');
        $p = array (
            'reid' => $rootid,
            'f' => $pageflag,
            'n' => $reqnum,
            't' => $pagetime,
            'tid' => $twitterid,
            'flag' => $flag
        );
        
        $client = new Core_Open_ClientMobile();
        $res = $client->getReplay($p);
        $reList = &$res['data']['info'];
        /* 当没有广播数据时，增加'data-hasnext'字段(前端需求) */
        if(empty($reList) && !isset($res['data']['hasnext']))
        {
            $res['data']['hasnext'] = 1;
        }
        $reList and Core_Lib_UtilMobile::formatTArr($reList);
        $userMap = &$res['data']['user'];
        $userMap and Core_Lib_UtilMobile::formatUserMap($userMap);
        echo json_encode($res);
        exit;
    }
    
    /**
     * 发表微博
     * @param  $apiType 1.add 2.re_add 3.reply 4.comment 
     *                  5.add_pic 6.add_music 7.add_video
     */
    public function postMsg($apiType)
    {  
        /*1,5,6,7均属于原创广播类型*/
        if(in_array($apiType, array(1,5,6,7)))
        {
            $type = 1;
        }else{
            $type = $apiType;
        }
        /*获取参数*/
        $content = $this->getParam('content');
        $this->contentFilter($content, $type); //检查微博内容*
        $clientIp = $this->getParam('clientip');
        $jing = $this->getParam('jing');
        $wei = $this->getParam('wei');
        $p = array(
            'type' => $type,
            'c' => $content,
            'ip' => $clientIp,
            'j' => $jing,
            'w' => $wei
        );
        
        /*非原创微博，获取父节点微博id*/
        if($type != 1)
        {
            $p['r'] = $this->getParam('reid');
        }
        /*图片微博，获取pic参数*/
        if($apiType == 5)
        {
            $p['p'] = $this->getPic();
        }
        /*音乐微博，获取music参数*/
        if($apiType == 6)
        {
            $p['audio']['url'] = $this->getParam('url');
            $p['audio']['title'] = $this->getParam('title');
            $p['audio']['author'] = $this->getParam('author');
        }
        /*视频微博，获取video参数*/
        if($apiType == 7)
        {
            $p['video'] = $this->getParam('url');
        }
        
        $client = new Core_Open_ClientMobile();
        $result = $client->postOne($p);
        if($result['ret'] != 0)
        {
            echo json_encode($result);
            exit;
        }
        
        $tid = $result['data']['id'];
        /* getOne容错，getOne失败只是导致本地存储失败，但这里实际已发微博 */
        Core_Lib_UtilMobile::turnOnSkipOuputFlag();
        $tInfo = $client->getOne(array('id' => $tid));
        Core_Lib_UtilMobile::turnOnSkipOuputFlag();
        if(!empty($tInfo['data']))
        {
            ob_start();
            $data = Core_Lib_Base::formatT ($tInfo["data"], 50, 160);
            ob_clean();
            $data['originopentid'] = '';
            $data['ip'] = $clientIp;
            $data['txt'] = $content;
            try
            {
                $this->addLocalBlog ($data); //本地化存储单条消息
                $this->addtStat ($type, $p); //统计代码
            } catch (Core_Exception $e)
            {
            }
        }else{
            /* 本地消息存储失败，记log */
            Core_Lib_UtilMobile::logs("ret=".Core_Comm_Modret::RET_LOCAL_SAVEERROR.";tid=".$tid);
        }
        Core_Lib_UtilMobile::bossLog(self::$ACTION_NAME[$apiType], $result['ret'], $result['msg'], $result['errcode']);
        echo json_encode($result);
        exit;
    }
    
    /**
    * 检验过滤内容
    *
    */
    public function contentFilter ($content, $type)
    {
        //白名单用户，无需审核
        if (Model_User_Member::isTrustUser ()) {
            return;
        }
        $wellArray = Model_Blog::getTopicByContent ($content);
        //包含被锁定话题，禁止发送
        if ($wellArray) {
            foreach ($wellArray as $topic)
            {
                if (Model_Topic::isMasked ($topic)) {
                    Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_T_TOPIC_REFUSE);
                }
            }
        }
        //包含敏感词语，禁止发送
        $this->_filter = Model_Filter::checkContent ($content);
        if (2 == $this->_filter) {
            Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_T_FILTER_REFUSE);
        }
        return;
    }
    
    
        
    public function addLocalBlog ($data)
    {
        if (!empty ($data) && !empty ($data['id'])) {
            Model_Blog::addBlog ($data); //本地化消息
            
            //白名单用户，无需审核
            if (Model_User_Member::isTrustUser ()) {
                return;
            }
            //含敏感词直接进审核箱
            $this->_filter == 1 && Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_T_FILTER_WAIT);

            //先审后发
            if (Core_Config::get ('censor', 'basic', false)) {
                Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_T_CENSOR);
            }
        }
    }
    
    public function getPic ()
    {
        $pic = array ();

        $len = isset ($_FILES["pic"]["size"]) ? intval ($_FILES["pic"]["size"]) : 0;
        if (!empty ($_FILES["pic"]['name']) && ($len > 2000000 || $len < 1)) {//图片最大2M
            Core_Lib_UtilMobile::logs("get pic error:\r\n".print_r($_FILES["pic"], true));
            Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_PIC_SIZE);
        }

        $code = Core_Comm_Validator::checkUploadFile ($_FILES["pic"]); //检验图片

        if ($code > 0) {//上传成功
            $fileContent = file_get_contents ($_FILES["pic"]["tmp_name"]);

            $picType = Core_Comm_Util::getFileType (substr ($fileContent, 0, 2)); //图片类型
            if ($picType != "jpg" && $picType != "gif" && $picType != "png") {
                Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_PIC_TYPE);
            }

            if (!is_uploaded_file ($_FILES["pic"]["tmp_name"])) {//非http post上传失败
                Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_T_UPLOAD_UN_HTTP);
            }

            $pic = array ($_FILES["pic"]["type"], $_FILES["pic"]["name"], $fileContent); //pic参数是个数组
        } elseif ($code < 0) {//上传失败
            Core_Lib_UtilMobile::logs("get pic error:code=".$code."\r\n".print_r($_FILES["pic"], true));
            Core_Lib_UtilMobile::outputReturnData($code);
        }

        return $pic;
    }
    
    public function addtStat ($type, $p)
    {
        //统计代码
        try
        {
            //1广播 2 转播 3 对话 4 评论
            if (!empty ($type)) {
                $skey = array ();//默认原创文本
                switch ($type)
                {//1原创文本广播 2 转播(评论并转播) 3 对话/对话 4 评论
                    case 2://2 转播
                        $skey[] = 'forward';
                        break;
                    case 3://3 对话/对话
                        $skey[] = 'dialog';
                        break;
                    case 4://4 评论
                        $skey[] = 'comment';
                        break;
                    default: //原创
                        if (!empty ($p['p'])) { //原创图片
                            $skey[] = 'oripic';
                        } elseif (!empty ($p['audio'])) {//原创音乐
                            $skey[] = 'orimp3';
                        } elseif (!empty ($p['video'])) {//原创视频
                            $skey[] = 'orivod';
                        } else {
                            $skey[] = 'oritxt';
                        }
                        break;
                }

                $p['c'] && $atNum = substr_count ($p['c'], '@');
                for ($i = 0; $i < $atNum; $i++)
                {
                    $skey[] = 'alt';
                }

                //话题统计数
                $wellNum = empty ($this->wellNum) ? 0 : $this->wellNum;
                $wellNum > 2 && $wellNum == 2;
                for ($i = 0; $i < $wellNum; $i++)
                {
                    $skey[] = 'topic'; //统计@次数
                }

                foreach ($skey as $v)
                {
                    Model_Stat::addStat ($v);//统计
                }
            }
        } catch (Core_Exception $e)
        {
            //pass
        }
    }
}
?>
