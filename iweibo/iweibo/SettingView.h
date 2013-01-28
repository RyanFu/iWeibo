//
//  SettingView.h
//  iweibo
//
//  Created by wangying on 2/28/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

extern NSString *const kThemeDidChangeNotification;

@interface SettingView : UIViewController <UITableViewDelegate,UITableViewDataSource>{
	UITableView			*settingTable;
	NSArray				*contentArray;
	MBProgressHUD		*mbProgress;
    UIButton            *editBtn;
	BOOL				playsound;
}

@property (nonatomic, retain) UITableView	*settingTable;
@property (nonatomic, retain) NSArray		*contentArray;
@property (nonatomic, retain) MBProgressHUD	*mbProgress;

//声音设置
- (void)setPlaySound:(id)sender;

//清除主timeline和消息页数据
- (void)ClickdarftListButton;

//加载关于页面
- (void)loadAboutView;

@end
