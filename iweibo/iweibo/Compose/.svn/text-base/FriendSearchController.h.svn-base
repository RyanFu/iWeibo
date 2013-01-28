//
//  FriendSearchController.h
//  iweibo
//
//  Created by LICHENTAO on 11-12-31.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraftController.h"
#import "NetSearchController.h"
#import "MBProgressHUD.h"
#import "iweiboAppDelegate.h"
#import "FriendSearchTableViewCell.h"

@protocol FriendSearchControllerDelegate ;

extern  NSString * const kThemeDidChangeNotification;

@interface FriendSearchController : UIViewController<UITableViewDelegate,
UITableViewDataSource,UISearchBarDelegate, DraftCtrllerSearchUserDelegate, NetSearchControllerDelegate> {
	
	UITableView		*friendTableList;		// 数据表格
	UISearchBar		*friendSearchBar;		// 搜索框
    UIButton        *leftButton;
	NSMutableArray	*friendArray;			// 好友数据
	NSMutableArray  *filterFriendArray;		// 好友列表
	NSMutableArray	*sectionArray;			// 存放以字母a_z开头的数组的数组集合
	NSMutableArray	*cCopySectionArray;		// sectionArray copyg
	NSString		*comnonContact;			// 常用联系人plist
	NSUInteger		count;					// 加载次数计数器
	
	UIView			*blackCoverView;		// 
	MBProgressHUD	*progressHD;			// 网络加载提示
	NSString		*sectionName;			// section name

    BOOL            bNeedReturn;            
    
    // 数据拉取相关
    MBProgressHUD   *MBprogress;            // 加载
    IWeiboAsyncApi  *requestApi;            // 网络请求接口
    BOOL            bStartGettingFriends;   // 是否正在拉取好友
    NSUInteger      unFriendsCnt;           // 已获取个数
	id<FriendSearchControllerDelegate> myFriendSearchControllerDelegate;
}

@property (nonatomic, retain) NSMutableArray	*friendArray;
@property (nonatomic, retain) NSMutableArray    *filterFriendArray;
@property (nonatomic, retain) NSMutableArray	*sectionArray;
@property (nonatomic, retain) NSMutableArray	*cCopySectionArray;
@property (nonatomic, retain) NSString			*comnonContact;
@property (nonatomic, assign) NSUInteger		count;
@property (nonatomic, retain) UITableView		*friendTableList;
@property (nonatomic, retain) UISearchBar		*friendSearchBar;
@property (nonatomic, retain) UIView			*blackCoverView;
@property (nonatomic, retain) UIButton          *leftButton;
@property (nonatomic, assign) id<FriendSearchControllerDelegate> myFriendSearchControllerDelegate;
@property (nonatomic, assign) BOOL              bNeedReturn; 
- (void) initData;
- (void) getComonContactList;
- (void) back:(id)sender;
- (void) hideProgressHD;

// 更新好友信息
// bNeedUpdateFromSvr: 本地数据为空的情况下是否去网络更新
- (void)getFriendsFansListWithUpdateStatus:(BOOL)bNeedUpdateFromSvr;
// 网络获取好友信息
- (void)getFriendsFansListFromServer;

@end
@protocol FriendSearchControllerDelegate <NSObject>
- (void)FriendsFansItemClicked:(NSString *)ItemName;
- (void)FriendsFansCancelBtnClicked;

@end
