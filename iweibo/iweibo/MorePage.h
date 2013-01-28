//
//  MorePage.h
//  iweibo
//
//  Created by LiQiang on 11-12-22.
//  Copyright 2011年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraftController.h"
#import "DraftListController.h"
#import "MoreDetailView.h"
#import "PersonalMsgHeaderView.h"
#import "IWeiboAsyncApi.h"

@class UserInfo;
@interface MorePage : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	UITableView *moreTableView;
	PersonalMsgHeaderView *headerView;
	IWeiboAsyncApi *api;
	UserInfo *myinfo;
    UIButton *editBtn;
	
	NSInteger draftMsgNum;
	BOOL	bUpdatedDraftNum;		// 是否已更新草稿个数
}

- (void)reloadPersonalInfo;
// 意见反馈方法lichentao 2012-03-06
- (void)suggestionFeedback;	
// 官方微博 lichentao 2012-03-06
- (void)officialTwitter;
@end


@interface CustomButton : UIButton {
	UILabel *numberLabel;
	UILabel *titlLabel;
}

@property (nonatomic, retain) UILabel *numberLabel;
@property (nonatomic, retain) UILabel *titlLabel;

- (id)buttonWithTitle:(NSString *)title number:(NSString *)num frame:(CGRect)frame type:(NSInteger)type;

@end
