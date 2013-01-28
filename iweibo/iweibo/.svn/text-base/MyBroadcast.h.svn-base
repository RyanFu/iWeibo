//
//  MyBroadcast.h
//  iweibo
//
//  Created by LiQiang on 11-12-27.
//  Copyright 2011年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWeiboAsyncApi.h"
#import "Canstants_Data.h"
#import "Info.h"
#import "OriginView.h"
#import "iweiboAppDelegate.h"
#import "MBProgressHUD.h"
#import "LoadMoreCell.h"
#import "IWeiboSyncApi.h"
#import "NoWebView.h"

extern NSString *const kThemeDidChangeNotification;

@interface MyBroadcast : UIViewController<HomelineCellVideoDelegate,UITableViewDelegate,UITableViewDataSource, OriginViewUrlDelegate, OriginViewVideoDelegate, SourceViewUrlDelegate> {
	IWeiboAsyncApi				*api;
	UITableView					*broadcastTable;
	NSMutableArray				*infoArray;
	MBProgressHUD				*MBprogress;
	DataSave					*saveBroadcast;
	EGORefreshTableHeaderView	*_refreshHeaderView;
	LoadMoreCell				*broadLoadmore;
	UIImageView					*broadImage;
	UIImageView					*errorImage;
	UIImageView					*iconImage;
	UILabel						*broadLabel;
    UIButton                    *leftButton;
	BOOL						_reloading;
	BOOL						isHasNext;
	BOOL						isLoading;
	NSTimer						*broadTimer;
	NSString					*oldTime;					// 向下翻页最后一条记录的时间
	NSString					*lastid;					// 向下翻页最后一条记录的id
	NSString					*nNewTime;
	NSString					*sinceTime;
	NSString					*pushType;
	int							n;
	LoadCell					*loadCell;
	BOOL						reachEnd;				// 搜索达最低线
	NoWebView					*cupView;
	NSMutableDictionary			*textHeightDic;			//存储每个cell的高度

}

@property (nonatomic, retain) IWeiboAsyncApi	*api;
@property (nonatomic, retain) UITableView		*broadcastTable;
@property (nonatomic, retain) NSMutableArray	*infoArray;
@property (nonatomic, retain) DataSave			*saveBroadcast;
@property (nonatomic, retain) UIImageView		*broadImage;
@property (nonatomic, retain) UIImageView		*errorImage;
@property (nonatomic, retain) UIImageView		*iconImage;
@property (nonatomic, retain) UILabel			*broadLabel;
@property (nonatomic, retain) NSTimer			*broadTimer;
@property (nonatomic, retain) NSString			*oldTime;
@property (nonatomic, retain) NSString			*lastid;
@property (nonatomic, retain) NSString			*nNewTime;
@property (nonatomic, retain) NSString			*sinceTime;
@property (nonatomic, retain) NSString			*pushType;
@property (nonatomic, assign) BOOL				reachEnd;
@property (nonatomic, retain) NSMutableDictionary	*textHeightDic;	

-(void) requstWebService:(NSString *)pageflag:(NSString *)pagetime:(NSString *)type:(NSString *)contenttype;
- (TransInfo *)convertSourceToTransInfo:(NSDictionary *)tSource;
- (void)dataSourceDidFinishLoadingNewData;
- (void)requestSuccessCallBack:(NSDictionary *)dic;
- (void)requestFailureCallBack:(NSError *)error;
- (CGFloat)getRowHeight:(NSUInteger)row;
- (void) showMBProgress;
- (void) hiddenMBProgress;

@end
