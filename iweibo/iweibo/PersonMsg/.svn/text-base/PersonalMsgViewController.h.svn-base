//
//  PersonalMsgViewController.h
//  iweibo
//
//  Created by LiQiang on 12-1-29.
//  Copyright 2012年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
///////
#import "IWeiboAsyncApi.h"
#import "Canstants_Data.h"
#import "Info.h"
#import "OriginView.h"
#import "iweiboAppDelegate.h"
#import "MBProgressHUD.h"
#import "LoadMoreCell.h"
#import "IWeiboSyncApi.h"
#import "Reachability.h"
#import "DetailsPage.h"

/////////////
@class PersonalMsgHeaderView;
@class CellZeroView;
@class CellOneView;
@class PersonalMsgModel;
@class IWeiboAsyncApi;
@class MBProgressHUD;
@interface PersonalMsgViewController : UIViewController <HomelineCellVideoDelegate,
															   UITableViewDelegate,
															 UITableViewDataSource,
															 OriginViewUrlDelegate,
														   OriginViewVideoDelegate,
															  SourceViewUrlDelegate> {
	UITableView                     *listMsgView;
    PersonalMsgHeaderView           *headerView;
    NSMutableArray                  *dataSourceArr;
    CellZeroView                    *cellZero;
    CellOneView                     *cellOne;
    PersonalMsgModel                *personMsg;

    NSDictionary                    *tempPersonMsgDic;
    NSString                        *accountName;
    UIButton                        *rightBtn;
    UIBarButtonItem                 *rightBarBtn;
//    IWeiboAsyncApi                  *api;
    MBProgressHUD                   *MBprogress;	
    UIImageView                     *arrawImage;
                                                                  
    int                             fisrt;
    int                             cell0Height;
    int                             cell0OpenStatus;
    int                             oddEven;
    int                             pushControllerType;

	int                             n;
	BOOL                            _reloading;
	BOOL                            reachEnd;                   // 搜索达最低线
	NSString                        *oldTime;					// 向下翻页最后一条记录的时间
	NSString                        *lastid;					// 向下翻页最后一条记录的id
	NSString                        *nNewTime;
	NSString                        *sinceTime;
	NSString                        *pushType;
	LoadCell                        *loadCell;
	MBProgressHUD                   *MBprogress1;
	NSMutableArray                  *infoArray;
	IWeiboAsyncApi                  *aApi;
	/////////////////////////
    NSMutableDictionary             *heights;
	BOOL                            bSendingListenOperRequest;
}
@property(nonatomic,retain) UITableView         *listMsgView;
@property(nonatomic,retain) NSMutableArray      *dataSourceArr;
@property(nonatomic,retain) NSDictionary        *tempPersonMsgDic;
@property(nonatomic,retain) NSString            *accountName;
@property(nonatomic,retain) IWeiboAsyncApi      *aApi; 
@property(nonatomic,retain) UIImageView         *arrawImage;
@property(nonatomic,assign) int                 cell0Height;
@property(nonatomic,assign) int                 cell0OpenStatus;
@property(nonatomic,assign) int                 first;
@property(nonatomic,assign) int                 oddEven;
@property(nonatomic,assign) int                 pushControllerType;

- (void)talkBtnClickedAction;
- (void)listenerBtnAction;
- (void)listenToBtnAction;
- (void)tableViewDataSource;
- (void)changeHeaderViewData;
- (void)addTitleAndRightBarBtn;
- (void)showMBProgress;
- (void)hiddenMBProgress;
- (void)showErrorView:(NSString *)errorMsg;
/////////////////////////////
@property (nonatomic, assign) BOOL                  reachEnd;
@property (nonatomic, retain) NSString              *oldTime;
@property (nonatomic, retain) NSString              *lastid;
@property (nonatomic, retain) NSString              *nNewTime;
@property (nonatomic, retain) NSString              *sinceTime;
@property (nonatomic, retain) NSString              *pushType;
@property (nonatomic, retain) NSMutableArray        *infoArray;
@property (nonatomic, retain) NSMutableDictionary   *heights;

- (void)requestSuccessCallBack:(NSDictionary *)dic;
- (void)requestFailureCallBack:(NSError *)error;
- (CGFloat)getRowHeight:(NSUInteger)row;
- (TransInfo *)convertSourceToTransInfo:(NSDictionary *)tSource;
-(void) requstWebService:(NSString *)pageflag:(NSString *)pagetime:(NSString *)type:(NSString *)contenttype;
////////////////////////////////////
@end
