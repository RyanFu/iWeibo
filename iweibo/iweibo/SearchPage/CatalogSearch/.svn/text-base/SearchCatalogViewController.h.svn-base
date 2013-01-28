//
//  SearchCatalogViewController.h
//  iweibo
//
//  Created by ZhaoLilong on 2/23/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWeiboAsyncApi.h"
#import "Canstants_Data.h"
#import "WordListViewController.h"
#import "UITableViewControllerEx.h"
#import "NoWebView.h"
#import "MessageViewUtility.h"
#import "MBProgressHUD.h"
#import "LoadCell.h"
#import "HomelineCell.h"

/*************************************常量定义**************************************/
#define RSSBTNLEFTMARGIN	6			// rss按钮左侧空白
#define RSSBTNTOPMARGIN		6			// rss顶部空白
#define RSSBTNWIDTH			38			// rss宽度
#define RSSBTNHEIGHT			29			// rss高度
#define SEARCHBARWIDTH		330			// 搜索条宽度
#define SEARCHBARHEIGHT		40			// 搜索条高度
#define NAVBTNHEIGHT			39			// 导航按钮高度
#define NAVBTNWIDTH			106.67		// 导航按钮宽度
#define CATALOGTABLEHEIGHT	382			// 分类列表高度
#define BOTTOMHEIGHT			50			// 底部高度
#define USERLISTHEIGHT		59			// 用户列表高度
#define TOPICLISTHEIGHT		40			// 主题列表高度
#define INDICATORSIZE			58			// 网络指示宽度
/**************************************************************************************/

/*************************************检索类型*************************************/
typedef enum{
	SearchBroadType	=	0,				// 广播类型
	SearchTopicType	=	1,				// 主题类型
	SearchUserType		=	2				// 用户类型
}SearchCatalogType;
/*************************************************************************************/

@interface SearchCatalogViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, PassValueDelegate, HideKeyBoardDelegate, HomelineCellVideoDelegate>{
	BOOL							reloading;					// 加载标识符
	BOOL							isHasNext;					// 下一页标识符
	BOOL							isLoading;					// 正在加载标识符
	BOOL							fromFront;					// 从上一页面进入
	BOOL							reachEnd;					// 搜索达最低线
	BOOL							searchEnabled;				// 分类按钮响应标识
	UIView							*blackView;					// 黑色遮盖视图
	UILabel							*errorLabel;				// 错误提示标签
	LoadCell						*loadCell;					// 加载更多
	UIButton						*rssBtn;					// 订阅按钮
	UIButton						*cancelBtn;					// 取消按钮
    UIButton                        *broadBtn; 
    UIButton                        *topicBtn;
    UIButton                        *userBtn;
	NSArray							*navBtnArray;				// 分类按钮数组
	NSString						*preText;					// 从上一页面传过来的文本
	NSString						*pushType;					// 请求类型
	UITextField						*searchField;				// 搜索框文本域
	NoWebView						*cupView;					// 茶杯视图
	UITableView						*catalogTable;				// 显示列表
	UISearchBar						*mSearchBar;				// 搜索条
	UIImageView					    *searchBarView;			    // 搜索条视图
	IWeiboAsyncApi					*api;						// 网络请求接口
	NSMutableArray					*tableData;					// 列表数据
	MBProgressHUD					*mbProgress;				// 加载提示
	MBProgressHUD					*progressHUD;				// 订阅提示
	SearchCatalogType				searchType;					// 搜索类型
	NSMutableDictionary				*textHeightDic;				//存储每个cell的高度
	WordListViewController			*wordListViewController;	// 提示列表
	EGORefreshTableHeaderView		*refreshHeaderView;			// 下拉刷新视图
    NSString                        *themePath;
}

@property (nonatomic, assign)   BOOL				reachEnd;
@property (nonatomic, retain)	NSArray				*navBtnArray;
@property (nonatomic, copy)     NSString			*preText;
@property (nonatomic, copy) 	NSString			*pushType;
@property (nonatomic, retain)	UITextField			*searchField;
@property (nonatomic, retain)	UITableView			*catalogTable;
@property (nonatomic, retain)	NSMutableArray		*tableData;
@property (nonatomic, assign)   SearchCatalogType	searchType;
@property (nonatomic, retain)	NSMutableDictionary	*textHeightDic;
@property (nonatomic, retain)   NSString            *themePath;

// 返回
- (void)back;

// 显示键盘
- (void)showKeyboard;

// 隐藏键盘
- (void)hideKeyboard;

// 延迟隐藏
- (void)hideDelayed;
	
// 加载获取更多
- (void)loadMoreStatuses;  

// 隐藏加载动画
- (void) hiddenMBProgress;

// 加载数据
- (void)reloadNewDataSource;
 
// 失败回调
- (void)failureCallBack:(NSError *)error;

// 隐藏提示列表
- (void)setWordListHidden:(BOOL)hidden;
	
// 获取行高度
- (CGFloat)getRowHeight:(NSUInteger)row;

// 数据源返回新数据
- (void)dataSourceDidFinishLoadingNewData;

// 成功回调
- (void)successCallBack:(NSDictionary *)result;
 
// 将搜索文本存入数据库
- (void)storeSearchTextToDatabase:(NSString *)searchText;

// 根据输入关键字请求网络数据
- (void)requestData:(NSString *)keyWord page:(NSString *)page;

// 数据类型转换
- (TransInfo *)convertSourceToTransInfo:(NSDictionary *)tSource;
  
@end
