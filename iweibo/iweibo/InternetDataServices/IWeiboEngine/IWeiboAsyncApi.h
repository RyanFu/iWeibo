//
//  IWeiboAsyncApi.h
//  iweibo
//
//  Created by zhaoguohui on 11-12-27.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURL+Additions.h"
#import "ASIHTTPRequest.h"

@interface DelegateObject : NSObject
{
	id		delegate;	// 用来保存委托接收体对象, 同时又不会增加delegate的引用计数
}
@property (nonatomic, assign) id		delegate;

@end

@interface IWeiboAsyncApi : NSObject {
	id temp_delegate;
	SEL onSuccessCallback;
	SEL onFailureCallback;

	//ASIHTTPRequest *httpRequest;
	NSMutableArray *httpRequests;
}

+ (void)clearSession;
- (void)cancelSpecifiedRequest;
- (void)cancelCurrentRequest;
/*
 主页时间线open api地址：http://wiki.open.t.qq.com/index.php/%E6%97%B6%E9%97%B4%E7%BA%BF/%E4%B8%BB%E9%A1%B5%E6%97%B6%E9%97%B4%E7%BA%BF
 function:主页时间线
 
 @param:paramters 存放请求参数的字典
	 request_api:请求api的url，供服务器使用
	 format 返回数据的格式，本应用只支持json格式
	 pageflag 分页标识(0：第一页，1：向下翻页，2：向上翻页)
	 pagetime 本页起始时间(第一页：填0，向上翻页：填上一次请求返回的第一条记录时间，
				向下翻页：填上一次请求返回的最后一条记录时间)
	 reqnum 每次请求记录的条数（1－70）
	 type 拉取类型：0x1  原创发表
						 0x2	 转载
						 0x8  回复
						 0x10 空回
						 0x20 提及
						 0x40 点评
						 如需拉取多个类型请使用｜，如(0x1|0x2)得到3，此时type＝3即可。填零表示拉取所有类型
	 contenttype 内容过滤.  0－表示所有类型
								 1－带文本
								 2－带链接
								 4－带图片
								 8－带视频
								 0x10－带音频
 
 @return 主页时间线数据，以字典的形式返回，如果出现错误，错误信息也包含在结果字典中
 */
- (void)getHomeTimelineMsgWithParamters:(NSDictionary *)paramters
								 delegate:(id)delegate 
								onSuccess:(SEL)successCallback 
								onFailure:(SEL)failureCallback;

/*
	发送文本微博open api地址：http://wiki.open.t.qq.com/index.php/%E5%BE%AE%E5%8D%9A%E7%9B%B8%E5%85%B3/%E5%8F%91%E8%A1%A8%E4%B8%80%E6%9D%A1%E5%BE%AE%E5%8D%9A
	function:发送文本微博
 
	@param:paramters 存放请求参数的字典，具体如下：
        request_api:请求api的url，供服务器使用
		format:		返回的数据格式，本应用只支持json
		content:	微博内容
		clientip:	用户ip（以分析用户所在地）
		jing:		经度，为实数，如113.421234（最多支持10位有效数字，可以填空）
		wei:		纬度，为实数，如22.354231(最多支持10为有效数字，可以填空)
		syncflag:	微博同步到空间分享标记(可选，0－同步，1－不同步，默认为0)
 
	@return: 发表一条文本微博后，服务器返回的结果信息。要注意进行错误处理
 */
- (void)publishTextWeiboWithParamters:(NSDictionary *)paramters 
							 delegate:(id)delegate 
							onSuccess:(SEL)successCallback
							onFailure:(SEL)failureCallback;

/*
	发送带图片的微博open api地址：http://wiki.open.t.qq.com/index.php/%E5%BE%AE%E5%8D%9A%E7%9B%B8%E5%85%B3/%E5%8F%91%E8%A1%A8%E4%B8%80%E6%9D%A1%E5%B8%A6%E5%9B%BE%E7%89%87%E7%9A%84%E5%BE%AE%E5%8D%9A
	@function: 发送带图片的微博
 
	@param:files  要传递的图片文件信息key：pic value：代表图片的NSData对象
	@param:paramters 请求参数字典，具体如下：
		request_api:请求api的url，供服务器使用
		format		返回数据的格式，本应用只支持json
		content		微博内容
		clientip	用户ip(以分析用户所在地)
		jing		经度，为实数，如113.421234（最多支持10位有效数字，可以填空）
		wei			纬度，为实数，如22.354231（最多支持10位有效数字，可以填空）
		syncflag	微博同步到空间分享标记（可选，0-同步，1-不同步，默认为0）
	@param: delegate 执行回调函数的对象
	@param: successCallback 请求成功时的回调函数
	@param: failureCallback 请求失败时的回调函数
 
	@return: 空
 */
- (void)publishPictureWeiboWithFiles:(NSDictionary *)files 
						   paramters:(NSDictionary *)paramters 
							delegate:(id)delegate 
						   onSuccess:(SEL)successCallback 
						   onFailure:(SEL)failureCallback;

/*
	我的广播open api地址：http://wiki.open.t.qq.com/index.php/%E6%97%B6%E9%97%B4%E7%BA%BF/%E6%88%91%E5%8F%91%E8%A1%A8%E6%97%B6%E9%97%B4%E7%BA%BF
	function: 我的广播
 
	@param:paramters 存放请求参数的字典，字典内容如下：
        request_api:请求api的url，供服务器使用
		format:		返回数据的格式（json）
		pageflag:	分页标识（0：第一页，1：向下翻页，2：向上翻页）
		pagetime:	本页起始时间（第一页：填0，向上翻页：填上一次请求返回的第一条记录时间，向下翻页：
					填上一次请求返回的最后一条记录时间）
		reqnum:		每次请求记录的条数（1-200条）
		lastid:		和pagetime配合使用（第一页：填0，向上翻页：填上一次请求返回的第一条记录id，
					向下翻页：填上一次请求返回的最后一条记录id）
		type:		拉取类型
					 0x1 原创发表
					 0x2 转载
					 0x8 回复
					 0x10 空回
					 0x20 提及
					 0x40 点评 
					如需拉取多个类型请使用|，如(0x1|0x2)得到3，则type=3即可，填零表示拉取所有类型 
		contenttype:内容过滤。0-表示所有类型，1-带文本，2-带链接，4-带图片，8-带视频，0x10-带音频
	@param: delegate 执行回调函数的对象
	@param: successCallback 请求成功时的回调函数
	@param: failureCallback 请求失败时的回调函数
 
	@return 空
 */
- (void)getBroadcastFromIweiboWithParamters:(NSDictionary *)paramters 
								   delegate:(id)delegate 
								  onSuccess:(SEL)successCallback 
								  onFailure:(SEL)failureCallback;

/*
	我的听众列表open api地址：http://wiki.open.t.qq.com/index.php/%E5%B8%90%E6%88%B7%E7%9B%B8%E5%85%B3/%E6%88%91%E7%9A%84%E5%90%AC%E4%BC%97%E5%88%97%E8%A1%A8
	function: 我的听众列表
		
	@param: paramters 请求参数的字典，字典内容如下：
		request_api:请求api的url，供服务器使用
		@format:	返回数据的格式（json或xml）
		@reqnum: 	请求个数(1-30)
		@startindex: 起始位置（第一页填0，继续向下翻页：填【reqnum*（page-1）】）
	@param: delegate 执行回调函数的对象
	@param: successCallback 请求成功时的回调函数
	@param: failureCallback 请求失败时的回调函数
 */
- (void)getFanslistOfFriendsWithparamters:(NSDictionary *)paramters 
								 delegate:(id)delegate 
								onSuccess:(SEL)successCallback 
								onFailure:(SEL)failureCallback;


/*
 话题列表open api地址：http://wiki.open.t.qq.com/index.php/%E6%95%B0%E6%8D%AE%E6%94%B6%E8%97%8F
 function: 获取已订阅的话题列表
 @param: paramters 请求参数字典，字典内容如下
	request_api:请求api的url，供服务器使用
	format:返回的数据格式（json）
	reqnum:请求数（最多15）
	pageflag：翻页标识（0：首页 1：向下翻页 2：向上翻页）
	pagetime：翻页用，第一页时：填0；向上翻页：填上上一次请求返回的第一条记录时间；向下翻页：
			  填上上一次返回的最后一条记录时间
	lastid：翻页用，第一页时：填0；继续向上翻页：填上一次请求返回的第一条记录id；继续向下翻页：
			填上一次请求返回的最后一条记录id
 @param: delegate 执行回调函数的对象
 @param: successCallback 请求成功时的回调函数
 @param: failureCallback 请求失败时的回调函数
 */
- (void)getFavList_htWithParamters:(NSDictionary *)paramters 
						  delegate:(id)delegate 
						 onSuccess:(SEL)successCallback 
						 onFailure:(SEL)failureCallback;

/*
 function: 
 @param: name 用户名
 @param: pwd 密码
 @param: delegate 执行回调函数的对象
 @param: successCallback 请求成功时的回调函数
 @param: failureCallback 请求失败时的回调函数
 */
- (void)iweiboLoginWithUserName:(NSString *)name 
					   password:(NSString *)pwd 
					   delegate:(id)delegate 
					  onSuccess:(SEL)successCallback 
					  onFailure:(SEL)failureCallback;

- (void)iweiboCheckHostWithUrl:(NSString *)strUrl 
					   delegate:(id)delegate 
					  onSuccess:(SEL)successCallback 
					  onFailure:(SEL)failureCallback;

/*
 搜索用户open api地址：http://wiki.open.t.qq.com/index.php/%E6%90%9C%E7%B4%A2%E7%9B%B8%E5%85%B3/%E6%90%9C%E7%B4%A2%E7%94%A8%E6%88%B7
 function: 搜索用户
 @param: paramters 请求参数，字典内容如下
		request_api: 请求api的url，供服务器使用
		format: 返回数据的格式（json）
		keyword: 搜索关键字
		pagesize: 页面数据的数目
		page: 请求数据的页码
 @param: delegate 执行回调函数的对象
 @param: successCallback 请求成功时的回调函数
 @param: failureCallback 请求失败时的回调函数
 */
- (void)searchUserWithParamters:(NSDictionary *)paramters 
					   delegate:(id)delegate 
					  onSuccess:(SEL)successCallback 
					  onFailure:(SEL)failureCallback;

/*
 获取用户自己的详细信息 open api地址：http://wiki.open.t.qq.com/index.php/%E5%B8%90%E6%88%B7%E7%9B%B8%E5%85%B3/%E8%8E%B7%E5%8F%96%E8%87%AA%E5%B7%B1%E7%9A%84%E8%AF%A6%E7%BB%86%E8%B5%84%E6%96%99
 function: 获取用户自己的详细信息
 @param: delegate 执行回调函数的对象
 @param: successCallback 请求成功时的回调函数
 @param: failureCallback 请求失败时的回调函数
 */	
- (void)getUserInfoWithDelegate:(id)delegate onSuccess:(SEL)successCallback onFailure:(SEL)failureCallback;

/*
 转播一条微博 open api地址：http://wiki.open.t.qq.com/index.php/%E5%BE%AE%E5%8D%9A%E7%9B%B8%E5%85%B3/%E8%BD%AC%E6%92%AD%E4%B8%80%E6%9D%A1%E5%BE%AE%E5%8D%9A
 function：转播一条微博
 @param: paramters 请求参数， 字典内容如下
     request_api: 请求api的url， 供服务器使用
	 format 	返回数据的格式（json或xml）
	 content 	微博内容
	 clientip 	用户ip(以分析用户所在地)
	 jing 	经度，为实数，如113.421234（最多支持10位有效数字，可以填空）
	 wei 	纬度，为实数，如22.354231（最多支持10位有效数字，可以填空）
	 reid 	转播父结点微博id
 @param:delegate 执行回调函数的对象
 @param：successCallback 请求成功时的回调函数 
 @param：failureCallback 请求失败时的回调函数
 */
- (void)reAddWeiboWithParamters:(NSDictionary *)paramters 
					   delegate:(id)delegate 
					  onSuccess:(SEL)successCallback 
					  onFailure:(SEL)failureCallback;

/*
 获取我的收听列表 open api地址：
 */
- (void)getMyIdolListWithParamters:(NSDictionary *)paramters 
						  delegate:(id)delegate
						 onSuccess:(SEL)successCallback 
						 onFailure:(SEL)failureCallback;

/*
 获取其他人的资料 open api地址：http://wiki.open.t.qq.com/index.php/%E5%B8%90%E6%88%B7%E7%9B%B8%E5%85%B3/%E8%8E%B7%E5%8F%96%E5%85%B6%E4%BB%96%E4%BA%BA%E8%B5%84%E6%96%99
 function：获取其他人的资料
 @param：paramters 请求参数，字典内容如下：
	request_api: 请求api的url， 供服务器使用
	format 	返回数据的格式（json或xml）
	name 	他人的帐户名（可选）
	fopenid 	他人的openid（可选）
		name和fopenid至少选一个，若同时存在则以name值为主 
 @param:delegate 执行回调函数的对象
 @param：successCallback 请求成功时的回调函数 
 @param：failureCallback 请求失败时的回调函数
 
 */
- (void)getOtherUserInfoWithParamters:(NSDictionary *)paramters
							 delegate:(id)delegate
							onSuccess:(SEL)successCallback
							onFailure:(SEL)failureCallback;


/*
 获取用户提及时间线 open api地址：http://wiki.open.t.qq.com/index.php/%E6%97%B6%E9%97%B4%E7%BA%BF/%E7%94%A8%E6%88%B7%E6%8F%90%E5%8F%8A%E6%97%B6%E9%97%B4%E7%BA%BF
 function：获取用户提及时间线
 @param：paramters 请求参数，字典内容如下：
		format 	返回数据的格式（json或xml）
		request_api: 请求api的url， 供服务器使用
		reqnum:请求数（1－70）
		pageflag：翻页标识（0：首页 1：向下翻页 2：向上翻页）
		pagetime：翻页用，第一页时：填0；向上翻页：填上上一次请求返回的第一条记录时间；向下翻页：
					填上上一次返回的最后一条记录时间
		lastid：翻页用，第一页时：填0；继续向上翻页：填上一次请求返回的第一条记录id；继续向下翻页：
				填上一次请求返回的最后一条记录id
 
		 type 拉取类型：0x1  原创发表
					 0x2	 转载
					 0x8  回复
					 0x10 空回
					 0x20 提及
					 0x40 点评
					 如需拉取多个类型请使用｜，如(0x1|0x2)得到3，此时type＝3即可。填零表示拉取所有类型
		 contenttype 内容过滤.  0－表示所有类型
							 1－带文本
							 2－带链接
							 4－带图片
							 8－带视频
							 0x10－带音频
 @param:delegate 执行回调函数的对象
 @param：successCallback 请求成功时的回调函数 
 @param：failureCallback 请求失败时的回调函数
 */
- (void)getMentionsTimeLineWithParamters:(NSDictionary *)paramters 
								delegate:(id)delegate
							   onSuccess:(SEL)successCallback 
							   onFailure:(SEL)failureCallback;

/*
 点评一条微博 open api地址：http://wiki.open.t.qq.com/index.php/%E5%BE%AE%E5%8D%9A%E7%9B%B8%E5%85%B3/%E7%82%B9%E8%AF%84%E4%B8%80%E6%9D%A1%E5%BE%AE%E5%8D%9A
 function：点评一条微博
 @param: paramters 请求参数，字典内容如下
		format 	返回数据的格式（json或xml）
		content 	微博内容
		clientip 	用户ip(以分析用户所在地)
		jing 	经度，为实数，如113.421234（最多支持10位有效数字，可以填空）
		wei 	纬度，为实数，如22.354231（最多支持10位有效数字，可以填空）
		reid 	点评根结点（非父结点）微博id 
 @param:delegate 执行回调函数的对象
 @param：successCallback 请求成功时的回调函数 
 @param：failureCallback 请求失败时的回调函数
 */
- (void)commentWeiboWithParamters:(NSDictionary *)paramters 
						 delegate:(id)delegate
						onSuccess:(SEL)successCallback
						onFailure:(SEL)failureCallback;

/*
 获取一条微博的转发或点评列表 open api地址：http://wiki.open.t.qq.com/index.php/%E5%BE%AE%E5%8D%9A%E7%9B%B8%E5%85%B3/%E8%8E%B7%E5%8F%96%E5%8D%95%E6%9D%A1%E5%BE%AE%E5%8D%9A%E7%9A%84%E8%BD%AC%E5%8F%91%E6%88%96%E7%82%B9%E8%AF%84%E5%88%97%E8%A1%A8
 function:获取一条微博的转发或点评列表
 @param: paramters 请求参数，字典内容如下
		format 	返回数据的格式（json或xml）
		flag 	标识。0－转播列表 1－点评列表 2－点评与转播列表
		rootid 	转发或回复的微博根结点id（源微博id）
		pageflag 	分页标识（0：第一页，1：向下翻页，2：向上翻页）
		pagetime 	本页起始时间（第一页：填0，向上翻页：填上一次请求返回的第一条记录时间，向下翻页：填上一次请求返回的最后一条记录时间）
		reqnum 	每次请求记录的条数（1-100条）
		twitterid 	翻页用，第1-100条填0，继续向下翻页，填上一次请求返回的最后一条记录id
 
 @param:delegate 执行回调函数的对象
 @param：successCallback 请求成功时的回调函数 
 @param：failureCallback 请求失败时的回调函数
 */
- (void)getWeiboRelistWithParamteers:(NSDictionary *)paramters
							delegate:(id)delegate
						   onSuccess:(SEL)successCallback
						   onFailure:(SEL)failureCallback;

/*
 回复一条微博，即对话 open api地址：http://wiki.open.t.qq.com/index.php/%E5%BE%AE%E5%8D%9A%E7%9B%B8%E5%85%B3/%E5%9B%9E%E5%A4%8D%E4%B8%80%E6%9D%A1%E5%BE%AE%E5%8D%9A%EF%BC%88%E5%8D%B3%E5%AF%B9%E8%AF%9D%EF%BC%89
 function：恢复一条微博
 @param： paramters 请求参数，字典内容如下
		format：返回的数据格式（json）
		content： 微博内容
		clientip：用户ip（以分析用户所在地）
		jing：经度，为实数，如113。421234（最多支持10位有效数字，可以填空）
		wei：纬度，为实数，如22。354231（最多支持10位有效数字，可以填空）
		reid：回复的父结点微博id
 
 @param：delegate 执行回调函数的对象
 @param：successCallback 请求成功时的回调函数
 @param：failureCallback 请求失败时的回调函数
 */
- (void)replyWithParamters:(NSDictionary *)paramters
				  delegate:(id)delegate
				 onSuccess:(SEL)successCallback
				 onFailure:(SEL)failureCallback;

/*
 获取其他用户的时间线 open api地址：http://wiki.open.t.qq.com/index.php/%E6%97%B6%E9%97%B4%E7%BA%BF/%E5%85%B6%E4%BB%96%E7%94%A8%E6%88%B7%E5%8F%91%E8%A1%A8%E6%97%B6%E9%97%B4%E7%BA%BF
 function：获取其他用户的时间线
 @param paramters 请求参数， 字典内容如下
 
 @param： delegate 执行回调函数的对象
 @param： successCallback 请求成功时的回调函数
 @param： failureCallback 请求失败时的回调函数
 */
- (void)getUserTimeLineWithParamters:(NSDictionary *)paramters
							delegate:(id)delegate
						   onSuccess:(SEL)successCallback
						   onFailure:(SEL)failureCallback;

/*
 收听某个用户 open api地址：http://wiki.open.t.qq.com/index.php/%E5%B8%90%E6%88%B7%E7%9B%B8%E5%85%B3/%E6%94%B6%E5%90%AC%E6%9F%90%E4%B8%AA%E7%94%A8%E6%88%B7
 function： 收听某个用户
 @param： paramters 请求参数， 字典内容如下
	format： 返回数据的格式（json）
	name： 要收听人的微博帐号列表（非昵称），用“，”隔开，例如：abc,bcde,eff(可选)
	fopenids： 你需要读取的用户penid列表，用下滑线"_"隔开，例如：B624064BA065E01CB73F835017FE96FA_B624064BA065E01CB73F835017FE96FB
			   name和fopenids至少选一个，若同时存在，则以name为主
 @param：delegate 执行回调函数的对象
 @param：successCallback 请求成功时的回调函数
 @param：failureCallback 请求失败时的回调函数
 */
- (void)friendsAddWithParamters:(NSDictionary *)paramters
					   delegate:(id)delegate
					  onSuccess:(SEL)successCallback
					  onFailure:(SEL)failureCallback;

/*
 取消收听某个用户 open api地址：http://wiki.open.t.qq.com/index.php/%E5%B8%90%E6%88%B7%E7%9B%B8%E5%85%B3/%E5%8F%96%E6%B6%88%E6%94%B6%E5%90%AC%E6%9F%90%E4%B8%AA%E7%94%A8%E6%88%B7
 @function：取消收听某个用户
 @param：paramters 请求参数，字典内容如下
	format： 返回数据的格式（json）
	name： 他人的账户名（可选）
	fopenid： 他人的openid（可选） name和fopenid至少选一个，若同时存在则以name值为主
	request_api: 请求api值
 @param：delegate 执行回调函数的对象
 @param：successCallback 请求成功时的回调函数
 @param：failureCallback 请求失败时的回调函数
 */
- (void)friendsDelWithParamters:(NSDictionary *)paramters
					   delegate:(id)delegate
					  onSuccess:(SEL)successCallback
					  onFailure:(SEL)failureCallback;

/*
 其他账户的听众列表 open api地址：http://wiki.open.t.qq.com/index.php/%E5%B8%90%E6%88%B7%E7%9B%B8%E5%85%B3/%E5%85%B6%E4%BB%96%E5%B8%90%E6%88%B7%E5%90%AC%E4%BC%97%E5%88%97%E8%A1%A8
 @function：其他账户的听众列表
 @param： paramters 请求参数， 字典内容如下
 
 @param：delegate 执行回调函数的对象
 @param: successCallback 请求成功时的回调函数
 @param: failureCallback 请求失败时的回调函数
 */
- (void)getUserFanListWithParamters:(NSDictionary *)paramters
						   delegate:(id)delegate
						  onSuccess:(SEL)successCallback
						  onFailure:(SEL)failureCallback;

/*
 其他账户的收听列表 open api地址： http://wiki.open.t.qq.com/index.php/%E5%B8%90%E6%88%B7%E7%9B%B8%E5%85%B3/%E5%85%B6%E4%BB%96%E5%B8%90%E6%88%B7%E6%94%B6%E5%90%AC%E7%9A%84%E4%BA%BA%E5%88%97%E8%A1%A8
 @function： 其他账户的收听列表
 @param：paramters 请求参数，字典内容如下
 
 @param：delegate 执行回调函数的对象
 @param：successCallback 请求成功时的回调函数
 @param：failureCallback 请求失败时的回调函数
 */
- (void)getUserIdolListWithParamters:(NSDictionary *)paramters
							delegate:(id)delegate
						   onSuccess:(SEL)successCallback
						   onFailure:(SEL)failureCallback;

/*
 搜索微博 open api地址： http://wiki.open.t.qq.com/index.php/%E6%90%9C%E7%B4%A2%E7%9B%B8%E5%85%B3/%E6%90%9C%E7%B4%A2%E5%BE%AE%E5%8D%9A
 @function：所搜微博
 @param： paramters 请求参数，字典内容如下
 
 @param： delegate 执行回调函数的对象
 @param：successCallback 请求成功时的回调函数
 @param：failureCallback 请求失败时的回调函数
 */
- (void)searchWeiboWithParamters:(NSDictionary *)paramters
						delegate:(id)delegate
					   onSuccess:(SEL)successCallback
					   onFailure:(SEL)failureCallback;

/*
 通过标签搜索用户 open api地址： 
 @function：通过标签搜索用户
 @param：paramters 请求参数，字典内容如下
 
 @param：delegate 执行回调函数的对象
 @param：successCallback 请求成功时的回调函数
 @param：failureCallback 请求失败时的回调函数
 */
- (void)searchUserByTagWithParamters:(NSDictionary *)paramters
							delegate:(id)delegate 
						   onSuccess:(SEL)successCallback 
						   onFailure:(SEL)failureCallback;

// Beta3接口
/*
 function: 热门话题
 */
- (void)getHotTopicWithParamters:(NSDictionary *)aParamters
						delegate:(id)delegate
					   onSuccess:(SEL)successCallback
					   onFailure:(SEL)failureCallback;

/*
 function: 热门用户／推荐用户
 */
- (void)getRecommendUserWithParamters:(NSDictionary *)aParamters
							 delegate:(id)delegate
							onSuccess:(SEL)successCallback
							onFailure:(SEL)failureCallback;

/*
 function：最新广播／最新本地微博
 */
- (void)getLatestTimelineWithParamters:(NSDictionary *)aParamters
							  delegate:(id)delegate
							 onSuccess:(SEL)successCallback
							 onFailure:(SEL)failureCallback;


/*
 function：话题时间线 open api地址：http://wiki.open.t.qq.com/index.php/%E6%97%B6%E9%97%B4%E7%BA%BF/%E8%AF%9D%E9%A2%98%E6%97%B6%E9%97%B4%E7%BA%BF
 */
- (void)getHTTimelineWithParamters:(NSDictionary *)aParamters
						  delegate:(id)delegate
						 onSuccess:(SEL)successCallback
						 onFailure:(SEL)failureCallback;

// 搜索话题
- (void)searchTopicWithparamters:(NSDictionary *)aParamters
						delegate:(id)delegate
					   onSuccess:(SEL)successCallback
					   onFailure:(SEL)failureCallback;

// 修改个人简介
- (NSDictionary *)updatePersonalIntroductionWithParamters:(NSDictionary *)aParamters;
// 订阅话题
- (NSDictionary *)addHUWithParamters:(NSDictionary *)aParamters;
// 取消订阅话题
- (NSDictionary *)delHTWithParamters:(NSDictionary *)aParamters;

/* 2012-04-01 By Yi Minwen
 LBS相关/通过经纬度获取地理位置 open api:http://wiki.open.t.qq.com/index.php/LBS%E7%9B%B8%E5%85%B3/%E9%80%9A%E8%BF%87%E7%BB%8F%E7%BA%AC%E5%BA%A6%E8%8E%B7%E5%8F%96%E5%9C%B0%E7%90%86%E4%BD%8D%E7%BD%AE
 */
- (void)reverseGeocodingWithParamters:(NSDictionary *)aParamters
							 delegate:(id)delegate
							onSuccess:(SEL)successCallback
							onFailure:(SEL)failureCallback;
/* 2012-04-01 By Yi Minwen
 LBS相关/通过地理位置获取经纬度 open api:http://wiki.open.t.qq.com/index.php/LBS%E7%9B%B8%E5%85%B3/%E9%80%9A%E8%BF%87%E5%9C%B0%E7%90%86%E4%BD%8D%E7%BD%AE%E8%8E%B7%E5%8F%96%E7%BB%8F%E7%BA%AC%E5%BA%A6
 */
- (void)getGeocodingWithParamters:(NSDictionary *)aParamters
						 delegate:(id)delegate
						onSuccess:(SEL)successCallback
						onFailure:(SEL)failureCallback;
/* 2012-04-01 By Yi Minwen
 LBS相关/获取POI(Point of Interest) open api:http://wiki.open.t.qq.com/index.php/LBS%E7%9B%B8%E5%85%B3/%E8%8E%B7%E5%8F%96POI%28Point_of_Interest%29
 */
- (void)getPOIWithParamters:(NSDictionary *)aParamters
						 delegate:(id)delegate
						onSuccess:(SEL)successCallback
						onFailure:(SEL)failureCallback;

// 主题拉取接口：customized/theme
-(void)getCustomizedThemeWithUrl:(NSString *)url
					  Parameters:(NSDictionary *)aParamters
						delegate:(id)delegate
					   onSuccess:(SEL)successCallback
					   onFailure:(SEL)failureCallback;

// 订阅网站信息获取: customized/siteinfo
-(void)getCustomizedSiteInfoWithUrl:(NSString *)url
						 Parameters:(NSDictionary *)aParamters
							   delegate:(id)delegate
							  onSuccess:(SEL)successCallback
							  onFailure:(SEL)failureCallback;

- (void)iweiboRegisterUserWithUrl:(NSString *)strUrl 
					   Parameters:(NSDictionary *)aParamters
						 delegate:(id)delegate
						onSuccess:(SEL)successCallback 
						onFailure:(SEL)failureCallback;
@end
