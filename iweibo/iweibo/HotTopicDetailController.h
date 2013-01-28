//
//  HotTopicDetailController.h
//  iweibo
//
//  Created by lichentao on 12-2-27.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "MessagePage.h"
#import "HomelineCell.h"
@class EGORefreshTableHeaderView;
@class LoadCell;
@class IWeiboAsyncApi;
@class DataSave;
@class MBProgressHUD;

extern NSString * const kThemeDidChangeNotification;

@interface HotTopicDetailController : UIViewController <UITableViewDelegate,UITableViewDataSource,HomelineCellVideoDelegate>{
	
	IWeiboAsyncApi				*aApi;							// 请求服务器api
	DataSave					*messageSaveToClass;			// 保存数据
	NSMutableArray				*hotTopicDetailArray;			// 数据源数组
	NSMutableDictionary			*textHeightDic;					// 保存高度字典
	UITableView					*hotTopicDetailTableList;		// 数据表		
	EGORefreshTableHeaderView	*refreshMessageView;			// 下拉刷新
	LoadCell					*messageMore;					// 加载更多
	NSString					*messageNewTime;				// 时间戳最新时间
	NSString					*messageOldTime;				// 时间戳上一次时间
	NSString					*nnewWeiboId;
	NSString					*oldWeiboId;
	UIImageView					*broadCastImage;				// 状态提示网络错误
	UIImageView					*errorCastImage;
	UILabel						*broadCastLabel;
	UIImageView					*IconCastImage;
	MBProgressHUD				*MBpro;
	mesRequestType				pushType;						// 请求类型,第一次请求，上啦刷新还是加载更多
	BOOL						isLoading;						// 加载更多 ,下拉刷新逻辑控制器,避免快速多次请求
	NSString					*searchString;					// 标题和加载关键字
	NSString					*pageInfoString;				// 请求服务器参数,每次请求返回一个pageInfo，下次在请求，上传此pageInfo
	NSNumber					*hasNext;						// 是否还有数据hasnext:2-表示不能往上翻，1-表示不能往下翻，0-表示两边都可以翻，3-表示两边都不能翻
	CGFloat						totalCellHeight;				// tableView Cell总的高度在此类中用于和偏移量比较，判断是否加载更多
	BOOL						isSubscription;					// 是否已订阅话题
	UIButton					*subscriptionButton;			// 订阅话题按钮
    BOOL                        bInSubscription;                // 是否已点击订阅按钮
    UIButton                    *writeWeiboBtn;                  // 写消息按钮
	NSString					*hotTopicIDString;				// 话题id
	int							hotPullRefreshCount;
    UIButton                    *leftButton;
}

@property (nonatomic, retain) UITableView				*hotTopicDetailTableList;
@property (nonatomic, retain) EGORefreshTableHeaderView *refreshMessageView;
@property (nonatomic, retain) LoadCell					*messageMore;
@property (nonatomic, retain) IWeiboAsyncApi			*aApi;
@property (nonatomic, retain) DataSave					*messageSaveToClass;
@property (nonatomic, retain) NSMutableArray			*hotTopicDetailArray;
@property (nonatomic, retain) NSMutableDictionary		*textHeightDic;
@property (nonatomic, retain) NSString					*messageNewTime;
@property (nonatomic, retain) NSString					*messageOldTime;
@property (nonatomic, retain) NSString					*nnewWeiboId;
@property (nonatomic, retain) NSString					*oldWeiboId;
@property (nonatomic, assign) mesRequestType			pushType;
@property (nonatomic, copy) NSString					*searchString;
@property (nonatomic, copy) NSString					*pageInfoString;	
@property (nonatomic, copy) NSNumber					*hasNext;
@property (nonatomic, retain)NSString					*hotTopicIDString;
@property (nonatomic, retain) UIImageView					*IconCastImage;
@property (nonatomic, retain)	UIImageView					*errorCastImage;
@property (nonatomic, retain) UILabel						*broadCastLabel;
@property (nonatomic, retain) UIImageView					*broadCastImage;				// 状态提示网络错误

- (void)caculateHomeline:(NSDictionary *)result;									// 保存数据
- (CGFloat)getRowHeight:(NSUInteger)row;											// 获取行高，字典保存
- (void)setNoData;																	// 没有数据动画提示
- (void)hiddenMBProgress;															// 隐藏状态提示								
- (TransInfo *)convertSourceToTransInfo:(NSDictionary *)tSource;					// 类型转换
- (BOOL)isHasHotTopic;		// 数据库中是否有该话题

@end
