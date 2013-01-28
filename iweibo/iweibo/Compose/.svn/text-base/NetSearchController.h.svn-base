//
//  NetSearchController.h
//  TableDemo
//
//  Created by lichentao on 12-1-11.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraftController.h"
#import "LoadCell.h"
#import "AsynchronousImageView.h"
#import "MBProgressHUD.h"

@protocol NetSearchControllerDelegate;

extern NSString *const kThemeDidChangeNotification;

@interface NetSearchController : UIViewController<UITableViewDelegate,UITableViewDataSource,DraftCtrllerSearchUserDelegate> {

	UITableView						*netTableList;	// 网络好友列表
	NSMutableArray					*netArray;		// 网络搜索数据
	NSString						*moreString;	// 搜索关键字
	NSInteger						count;			// 请求次数
	NSMutableArray					*infoMoreArray;	// 网络返回数据数组
	MBProgressHUD					*proHD;
	NSString						*totalNum;		// 网络搜索好友总量;
	LoadCell						*moreCell;		// 加载更多
    UIButton                        *leftButton;
    id                              parentID;
	id<NetSearchControllerDelegate>	myNetsearchControllerDelegate;
}

@property (nonatomic, retain) UITableView		*netTableList;
@property (nonatomic, retain) NSMutableArray	*netArray;
@property (nonatomic, retain) NSString			*moreString;
@property (nonatomic, retain) NSMutableArray	*infoMoreArray;
@property (nonatomic, retain) NSString			*totalNum;
@property (nonatomic, assign) id<NetSearchControllerDelegate>	myNetsearchControllerDelegate;
@property (nonatomic, assign) id                              parentID;

// 检测网络状态YES/NO
- (BOOL)connectionStatus;
// 加载更多方法
- (void)loadMoreCell;
@end

@protocol NetSearchControllerDelegate <NSObject>
- (void)NetSearchItemClicked:(NSDictionary *)ItemDic;
@end
