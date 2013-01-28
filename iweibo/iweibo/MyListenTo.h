//
//  MyListenTo.h
//  iweibo
//
//  Created by LiQiang on 11-12-27.
//  Copyright 2011年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IWeiboAsyncApi;
@class LoadCell;
@class EGORefreshTableHeaderView;
@class MBProgressHUD;
@class DataSave;
@class NoWebView;

typedef enum{
	listenRequestFirst = 0,
	listenRequestLoadMore,
	listenRequestPullRefresh,
}listenRequestType;

extern NSString *const kThemeDidChangeNotification;

@interface MyListenTo : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	int							currentPage;				// 当前页
	int							controllerType;			// 控制器类型
	BOOL						isLoading;				// 异步加载时控制
	BOOL						_reloading;				// 上拉刷新时
	BOOL						hasNext;				//是否需要加载获取更多
	BOOL						hasBack;				// 数据返回标识
	UILabel						*broadCastLabel;			// 数据更新标签
	NSString					*listenNewTime;			// 时间戳
	NSString					*name;					// 用户名
	listenRequestType			pushType;				// 请求类型
	LoadCell					*listenMore;				// 加载更多
	DataSave					*listenDataSave;			// 数据存储
	UITableView					*listenTable;				// 听众列表
	NoWebView					*cupView;				// 杯子视图（即错误提示）
	UIImageView					*broadCastImage;		// 数据更新图片
	UIImageView					*errorCastImage;			// 更新错误图片
	UIImageView					*IconCastImage;			// 蒲公英图片
	IWeiboAsyncApi				*aApi;					// 网络请求对象
	NSMutableArray				*listenArray;				// 听众数组
	NSArray						*lastSaveArray;			// 保留最后一次数组用于比较
	MBProgressHUD				*MBprogress;			// 加载提示
	//LisAndAudiComm			*lisAndAudi;			
	EGORefreshTableHeaderView	*refreshHeaderView;		// 顶端更新视图
	NSString					*lisNum;					// 收听数
	BOOL						showProgress;			// 显示加载标识
    UIButton                    *leftButton;
}

@property (nonatomic, retain) IWeiboAsyncApi		*aApi;
@property (nonatomic, retain) UITableView			*listenTable;
@property (nonatomic, retain) NSMutableArray		*listenArray;
@property (nonatomic, retain) NSArray				*lastSaveArray;
@property (nonatomic, assign) listenRequestType		pushType;
@property (nonatomic, retain) DataSave				*listenDataSave;
@property (nonatomic, retain) NSString				*name;
@property (nonatomic, retain) NSString				*listenNewTime;
@property (nonatomic, assign) int					controllerType;
@property (nonatomic, copy) NSString				*lisNum;	

- (id)initWithName:(NSString *)name1;
// 设置无数据状态
- (void)setNoData;

// 设置错误状态
- (void)setErrorState;

// 设置加载状态
- (void)showMBProgress;

// 完成列表数据更新并显示提示
- (void)doneLoadingTableViewData;

- (void)storeListenInfoToArray:(NSDictionary *)info;
- (void)dataSourceDidFinishLoadingNewData;
- (void)reloadNewDataSource;

// 隐藏加载状态
- (void)hiddenMBProgress;

// 加载新数据
- (void)reloadNewDataSource;

// 更新返回新数据
- (void)dataSourceDidFinishLoadingNewData;

@end
