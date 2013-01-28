//
//  DraftController.h
//  iweibo
//
//	草稿相关操作
//
//  Created by Minwen Yi on 12/29/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Draft.h"
#import "IWeiboAsyncApi.h"

// 单次获取的好友个数
#define FriendFansListCountEachTime				20
// 单次获取已订阅话题个数
#define MyFavTopicsCountEachTime				15
// 单次获取搜索用户个数
#define SearchedUserCountEachTime				20

// 协议
@protocol DraftControllerDelegate;
@protocol DraftCtrllerGetSearchListDelegate;
@protocol DraftCtrllerSearchUserDelegate;
@protocol DraftCtrllerDraftListDelegate;
// 2012-03-08 By Yi Minwen 发消息时额外的发送状态协议
// 说明: 默认都通过DraftControllerDelegate发送到iweiboAppDelegate，但假如通过草稿箱发送的，需要获取最终发送状态
@protocol DraftControllerExternalDelegate;

@interface DraftController : NSObject {
	IWeiboAsyncApi							*aSyncAApi;				// 网络通讯控制类对象
	id<DraftControllerDelegate>				myDraftControllerDelegate;
	id<DraftCtrllerGetSearchListDelegate>	myDraftControllerFansListDelegate;
	id<DraftCtrllerSearchUserDelegate>		myDraftCtllerSearchUserDelegate;
	id<DraftCtrllerDraftListDelegate>       myDraftCtrllerDraftListDelegate;
	id<DraftControllerExternalDelegate>		myDraftControllerExternalDelegate;
	
	// 单次获取话题列表请求辅助参数
	BOOL									bStartGettingMyFavTopics;		// 是否正在请求	
	NSString								*myFavTopicsLastID;		// 翻页用，第一页时：填0；继续向上翻页：填上一次请求返回的第一条记录id；继续向下翻页：填上一次请求返回的最后一条记录id
	NSNumber								*myFavTopicsPageTime;	//翻页用，第一页时：填0；向上翻页：填上一次请求返回的第一条记录时间；向下翻页：填上一次请求返回的最后一条记录时间
	NSInteger								myFavTopicspageFlag;			// 翻页标识（0：首页 1：向下翻页 2：向上翻页）
	NSInteger								pageCount;
	Draft *sendDraft;						// lichentao 2012-03-30发送消息保留草稿数据
}

// 全局唯一共享实例
+ (DraftController *)sharedInstance;

@property (nonatomic, retain) IWeiboAsyncApi							*aSyncAApi;	
@property (nonatomic, assign) id<DraftControllerDelegate>				myDraftControllerDelegate; 
@property (nonatomic, assign) id<DraftCtrllerGetSearchListDelegate>		myDraftControllerFansListDelegate;
@property (nonatomic, assign) id<DraftCtrllerSearchUserDelegate>		myDraftCtllerSearchUserDelegate;
@property (nonatomic, assign) id<DraftCtrllerDraftListDelegate>			myDraftCtrllerDraftListDelegate;
@property (nonatomic, assign) id<DraftControllerExternalDelegate>		myDraftControllerExternalDelegate;
@property (nonatomic, assign) BOOL										bStartGettingMyFavTopics;
@property (nonatomic, copy) NSString									*myFavTopicsLastID;
@property (nonatomic, assign) NSInteger									myFavTopicspageFlag;
@property (nonatomic, retain) Draft  *sendDraft;

// 快捷生成Draft类型对象
//- (Draft *)buildDraftWithType:(ComposeMsgType)enumType Text:(NSString *)draftText AndImageData:(NSData *)data;
//- (void)disposeDraft:(Draft *)draftContext;
// 获取话题列表
- (void)getMyFavTopicsList;
// 更新好友列表
- (void)updateFriendsFansList;
// 获取好友列表
- (void)getFriendsFansList;
// 根据关键字搜索好友
- (void)searchUserWithKeyword:(NSString *)keyword AndPageIndex:(NSNumber *)pageIndex;

// 获取草稿内容
- (void)getDraftListFromDB;
-  (NSMutableArray *)mySimpleDraftListFromDB;

// 发送消息
// 返回值说明: 0, 1...
- (NSInteger )PostDraftToServer:(Draft *)draft;

// 更新热门话题
- (void)getHotTopicList;
// 更新收藏话题列表
- (void)getSubscibedTopicList;

// 读取草稿箱中草稿个数
// 读取草稿列表
// 读取草稿详细信息
@end

//	从数据库中读取草稿数据
@protocol DraftCtrllerDraftListDelegate <NSObject>
- (void)draftListSuccess:(NSArray *)info;
- (void)draftListFailure:(NSError *)error;
@end

// 协议
// 发送带图片消息是异步回调方法
@protocol DraftControllerDelegate <NSObject>
-(void)DraftSendOnSuccess:(NSDictionary *)dict;
-(void)DraftSendOnFailure:(NSError *)error;
@end

@protocol DraftCtrllerGetSearchListDelegate <NSObject>
// 获取好友列表回调方法
-(void)getFriendsFansListOnSuccess:(NSArray *)info;
-(void)getFriendsFansListOnFailure:(NSError *)error;
// 获取话题列表回调方法
-(void)getMyFavTopicsOnSuccess:(NSArray *)info;
-(void)getMyFavTopicsOnFailure:(NSError *)error;
@end

@protocol DraftCtrllerSearchUserDelegate <NSObject>
// 搜索用户回调方法
//-(void)searchUserOnSuccess:(NSArray *)info;
-(void)searchUserOnSuccess:(NSArray *)info totalNumber:(NSString *)totalNum;
-(void)searchUserOnFailure:(NSError *)error;
@end

@protocol DraftControllerExternalDelegate<NSObject>
@optional
-(void)DraftExternalSendOnSuccess:(NSDictionary *)dict;
-(void)DraftExternalSendOnFailure:(NSError *)error;
@end
