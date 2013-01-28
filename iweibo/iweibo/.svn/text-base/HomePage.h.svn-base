//
//  HomePage.h
//  iweibo
//
//  Created by LiQiang on 11-12-22.
//  Copyright 2011年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "DraftController.h"
#import "LoadCell.h"
#import "Info.h"
#import "TransInfo.h"
#import "Database.h"
#import "OriginView.h"
#import "SourceView.h"
#import "Asyncimageview.h"
#import "MBProgressHUD.h"
#import "DataManager.h"
#import "DataSave.h"
#import "CustomStatusBar.h"
#import "IWeiboAsyncApi.h"
#import "Canstants.h"
#import "DetailLayout.h"
#import "HomelineCell.h"

#define NAME_CONTENT_MARGIN 20
#define CONTENT_IMAGE_MARGIN 20
#define IMAGE_OTHER_MARGIN 20

typedef enum {
	pullRefreshRequest = 0,	//下拉刷新
	loadMoreRequest = 1,	//加载更多
	firstRequest = 2,		//首次请求网络
	draftRequest = 3,		//写消息请求
	faultageRequest = 4,	//断层请求
}requestType;

typedef enum{
	calNewTimeStamp = 0,		//所有请求数据的最新记录的时间戳
	calOldTimeStamp = 1,		//所有请求数据的最久记录的时间戳
	calPullOldTimeStamp = 2,	//下拉请求的最后一条记录时间戳
	calIsTageTime,
}calTimeType;

typedef enum{
	firstRequestFromDB = 0,	//首次从数据库加载
	loadMoreFromDB = 1,		//加载更多时从数据库加载
}requestFromDBType;

extern NSString * const kThemeDidChangeNotification;

@interface HomePage : UIViewController <HomelineCellVideoDelegate,UITableViewDelegate,UITableViewDataSource, DraftControllerDelegate>{
    UITableView					*homePageTable;
	NSMutableArray				*homePageDic;
	NSMutableArray				*homePageArray;
	NSMutableArray				*transSource;
	NSMutableArray				*videoUrlList;
	NSMutableArray				*musicList;
	NSMutableArray				*draftArray;				//存储写消息数据
	NSArray						*databaseArray;
	
	UIImageView					*broadCastImage;    
	UILabel						*broadCastLabel;
	UIImageView					*errorCastImage;
	UIImageView					*IconCastImage;
	UIButton					*reloadBtn;
	UIButton					*writeWeiboBtn;
	
	EGORefreshTableHeaderView	*refreshHeaderView;
	LoadCell					*loadCell;
	
	NSString					*oldTimeStamp;				//最后一条记录的时间戳
	NSString                    *newTimeStamp;				//最新一条记录的时间戳
	NSString					*pullOldTimeStamp;			//下拉请求最久记录的时间戳
	NSString					*midNewTimeStamp;			//断层需要记录的最新记录时间戳
	NSString					*isTageTime;
	NSString					*databaseOldTimestamp;		//数据库中存储的当前请求最后一条记录的时间戳 
    NSDictionary                *plistDict;                       //换肤中图片存储字典
	NSNumber					*draftSendTimestamp;
    NSString                    *draftId;
				
	NSString					*userNameInfo;				//用户名信息
	NSString					*siteInfo;					//站点信息
	
	NSString					*imageType;					//1为头像，2为视频缩略图 3为image
	NSTimeInterval				nowTime;
	
	MBProgressHUD				*MBprogress;
	MBProgressHUD				*errorView;
	IWeiboAsyncApi				*aApi;
	DataManager					*dataToDatabase;
	DataSave					*dataSaveToClass;
	CustomStatusBar				*_statusBar;
	requestType					pushType;
	BOOL						homeButtonSelected;			//切换用户时用于判断首次登陆
	BOOL						reloading;
	BOOL						isHasNext;
	BOOL						isLoading;					//加载更多控制器
	BOOL						isDatabaseHasNext;			//数据库是否有数据，有为0，没有为1
	BOOL						hasfaultage;				//是否显示断层标志 1有断层，0没有断层
	BOOL						hasLocked;					//标识控制 0发消息  1下拉刷新
	int							draftNum;
	int							pullRefreshCount;			//刷新后回来的新的微博数量
	NSMutableDictionary			*textHeightDic;				// 保存所有timeline里边消息高度(包括源消息高度originHeight和被转发的消息高度sourceHeight)
	NSOperationQueue			*op;	// 操作队列
	
	NSUInteger					faultageRowIndex;

}

@property (nonatomic, retain) IWeiboAsyncApi		*aApi;
@property (nonatomic, retain) NSMutableArray		*homePageDic;
@property (nonatomic, retain) NSMutableArray		*homePageArray;
@property (nonatomic, retain) NSMutableArray		*musicList;
@property (nonatomic, retain) NSArray				*databaseArray;
@property (assign,getter=isReloading) BOOL			reloading;
@property (nonatomic, retain) UILabel				*broadCastLabel;
@property (nonatomic, retain) UIImageView			*broadCastImage;
@property (nonatomic, retain) UIImageView			*errorCastImage;
@property (nonatomic, retain) UIImageView			*IconCastImage;
@property (nonatomic, retain) NSString				*oldTimeStamp;
@property (nonatomic, retain) NSString				*newTimeStamp;
@property (nonatomic, retain) NSString				*midNewTimeStamp;
@property (nonatomic, retain) NSString				*pullOldTimeStamp;
@property (nonatomic, retain) NSString				*isTageTime;
@property (nonatomic, retain) NSString				*databaseOldTimestamp;
@property (nonatomic, retain) NSDictionary          *plistDict;
@property (nonatomic, retain) NSNumber				*draftSendTimestamp;
@property (nonatomic, retain) NSString              *draftId;
@property (nonatomic, assign) requestType			pushType;
@property (nonatomic, retain) CustomStatusBar		*_statusBar;
@property (nonatomic, retain) UITableView			*homePageTable;
@property (nonatomic, retain) NSMutableDictionary	*textHeightDic;
@property (nonatomic, copy) NSString				*userNameInfo;
@property (nonatomic, copy) NSString				*siteInfo;

- (void)caculateHomeline:(NSDictionary *)result;

- (void)reStructerFromDB:(requestFromDBType)readType;

- (void)getNewTimesStamp:(NSDictionary *)result;

- (void)storeInfoToArray:(NSArray *)infoQueue;
//计算返回的新的微博数
-(int)returnNewCount:(NSDictionary *)result timestampNew:(NSString *)timeStamp;
//刷新主timeline
- (void)refresh;	
//下拉刷新
- (void)reloadNewDataSource:(requestType)refreshType;
//下拉刷新数据成功回来
- (void)doneLoadingTableViewData;
//隐藏tabbar
- (void)hideTabBar:(BOOL) hidden;
//黄色提示条上移
- (void)moveUp;	
//黄色提示条下拉
- (void)moveDown;	
//刷新错误提示
- (void)doneLoadingTableViewDataWithNetError;
//设置动画效果
- (void)setAnimation;

- (void)setHomeButtonSelected;

- (void)showDraftStatus;

- (void)loadMoreStatuses;

- (void)showMBProgress;

- (void)hiddenMBProgress;
// 处理写消息展示到timeline逻辑
- (void)handleDraftSendMessage:(NSDictionary *)stsDraft;
//设置状态值
- (void)setMutex:(BOOL)status;
// 获取全局保存昵称字典
+ (NSMutableDictionary *)nickNameDictionary;
// 插入数据到当前字典
+ (void)insertNickNameToDictionaryWithDic:(NSDictionary *)sourceDic;
// 表情字典
+ (NSMutableDictionary *)emotionDictionary;

- (void)setDraftSendTime:(NSNumber *)time andID:(NSString *)draftId;
@end
