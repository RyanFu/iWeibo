//
//  DetailsPage.h
//  iweibo
//
//  Created by LiQiang on 11-12-23.
//  Copyright 2011年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeBaseViewController.h"
#import "DetailCell.h"
#import "CommOrTransInfo.h"
@class DetailView;
@class Info;
@class TransInfo;
@class LoadCell;
@class IWeiboSyncApi;

typedef enum{
	personalDataAction,
	broadcastAction,
	commentsAction,
	dialogueAction
}ActionType;

extern NSString *const KThemeDidChangeNotification;

@interface DetailsPage : UIViewController<DetailCellDelegate, UIAlertViewDelegate, UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource>{
	IWeiboAsyncApi		*aApi;
	DetailView			*detailHeaderView;
	UITableView			*listView;
	Info				*homeInfo;
	TransInfo			*sourceInfo;
	
	NSMutableDictionary	*heightDiction;
    NSDictionary        *plistDic;
	LoadCell			*loadMoreCell;
	NSMutableArray		*detailArray;
	
	NSString			*oldTimeStamp;
	
	UIImageView			*errorCastImage;
	UIImageView			*IconCastImage;
	UIImageView			*broadCastImage;
	UILabel				*broadCastLabel;
	UIButton            *leftButton;
    
	ActionType			actionType;
	NSUInteger			rowNum;
	CGFloat				oHeight;
	CGFloat				sHeight;
	int					rootContrlType;
	BOOL				isLoading;
	BOOL				firstLogin;
	
}

@property (nonatomic, retain) DetailView			*detailHeaderView;
@property (nonatomic, retain) UITableView			*listView;
@property (nonatomic, retain) Info					*homeInfo;
@property (nonatomic, retain) TransInfo				*sourceInfo;
@property (nonatomic, retain) NSMutableDictionary	*heightDiction;
@property (nonatomic, retain) IWeiboAsyncApi		*aApi;
@property (nonatomic, assign) CGFloat				oHeight;
@property (nonatomic, assign) CGFloat				sHeight;
@property (nonatomic, retain) LoadCell				*loadMoreCell;
@property (nonatomic, retain) NSMutableArray		*detailArray;
@property (nonatomic, retain) NSString				*oldTimeStamp;
@property (nonatomic, retain) UIImageView			*errorCastImage;
@property (nonatomic, retain) UIImageView			*IconCastImage;
@property (nonatomic, retain) UIImageView			*broadCastImage;
@property (nonatomic, retain) UILabel				*broadCastLabel;
@property (nonatomic, retain) UIButton              *leftButton;
@property (nonatomic, assign) int					rootContrlType;
@property (nonatomic, assign) ActionType			actionType;
@property (nonatomic, retain) NSDictionary          *plistDic;

//@property (nonatomic, assign) CGFloat		heightx;

- (void)transmitBtnAction;
- (void)commentBtnAction;
- (void)speakToBtnAction;
- (void)moreMsgBtnAction;
- (NSUInteger) returnCount:(NSDictionary *)dic;
//- (BOOL)initSendDraft :(ForwardMsgViewController *)forwardMsgController draftType:(ComposeMsgType)draftType;// 草稿内容
- (BOOL)initSendDraft :(ComposeBaseViewController *)composeBaseViewController draftType:(ComposeMsgType)draftType;
- (void) presentSheet;
- (void)toWhere:(CommOrTransInfo *)info withType:(NSUInteger)type;
- (void)initDraft :(ComposeBaseViewController *)composeBaseViewController withInfo:(CommOrTransInfo *)info draftType:(ComposeMsgType)draftType;

@end


