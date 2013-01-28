//
//  DraftController.m
//  iweibo
//
//  Created by Minwen Yi on 12/29/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import "DraftController.h"
#import "Canstants_Data.h"
#import "Database.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "MyFavTopicInfo.h"
#import "MyFriendsFansInfo.h"
#import "Canstants.h"
#import "ComposeBaseViewController.h"
#import "Reachability.h"

static DraftController* g_draftController = nil;

static BOOL					g_startRequestForData = NO;		// 单次请求已开始
// 单词获取好友列表请求时用到的临时数据
static NSMutableArray		*g_FriendsFansArray = nil;	// 已收藏话题列表
static NSMutableArray		*draftArray;				// 草稿数组数据
static NSMutableArray		*allArray;
static NSInteger			g_hasGetFansCounts = 0;		// 单次获取好友列表请求: 已经获取的用户个数
static BOOL					g_bUpdateFans = NO;

// 单词获取话题列表请求时用到的临时数据
//static NSMutableArray		*g_favTopicsArray = nil;	// 已收藏话题列表

@implementation DraftController
@synthesize myDraftControllerDelegate;
@synthesize myDraftControllerFansListDelegate;
@synthesize aSyncAApi;
@synthesize myDraftCtllerSearchUserDelegate;
@synthesize myDraftCtrllerDraftListDelegate;
@synthesize myDraftControllerExternalDelegate;
@synthesize sendDraft;
@synthesize bStartGettingMyFavTopics, myFavTopicsLastID, myFavTopicspageFlag;

+ (DraftController *)sharedInstance {
	if (nil == g_draftController) {
		g_draftController = [[DraftController alloc] init];
		IWeiboAsyncApi *api = [[IWeiboAsyncApi alloc] init];
		g_draftController.aSyncAApi =  api;
		[api release];
		g_draftController.bStartGettingMyFavTopics = NO;
		g_draftController.myFavTopicsLastID = @"0";
	}
	return g_draftController;
}

- (void)dealloc {
	[aSyncAApi release];
	aSyncAApi = nil;
	// 可能存在异常处理
	if (g_FriendsFansArray) {
		[g_FriendsFansArray release];
		g_FriendsFansArray = nil;
	}

	[super dealloc];
}

- (void)setASyncAApi:(IWeiboAsyncApi *)iweiboApi {
	//CLog(@"before DraftController::setASyncAApi iweiboApi retainCount:%d", [iweiboApi retainCount]);
	[iweiboApi retain];
	if (nil != aSyncAApi) {
		[aSyncAApi release];
	}
	aSyncAApi = iweiboApi;
	[aSyncAApi retain];
	[iweiboApi release];
	//CLog(@"after DraftController::setASyncAApi iweiboApi retainCount:%d", [iweiboApi retainCount]);
}

//- (Draft *)buildDraftWithType:(ComposeMsgType) enumType Context:(NSString *)draftText AndImageData:(NSData *)data {
//	Draft *draft = [[Draft alloc] init];
//	draft.draftType = enumType;
//	draft.draftText = draftText;
//	if (data != nil) {
//		draft.attachedData = data;
//	}
//	return draft;
//}
//
//- (void)disposeDraft:(Draft *)draftContext {
//	[draftContext release];
//}

- (void)getFriendsFansListFromServer {
	if (!g_startRequestForData) {
		g_startRequestForData = YES;
		g_hasGetFansCounts = 0;
		if (nil == g_FriendsFansArray) {
			g_FriendsFansArray = [[NSMutableArray alloc] initWithCapacity:5];
		}
		[g_FriendsFansArray removeAllObjects];
	}
	NSMutableDictionary *parGetFriends = [NSMutableDictionary dictionaryWithCapacity:5];
	[parGetFriends setObject:@"json" forKey:@"format"];
	NSString	*num = [NSString stringWithFormat:@"%d", FriendFansListCountEachTime];
	[parGetFriends setObject:num forKey:@"reqnum"];
	NSString	*index = [NSString stringWithFormat:@"%d", g_hasGetFansCounts];
	[parGetFriends setObject:index forKey:@"startindex"];
	[parGetFriends setObject:URL_IDOLLIST forKey:@"request_api"];
	[aSyncAApi getMyIdolListWithParamters:parGetFriends
								 delegate:self
								onSuccess:@selector(getFriendsFansListOnSuccessCallback:)  
								onFailure:@selector(getFriendsFansListOnFailureCallback:)];
	/*
	 [aSyncAApi getFanslistOfFriendsWithparamters:parGetFriends 
	 delegate:self 
	 onSuccess:@selector(getFriendsFansListOnSuccessCallback:)  
	 onFailure:@selector(getFriendsFansListOnFailureCallback:)];
	 */
}

- (void)getFriendsFansListFromLocal {
	// lichentao 2012-02-17读取本地数据库好友列表时候重新创建数组和保存到数据库的数组区分开 
	NSMutableArray *g_LocalFriendsFansArray = [[NSMutableArray alloc] initWithCapacity:10];
	NSMutableArray *arrayAll = [MyFriendsFansInfo mySimpleFriendsFansListFromDB];
	for (MyFriendsFansInfo *infoItem in arrayAll) {
		NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithCapacity:6];
		[infoDic setObject:infoItem.fansname forKey:@"name"];
		[infoDic setObject:infoItem.nick forKey:@"nick"];
		[infoDic setObject:infoItem.head forKey:@"head"];
		[infoDic setObject:infoItem.isvip forKey:@"isvip"];
		[g_LocalFriendsFansArray addObject:infoDic];
	}
	// 2012-02-23 检测数据，假如没有好友，则去网络获取
	if ([g_LocalFriendsFansArray count] == 0) {
		g_bUpdateFans = NO;
		[self getFriendsFansListFromServer];
	}
	else {
		// 发送数据
		if ([self.myDraftControllerFansListDelegate respondsToSelector:@selector(getFriendsFansListOnSuccess:)]) {
			[myDraftControllerFansListDelegate getFriendsFansListOnSuccess:g_LocalFriendsFansArray];
		}
	}
	// 删除数组
	[g_LocalFriendsFansArray release];
}

// 获取好友列表成功回调函数
- (void)getFriendsFansListOnSuccessCallback:(NSDictionary *)dict {
	//NSLog(@"dict is %@",dict);
	// 好友列表返回数据不能为空逻辑处理
	//lichentao 2012-03-02修改数据类型去掉msg字段的逻辑判断
		NSDictionary *friendsData = [DataCheck checkDictionary:dict forKey:@"data" withType:[NSDictionary class]];
		NSNumber *hasNext = [DataCheck checkDictionary:friendsData forKey:@"hasnext" withType:[NSNumber class]];
		NSArray *infoArray = [DataCheck checkDictionary:friendsData forKey:@"info" withType:[NSArray class]];
		if (![infoArray isKindOfClass:[NSNull class]]) {
			// 接收数据
			NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:10];
			for (NSDictionary *infoItem in infoArray) {
				//[g_FriendsFansArray addObject:infoItem];	// 添加到全局数组
				[tempArray addObject:infoItem];
			}
			// 保存到数据库
			[MyFriendsFansInfo updateMyFriendsFansInfoToDB:tempArray];
			[tempArray release];
		}
		// 服务器还有好友数据继续发送请求
		if (![hasNext isKindOfClass:[NSNull class]] && [hasNext intValue] != 1) {
			// 继续要数据
			//g_hasGetFansCounts += [infoArray count];
			// 2012-02-08 修正一个服务器返回数据少于FriendFansListCountEachTime导致下一次请求异常的问题
			g_hasGetFansCounts += FriendFansListCountEachTime;
			//CLog(@" received count:%d",  [infoArray count]);
			[self getFriendsFansListFromServer];
		}
		else {		// 接收完成
			NSLog(@"接收好友列表完成");
			g_startRequestForData = NO;
			g_hasGetFansCounts = 0;
			// 发送数据(非更新状态才发送)
			if (!g_bUpdateFans && [self.myDraftControllerFansListDelegate respondsToSelector:@selector(getFriendsFansListOnSuccess:)]) {
				[self.myDraftControllerFansListDelegate getFriendsFansListOnSuccess:g_FriendsFansArray];
			}
			g_bUpdateFans = NO;
			// 这里调用 removeAllObjects会不会删除过快？
			[g_FriendsFansArray removeAllObjects];
		}
}

// 获取好友列表失败回调函数
- (void)getFriendsFansListOnFailureCallback:(NSError *)error {
	CLog(@"error:%@", error);
	g_startRequestForData = NO;
	g_hasGetFansCounts = 0;
	[g_FriendsFansArray removeAllObjects];
	if (!g_bUpdateFans && [self.myDraftControllerFansListDelegate respondsToSelector:@selector(getFriendsFansListOnFailure:)]) {
		[myDraftControllerFansListDelegate getFriendsFansListOnFailure:error];
	}
	g_bUpdateFans = NO;
	
}

// 更新好友列表
- (void)updateFriendsFansList {
	g_bUpdateFans = YES;
	[self getFriendsFansListFromServer];
}

- (void)getFriendsFansList {
	// 2012-01-16 
	// 逻辑变更，好友列表更新只在登陆时发生，写消息时直接调用本地数据库中数据
//	int fansUpdateStatus = [MyFriendsFansInfo isUpdateFansFromServerNeeded];
//	if (fansUpdateStatus == 0) {
		[self getFriendsFansListFromLocal];
//	}
//	else {
//		[self getFriendsFansListFromServer];
//	}
}


- (void)getMyFavTopicsListFromServer {
	NSMutableDictionary *parMyFavTopics = [NSMutableDictionary dictionaryWithCapacity:10];
	[parMyFavTopics setValue:@"json" forKey:@"format"];	
	NSString	*num = [NSString stringWithFormat:@"%d", MyFavTopicsCountEachTime];
	NSString	*pageflag = [NSString stringWithFormat:@"%d", self.myFavTopicspageFlag];
	NSString	*pageTime = [NSString stringWithFormat:@"%@", myFavTopicsPageTime];
	[parMyFavTopics setValue:num forKey:@"reqnum"];
	[parMyFavTopics setValue:pageflag forKey:@"pageflag"];
	[parMyFavTopics setValue:pageTime forKey:@"pagetime"];
	[parMyFavTopics setValue:self.myFavTopicsLastID forKey:@"lastid"];
	[parMyFavTopics setValue:URL_FAV_LIST_HT forKey:@"request_api"];
	[aSyncAApi getFavList_htWithParamters:parMyFavTopics
								 delegate:self 
								onSuccess:@selector(getMyFavTopicsListOnSuccessCallback:)
								onFailure:@selector(getMyFavTopicsListOnFailureCallback:)];
}

- (void)getMyFavTopicsListFromLocal {
	NSMutableArray *arrTopics = [[NSMutableArray alloc] initWithCapacity:15];
	NSMutableArray *arrayAll = [MyFavTopicInfo mySimpleFavTopicsFromDB];
	for (MyFavTopicInfo *infoItem in arrayAll) {
		NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithCapacity:3];
		[infoDic setObject:infoItem.topicID forKey:@"id"];
		[infoDic setObject:infoItem.textString forKey:@"text"];
		[infoDic setObject:infoItem.hasAddedBefore forKey:@"isaddedbefore"];
		[arrTopics addObject:infoDic];
	}
	// 发送数据
	if ([self.myDraftControllerFansListDelegate respondsToSelector:@selector(getMyFavTopicsOnSuccess:)]) {
		[myDraftControllerFansListDelegate getMyFavTopicsOnSuccess:arrTopics];
	}
	// 删除数组
	[arrTopics release];
	bStartGettingMyFavTopics = NO;
}

// 获取好友列表成功回调函数
- (void)getMyFavTopicsListOnSuccessCallback:(NSDictionary *)dict {
	//CLog(@"on getMyFavTopicsListOnSuccessCallback :%@", dict);
	//	CLog(@"on getFriendsFansListOnSuccessCallback");
	NSDictionary *friendsData = [DataCheck checkDictionary:dict forKey:@"data" withType:[NSDictionary class]];
	NSArray *infoArray = [DataCheck checkDictionary:friendsData forKey:@"info" withType:[NSArray class]];
	if (![infoArray isKindOfClass:[NSNull class]]) {
	// 接收数据
		[MyFavTopicInfo updateMyFavTopicInfoToDB:infoArray];
		// (pageCount++) < 10柔性处理异常情况
		if ([infoArray count] == MyFavTopicsCountEachTime && (pageCount++) < 10) {
			NSDictionary *info = [infoArray lastObject];
			myFavTopicspageFlag = 1;			// 向下翻页
			myFavTopicsPageTime = [info objectForKey:@"timestamp"];
			self.myFavTopicsLastID = (NSString *)[info objectForKey:@"id"];
			// 继续要数据
			[self getMyFavTopicsList];
		}
		else {		// 接收完成
			bStartGettingMyFavTopics = NO;
			myFavTopicspageFlag = 0;
			myFavTopicsPageTime = [NSNumber numberWithInt:0];
			self.myFavTopicsLastID = @"0";
			// 取自本地
			[self getMyFavTopicsListFromLocal];
		}
	}
	else {
		// 接收完成
		bStartGettingMyFavTopics = NO;
		myFavTopicspageFlag = 0;
		myFavTopicsPageTime = [NSNumber numberWithInt:0];
		self.myFavTopicsLastID = @"0";
		// 取自本地
		[self getMyFavTopicsListFromLocal];
	}

}

// 获取好友列表失败回调函数
- (void)getMyFavTopicsListOnFailureCallback:(NSError *)error {
	CLog(@"error:%@", error);
	g_startRequestForData = NO;
	myFavTopicspageFlag = 0;
	myFavTopicsPageTime = [NSNumber numberWithInt:0];
	self.myFavTopicsLastID = @"0";
	if ([self.myDraftControllerFansListDelegate respondsToSelector:@selector(getMyFavTopicsOnFailure:)]) {
		[myDraftControllerFansListDelegate getMyFavTopicsOnFailure:error];
	}
}
// 检测网路状态

-(BOOL)checkNetWorkStatus {
	BOOL bResult = YES;
	if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable) 
		&& ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
		bResult = NO; 
	}
	return bResult;
}
// 获取话题列表
- (void)getMyFavTopicsList {
	if (!bStartGettingMyFavTopics) {
		bStartGettingMyFavTopics = YES;
		myFavTopicspageFlag = 0;
		myFavTopicsPageTime = [NSNumber numberWithInt:0];
		pageCount = 0;
		self.myFavTopicsLastID = @"0";
	}
	// 判断是否需要更新数据库™
	if ([self checkNetWorkStatus] &&[MyFavTopicInfo IsUpdateMyFavTopicListFromServerNeeded]) {
		// 24小时以内没有查询过，则需要向服务器发送查询请求
		[self getMyFavTopicsListFromServer];
	}
	else
	{
		// 24小时以内查询过则不再查询
		[self getMyFavTopicsListFromLocal];
	}
}

// 访问本地数据库数据
- (void)getDraftListFromDB{
	NSMutableArray *arrayAll1 = [self mySimpleDraftListFromDB];
	draftArray = [NSMutableArray arrayWithCapacity:7];
	for (Draft *draft in arrayAll1) {
		NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithCapacity:6];
		NSNumber *draftType = [NSNumber numberWithInt:draft.draftType];// 类型封装NSNuber
		[infoDic setObject:draft.uid forKey:@"id"];
		[infoDic setObject:draftType forKey:@"draftType"];
		[infoDic setObject:draft.draftText forKey:@"draftText"];
		[infoDic setObject:draft.timeStamp forKey:@"timeStamp"];
		[infoDic setObject:draft.draftForwardOrCommentName forKey:@"draftForwardOrCommentName"];
		[infoDic setObject:draft.draftForwardOrCommentText forKey:@"draftForwardOrCommentText"];
		[draftArray addObject:infoDic];
	}
	
	if ([self.myDraftCtrllerDraftListDelegate respondsToSelector:@selector(draftListSuccess:)]) {
		[myDraftCtrllerDraftListDelegate draftListSuccess:draftArray];
	}
}

// 草稿数据库
-  (NSMutableArray *)mySimpleDraftListFromDB {
	allArray = [NSMutableArray arrayWithCapacity:6];
	FMDatabase *db = [Database sharedManager].db;
	FMResultSet *s = [db executeQueryWithFormat:@"select id, draftType, draftText, draftDate, draftForwardOrCommentName,draftForwardOrCommentText from draft order by draftType desc"];
	while ([s next]) {
		Draft  *draft = [[Draft alloc] init];
		draft.uid = [s stringForColumnIndex:0];
		draft.draftType = [s intForColumnIndex:1];
		draft.draftText = [s stringForColumnIndex:2];
		draft.timeStamp = [s stringForColumnIndex:3];
		draft.draftForwardOrCommentName = [s stringForColumnIndex:4];
		draft.draftForwardOrCommentText = [s stringForColumnIndex:5];
		[allArray addObject:draft];
		[draft release];
	}
	return allArray;
}

- (NSInteger )PostBroadcastMsgToServer:(Draft *)draft {
	NSInteger retValue = -1;
	if (nil == draft.attachedData) {
		if (nil != draft.draftText) {
			// 发送文本消息
			NSMutableDictionary *paraMessageNormal = [NSMutableDictionary dictionaryWithCapacity:10];
			[paraMessageNormal setValue:@"json" forKey:@"format"];
			[paraMessageNormal setValue:draft.draftText forKey:@"content"];
			[paraMessageNormal setValue:@"127.0.0.1" forKey:@"clientip"];
			[paraMessageNormal setValue:URL_MESSAGE_NORMAL forKey:@"request_api"];
			[aSyncAApi publishTextWeiboWithParamters:paraMessageNormal
											delegate:self 
										   onSuccess:@selector(onSuccessCallBack:) 
										   onFailure:@selector(onFailureCallback:)];
		}
		else {
			CLog(@"no text to send");
		}		
	}
	else {
		assert(draft.attachedDataType == PICTURE_DATA);
		// 发送带图片的消息
		NSMutableDictionary *paraMessagePicture = [NSMutableDictionary dictionaryWithCapacity:10];
		[paraMessagePicture setValue:@"json" forKey:@"format"];
		if ([draft.draftText length] > 0) {// lichentao 2012-03-15修改将draft.draftText更改[draft.draftText length] > 0
			[paraMessagePicture setValue:draft.draftText forKey:@"content"];
		}
		else {
			[paraMessagePicture setValue:@"转发图片" forKey:@"content"];
		}

		[paraMessagePicture setValue:@"127.0.0.1" forKey:@"clientip"];
		[paraMessagePicture setValue:URL_MESSAGE_PICTURE forKey:@"request_api"];
		NSDictionary *files = [NSDictionary dictionaryWithObject:draft.attachedData forKey:@"pic"];
		[aSyncAApi publishPictureWeiboWithFiles:files paramters:paraMessagePicture 
									   delegate:self 
									  onSuccess:@selector(onSuccessCallBack:) 
									  onFailure:@selector(onFailureCallback:)];
	}
	return retValue;
}

// 转发微博向服务器发送textView内容及转发微博唯一id
- (NSInteger )PostForwardMsgToServer:(Draft *)draft {

	NSInteger retValue = -1;
	NSMutableDictionary *paramter = [NSMutableDictionary dictionaryWithCapacity:5];
	[paramter setValue:@"json" forKey:@"format"];
	[paramter setValue:URL_RE_ADD forKey:@"request_api"];
	[paramter setValue:draft.draftText forKey:@"content"];
	[paramter setValue:@"127.0.0.1" forKey:@"clientip"];
	//[paramter setValue:@"113.421234" forKey:@"jing"];
//	[paramter setValue:@"22.354231" forKey:@"wei"];
	[paramter setValue:draft.uid forKey:@"reid"];
	
	[aSyncAApi reAddWeiboWithParamters:paramter delegate:self onSuccess:@selector(onSuccessCallBack:) onFailure:@selector(onFailureCallback:)];
	return retValue;
}

// 对话
- (NSInteger )PostTalkToMsgToServer:(Draft *)draft {
	
	NSInteger retValue = -1;
	// 未完成
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithCapacity:10];
	[parameters setValue:@"json" forKey:@"format"];
	NSString *strTitle = [[NSString alloc] initWithFormat:@"%@", draft.draftText];
	[parameters setValue:strTitle forKey:@"content"];
	[strTitle release];
	[parameters setValue:@"127.0.0.1" forKey:@"clientip"];
	//[parameters setValue:@"233.22" forKey:@"jing"];
//	[parameters setValue:@"123.321" forKey:@"wei"];
	[parameters setValue:draft.uid forKey:@"reid"];
	[parameters setValue:URL_REPLY forKey:@"request_api"];
	[aSyncAApi replyWithParamters:parameters
					delegate:self
				   onSuccess:@selector(onSuccessCallBack:) 
				   onFailure:@selector(onFailureCallback:)];
	
	[parameters release];
	return retValue;
}
- (NSInteger )PostCommentToServer:(Draft *)draft{
	NSInteger retValue = -1;
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithCapacity:10];
	[parameters setValue:@"json" forKey:@"format"];
	[parameters setValue:draft.draftText forKey:@"content"];
	[parameters setValue:@"127.0.0.1" forKey:@"clientip"];
	//[parameters setValue:@"113.421234" forKey:@"jing"];
//	[parameters setValue:@"22.354231" forKey:@"wei"];
	[parameters setValue:draft.uid forKey:@"reid"];
	[parameters setValue:URL_COMMENT forKey:@"request_api"];
	
	IWeiboAsyncApi *apis = [[IWeiboAsyncApi alloc] init];
	[apis commentWeiboWithParamters:parameters
						   delegate:self
						  onSuccess:@selector(onSuccessCallBack:)
						  onFailure:@selector(onFailureCallback:)];
	[parameters release];
	return retValue;
}

// 发送消息
// 返回值说明: 0, 1...
- (NSInteger )PostDraftToServer:(Draft *)draft {
	NSInteger retValue = -1;
	if (nil == draft) {
		assert(NO);
		return retValue;
	}
	// lichentao 2012-03-30发送将草稿保留，如果失败，存入草稿箱中
	self.sendDraft = draft;
	switch (draft.draftType) {
		case BROADCAST_MESSAGE: {			// 广播消息
			retValue = [self PostBroadcastMsgToServer:draft];
		}
			break;
		case FORWORD_MESSAGE: {				// 转发消息
			// 处理方法
			retValue = [self PostForwardMsgToServer:draft];
		}
			break;
		case COMMENT_MESSAGE: {
			retValue = [self PostCommentToServer:draft];
		}
			break;	
		case REPLY_COMMENT_MESSAGE: {		// 评论（并转播）消息
			// 处理方法
			retValue = [self PostForwardMsgToServer:draft];
		}
			break;
		case TALK_TO_MESSAGE: {
			retValue = [self PostTalkToMsgToServer:draft];
		}
			break;
		case SUGGESTION_FEEDBACK_MESSAGE:// lichentao 2012-03-06发送意见反馈,服务器目前要求是广播形式，之后可能改动
			retValue = [self PostBroadcastMsgToServer:draft];
			break;

		default:
			assert(NO);
			break;
	}
	return retValue;
}

// 发送成功回调函数
- (void)onSuccessCallBack:(NSDictionary *)dict {
    
	[[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDraftNotification" object:nil];
	if ([self.myDraftControllerDelegate respondsToSelector:@selector(DraftSendOnSuccess:)]) {
		[myDraftControllerDelegate DraftSendOnSuccess:dict];
	}
	if ([self.myDraftControllerExternalDelegate respondsToSelector:@selector(DraftExternalSendOnSuccess:)]) {
		[myDraftControllerExternalDelegate DraftExternalSendOnSuccess:dict];
	}
	// lichentao 2012-03-31 发送消息成功后将引用计数置为空
	self.sendDraft = nil;
}

// 发送失败回调函数
- (void)onFailureCallback:(NSError *)error {
	if ([self.myDraftControllerDelegate respondsToSelector:@selector(DraftSendOnFailure:)]) {
		[myDraftControllerDelegate DraftSendOnFailure:error];
		// lichentao 2012-03-30发送消息失败后,将消息保存到草稿箱更改部分
		[DataManager insertDraftToDatabase:sendDraft];
		// 更新草稿箱列表
		[[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDraftNotification" object:nil];
	}
	if ([self.myDraftControllerExternalDelegate respondsToSelector:@selector(DraftExternalSendOnFailure:)]) {
		[myDraftControllerExternalDelegate DraftExternalSendOnFailure:error];
	}
	// lichentao 2012-03-31 发送消息成功后将引用计数置为空
	self.sendDraft = nil;
}

// 根据关键字搜索好友
- (void)searchUserWithKeyword:(NSString *)keyword  AndPageIndex:(NSNumber *)pageIndex{
	NSMutableDictionary *searchUser = [NSMutableDictionary dictionaryWithCapacity:10];
	[searchUser setValue:@"json" forKey:@"format"];
	[searchUser setValue:keyword forKey:@"keyword"];
	NSString *pageSizeString = [[NSString alloc] initWithFormat:@"%d", SearchedUserCountEachTime];
	[searchUser setValue:pageSizeString forKey:@"pagesize"];
	[pageSizeString release];
	NSString *page = [[NSString alloc] initWithFormat:@"%d", [pageIndex intValue]];
	[searchUser setValue:page forKey:@"page"];
	[page release];
	[searchUser setValue:URL_SEARCH_USER forKey:@"request_api"];
	[aSyncAApi searchUserWithParamters:searchUser 
						 delegate:self 
						onSuccess:@selector(searchUserWithKeyWordOnSuccess:) 
						onFailure:@selector(searchUserWithKeyWordOnFailure:)];
}

// 搜索用户回调方法
-(void)searchUserWithKeyWordOnSuccess:(NSDictionary *)info {
	//CLog(@"info :%@", info);
	// 关键字在服务器数据库存在返回数据，否则提示没有搜索到n相关数据 // ret == 0表示数据返回成功
	//lichentao 2012-03-02修改数据类型ret代替msg字段
	if ([[info objectForKey:@"ret"] intValue] == 0) {
		NSMutableArray *usersArr = [[NSMutableArray alloc] initWithCapacity:20];
		NSDictionary *friendsData = [DataCheck checkDictionary:info forKey:@"data" withType:[NSDictionary class]];
		NSArray *infoArray = [DataCheck checkDictionary:friendsData forKey:@"info" withType:[NSArray class]];
		if (![infoArray isKindOfClass:[NSNull class]]) {
			// 接收数据
			for (NSDictionary *infoItem in infoArray) {
				[usersArr addObject:infoItem];
			}
		}
		NSNumber *num = [DataCheck checkDictionary:friendsData forKey:@"totalnum" withType:[NSNumber class]];
		if (![num isKindOfClass:[NSNull class]]) {
			NSString *totalNum =[[NSString alloc] initWithFormat:@"%@", num];
			if ([self.myDraftCtllerSearchUserDelegate respondsToSelector:@selector(searchUserOnSuccess:totalNumber:)]) {
				[myDraftCtllerSearchUserDelegate searchUserOnSuccess:infoArray totalNumber:totalNum];
			}
			[totalNum release];
		}
		else {
			if ([self.myDraftCtllerSearchUserDelegate respondsToSelector:@selector(searchUserOnSuccess:totalNumber:)]) {
				[myDraftCtllerSearchUserDelegate searchUserOnSuccess:nil totalNumber:@""];
			}
		}
		[usersArr release];		
	}else {
		if ([self.myDraftCtllerSearchUserDelegate respondsToSelector:@selector(searchUserOnSuccess:totalNumber:)]) {
			[myDraftCtllerSearchUserDelegate searchUserOnSuccess:nil totalNumber:@""];
		}
	}
}

-(void)searchUserWithKeyWordOnFailure:(NSError *)error {
	CLog(@"error:%@", [error localizedDescription]);
	if ([self.myDraftCtllerSearchUserDelegate respondsToSelector:@selector(searchUserOnFailure:)]) {
		[myDraftCtllerSearchUserDelegate searchUserOnFailure:error];
	}
}


// 热门话题成功回调
- (void)getHotTopicInfoSuccess:(NSDictionary *)result {
	NSLog(@"%s, result:%@", __FUNCTION__, result);
	UserInfo *userInfo = [UserInfo sharedUserInfo];
	NSDictionary *data = [DataCheck checkDictionary:result forKey:@"data" withType:[NSDictionary class]];
	if ([data isKindOfClass:[NSDictionary class]]) {
		NSArray *info = [DataCheck checkDictionary:data forKey:@"info" withType:[NSArray class]];
		if ([info isKindOfClass:[NSArray class]]) {
			NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:10];
			for (NSDictionary *dict in info) {
				NSString *topicName = [DataCheck checkDictionary:dict forKey:@"text" withType:[NSString class]];
				if ([topicName isKindOfClass:[NSString class]]) {
					[array addObject:topicName];
				}
			}
			NSArray *titleArray = nil;
			if ([titleArray count] >= 6) {
				titleArray = [array subarrayWithRange:NSMakeRange(0, 6)];
			}else {
				titleArray = [NSMutableArray arrayWithArray:array];
			}
			for (int i = 0; i < [titleArray count]; i++) {
				NSString *hotWord = [titleArray objectAtIndex:[titleArray count] - i - 1];
				[DataManager insertHotWordSearchToDatabase:userInfo.name hotWord:hotWord hotType:@"1"];
			}
			[array release];			
		}
	}
}

// 热门话题失败回调
- (void)getHotTopicInfoFailure:(NSError *)error {
	
}

// 更新热门话题
- (void)getHotTopicList {
	NSMutableDictionary *reqDict = [[NSMutableDictionary alloc] initWithCapacity:5];
	[reqDict setObject:@"json" forKey:@"format"];
	[reqDict setObject:@"6" forKey:@"reqnum"];
	[reqDict setObject:@"0" forKey:@"lastid"];
	[reqDict setObject:@"0" forKey:@"pageflag"];
	[reqDict setObject:URL_HOT_TOPIC forKey:@"request_api"];
	[self.aSyncAApi getHotTopicWithParamters:reqDict
								 delegate:self
								onSuccess:@selector(getHotTopicInfoSuccess:) 
								onFailure:@selector(getHotTopicInfoFailure:)];	
	[reqDict release];
}

// 已订阅话题成功回调方法
- (void)getSubscibedTopicInfoSuccess:(NSDictionary *)result{
	NSLog(@"%s, result:%@", __FUNCTION__, result);
	UserInfo *userInfo = [UserInfo sharedUserInfo];
	NSDictionary *data = [DataCheck checkDictionary:result forKey:@"data" withType:[NSDictionary class]];
	if ([data isKindOfClass:[NSDictionary class]]) {
		NSArray *info = [DataCheck checkDictionary:data forKey:@"info" withType:[NSArray class]];
		if ([info isKindOfClass:[NSArray class]]) {
			NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:10];
			for (NSDictionary *dict in info) {
				NSString *topicName = [DataCheck checkDictionary:dict forKey:@"text" withType:[NSString class]];
				if ([topicName isKindOfClass:[NSString class]]) {
					[array addObject:topicName];
				}
			}
			for (int i = 0; i < [array count]; i++) {
				NSString *hotWord = [array objectAtIndex:[array count] - i - 1];
				[DataManager insertHotWordSearchToDatabase:userInfo.name hotWord:hotWord hotType:@"0"];
			}
			[array release];						
		}
	}
}

// 已订阅话题失败回调方法
- (void)getSubscibedTopicInfoFailure:(NSError *)error{
}

// 更新收藏话题列表
- (void)getSubscibedTopicList {
	// 初始化请求字典
	NSMutableDictionary *reqDict = [[NSMutableDictionary alloc] initWithCapacity:10];
	[reqDict setValue:URL_FAV_LIST_HT forKey:@"request_api"];
	[reqDict setValue:@"json" forKey:@"format"];
	[reqDict setValue:@"6" forKey:@"reqnum"];
	[reqDict setValue:@"0" forKey:@"pageflag"];
	[reqDict setValue:@"0" forKey:@"pagetime"];
	[reqDict setValue:@"0" forKey:@"lastid"];
	[self.aSyncAApi getFavList_htWithParamters:reqDict delegate:self onSuccess:@selector(getSubscibedTopicInfoSuccess:) onFailure:@selector(getSubscibedTopicInfoFailure:)];
	[reqDict release];
}
@end
