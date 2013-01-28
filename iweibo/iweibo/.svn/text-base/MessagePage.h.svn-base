//
//  MessagePage.h
//  iweibo
//
//  Created by LiQiang on 11-12-22.
//  Copyright 2011年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "HomelineCell.h"
@class EGORefreshTableHeaderView;
@class LoadCell;
@class IWeiboAsyncApi;
@class DataSave;
@class DataManager;
@class MBProgressHUD;
@class NoWebView;

typedef enum {
	mesPullRefreshRequest = 0,	//下拉刷新
	mesLoadMoreRequest = 1,		//加载更多
	mesFirstRequest = 2,		//首次请求网络
}mesRequestType;

typedef enum {
	readDataFirst = 0,			//首次读数据库
	readDataMore,				//从数据库加载更多	
}readDatabase;

@interface MessagePage : UIViewController <UITableViewDelegate,UITableViewDataSource, HomelineCellVideoDelegate>{
	
	IWeiboAsyncApi				*aApi;
	DataManager					*messageToDatabase;
	DataSave					*messageSaveToClass;
	NSMutableArray				*messageArray;
	NSMutableDictionary			*textHeightDic;
	UITableView					*messageTable;
	
	EGORefreshTableHeaderView	*refreshMessageView;
	LoadCell					*messageMore;

	NSString					*messageNewTime;
	NSString					*messageOldTime;
	NSString					*nnewWeiboId;
	NSString					*oldWeiboId;
	NSString					*mesOldTimeFromDatabase;

	NSString					*siteInfo;				//站点信息
	NSString					*userNameInfo;			//用户名信息
	
	UIImageView					*broadCastImage;
	UIImageView					*errorCastImage;
	UILabel						*broadCastLabel;
	UIImageView					*IconCastImage;
	UIImageView					*fingerView;
	NoWebView					*cupView;
	MBProgressHUD				*MBprogress;
	
	readDatabase				readDataType;
	mesRequestType				pushType;
	BOOL						hasNext;
	BOOL						isLoading;				// 异步加载时控制
	BOOL						reloading;				// 上拉刷新时
	BOOL						againLoading;			//数据库加载获取更多标志
	BOOL						messageButtonSelected;  //消息页为0未被选过，首次需加载网络
	BOOL						firstNull;
	int							pullRefreshMessageCount;	//刷新时返回的新消息数
}

@property (nonatomic, retain) UITableView				*messageTable;
@property (nonatomic, retain) EGORefreshTableHeaderView *refreshMessageView;
@property (nonatomic, retain) LoadCell					*messageMore;
@property (nonatomic, retain) IWeiboAsyncApi			*aApi;
@property (nonatomic, retain) DataSave					*messageSaveToClass;
@property (nonatomic, retain) NSMutableArray			*messageArray;
@property (nonatomic, retain) NSMutableDictionary		*textHeightDic;
@property (nonatomic, retain) DataManager				*messageToDatabase;
@property (nonatomic, retain) NoWebView					*cupView;

@property (nonatomic, retain) NSString					*messageNewTime;
@property (nonatomic, retain) NSString					*messageOldTime;
@property (nonatomic, retain) NSString					*nnewWeiboId;
@property (nonatomic, retain) NSString					*oldWeiboId;
@property (nonatomic, retain) NSString					*mesOldTimeFromDatabase;

@property (nonatomic, copy) NSString					*siteInfo;
@property (nonatomic, copy) NSString					*userNameInfo;

@property (nonatomic, assign) mesRequestType			pushType;

//根据参数类型存储信息
- (void)caculateHomeline:(NSDictionary *)result;

//刷新后返回的新消息数
-(int)returnNewCount:(NSDictionary *)result timestampNew:(NSString *)timeStamp;

//计算行高
- (CGFloat)getRowHeight:(NSUInteger)row;

//首次请求网络
- (void)firstRequest;

//显示进度条
- (void)showMBProgress;

//隐藏进度条
- (void)hiddenMBProgress;

//动画
- (void)moveDown;
//无网情况设置背景显示效果
- (void)setNoData;
//下拉刷新请求完毕后的处理
- (void)dataSourceDidFinishLoadingNewData;

- (void)doneLoadingTableViewDataWithNetError;

- (void)setMessageButtonState;

@end
