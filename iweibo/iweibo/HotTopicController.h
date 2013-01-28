//
//  HotTopicController.h
//  iweibo
//
//  Created by lichentao on 12-2-23.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonMethod.h"
#import "LoadCell.h"

extern NSString * const kThemeDidChangeNotification;

@interface HotTopicController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	IWeiboAsyncApi		*aApi;
	UITableView			*hotTopicTableList; // 热门话题tableView
	NSMutableArray		*hotTopicArray;		// 热门话题数组
	MBProgressHUD		*HUD;				// 网络错误提示
	LoadCell			*moreCell;			// 加载更多
	NSNumber			*hasNext;			// 是否还有更多数据0 表示有 1标识没有
    UIButton            *backBtn;
	BOOL				LOADING;			// YES可以加载，数据返回之前NO 数据返回来后置为YES避免重复加载
}
@property (nonatomic, retain) UITableView		*hotTopicTableList;
@property (nonatomic, retain) UIButton          *backBtn;
@property (nonatomic, retain) NSMutableArray	*hotTopicArray;
@property (nonatomic, copy)	  NSNumber			*hasNext;	
@property (nonatomic, retain) IWeiboAsyncApi	*aApi;
// 隐藏状态提示
- (void)hideHUD;
// 请求热门话题接口
- (void)requestHotTopicServer:(NSString *)pageFlag setLastID:(NSString *)lastid;
@end