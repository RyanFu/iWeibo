//
//  IWeiboASyncHttpRequest.h
//  iweibo
//
//  Created by zhaoguohui on 11-12-27.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Canstants_Data.h"


@interface IWeiboASyncHttpRequest : NSObject {

}

/*
	function: 根据传入的请求参数生成一个主页时间线的请求地址
	@param:aParamters 包含请求参数的字典
	@return: 生成的请求URL
 */
- (NSString *)getTimeLineURLWithParameters:(NSDictionary *)aParameters;

/*
 function: 根据传入的请求参数生成一个发送文本微博的请求地址
 @param:aParamters 包含请求参数的字典
 @return: 生成的请求URL
 */
- (NSString *)getPublishTextWeiboURLWithParamters:(NSDictionary *)aParamters;

/*
 function: 根据传入的请求参数生成一个发表带图片的微博的请求地址
 @param:aParamters 包含请求参数的字典
 @return: 生成的请求URL
 */
- (NSString *)getPublishPictureWeiboURLWithParamters:(NSDictionary *)aParamters;

/*
 function: 根据传入的请求参数生成一个获取我的广播的请求地址
 @param:aParamters 包含请求参数的字典
 @return: 生成的请求URL
 */
- (NSString *)getBroadcastFromIWeiboURLWithParamters:(NSDictionary *)aParamters;

/*
 function: 根据传入的请求参数生成一个获取我的听众列表的请求地址
 @param:aParamters 包含请求参数的字典
 @return: 生成的请求URL
 */
- (NSString *)getFanslistOfFriendsURLWithParamters:(NSDictionary *)aParamters;

/*
 function:根据传入的请求参数生成一个获取已订阅的话题列表的请求地址
 @param: aParamters 包含请求参数的字典
 @return:生成的请URL
 */
- (NSString *)getFavList_htURLWithParamters:(NSDictionary *)aParamters;

/*
 function:根据传入的请求参数生成一个搜索用户的请求地址
 @param:aParamters 包含请求参数的字典
 @return: 生成的URL
 */
- (NSString *)getSearchUserURLWithParamgers:(NSDictionary *)aParamters;

/*
 function: 生成获取用户详细信息的URL
 @param: 空
 
 @return: 生成的URL信息
 */
- (NSString *)getUserInfoURL;

/*
 function：生成获取转播一条微博的URL
 @param: 
 
 @return: 生成的URL信息
 */
- (NSString *)getReAddWeiboURLWithParamters:(NSDictionary *)aParamters;

/*
 function:生成获取收听列表的URL
 @param: aParamters 包含请求参数的字典
 
 @return:生成的URL信息
 */
- (NSString *)getIdolListURLWithParamters:(NSDictionary *)aParamters;

/*
 function：获取其他人的资料
 @param： aParamters 包含请求参数的字典
 
 @return： 生成的URL信息
 */
- (NSString *)getOtherUserInfoURLWithParamters:(NSDictionary *)aParamters;


/*
 function: 生成提及我的的URL
 @param：aParamters 包含请求参数的字典
 
 @return： 生成的URL信息
 */
- (NSString *)getMentions_timelineURLWithParamters:(NSDictionary *)aParaters;


/*
 function: 生成点评一条微博的URL
 @param：aParamters 包含请求参数的字典
 
 @return： 生成的URL信息
 */
- (NSString *)getWeiboCommentURLWithParamters:(NSDictionary *)aParamters;

/*
 function: 获取一条微博的转发或点评列表URL
 @param：aParamters 包含请求参数的字典
 
 @return： 生成的URL信息
 */
- (NSString *)getWeiboRelistURLWithParamters:(NSDictionary *)aParamters;

/*
 function：获取回复一条微博即对话的URL
 @param：aParamters 包含请求参数的字典
 
 @return： 生成的URL信息
 */
- (NSString *)getReplyURLWithParamters:(NSDictionary *)aParamters;

/*
 function: 获取其他用户时间线的URL
 @param: aParamters 包含请求参数的字典
 
 @return： 生成的URL信息
 */
- (NSString *)getUserTimelineURLWithParamters:(NSDictionary *)aParamters;

/*
 function: 收听某个用户
 @param： aParamters： 包含请求参数的字典
 
 @return： 生成的URL信息
 */
- (NSString *)getFriendsAddURLWithParamters:(NSDictionary *)aParamters;

/*
 function: 取消收听某个用户
 @param: aParamters： 包含请求参数的字典
 
 @return: 生成的URL信息
 */
- (NSString *)getFriendsDelURLWithParamters:(NSDictionary *)aParamters;

/*
 function: 其他账户的听众列表
 @param： aParamters 包含请求参数的字典
 
 @return：生成的URL信息
 */

- (NSString *)getUserFanListURLWithParamters:(NSDictionary *)aParamters;

/*
 function：其他账户的收听列表
 @param： aParamters 包含请求参数的字典
 
 @return： 生成的URL信息
 */
- (NSString *)getUserIdolListURLWithParamters:(NSDictionary *)aParamters;

/*
 function: 搜索微博
 @param: aParamters 包含请求参数的字典
 
 @return: 生成的URL信息
 */
- (NSString *)getSearchWeiboURLWithParamters:(NSDictionary *)aParamters;

/*
 function: 搜索微博
 @param: aParamters 包含请求参数的字典
 
 @return: 生成的URL信息
 */
- (NSString *)getSearchUserByTagWithParamters:(NSDictionary *)aParamters;

// Beta3接口
/*
 function: 热门话题
 @param： aParamters 包含请求参数的字典
 
 @return： 生成的URL信息
 */
- (NSString *)getHotTopicURLWithParamters:(NSDictionary *)aParamters;

/*
 function: 热门用户／推荐用户
 @param：aParamters 包含请求参数的字典
 
 @return：生成的URL信息
 */
- (NSString *)getRecommendUserURLWithParamters:(NSDictionary *)aParamters;

/*
 function：最新广播／最新本地微博
 @param：aParamters 包含请求参数的字典
 
 @return： 生成的URL信息
 */
- (NSString *)getLatestTimelineURLWithParamters:(NSDictionary *)aParamters;

/*
 function: 话题时间线
 @param: aparamters 包含请求参数的字典
 
 @return：生成的URL信息
 */
- (NSString *)getHTTimelineURLWithParamters:(NSDictionary *)aParamters;

// 搜索话题
- (NSString *)getSearchTopicURLWithParamters:(NSDictionary *)aParamters;

// 修改个人简介
- (NSString *)getUpdateIntroductionURLWithparamters:(NSDictionary *)aParamters;

// 订阅话题
- (NSString *)getAddHTURLWithParamters:(NSDictionary *)aParamters;

// 取消订阅话题
- (NSString *)getDelHTURLWithParamters:(NSDictionary *)aParamters;

/*
 function: 获取登录的url
 @param: name 用户名
 @param: pwd 密码
 
 @return: 等录的请求URL
 */
+ (NSString*)getIWeiboLoginURLWithName:(NSString *)name password:(NSString *)pwd;

// reverse Geocoding
- (NSString *)getReverseGeocodingURLWithParameters:(NSDictionary *)aParamters;
// get Geocoding
- (NSString *)getGeocodingURLWithParameters:(NSDictionary *)aParamters;
// get POI
- (NSString *)getPOIURLWithParameters:(NSDictionary *)aParamters;
// get customized theme
-(NSString *)getCustomizedThemeWithUrl:(NSString *)url andParameters:(NSDictionary *)aParamters;
// get customized siteInfo
-(NSString *)getCustomizedSiteInfoWithUrl:(NSString *)url andParameters:(NSDictionary *)aParamters;
// register for user
-(NSString *)registerUserWithUrl:(NSString *)url andParameters:(NSDictionary *)aParamters;
@end
