//
//  PersonalInfoViewController.h
//  iweibo
//
//  Created by zhaoguohui on 12-3-5.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class WordsLeftView;
@class ComposeBaseViewController;

extern NSString *const kThemeDidChangeNotification;

@interface PersonalInfoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIActionSheetDelegate> {
	UITableView *personInfoTable;
	UIImage *head;
	UITextView *textView;
	NSString *personalInfo;

	WordsLeftView		*wordsLeftView;		// 剩余字数视图
	NSInteger leftWordNum;
	
	MBProgressHUD *hud;
    UIButton        *backBtn;
}

@property (nonatomic, retain) UIImage *head;
@property (nonatomic, retain) WordsLeftView		*wordsLeftView;		// 剩余字数视图
@property (nonatomic, retain) NSString *personalInfo;

- (void)checkWordNumOfPersonalInfo:(UITextView *)tView;

@end
