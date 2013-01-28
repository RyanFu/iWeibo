//
//  UITableViewControllerEx.h
//  iweibo
//
//	UITableViewController扩充类
// 
//  Created by Minwen Yi on 2/24/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableCellBuilder.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadCell.h"
#import "UITableViewCellEx.h"
#import "MBProgressHUD.h"

// 获取数据类型
typedef enum {
	InvalidLoadingStatus = 0,	// 空闲状态
	FirstLoadingStatus = 1,		// 首次加载
	PullDownLoadingStatus = 2,	// 下拉刷新中
	RefreshLoadingStatus,		// 手动刷新中
	LoadMoreLoadingStatus,		// 加载更多
}LoadingDataStatus;

@interface UITableViewControllerEx : UITableViewController {
	TableCellType				tableCellType;			// 单元行数据类型
	LoadingDataStatus			loadingStatus;			// 加载数据状态标示
	NSInteger					requestNumEachTime;		// 每次请求数据个数
	EGOLastTime					egoLastTime;			// 表格标示
	BOOL						isDragging;				// 是否正在拖拽
	BOOL						showPullDown;			// 是否显示"下拉刷新"
	BOOL						showLoadMore;			// 是否显示"加载更多"
	LoadMoreStatus				loadMoreStatus;			// "加载更多"状态(在加载完成后需要手动设置状态值)
	NSMutableArray				*cellInfoArray;			// 数据存储数组(二维，因为可能存在多个section)

	EGORefreshTableHeaderView	*refreshHeaderView;		// 下拉刷新视图
	LoadCell					*loadMoreCell;			// "加载更多"视图
	
	UIImageView					*broadCastImage;		// 刷新提示标签背景
	UILabel						*broadCastLabel;		// 刷新提示标签文本
	NSString					*succeedStringFormat;	// 获取n条记录成功格式化字符串
	NSString					*noResultString;		// 没有新记录提示字符串
	UIImageView					*errorCastImage;		// 刷新提示标签失败状态图
	UIImageView					*iconCastImage;			// 刷新提示标签成功状态图
	MBProgressHUD				*errorView;				// 中间位置错误提示框
	MBProgressHUD				*MBprogress;			// 中间位置"加载中提示按钮"
	BOOL						showLabel;
}

@property (nonatomic, assign) TableCellType				tableCellType;
@property (nonatomic, assign) LoadingDataStatus			loadingStatus;
@property (nonatomic, assign) NSInteger					requestNumEachTime;	
@property (nonatomic, assign) BOOL						isDragging;	
@property (nonatomic, assign) BOOL						showPullDown;
@property (nonatomic, retain) EGORefreshTableHeaderView	*refreshHeaderView;	
@property (nonatomic, assign) BOOL						showLoadMore;
@property (nonatomic, assign) LoadMoreStatus			loadMoreStatus;
@property (nonatomic, retain) LoadCell					*loadMoreCell;
@property (nonatomic, retain) NSMutableArray			*cellInfoArray;	
@property (nonatomic, retain) UILabel					*broadCastLabel;
@property (nonatomic, retain) NSString					*succeedStringFormat;
@property (nonatomic, retain) NSString					*noResultString;
@property (nonatomic, retain) UIImageView				*broadCastImage;
@property (nonatomic, retain) UIImageView				*errorCastImage;
@property (nonatomic, retain) UIImageView				*iconCastImage;
@property (nonatomic, retain) MBProgressHUD				*errorView;
@property (nonatomic, retain) MBProgressHUD				*MBprogress;
@property (nonatomic, assign) EGOLastTime				egoLastTime;
@property (nonatomic, assign) BOOL					showLabel;

// 设置数据
-(void)updateWithObjects:(NSArray *)infoArr forSection:(NSInteger)sect;
// 插入数据到头部
-(void)addObjectsToHead:(NSArray *)infoArr forSection:(NSInteger)sect;
// 插入数据到尾部
-(void)addObjectsToTail:(NSArray *)infoArr forSection:(NSInteger)sect;

// 分割线颜色
-(UIColor *)sepColor;

// 隐藏提示框
- (void)hidebroadcastImage;
// 显示新加载数据个数
- (void)showBroadcastCount:(NSNumber *)num;
// 显示加载中提示框
- (void)showMBProgress;
// 隐藏提示框
- (void)hiddenMBProgress;
// 显示网络错误信息
- (void)showErrorView:(NSString *)errorMsg;
// 检测网路状态
-(BOOL)checkNetWorkStatus;
//+(BOOL)checkShowMapNetWorkStatus;
// 界面进入时数据初始化
-(BOOL)initData;
// 手动刷新事件(处理滚动提示，派生类需先调用super方法,并根据返回值决定是否执行刷新操作)
-(BOOL)refreshBtnClicked;
// 下拉刷新事件
-(BOOL)pullDownCellActived;
// 加载更多事件
-(BOOL)loadMoreCellActived;
// 加载完毕响应事件，没错时err置nil
// 注: 假如为加载更多，则在加载完成后需要手动设置成员loadMoreStatus状态值
-(void)dataSourceDidFinishLoadingNewData;
// 更新cell数据(派生类可重载该方法，或者在TableCellBuilder类中做相应处理)
-(void)configCell:(UITableViewCellEx *)tableCell withInfo:(id)infoId andSection:(NSInteger)sect;
@end
