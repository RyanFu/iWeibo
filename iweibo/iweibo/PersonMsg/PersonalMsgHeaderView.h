//
//  PersonalMsgHeaderViewController.h
//  iweibo
//
//  Created by LiQiang on 12-1-29.
//  Copyright 2012年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonalMsgViewController;

@interface PersonalMsgHeaderView: UIView {
	UIImageView *headPortrait;
	PersonalMsgViewController *parentController;
    UIButton    *talkBtn;
    
    NSURLResponse *response;
	NSMutableData *data;
	NSString *urlString;
	NSURLConnection *urlconnection;
	BOOL isDownloading;
	NSString *accountName;
}
@property (retain) UIImageView *headPortrait;
@property (nonatomic, assign) PersonalMsgViewController *parentController;
@property (nonatomic, retain) UIButton *talkBtn;
@property (nonatomic, retain) UILabel  *nicknameLabel;
@property (nonatomic, retain) UILabel  *accountLabel;
@property (retain) NSURLConnection *urlconnection;
@property (retain) NSMutableData *data;
@property (retain) NSString *urlString;
@property (assign) BOOL isDownloading;
@property (nonatomic, copy) NSString *accountName;

- (id)constructFrame:(CGRect)frame;
- (id)constructForMorePageFrame:(CGRect)frame;
- (void)talkAction;
- (void)getData;
- (void)setMyPortraitToDefaultImage;

@end
