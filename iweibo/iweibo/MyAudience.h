//
//  MyAudience.h
//  iweibo
//
//  Created by LiQiang on 11-12-27.
//  Copyright 2011年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IWeiboAsyncApi;
@class EGORefreshTableHeaderView;
@class LoadCell;
@class DataSave;
@class MBProgressHUD;
@class NoWebView;

typedef enum{
	audienRequestFirst = 0,
	audienRequestLoadMore,
	audienRequestPullRefresh,
}audienRequestType;

extern NSString *const kThemeDidChangeNotification;

@interface MyAudience : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	int							currentPage;				// 当前页
	int							controllerType;			// 控制器类型
	BOOL						isLoading;				// 异步加载时控制
	BOOL						_reloading;				// 上拉刷新时
	BOOL						hasNext;				// 是否需要加载获取更多
	BOOL						hasBack;				// 返回数据标识
	UILabel						*broadCastLabel;			// 更新条数标签
	LoadCell					*audienceMore;			// 加载更多
	NSString					*name;					// 用户名
	audienRequestType			pushType;				// 0-下拉刷新 1-加载更多 2- 首次请求网络	
	DataSave					*audienceSave;			// 数据存储对象
	NoWebView					*cupView;				// 杯子视图（即错误提示）
	UITableView					*audienceTable;			// 听众列表
	UIImageView					*broadCastImage;		// 更新默认图
	UIImageView					*errorCastImage;			// 更新错误图
	UIImageView					*IconCastImage;			// 蒲公英图片
	IWeiboAsyncApi				*aApi;					// 网络请求对象
	NSMutableArray				*audienceArray;			// 听众数组
	NSArray						*lastSaveArray;			// 保留最后一次数组用于比较
	EGORefreshTableHeaderView	*refreshHeaderView;		// 列表顶端视图
//	LisAndAudiComm			*lisAndAudi;				
	MBProgressHUD				*MBprogress;			// 加载提示
	NSString					*audNum;				// 听众数
	BOOL						showProgress;			// 显示加载标识
    UIButton                    *leftButton;
}

// 属性声明
@property (nonatomic, assign) int					controllerType;
@property (nonatomic, copy)	  NSString				*name;
@property (nonatomic, retain) NSString				*audienNewTime;
@property (nonatomic, retain) UITableView			*audienceTable;
@property (nonatomic, retain) IWeiboAsyncApi		*aApi;
@property (nonatomic, retain) NSMutableArray		*audienceArray;
@property (nonatomic, retain) NSArray				*lastSaveArray;
@property (nonatomic, assign) audienRequestType		pushType;
@property (nonatomic, copy)	NSString			*audNum;

// 初始化方法
- (id)initWithName:(NSString *)name;
 
// 显示加载视图
- (void)showMBProgress;
 
// 隐藏加载视图
- (void)hiddenMBProgress;

// 设置错误状态
- (void)setErrorState;

// 设置无数据状态
- (void)setNoData;

// 完成列表数据更新并显示提示
- (void)doneLoadingTableViewData;

// 获取昵称和位置的最大长度
- (CGFloat)getMaxWidth:(CGSize)nameSize andLocationSize:(CGSize)locationSize;

@end
