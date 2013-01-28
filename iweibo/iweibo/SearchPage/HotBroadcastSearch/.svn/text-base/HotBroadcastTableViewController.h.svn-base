//
//  HotBroadcastTableViewController.h
//  iweibo
//
//  Created by Minwen Yi on 2/24/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewControllerEx.h"
#import "IWeiboAsyncApi.h"

// 单次请求数据个数
#define HotBroadcastInfoReqNum				30
#define HotBroadcastOldestLocalID			@"HBOldestLocalID"

extern NSString * const kThemeDidChangeNotification;

@interface HotBroadcastTableViewController : UITableViewControllerEx {
	IWeiboAsyncApi					*asyncApi;					// 网络请求对象
	NSString						*lastID;					// 本页起始local_id(由于没有上拉刷新，保存的永远为最后一条记录id)
	NSNumber						*hasNext;					// 0-表示还有微博可拉取，1-已拉取完毕 
	BOOL							isLoadFromDB;				// 是否从数据库加载数据
    UIButton                        *leftButton;
}

@property (nonatomic, retain) NSString					*lastID;
@property (nonatomic, retain) NSNumber					*hasNext;
@property (nonatomic, assign) BOOL						isLoadFromDB;
@property (nonatomic, retain) UIButton                  *leftButton;

// 点击视频url
-(void)videoImageClicked:(NSString *)urlString;

// 界面进入时数据初始化
-(BOOL)initData;

// 父类方法继承
// 手动刷新事件(演示用法，无实际意义)
-(BOOL)refreshBtnClicked;
// 下拉刷新事件
-(BOOL)pullDownCellActived;
// 加载更多事件
-(BOOL)loadMoreCellActived;

// 从网络获取数据
- (void)loadHotBroadcastWithPageflag:(NSString *)pageflag lastID:(NSString *)lastIDString andType:(NSString *)type;
@end
