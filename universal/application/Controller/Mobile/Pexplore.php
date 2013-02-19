<?php
/**
 * 探索接口控制器
 * @author lololi
 *
 */
class Controller_Mobile_Pexplore extends Core_Controller_MobileAction
{
    /**
     * 本地最新微博  接口
     */
    public function latest_timelineAction()
    {
        $reqnum   = Core_Comm_Validator::getNumArg($this->getParam('reqnum'), 1, 50, 10);
        $pageflag = Core_Comm_Validator::getNumArg($this->getParam('pageflag'), 0, 2, 0);
        $lastid   = Core_Comm_Validator::getNumArg($this->getParam('lastid'), 0, PHP_INT_MAX, 0);
        $type     = Core_Comm_Validator::getNumArg($this->getParam('type'), 0, 123, 0);

        /* 
         * 设置数据库查询数比请求数更多 
         * 多请求的目的在于避免因为空数据或者设置新审核词等引起的微博过滤后，实际得到微博条数变少
         */
        $mb = new Model_Blog();
        $bufferRate = 0.5;    //每次多请求数据条数的比率
        $num = ceil((1+$bufferRate)*$reqnum);
        $idsMap = $mb->getLatestBlogIDs($num, $pageflag, $lastid, $type);
        if(empty($idsMap))
        {
            $data = array('hasnext' => 1, 'info' => null);
            $msg = '没有本地微博';
            Core_Lib_UtilMobile::outputReturnData(0, 0, $msg, $data);
        }

        /* 过滤掉opentid为空的本地微博 */
        foreach($idsMap as $k => &$v)
        {
            if(empty($k))
            {
                unset($v);
            }
        }

        /* 从平台获取对应本地微博的更全的数据 */
        $idsArr = array_keys($idsMap);
        $idList = implode(',', $idsArr);
        $p = array(
            'ids' => $idList
        );
        $client = new Core_Open_ClientMobile();
        $res = $client->getBlogList($p);

        /* 本地化处理 */
        $info = &$res['data']['info'];
        Core_Lib_UtilMobile::formatTArr($info);

        /* 过滤掉相比实际请求数reqnum多请求的数据*/
        $count = 0;
        foreach($info AS $k => &$v)
        {
            
            if($count < $reqnum)
            {
                $tid = $v['id'];
                $v['local_id'] = $idsMap[$tid]['id'];    //设置本地微博id字段，用于翻页
                $count ++;
            }else{
                unset($info[$k]);
            }
        }
        /*
         * 设置hasNext字段,0表示还有数据，1相反
         * pageflag=2，hasNext表示向上翻是否有数据
         * pageflag=0或1，则表示向下翻是否有数据
         */
        $hasNext = 1;
        if($pageflag < 2)
        {
            $last = end($idsMap);
            $boundaryID = $mb->getBoundaryBlogID(0);
            if($last['id'] > $boundaryID)
            {
                $hasNext = 0;
            }
        }else{
            $first = reset($idsMap);
            $boundaryID = $mb->getBoundaryBlogID(1);
            if($first['id'] < $boundaryID)
            {
                $hasNext = 0;
            }
        }
        $res['data']['hasnext'] = $hasNext;
        
        echo json_encode($res);
        exit;
    }

    /**
     * 本地热门话题 接口
     */
    public function hot_topicAction()
    {
        $lastid   = Core_Comm_Validator::getNumArg($this->getParam('lastid'), 0, PHP_INT_MAX, 0);
        $pageflag = Core_Comm_Validator::getNumArg($this->getParam('pageflag'), 0, 2, 0);
        $reqnum   = Core_Comm_Validator::getNumArg($this->getParam('reqnum'), 1, 30, 5);

        $htModel = new Model_Hottopic();
        $maxId = $htModel->getHotTopicsCount();
        $htList = $htModel->getHotTopicList($reqnum, $pageflag, $lastid);
        if(empty($htList))
        {
            $data = array('hasnext' => 1, 'info' => null);
            $msg = '没有推荐话题';
            Core_Lib_UtilMobile::outputReturnData(0, 0, $msg, $data);
        }

        /*
         * 设置hasNext字段,0表示还有数据，1相反
         * pageflag=2，hasNext表示向上翻是否有数据
         * pageflag=0或1，则表示向下翻是否有数据
         */
        $hasNext = 1;
        if($pageflag<2)
        {
            $last = end($htList);
            if($last['id'] > 1)
            {
                $hasNext = 0;
            }
        }else{
            $first = reset($htList);
            if($first['id'] < $maxId)
            {
                $hasNext = 0;
            }
        }

        /* 从平台获取话题的相关信息 */
        $htNameArr = array();
        foreach($htList as $k => $v)
        {
            $v['name'] = trim($v['name']);
            if(!empty($v['name']))
            {
                $htNameArr[] = $v['name'];
            }else{ 
                unset($htList[$k]);
            }
        }
        $htNameList = implode(',', $htNameArr);
        $p = array(
            'httexts' => $htNameList
        );
        $client = new Core_Open_ClientMobile();
        $apiRes = $client->getTopicInfo($p);

        /* 容错处理 
        if($apiRes['ret'] != 0)
        {
            if(!empty($htList))
            {
                $data = array();
                $data['hasnext'] = $hasNext;
                foreach($htList as $k => $v)
                {
                    $htList[$k]['local_id'] = $v['id'];
                    unset($htList[$k]['id']);
                    $data['info'][] = $htList[$k];;
                }
                $msg = Core_Comm_Modret::getMsg(Core_Comm_Modret::RET_API_ERR);
                Core_Lib_UtilMobile::outputReturnData(1, $apiRes['ret']*1000+$apiRes['errcode'], $msg, $data);
            }else{
                Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_API_ARG_ERR);
            }
        }*/
        

        /* 构造 话题名 为key的数组 */
        $info = $apiRes['data']['info'];
        $infoMap = array();
        foreach($info as $v)
        {
            $name = strtolower(trim($v['text']));
            $infoMap[$name] = $v;
        }

        /* 增加话题的本地相关数据 */
        $resInfo = array();
        foreach($htList as $ht)
        {
            $name = strtolower($ht['name']);
            if(array_key_exists($name, $infoMap))
            {
                $htInfo = $infoMap[$name];
                $htInfo['local_id'] = $ht['id'];
                $htInfo['description'] = $ht['description'];
                $htInfo['picture'] = $ht['picture'];
                $htInfo['picture2'] = $ht['picture2'];
            }else{
                /* 话题下还没有任何微博的情况处理 , 平台接口不返回数据*/
                $htInfo = $ht;
                $htInfo['local_id'] = $ht['id'];
                $htInfo['id'] = 0;
                $htInfo['text'] = $ht['name'];
                unset($htInfo['name']);
                $htInfo['favnum'] = 0;
                $htInfo['tweetnum'] = 0;
            }
            $resInfo [] = $htInfo;
        }
        $res['data']['info'] = $resInfo;
        $res['data']['hasnext'] = $hasNext;
        $res['msg'] = 'ok';
        $res['errcode'] = 0;
        $res['ret'] = 0;
        echo json_encode($res);
        exit;
    }
    
    /**
     * 推荐用户 接口
     */
    public function recommend_userAction()
    {
        $lastid   = Core_Comm_Validator::getNumArg($this->getParam('lastid'), 0, PHP_INT_MAX, 0);
        $pageflag = Core_Comm_Validator::getNumArg($this->getParam('pageflag'), 0, 2, 0);
        $reqnum   = Core_Comm_Validator::getNumArg($this->getParam('reqnum'), 1, 30, 10);
        $random   = Core_Comm_Validator::getNumArg($this->getParam('random'), 0, 1, 0);

        $huModel= new Model_Recommend();
        $maxId = $huModel->getHotUsersCount();

        /* $random为1，随机推荐$reqnum个用户 */
        if($random == 1)
        {
            $randomArr = array();
            if($reqnum >= $maxId)
            {
                $randomArr = range(1, $maxId);
            }else{
                /* 从n个数中随机选出m(m<n)个数的算法 ，O(n)*/
                srand(mktime());
                for($i=0;$i<$maxId;$i++)
                {
                    $arr []= $i+1;
                }
                for($i=1;$i<$maxId;$i++)
                {
                    $j = rand(0, $i);
                    $tmp = $arr[$j];
                    $arr[$j] = $arr[$i];
                    $arr[$i] = $tmp;
                }
                $randomArr = array_slice($arr, 0, $reqnum);
                $huList = $huModel->getHotUserByIDs($randomArr);
            }
        }else{
            $huList = $huModel->getHotUserList($reqnum, $pageflag, $lastid);
        }

        if(empty($huList))
        {
            $data = array('hasnext' => 1, 'info' => null);
            $msg = '没有推荐用户';
            Core_Lib_UtilMobile::outputReturnData(0, 0, $msg, $data);
        }
        $huList = array_change_key_case($huList, CASE_LOWER);

        /*
         * 设置hasNext字段,0表示还有数据，1相反
         * pageflag=2，hasNext表示向上翻是否有数据
         * pageflag=0或1，randnom=1,则表示向下翻是否有数据
         */
        $hasNext = 1;
        if($random ==1 && $maxId>$reqnum)
        {
            $hasNext = 0;
        }else{
            if($pageflag<2)
            {
                $last = end($huList);
                if($last['id'] > 1)
                {
                    $hasNext = 0;
                }
            }else{
                $first = reset($huList);
                if($first['id'] < $maxId)
                {
                    $hasNext = 0;
                }
            }
        }

        $accounts = array();
        foreach($huList as $k => $v)
        {
            $lower = strtolower($v['account']);
            $huList[$k]['account'] = $lower;
            $accounts [] = $lower;
        }

        $infoList = Model_User_Util::getInfos($accounts); //本地用户有冗余数据，后期考虑减少数据传输
       /* if(empty($infoList))
        {
            /* 容错处理 
            if(!empty($huList))
            {
                $data = array();
                foreach($huList as $v)
                {
                    $tmp = array();
                    $tmp['name'] = $v['account'];
                    if($random == 1)
                    {
                        $tmp['introduction'] = $v['description'];
                    }else{
                        $tmp['local_id'] = $v['id'];
                    }
                    $data['info'][] = $tmp;
                }
                $data['hasnext'] = $hasNext;
                $msg = '获取用户数据失败';
                Core_Lib_UtilMobile::outputReturnData(1, 0, $msg, $data);  
            }else{
                Core_Lib_UtilMobile::outputReturnData(Core_Comm_Modret::RET_MOBILE_USERINFOERROR);
            }
        }*/

        /* 数据后期处理 */
        $res = array();
        $info = &$res['data']['info'];
        foreach($accounts as $v)
        {
            $userInfo = $infoList[$v];
            if(!empty($userInfo))
            {
                $userInfo['ismyidol'] = $userInfo['isidol']?1:0;
                $userInfo['is_auth'] = $userInfo['is_auth']?1:0;
                unset($userInfo['isidol']);
                if($random == 1)
                {
                    $userInfo['introduction'] = $huList[$v]['description'];    //本地的用户推荐描述
                }else{
                    $userInfo['local_id'] = $huList[$v]['id'];    //local_id用于翻页
                }
                $info []= $userInfo;
            }
        }

        $res['data']['hasnext'] = $hasNext;
        $res['msg'] = 'ok';
        $res['errcode'] = 0;
        $res['ret'] = 0;
        echo json_encode($res);
        exit;
    }
}