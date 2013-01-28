    //
//  SubScribeWeiboViewController.m
//  iweibo
//
//  Created by Minwen Yi on 5/17/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "SubScribeWeiboViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "iweiboAppDelegate.h"
#import "IWBSvrSettingsManager.h"
#import "DataCheck.h"


@implementation SubScribeWeiboViewController
@synthesize tfSiteAddr, btnCommit, lbErrorDes, imgErrorBackground;
@synthesize siteInfo;
@synthesize dicThemeResult;
@synthesize siteUrl;
@synthesize idParentController;
@synthesize checkView;
@synthesize desInfo;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];	
//	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	self.view.backgroundColor = [UIColor blackColor];
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
	delegate.draws = 2;
	// 显示导航栏
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	// 添加返回按钮
	UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
	leftButton.frame = CGRectMake(0, 0, 50, 30);
	[leftButton setTitle:@"返回" forState:UIControlStateNormal];
	leftButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
	[leftButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 5)];
	[leftButton setBackgroundImage:[UIImage imageNamed:@"subScribeNav.png"] forState:UIControlStateNormal];
	[leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
	self.navigationItem.leftBarButtonItem = leftBar;
	[leftBar release];

	UIImageView *imgBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subScribeBg.png"]];
	imgBackground.frame = CGRectMake(0.0f, 0.0f, 320.0f, 416.0f);
	[self.view addSubview:imgBackground];
	[imgBackground release];
    
    UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -64.0f, 320.0f, 64.0f)];
    tempView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:tempView];
    [tempView release];

	// “请输入订阅的iWeibo地址”
	CGSize sz= [@"请输入自定义iWeibo地址" sizeWithFont:[UIFont fontWithName:@"Helvetica" size:16]];
	UILabel *lbText = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 90.0f - 64.0f, sz.width, sz.height)];
	lbText.text = @"请输入自定义iWeibo地址";
	lbText.backgroundColor = [UIColor clearColor];
	lbText.font = [UIFont fontWithName:@"Helvetica" size:16];
	lbText.textColor = [UIColor colorStringToRGB:@"373737"];
	[self.view addSubview:lbText];
	[lbText release];
	UIButton *btnBg = [UIButton buttonWithType:UIButtonTypeCustom];
	[btnBg setBackgroundImage:[UIImage imageNamed:@"subScribeInput.png"] forState:UIControlStateNormal];
	[btnBg setBackgroundImage:[UIImage imageNamed:@"subScribeInput.png"] forState:UIControlStateHighlighted];
	btnBg.frame = CGRectMake(20.0f, lbText.frame.origin.y + sz.height + 8, 280.0f, 42.0f);
	[btnBg addTarget:self action:@selector(textFieldBGClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btnBg];
	tfSiteAddr = [[UITextField alloc] initWithFrame:CGRectMake(8.0f, 9.0f, 250.0f, 24.0f)];
	tfSiteAddr.placeholder = @"http://";
	tfSiteAddr.borderStyle = UITextBorderStyleNone;
	tfSiteAddr.textColor = [UIColor blackColor];
	tfSiteAddr.font = [UIFont systemFontOfSize:18.0f];
	tfSiteAddr.backgroundColor = [UIColor clearColor];
	tfSiteAddr.keyboardType = UIKeyboardTypeURL;
	tfSiteAddr.returnKeyType = UIReturnKeyDone;	
	tfSiteAddr.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	tfSiteAddr.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
	[btnBg addSubview:tfSiteAddr];
	btnCommit = [UIButton buttonWithType:UIButtonTypeCustom];
	btnCommit.frame = CGRectMake(20.0f, btnBg.frame.origin.y + btnBg.frame.size.height + 10, 280.0f, 42.0f);
	[btnCommit setBackgroundImage:[UIImage imageNamed:@"subScribeStart.png"] forState:UIControlStateNormal];
	[btnCommit addTarget:self action:@selector(commitSite) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btnCommit];
	// 描述文本框
	imgErrorBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subScribeErrorBg.png"]];
	imgErrorBackground.frame = CGRectMake(20.0f, btnCommit.frame.origin.y + 42.0f + 15.0f, 280.0f, 59.0f);
	[self.view addSubview:imgErrorBackground];
	
	lbErrorDes = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 260.0f, 40.0f)];
	lbErrorDes.font = [UIFont fontWithName:@"Helvetica" size:15];	// 20px
	lbErrorDes.backgroundColor = [UIColor clearColor];
	lbErrorDes.textColor = [UIColor colorStringToRGB:@"baa279"];
	[imgErrorBackground addSubview:lbErrorDes];
	[self setErrorText:@""];
	checkView = [[UIView alloc] initWithFrame:CGRectMake(100, btnCommit.frame.origin.y + 42.0f + 30.0f, 40, 200)];
    checkView.backgroundColor = [UIColor clearColor];
	checkView.hidden = YES;
	UILabel *checkLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 150, 30)];
    checkLabel.text = @"检查配置中...";
    checkLabel.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0];
    checkLabel.font = [UIFont systemFontOfSize:16];
    checkLabel.backgroundColor = [UIColor clearColor];
    [checkView addSubview:checkLabel];
    [checkLabel release];
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];  
     indicatorView.frame = CGRectMake(6, 5, 20, 20);
    [checkView addSubview:indicatorView];
    [self.view addSubview:checkView];
	api = [[IWeiboAsyncApi alloc] init];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didEnterBackground)
												 name:UIApplicationDidEnterBackgroundNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(willEnterForeground)
												 name:UIApplicationWillEnterForegroundNotification
											   object:nil];
}

-(void)didEnterBackground {
	CLog(@"%s", __FUNCTION__);
	// 下载线程暂停
	[[IWBSvrSettingsManager sharedSvrSettingManager] CancelThemeDownLoading];
	if (isDownloadingTheme) {
		isCancelledFromBackground = YES;
	}
}

-(void)willEnterForeground {
	CLog(@"%s", __FUNCTION__);
	// 下载线程重新启动
	if (isCancelledFromBackground) {
		isCancelledFromBackground = NO;
		[self startDownloadThemeIcons];
	}
}

-(void)textFieldBGClicked {
	[tfSiteAddr becomeFirstResponder];
}

-(void)back {
	//[self.navigationController setNavigationBarHidden:YES animated:NO];
	[self.navigationController popViewControllerAnimated:YES];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.tfSiteAddr = nil;
	self.lbErrorDes = nil;
	self.imgErrorBackground = nil;
	self.checkView = nil;
}


- (void)dealloc {
	[[IWBSvrSettingsManager sharedSvrSettingManager] CancelThemeDownLoading];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	[tfSiteAddr release];
	tfSiteAddr = nil;
	[lbErrorDes release];
	lbErrorDes = nil;
	[imgErrorBackground release];
	imgErrorBackground = nil;
	[api cancelSpecifiedRequest];
	[api release];
	api = nil;
	self.siteUrl = nil;
	self.checkView = nil;
	self.desInfo = nil;
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated {
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
	delegate.draws = 2;
	[super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
	delegate.draws = 1;
	[super viewWillDisappear:animated];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[tfSiteAddr resignFirstResponder];
    return YES;
}


//1. 检测本地是否已经有对应site存在
//1.1假如是，则转到3
//1.2假如不是，转到2
//2. 通过check接口检测site状态，监听返回状态
//2.1 返回成功，跳转到3
//2.2 返回不成功，界面显示错误信息
//3. 通过theme接口获取icon信息，监听返回状态
//3.1 成功，缓存theme字典信息，转到4
//3.2 失败，界面显示错误信息
//4. 获取站点信息siteInfo
//4.1 成功，更新theme信息到本地文件，下载图片，更新描述信息，标记服务器激活状态，进入loading页面..
//4.2 失败，界面显示错误信息
// 检测站点信息
-(void)checkSite:(NSString *)siteName {
	[api iweiboCheckHostWithUrl:siteName delegate:self onSuccess:@selector(onCheckSuccess:) onFailure:@selector(onCheckFailure:)];
}

-(void)getThemeInfo {
	NSMutableDictionary *par = [NSMutableDictionary dictionaryWithCapacity:3];
	[par setObject:@"json" forKey:@"format"];
	[par setObject:@"customized/theme" forKey:@"request_api"];
	[par setObject:@"-1" forKey:@"ver"];
	[api getCustomizedThemeWithUrl:self.siteUrl Parameters:par delegate:self
								onSuccess:@selector(onGetThemeSuccess:) onFailure:@selector(onGetThemeFailure:)];
}

-(void)getSiteInfo {
	NSMutableDictionary *par = [NSMutableDictionary dictionaryWithCapacity:2];
	[par setObject:@"json" forKey:@"format"];
	[par setObject:@"customized/siteinfo" forKey:@"request_api"];
	[api getCustomizedSiteInfoWithUrl:self.siteUrl Parameters:par delegate:self
								   onSuccess:@selector(onGetSiteInfoSuccess:) onFailure:@selector(onGetSiteFailure:)];
}

// 设置异常文本
-(void)setErrorText:(NSString *)errText {
	if (nil == errText || [errText length] == 0) {
		imgErrorBackground.hidden = YES;
	}
	else {
		imgErrorBackground.hidden = NO;
		// 
		lbErrorDes.text = errText;
	}
	[indicatorView stopAnimating];
	checkView.hidden = YES;
	btnCommit.enabled = YES;
	
}

-(void)commitSite {
	[tfSiteAddr resignFirstResponder];
	[self setErrorText:@""];
	btnCommit.enabled = NO;
	checkView.hidden = NO;
	[indicatorView startAnimating];
	NSString *strUrlName = [[tfSiteAddr.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
	if (![strUrlName hasPrefix:@"http://"]) {
		self.siteUrl = [NSString stringWithFormat:@"http://%@%@", strUrlName, HOST_SUB_PATH_COMPONENT];
	}
	else {
		self.siteUrl = [strUrlName stringByAppendingString:HOST_SUB_PATH_COMPONENT];
	}
	// 1. 检测本地是否已经有对应site存在
	self.siteInfo = [[IWBSvrSettingsManager sharedSvrSettingManager] getSiteInfoByUrl:self.siteUrl];
	if (NO) {
	//if (nil != self.siteInfo) {
		// 已存在当前站点，
		//3. 通过theme接口获取icon信息，监听返回状态
		[self performSelector:@selector(getThemeInfo) withObject:nil afterDelay:0.0f];
	}
	else {
		//2. 通过check接口检测site状态，监听返回状态
		[self performSelector:@selector(checkSite:) withObject:self.siteUrl afterDelay:0.0f];
	}

}

-(void)iconsDidFinishedDownloadingWithPar:(NSDictionary *)result {
	isDownloadingTheme = NO;
	CLog(@"%s", __FUNCTION__);// 更新信息theme信息
	NSString *ret = [result objectForKey:@"ret"];
	if ([ret intValue] != 0) {
		NSString *strFolder = [result objectForKey:@"PATH"];
		NSNumber *ver = [self.dicThemeResult objectForKey:@"version"];
		NSString *strVer = [NSString stringWithFormat:@"%@", ver];
		NSDictionary *dicTheme = [self.dicThemeResult objectForKey:@"list"];
		// 保存信息到本地文件themeDic:(NSDictionary *)dicDeltaTheme andIconFolder
		BOOL bResult = [[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:self.siteUrl withVer:strVer themeDic:dicTheme andIconFolder:strFolder];
		if (bResult) {
			self.siteInfo = [[IWBSvrSettingsManager sharedSvrSettingManager] getSiteInfoByUrl:self.siteUrl];
			// 3. 站点信息拉取(siteInfo)
			siteInfo.descriptionInfo = self.desInfo;
			[[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:self.siteUrl withDescription:siteInfo.descriptionInfo];
			// 设置激活状态
			[[IWBSvrSettingsManager sharedSvrSettingManager] updateAndSetSiteActive:self.siteUrl];
			// 更新界面(未完成)
			// 启动loading页面
			//[self.navigationController popViewControllerAnimated:NO];
			if ([idParentController respondsToSelector:@selector(doneServerPreparation)]) {
				[idParentController performSelectorOnMainThread:@selector(doneServerPreparation) withObject:nil waitUntilDone:NO];
			}
		}
		else
			[self setErrorText:@"保存数据异常"];
	}
	else {
		[self setErrorText:@"下载文件超时"];
	}

}

-(void)startDownloadThemeIcons {
	isDownloadingTheme = YES;
	// 更新信息theme信息
	NSDictionary *dicTheme = [self.dicThemeResult objectForKey:@"list"];
	// 保存信息到本地文件
	if ([dicTheme isEqual:[NSNull null]] || [dicTheme count] == 0) {
		[self setErrorText:@"数据获取异常"];	// 有可能返回的为最新版本，但在自定义页面不会出现这种情况
	}
	else {
		[[IWBSvrSettingsManager sharedSvrSettingManager] downloadTheme:self.siteUrl
															wiThemeDic:dicTheme 
															  delegate:self 
															  Callback:@selector(iconsDidFinishedDownloadingWithPar:)];
	}
}

#pragma mark callbacks
- (void)onCheckSuccess:(NSDictionary *)result {
	CLog(@"%s, result:%@", __FUNCTION__, result);
	//NSString *ret = [result objectForKey:@"ret"];
	if (nil != result) {
		
	//	NSDictionary *friendsData = [DataCheck checkDictionary:dict forKey:@"data" withType:[NSDictionary class]];
//		NSArray *infoArray = [DataCheck checkDictionary:friendsData forKey:@"info" withType:[NSArray class]];

		//2.1 返回成功
		//3. 通过theme接口获取icon信息，监听返回状态
		[self performSelector:@selector(getThemeInfo) withObject:nil afterDelay:0.0f];
	}
	else {
		// 主站未准备好
		[self setErrorText:@"检测服务器失败"];
	}

}

-(void)onGetThemeSuccess:(NSDictionary *)result {
	CLog(@"%s, result:%@", __FUNCTION__, result);
	NSNumber *ret = [DataCheck checkDictionary:result forKey:@"ret" withType:[NSNumber class]];
	// 数据获取异常
	if ([ret isEqual:[NSNull null]] || [ret intValue] != 0) {
		if ([ret isEqual:[NSNull null]]) {
			[self setErrorText:@"数据获取异常"];
		}
		else {
			NSString *msg = [DataCheck checkDictionary:result forKey:@"ret" withType:[NSString class]];
			if ([msg isEqual:[NSNull null]])
				[self setErrorText:@"数据获取异常"];
			else
				[self setErrorText:[msg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		}
	}
	else {
		// ret=0, errcode=1时表示主题版本已经是最新
		NSNumber *errorcode = [DataCheck checkDictionary:result forKey:@"errcode" withType:[NSNumber class]];
		if ([ret isEqual:[NSNull null]]) {
			[self setErrorText:@"数据获取异常"];
		}
		else if ([errorcode intValue] == 1) {
			// 已是最新版本
			// 3. 站点信息拉取(siteInfo)
			[self performSelector:@selector(getSiteInfo) withObject:nil afterDelay:0.0f];
		}
		else {
			NSDictionary *dicData = [DataCheck checkDictionary:result forKey:@"data" withType:[NSDictionary class]];
			// 自定义微博页面必须要有所有图片，因此要判定[dicData count]值
			if ([dicData isEqual:[NSNull null]] || [dicData count] == 0) {
				[self setErrorText:@"数据获取异常"];
			}
			else {
				self.dicThemeResult = dicData;	// 缓存数据
				[self performSelector:@selector(getSiteInfo) withObject:nil afterDelay:0.0f];
			}
		}
	}
}

-(void)onGetSiteInfoSuccess:(NSDictionary *)result {
//	CLog(@"%s, result:%@", __FUNCTION__, result);
	// 检测返回值
	NSNumber *ret = [DataCheck checkDictionary:result forKey:@"ret" withType:[NSNumber class]];
	
	// 数据获取异常
	if ([ret isEqual:[NSNull null]] || [ret intValue] != 0) {
		if ([ret isEqual:[NSNull null]]) {
			[self setErrorText:@"数据获取异常"];
		}
		else {
			NSString *msg = [DataCheck checkDictionary:result forKey:@"ret" withType:[NSString class]];
			if ([msg isEqual:[NSNull null]])
				[self setErrorText:@"数据获取异常"];
			else
				 [self setErrorText:[msg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		}
	}
	else {
		NSDictionary *dicData = [DataCheck checkDictionary:result forKey:@"data" withType:[NSDictionary class]];
		if ([dicData isEqual:[NSNull null]]) {
			[self setErrorText:@"数据获取异常"];
		}
		else {
            SiteDescriptionInfo *infoDes = [[SiteDescriptionInfo alloc] initWithDic:dicData];
			self.desInfo = infoDes;
            [infoDes release];
			[self startDownloadThemeIcons];
            
					// 1. 检测本地是否已经有对应site存在
			// 更新信息theme信息
//			NSNumber *ver = [self.dicThemeResult objectForKey:@"version"];
//			NSString *strVer = [NSString stringWithFormat:@"%@", ver];
//			NSDictionary *dicTheme = [self.dicThemeResult objectForKey:@"list"];
//			// 保存信息到本地文件
//			BOOL bResult = YES;
//			if ([dicTheme isEqual:[NSNull null]] || [dicTheme count] == 0) {
//				[self setErrorText:@"数据获取异常"];	// 有可能返回的为最新版本，但在自定义页面不会出现这种情况
//			}
//			else {
//				bResult = [[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:self.siteUrl withVer:strVer andThemeDic:dicTheme];
//			}
//			if (bResult) {
//				// 下载图片资源(未完成)	
//				
//				self.siteInfo = [[IWBSvrSettingsManager sharedSvrSettingManager] getSiteInfoByUrl:self.siteUrl];
//				// 3. 站点信息拉取(siteInfo)
//				siteInfo.descriptionInfo = desInfo;
//				[[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:self.siteUrl withDescription:siteInfo.descriptionInfo];
//				// 设置激活状态
//				[[IWBSvrSettingsManager sharedSvrSettingManager] updateAndSetSiteActive:self.siteUrl];
//				// 更新界面(未完成)
//				// 启动loading页面
//				//[self.navigationController popViewControllerAnimated:NO];
//				if ([idParentController respondsToSelector:@selector(doneServerPreparation)]) {
//					[idParentController doneServerPreparation];
//				}
//			}
//			else
//				[self setErrorText:@"保存数据异常"];
//			[desInfo release];	
		}
	}
}

- (void)onCheckFailure:(NSError *)error {
    CLog(@"error = %@",error);
	[self setErrorText:[error localizedDescription]];
}

- (void)onGetThemeFailure:(NSError *)error {
    CLog(@"error = %@",error);
	[self setErrorText:[error localizedDescription]];
}

- (void)onGetSiteFailure:(NSError *)error {
    CLog(@"error = %@",error);
	[self setErrorText:[error localizedDescription]];
}
@end
