//
//  morePage.m
//  iweibo
//
//  Created by LiQiang on 11-12-22.
//  Copyright 2011年 Beyondsoft. All rights reserved.
//

#import "MorePage.h"
#import "LoginPage.h"
#import "iweiboAppDelegate.h"
#import "MyBroadcast.h"
#import "MyAudience.h"
#import "MyListenTo.h"
#import "SettingView.h"
#import <QuartzCore/QuartzCore.h>
#import "PersonalInfoViewController.h"
#import "ComposeBaseViewController.h"
#import "ComposeViewControllerBuilder.h"
#import "SuggestionFeedController.h"
#import "DraftViewController.h"
#import "DetailPageConst.h"
#import "UserInfo.h"
#import "HpThemeManager.h"
#import "PushAndRequest.h"
#import "CustomNavigationbar.h"
#import "ModelAlertDelegate.h"
#import "IWeiboSyncApi.h"
#import "SCAppUtils.h"

#define ISCREATEDOK		@"createdOK"

@implementation CustomButton
@synthesize numberLabel;
@synthesize titlLabel;

// 根据传入的参数初始化一个按钮对象
- (id)buttonWithTitle:(NSString *)title number:(NSString *)num frame:(CGRect)frame type:(NSInteger)type {
	self = [super initWithFrame:frame];
	if (nil != self) {
		numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 100, 16)];
		numberLabel.backgroundColor = [UIColor clearColor];
		numberLabel.font = [UIFont systemFontOfSize:16];
		numberLabel.textAlignment = UITextAlignmentCenter;
		numberLabel.text = @"0";
		
		titlLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 31, 100, 16)];
		titlLabel.backgroundColor = [UIColor clearColor];
		titlLabel.font = [UIFont systemFontOfSize:16];
		titlLabel.textAlignment = UITextAlignmentCenter;
		
		if (type == 0) {
			[self setBackgroundImage:[UIImage imageNamed:@"broadcastNormal.png"] forState:UIControlStateNormal];
			[self setBackgroundImage:[UIImage imageNamed:@"broadcastHighlighted.png"] forState:UIControlStateHighlighted];
			self.titlLabel.text = @"广播";
			
		}else if(type == 1){
			[self setBackgroundImage:[UIImage imageNamed:@"fansNormal.png"] forState:UIControlStateNormal];
			[self setBackgroundImage:[UIImage imageNamed:@"fansHighlighted.png"] forState:UIControlStateHighlighted];
			self.titlLabel.text = @"听众";
		}else {
			[self setBackgroundImage:[UIImage imageNamed:@"listenNormal.png"] forState:UIControlStateNormal];
			[self setBackgroundImage:[UIImage imageNamed:@"listenHighlighted.png"] forState:UIControlStateHighlighted];
			self.titlLabel.text = @"收听";
		}
		
		[self addSubview:numberLabel];
		[self addSubview:titlLabel];
	}
		
	return self;

}

- (void)dealloc {
	[numberLabel release];
	[titlLabel release];
	
	[super dealloc];
}

@end

@implementation MorePage

// 获取用户信息成功时的回调函数
- (void)getUserInfoSuccess:(NSDictionary *)dict {
	if (nil == dict || [dict isKindOfClass:[NSNull class]]) {
		return;
	}
	
	id ret = [dict objectForKey:@"ret"];
	if (nil == ret || [ret intValue] != 0) {
		return;
	}
	
	NSDictionary *data = [dict objectForKey:@"data"];
	if (nil == data || [data isKindOfClass:[NSNull class]]) {
		return;
	}
	
//    NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++data is %@",data);
//    NSLog(@"+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++nick is %@ tweetnum is %@,fansnum is %@,idom is %@,head is %@",[data objectForKey:@"nick"],[data objectForKey:@"tweetnum"],[data objectForKey:@"fansnum"],[data objectForKey:@"idolnum"],[data objectForKey:@"head"]);
    
    // 网络不好的情况下，会加载成空字段，或者为0的字段，这样的话不应该存储，否则的话，在切换到更多页面，就会显示空字段和0数据了
    if([data objectForKey:@"nick"] != nil || [data objectForKey:@"tweetnum"] != nil){
        [[UserInfo sharedUserInfo] saveUserDataToUserInfo:data];
    }
	//myinfo = [UserInfo sharedUserInfo];
/*
	if (nil == headUrl || [headUrl isKindOfClass:[NSNull class]]) {
		
	}else {
		headerView.urlString = [NSString stringWithFormat:@"%@/%d", myinfo.head, 100];
		[headerView getData];
	}
*/
	if (nil != myinfo.head && [myinfo.head length] > 0) {
		headerView.urlString = [NSString stringWithFormat:@"%@/%d", myinfo.head, 180];
		NSLog(@"url = %@", headerView.urlString);
		[headerView getData];
	}else {
		[headerView setMyPortraitToDefaultImage];
	}

	[moreTableView reloadData];
	
}

- (void)getUserInfoFailure:(NSError *)error {
	NSLog(@"userInfo:%@", [error localizedDescription]);
}

- (void)updateTheme:(NSNotificationCenter *)noti{
    NSDictionary *plistDict = [[HpThemeManager sharedThemeManager]themeDictionary];
    NSString *themePathTmp = [plistDict objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    UIImage *imageNav = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"navigationbar_bg.png"]];
    [SCAppUtils navigationController:self.navigationController setImage:imageNav];
    
    [editBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"composebtn-bg.png"]] forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    NSDictionary *plistDict = nil;
    NSDictionary *pathDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"ThemePath"];
    if ([pathDic count] == 0){
        plistDict = [[HpThemeManager sharedThemeManager]themeDictionary];
        if ([plistDict count] == 0) {
            NSString *skinPath = [[NSBundle mainBundle] pathForResource:@"ThemeManager" ofType:@"plist"];
            plistDict = [[NSArray arrayWithContentsOfFile:skinPath] objectAtIndex:0];
        }
    }
    else{
        plistDict = pathDic;
    }
	NSString *themePathTmp = [plistDict objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    
    UIImage *imageNav = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"navigationbar_bg.png"]];
    [SCAppUtils navigationController:self.navigationController setImage:imageNav];
    
	UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
	[customLab setTextColor:[UIColor whiteColor]];
	[customLab setText:@"更多"];
	[customLab setTextAlignment:UITextAlignmentCenter];
	customLab.backgroundColor = [UIColor clearColor];
	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	self.navigationItem.titleView = customLab;
	[customLab release];
	//self.title = @"更多";
	draftMsgNum = 0;
	
	moreTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 370) style:UITableViewStyleGrouped];
	moreTableView.delegate = self;
	moreTableView.dataSource = self;
	moreTableView.backgroundColor = [UIColor colorStringToRGB:MoreSettingBackgroundColor];

	headerView = [[PersonalMsgHeaderView alloc] init];
	headerView.parentController = nil;
	[headerView constructForMorePageFrame:CGRectMake(0, 0, 320,100)];
	moreTableView.tableHeaderView = headerView;
	
	[self.view addSubview:moreTableView];
	
	
	// 编辑按钮
	editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
	editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
	[editBtn setTitle:@"设置" forState:UIControlStateNormal];
	[editBtn addTarget:self action:@selector(settingTabed) forControlEvents:UIControlEventTouchUpInside];
	[editBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"composebtn-bg.png"]] forState:UIControlStateNormal];
	
	UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
	self.navigationItem.rightBarButtonItem = editItem;
	[editItem release];
	
	myinfo = [UserInfo sharedUserInfo];
	//数据表增加userName和site两个字段
	NSString *isCreated = [[NSUserDefaults standardUserDefaults] objectForKey:ISCREATEDOK];
	if (!isCreated) {
		BOOL isAlterSiteOK = [DataManager alterDraftColoum:SITE];
		if (isAlterSiteOK) {
			[[NSUserDefaults standardUserDefaults] setObject:@"OK" forKey:ISCREATEDOK];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
	}
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification object:nil];
}


- (void)buttonClicked:(id)sender {
	[self.tabBarController performSelector:@selector(hideNewTabBar)];
	NSInteger tag = ((UIButton *)sender).tag;
    switch (tag) {
        case 201:{
            MyBroadcast *broadcast = [[[MyBroadcast alloc] init] autorelease];
            [self.navigationController pushViewController:broadcast animated:YES];
        }
            break;
        case 202: {
            MyAudience *audience = [[[MyAudience alloc] init] autorelease];
            audience.controllerType = 4;
            //添加此行，把个人资料中的听众数传到听众列表，以前没有传，导致从个人资料页面进入听众列表页的时候，self.audNum字段为空值，也就不加载提示视图了。
            audience.audNum = [NSString stringWithFormat:@"%@",myinfo.fansnum];
            [self.navigationController pushViewController:audience animated:YES];
        }
            break;
        case 203: {
            MyListenTo *listenTo = [[[MyListenTo alloc] init] autorelease];
            listenTo.controllerType = 4;
            [self.navigationController pushViewController:listenTo animated:YES];
        }
        default:
            break;
    }
}
#pragma mark -
#pragma mark UITableViewDelegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rowsNum = 0;
	switch (section) {
		case 0:
			rowsNum = 1;
			break;
		case 1:
			rowsNum = 1;
			break;
		case 2:
			rowsNum = 3;
			break;
		case 3:
			rowsNum = 1;
			break;
		case 4:
			rowsNum = 1;
			break;
	
		default:
			break;
	}
	return rowsNum;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *cellIdentifierForSection_one = @"cellIdentifierForSection_one";
	static NSString *cellIdentifierForSection_two = @"cellIdentifierForSection_two";
	static NSString *cellIdentifierForSection_three = @"cellIdentifierForSection_three";
	static NSString *cellIdentifierForSection_four = @"cellIdentifierForSection_four";
	static NSString *cellIdentifierForSection_five = @"cellIdentifierFiveSection_five";

	if (indexPath.section == 0) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForSection_one];
		if (nil == cell) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierForSection_one] autorelease];
			UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moreBg.png"]];
			bg.frame = CGRectMake(-2, -1, 303, 39);
			[cell.contentView addSubview:bg];
			[bg release];
		
			UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 230, 39)];
			info.tag = 101;
			info.backgroundColor = [UIColor clearColor];
			[cell.contentView addSubview:info];
			[info release];
			
			UIImageView *edit = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moreedit.png"]];
			edit.frame = CGRectMake(236, 9, 53, 20);
			[cell.contentView addSubview:edit];
			[edit release];
		}
		UILabel *info = (UILabel *)[cell.contentView viewWithTag:101];
		info.text = [NSString stringWithFormat:@"%@(@%@)", myinfo.nick, myinfo.name];
		
		return cell;
							 
	}else if (indexPath.section == 1) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForSection_two];
		NSString *broadNumStr = [NSString stringWithFormat:@"%@", myinfo.tweetnum];
		NSString *fansNumStr = [NSString stringWithFormat:@"%@", myinfo.fansnum];
		NSString *listenNumStr = [NSString stringWithFormat:@"%@", myinfo.idolnum];	

		if (nil == cell) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierForSection_two] autorelease];

			CustomButton *broad = [[CustomButton alloc] buttonWithTitle:@"广播" number:@"0" frame:CGRectMake(-1, -1, 101, 56) type:0];
			[broad addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            broad.tag = 201;
            [cell.contentView addSubview:broad];
            [broad release];
            
			CustomButton *fans = [[CustomButton alloc] buttonWithTitle:@"听众" number:@"0" frame:CGRectMake(100, -1, 100, 56) type:1];
			[fans addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
			fans.tag = 202;
            [cell.contentView addSubview:fans];
            [fans release];
            
			CustomButton *listen = [[CustomButton alloc] buttonWithTitle:@"收听" number:@"0" frame:CGRectMake(200, -1, 101, 56) type:2];
			[listen addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
			listen.tag = 203;
			[cell.contentView addSubview:listen];
			[listen release];

		}

		CustomButton *broad = (CustomButton *)[cell.contentView viewWithTag:201];
		if (broadNumStr == nil || [broadNumStr isKindOfClass:[NSNull class]]) {
			broad.numberLabel.text = @"0";
		}else {
			broad.numberLabel.text = broadNumStr;
		}
		
		CustomButton *fans = (CustomButton *)[cell.contentView viewWithTag:202];
		if (fansNumStr == nil || [fansNumStr isKindOfClass:[NSNull class]]) {
			fans.numberLabel.text = @"0";
		}else {
			fans.numberLabel.text = fansNumStr;
		}
		
		CustomButton *listen = (CustomButton *)[cell.contentView viewWithTag:203];
		if (listenNumStr == nil || [listenNumStr isKindOfClass:[NSNull class]]) {
			listen.numberLabel.text = @"0";
		}else {
			listen.numberLabel.text = listenNumStr;
		}
		
		return cell;
	}else if (indexPath.section == 2) {
		UITableViewCell *cel = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForSection_three];
		if (nil == cel) {
			cel = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierForSection_three] autorelease];
			cel.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			
			// 显示标题
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 80, 43)];
			label.tag = 301;
			label.backgroundColor = [UIColor clearColor];
			[cel.contentView addSubview:label];
			[label release];
			
			UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"morenotation.png"]];
			bgView.frame = CGRectMake(246, 10, 31, 22);
			bgView.hidden = YES;
			bgView.tag = 303;
			[cel.contentView addSubview:bgView];
			[bgView release];
			
			UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(246, 10, 31, 22)];
			num.backgroundColor = [UIColor clearColor];
			num.font = [UIFont systemFontOfSize:14];
			num.textAlignment = UITextAlignmentCenter;
			num.tag = 302;
			num.hidden = YES;
			[cel.contentView addSubview:num];
			[num release];
		}
		UILabel *label = (UILabel *)[cel.contentView viewWithTag:301];
		UILabel *num = (UILabel *)[cel.contentView viewWithTag:302];
		UIImageView *imgView = (UIImageView *)[cel.contentView viewWithTag:303];
		if (indexPath.row == 0) {
			imgView.hidden = YES;
			num.hidden = YES;
			label.text = @"官方微博";
		}else if (indexPath.row == 1) {
			imgView.hidden = YES;
			num.hidden = YES;
			label.text = @"意见反馈";
		}else {
			imgView.hidden = NO;
			num.hidden = NO;
			num.text = [NSString stringWithFormat:@"%d", draftMsgNum];
			label.text = @"草稿箱";
		}
		
		return cel;

	}else if (indexPath.section == 4) {
		UITableViewCell *cel = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForSection_four];
		if (nil == cel) {
			cel = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierForSection_four] autorelease];
			cel.contentView.backgroundColor = [UIColor clearColor];
			UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
			logout.frame = CGRectMake(-1, -1, 302, 43);
			[logout setBackgroundImage:[UIImage imageNamed:@"logoutBtnNormal.png"] forState:UIControlStateNormal];
			[logout setBackgroundImage:[UIImage imageNamed:@"logoutBtnHighlighted.png"] forState:UIControlStateHighlighted];
			[logout addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
			[cel.contentView addSubview:logout];
		}
		return cel;
	}
	else {
		UITableViewCell *cel = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForSection_five];
		if (nil == cel) {
			cel = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierForSection_five] autorelease];
			cel.contentView.backgroundColor = [UIColor clearColor];
			UIButton *exchangeToOther = [UIButton buttonWithType:UIButtonTypeCustom];
			exchangeToOther.frame = CGRectMake(-1, -1, 302, 43);
			[exchangeToOther setBackgroundImage:[UIImage imageNamed:@"switch_other.png" ]forState:UIControlStateNormal];
			[exchangeToOther setBackgroundImage:[UIImage imageNamed:@"switch_other_hover.png"] forState:UIControlStateHighlighted];
			[exchangeToOther addTarget:self action:@selector(exchangeToOther) forControlEvents:UIControlEventTouchUpInside];
			[cel.contentView addSubview:exchangeToOther];
            
            // 点击exchangeToOther之后，为防止alertView未出现前重复点击，用coverView覆盖exchangeToOther
            UIView *coverView = [[UIView alloc] initWithFrame:exchangeToOther.bounds];
            coverView.backgroundColor = [UIColor clearColor];
            coverView.tag = 500;
            coverView.hidden = YES;
            [cel.contentView addSubview:coverView];
            [coverView release];

		}
		return cel;
	}
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 5;
}

// 重新请求用户信息
- (void)reloadPersonalInfo {
	
	NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithCapacity:3];
	[paramters setValue:@"json" forKey:@"format"];
	[paramters setValue:URL_USER_INFO forKey:@"request_api"];
	api = [[IWeiboAsyncApi alloc] init];
	[api getUserInfoWithDelegate:self onSuccess:@selector(getUserInfoSuccess:) onFailure:@selector(getUserInfoFailure:)];
	NSLog(@"reloadPersonalInfo");
}

- (void)getDraftCount {
	draftMsgNum = [DataManager getDraftCountFromDatabase:[UserInfo sharedUserInfo].name];
	bUpdatedDraftNum = YES;
	// 假如有多个刷新操作，则需要判断是否都加载完毕，然后再执行界面刷新
	if (bUpdatedDraftNum) {
		[moreTableView reloadData];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// 每次进入该页面的时候刷新其中的数据
	[self reloadPersonalInfo];
	bUpdatedDraftNum = NO;
	[self performSelector:@selector(getDraftCount) withObject:nil afterDelay:0.1f];
	[self.tabBarController performSelector:@selector(showNewTabBar)];
}

// 清除当前用户的信息
- (void)clearInfoForCurrentUser {
	[headerView setMyPortraitToDefaultImage];
	[[UserInfo sharedUserInfo] clearUserInfo];
}

//切换到其他iWeibo
- (void)exchangeToOther{
    [self.view viewWithTag:500].hidden = NO;
	CFRunLoopRef currentRunLoop = CFRunLoopGetCurrent();
	ModalAlertDelegate *modalDelegate = [[ModalAlertDelegate alloc] initWithRunLoop:currentRunLoop];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
														message:@"切换到其他微博，并保持当前的登录状态？" 
													   delegate:modalDelegate 
											  cancelButtonTitle:@"取消" 
											  otherButtonTitles:@"确定",nil]; 
	alertView.tag = 100;
	[alertView show];

	CFRunLoopRun();
	
	NSUInteger answer = modalDelegate.index;

	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
	// 当用户选择切换的时候，将图像设置为默认头像
	[self clearInfoForCurrentUser];
	if (answer != 1) {
		CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
		[delegate performSelector:@selector(selectSite)];
		if (actSite != nil) {
			[[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:actSite.descriptionInfo.svrUrl withUser:actSite.loginUserName loginState:NO firstLogin:NO];
            actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
			[[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:actSite.descriptionInfo.svrUrl withUser:actSite.loginUserName accessToken:@"" accessKey:@""];
		}
//		[delegate playAnimation];
		// 登陆再次退出后好友列表不会返回数据
		[[DraftController sharedInstance].aSyncAApi cancelCurrentRequest];
		// 清除cookies
		//[IWeiboAsyncApi clearSession];
	}
	else {
		CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
		if (actSite != nil) {
			[[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:actSite.descriptionInfo.svrUrl withUser:actSite.loginUserName loginState:YES firstLogin:NO];
		}
	}
    [delegate playAnimation];
	// 清除激活状态
	[[IWBSvrSettingsManager sharedSvrSettingManager] inactiveAllSite];
	[delegate backToSelectPage];
	//SelectWeiboPage *select = [[SelectWeiboPage alloc] init];
//	[self presentModalViewController:select animated:YES];
	[alertView release];
	[modalDelegate release];
    [[self.view viewWithTag:500] removeFromSuperview];
}
//退出登陆时调用方法
- (void)loginOut{
//	CFRunLoopRef currentRunLoop = CFRunLoopGetCurrent();
//	ModalAlertDelegate *modalDelegate = [[ModalAlertDelegate alloc] initWithRunLoop:currentRunLoop];
//	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"退出" 
//														message:@"是否要退出当前登陆账号?" 
//													   delegate:modalDelegate 
//											  cancelButtonTitle:@"取消" 
//											  otherButtonTitles:@"确定",nil]; 
//	alertView.tag = 100;
//	[alertView show];
	
//	CFRunLoopRun();
//	NSUInteger answer = modalDelegate.index;
	
//	if (answer != 0) {
		// 当用户退出的时候，将图像设置为默认头像
//	[self clearInfoForCurrentUser];
	// 清除cookies
	[IWeiboAsyncApi clearSession];
	
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
	[delegate playAnimation];
	// 登陆再次退出后好友列表不会返回数据
	[[DraftController sharedInstance].aSyncAApi cancelCurrentRequest];
	[delegate performSelector:@selector(loginOut)];
		CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
		if (actSite != nil) {
			[[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:actSite.descriptionInfo.svrUrl withUser:actSite.loginUserName loginState:NO firstLogin:NO];
            actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
			[[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:actSite.descriptionInfo.svrUrl withUser:actSite.loginUserName accessToken:@"" accessKey:@""];
		}
//	}
//	[alertView release];
//	[modalDelegate release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger section = [indexPath section];
	CGFloat height = 0;
	switch (section) {
		case 0:
			height = 37;
			break;
		case 1:
			height = 54;
			break;
		case 2:
			height = 43;
			break;
		case 3:
			height = 41;
			break;
		case 4:
			height = 41;
			break;
		default:
			break;
	}
	return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (0 == indexPath.section) {
		PersonalInfoViewController *person = [[PersonalInfoViewController alloc] init];
		person.head = headerView.headPortrait.image;
		person.personalInfo = myinfo.introduction;
		
		[self.navigationController pushViewController:person animated:YES];
		[self.tabBarController performSelector:@selector(hideNewTabBar)];
		[person release];
	}else if (2 == indexPath.section) {
		if (indexPath.row == 0) {			// 官方微博
			[self officialTwitter];
		}else  if (indexPath.row == 1) {	// 意见反馈
			[self suggestionFeedback];
		}else {
			DraftViewController *draft = [[DraftViewController alloc] init];
			[self.navigationController pushViewController:draft animated:YES];
			[self.tabBarController performSelector:@selector(hideNewTabBar)];
			[draft release];
		}
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
// 官方微博lichntao 2012-03-06
- (void)officialTwitter{
	
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil) {
		if (actSite.descriptionInfo.official != nil && [actSite.descriptionInfo.official length] > 0) {
			[[PushAndRequest shareInstance] pushControllerType:4 withName:actSite.descriptionInfo.official];
		}
		else {
			[[PushAndRequest shareInstance] pushControllerType:4 withName:@"api_iweibo"];
		}
	}
}
// 意见反馈lichentao 2012-03-06
- (void)suggestionFeedback{
	Draft *draft = [[Draft alloc] init];
	draft.draftType = SUGGESTION_FEEDBACK_MESSAGE; 
	// textView中显示空内容
	NSString *feedbackString = nil;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	
	if (actSite != nil) {
		feedbackString = [NSString stringWithFormat:@"%@_iWeibo iPhone客户端意见反馈", actSite.descriptionInfo.svrName];
	}
	else {
		feedbackString = @"_iWeibo iPhone客户端意见反馈";
	}

	NSString *draftString = [[NSString alloc] initWithFormat:@"#%@#\n%@_%@_%@", feedbackString, [UIDevice currentDevice].systemVersion,[UIDevice currentDevice].name,[UIDevice currentDevice].systemName];
	draft.draftText = draftString;
	[draftString release];
	ComposeBaseViewController	*composeViewController =  [ComposeViewControllerBuilder createWithDraft:draft];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:composeViewController];
	[self presentModalViewController:nav animated:YES];
	// composeViewController无需手动释放
	//[ComposeViewControllerBuilder desposeViewController:composeViewController];
	[nav release];
	[draft release];	
}

- (void)animationDidStop {
	iweiboAppDelegate *dele = (iweiboAppDelegate *)[[UIApplication sharedApplication] delegate];
    dele.window.backgroundColor = [UIColor whiteColor];
}

- (void)settingTabed{
	iweiboAppDelegate *dele = (iweiboAppDelegate *)[[UIApplication sharedApplication] delegate];
	  
	dele.window.backgroundColor = [UIColor blackColor];
	[UIView beginAnimations:@"View Flip" context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationTransition:  UIViewAnimationTransitionFlipFromRight forView:dele.mainContent.view cache: NO];	
	[UIView setAnimationDelegate:self];
//	[UIView setAnimationDidStopSelector:@selector(animationDidStop)]; 注释掉此行，解决界面翻转太快时候，背景出现白色的现象
	
	SettingView  *settingView = [[SettingView alloc] init];
	//[self presentModalViewController:settingView animated:NO];
	[self.navigationController pushViewController:settingView animated:NO];
	[settingView release];

	[UIView commitAnimations];
	
	//dele.window.backgroundColor = [UIColor whiteColor];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	
	CGFloat height = 0;
	switch (section) {
		case 0:
			height = 17;
			break;
		case 1:
			height = 6;
			break;
		case 2:
			height = 10;
			break;
		case 3:
			height = 20;
			break;
		default:
			break;
	}
	return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (section < 3) {
		return 0.1f;
	}
	return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UILabel *header = nil;
	header = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 17)] autorelease];
	header.backgroundColor = [UIColor clearColor];
	
	switch (section) {
		case 0:
			header.frame = CGRectMake(0, 0, 320, 17);
			break;
		case 1:
			header.frame = CGRectMake(0, 0, 320, 6);
			break;
		case 2:
			header.frame = CGRectMake(0, 0, 320, 10);
			break;
		case 3:
            
			header.frame = CGRectMake(0, 0, 320, 20);
			break;
		default:
			break;
	}
	
	return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	if (section < 3) {
		UILabel *footer = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 0.1f)] autorelease];
		return footer;
	}
	return nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    [editBtn release];
	[moreTableView release];
	[headerView release];
	[api release];
	
	[super dealloc];
}

@end
