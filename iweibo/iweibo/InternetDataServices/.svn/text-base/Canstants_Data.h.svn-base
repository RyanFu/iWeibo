//
//  Canstants_Data.h
//  iweibo
//
//  Created by zhaoguohui on 11-12-27.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

/*
 IWeibo API宏定义文件
 */

// 服务器地址

//#define OAuthConsumerKey @"800000020"
//#define OAuthConsumerSecret @"6173eedf9477bc6124ed695d7153cf76"
//
//#define IWeibo_Host @"http://dev.i.t.qq.com/index.php/mobile/" 
//#define IWeibo_Host_Beta3 @"http://dev.i.t.qq.com/index.php/mobile/" 

#define IWeibo_Host @"http://demo.i.t.qq.com/index.php/mobile/" 
#define IWeibo_Host_Beta3 @"http://demo.i.t.qq.com/index.php/mobile/" 

//#define OAuthConsumerKey @"86cf657f2b874c45885e31ab6aaa83d2"
//#define OAuthConsumerSecret @"6513d43f04918f0e642ba5e7fc367183"

#define OAuthConsumerKey @"801065645"
#define OAuthConsumerSecret @"fe55b90d1757317bccc56744ee90a7ee"

#define		HOST_SUB_PATH_COMPONENT			@"/index.php/mobile/"


// 用户登录接口
#define URL_IWEIBO_LOGIN  [NSString stringWithFormat:@"%@%@", IWeibo_Host, @"private/login"] 

// 时间线
#define URL_HOME_TIMELINE [NSString stringWithFormat:@"%@%@", IWeibo_Host, @"statuses/home_timeline"]	// 主页timeline接口
#define URL_USER_TIMELINE [NSString  stringWithFormat:@"%@%@", IWeibo_Host, @"statuses/user_timeline"] // 其他用户发表的时间线
#define URL_MENTIONS_TIMELINE [NSString stringWithFormat:@"%@%@", IWeibo_Host, @"statuses/mentions_timeline"] // 获取用户提及的时间线
#define	URL_BROADCAST_TIMELINE [NSString stringWithFormat:@"%@%@", IWeibo_Host, @"statuses/broadcast_timeline"] // 我的广播接口

// 微博相关
#define URL_REPLY [NSString stringWithFormat:@"%@%@", IWeibo_Host, @"t/reply"] // 回复一条微博，即对话
#define URL_RE_ADD [NSString stringWithFormat:@"%@%@", IWeibo_Host, @"t/re_add"] // 转播一条微博
#define URL_COMMENT [NSString stringWithFormat:@"%@%@", IWeibo_Host, @"t/comment"] // 点评一条微博
#define URL_RE_LIST [NSString stringWithFormat:@"%@%@", IWeibo_Host, @"t/re_list"] // 单条微博的转发或点评列表
#define URL_MESSAGE_NORMAL [NSString stringWithFormat:@"%@%@", IWeibo_Host, @"t/add"] // 发表一条微博
#define URL_MESSAGE_MUSIC	[NSString stringWithFormat:@"%@%@", IWeibo_Host, @"t/add_music"] // 音乐微博
#define URL_MESSAGE_VIDEO	[NSString stringWithFormat:@"%@%@", IWeibo_Host, @"t/add_video"] // 视频微博
#define URL_MESSAGE_PICTURE [NSString stringWithFormat:@"%@%@", IWeibo_Host, @"t/add_pic"] // 图片微博

// 账户相关
#define URL_USER_INFO [NSString stringWithFormat:@"%@%@", IWeibo_Host, @"user/info"] // 获取自己的详细资料
#define URL_OTHER_INFO [NSString stringWithFormat:@"%@%@", IWeibo_Host, @"user/other_info"] // 获取其他人的资料

// 关系链相关
#define URL_IDOLLIST [NSString stringWithFormat:@"%@%@", IWeibo_Host, @"friends/idollist"] // 我的收听列表
#define URL_FRIENDS_ADD [NSString stringWithFormat:@"%@%@", IWeibo_Host, @"friends/add"] // 收听某个用户
#define URL_FRIENDS_DEL [NSString stringWithFormat:@"%@%@", IWeibo_Host, @"friends/del"] // 取消收听某个用户
#define URL_FRIENDS_FANSLIST [NSString stringWithFormat:@"%@%@", IWeibo_Host, @"friends/fanslist"] // 我的听众列表
#define URL_USER_FANLIST [NSString stringWithFormat:@"%@%@", IWeibo_Host, @"friends/user_fanslist"] // 其他账户听众列表
#define URL_USER_IDOLLIST [NSString stringWithFormat:@"%@%@", IWeibo_Host, @"friends/user_idollist"] // 其他账户的收听列表

// 搜索相关
#define URL_SEARCH_USER [NSString stringWithFormat:@"%@%@", IWeibo_Host, @"search/user"] // 搜索用户
// beta3
#define URL_SEARCH_WEIBO [NSString stringWithFormat:@"%@%@", IWeibo_Host_Beta3, @"search/t"] // 搜索微博
#define URL_SEARCH_USERBYTAG [NSString stringWithFormat:@"%@%@", IWeibo_Host_Beta3, @"search/userbytag"] // 通过标签搜索用户

// 获取已订阅的话题列表
#define URL_FAV_LIST_HT [NSString stringWithFormat:@"%@%@", IWeibo_Host, @"fav/list_ht"]


// Beta3接口
// 热门用户／推荐用户
#define URL_RECOMMEND_USER [NSString stringWithFormat:@"%@%@", IWeibo_Host_Beta3, @"pexplore/recommend_user"]

// 最新广播／最新本地微博
#define URL_LATEST_TIMELINE [NSString stringWithFormat:@"%@%@", IWeibo_Host_Beta3, @"pexplore/latest_timeline"]

// 热门话题
#define URL_HOT_TOPIC [NSString stringWithFormat:@"%@%@", IWeibo_Host_Beta3, @"pexplore/hot_topic"]

// 话题时间线
#define URL_HT_TIMELINE [NSString stringWithFormat:@"%@%@", IWeibo_Host_Beta3, @"statuses/ht_timeline"]

// 搜索话题
#define URL_SEARCH_TOPIC [NSString stringWithFormat:@"%@%@", IWeibo_Host_Beta3 , @"search/ht"]

// 修改个人简介
#define URL_UPDATE_INTRODUCTION [NSString stringWithFormat:@"%@%@", IWeibo_Host_Beta3, @"user/updatesummary"]


// 订阅话题
#define URL_ADD_HT [NSString stringWithFormat:@"%@%@", IWeibo_Host_Beta3, @"fav/addht"]

// 取消订阅话题
#define URL_DEL_HT [NSString stringWithFormat:@"%@%@", IWeibo_Host_Beta3, @"fav/delht"]


// reverse Geocoding
#define URL_REVERSE_GEOCODING [NSString stringWithFormat:@"%@%@", IWeibo_Host_Beta3, @"lbs/rgeoc"]
// get Geocoding
#define URL_GET_GEOCODING [NSString stringWithFormat:@"%@%@", IWeibo_Host_Beta3, @"lbs/geoc"]
// get Geocoding
#define URL_GET_POI [NSString stringWithFormat:@"%@%@", IWeibo_Host_Beta3, @"lbs/get_poi"]

