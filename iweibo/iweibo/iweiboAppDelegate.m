//
//  iweiboAppDelegate.m
//  iweibo
//
//  Created by LiQiang on 11-12-22.
//  Copyright 2011年 Beyondsoft. All rights reserved.
//

#import "iweiboAppDelegate.h"
#import "UserInfo.h"
///////////
#import "SCAppUtils.h"
#import "IweiboOauth.h"
#import "IWeiboAsyncApi.h"
#import "IWeiboSyncApi.h"
#import "Canstants_Data.h"
#import "Database.h"
#import "CustomStatusBar.h"
#import "CustomNavigationbar.h"
#import "NamenickInfo.h"
#import "SelectWeiboPage.h"
#import "IWBSvrSettingsManager.h"
#import "HpThemeManager.h"

@implementation UINavigationBar(Custom)

//- (void)drawRect:(CGRect)rect {
//	//[super drawRect:rect];
//	NSLog(@"UINavigationBar");
////	iweiboAppDelegate *delegat = (iweiboAppDelegate *) [[UIApplication sharedApplication] delegate];
////	if (delegat.draws == 1) {
////		UIImage *navBg = [UIImage imageNamed:@"navigationbar_bg.png"];
////		[navBg drawInRect:CGRectMake(0, 0, 320, 44)];
////	}
////	else if (delegat.draws == 2) {
////		UIImage *navBg = [UIImage imageNamed:@"subScribeTitleBg.png"];
////		[navBg drawInRect:CGRectMake(0, 0, 320, 44)];
////		delegat.draws = 1;
////	}
////	else {
////		UIImage *navBg = [UIImage imageNamed:@"top_navigationbar_icon.png"];
////		[navBg drawInRect:CGRectMake(0, 0, 320, 44)];
////	}
//}

@end

@implementation iweiboAppDelegate

@synthesize window=_window,mainContent,homeTab,homeNav,msgTab,msgNav,searchTab, searchNav,moreTab,moreNav, selectPage;
@synthesize nNewMsgTimer;
@synthesize nNewMsgApi;
@synthesize firstLaunch, shouldComeIn;
@synthesize cStatusBar;
@synthesize draws;
@synthesize strSiteUrl;
@synthesize themeVer, latestThemeVer;

// 用户每次登陆或者自动登陆前，需要初始化的数据
-(void)prepareDataForLoginUser {
	Database *dbase = [Database sharedManager];
	[dbase setupDB];
	[dbase connectDB];
	FMDatabase *database = dbase.db;
	[database open];
	// 1. 加载昵称信息
	NSMutableArray *nickNameArr = [DataManager getUserInfoFromDB];
	NSMutableDictionary *dic = [HomePage nickNameDictionary];
	[dic removeAllObjects];	// 先清空，防止切换服务器时数据混乱
	for (NamenickInfo *nickInfo in nickNameArr) {
		[dic setObject:nickInfo.userNick forKey:nickInfo.userName];
	}
	// 2. 加载用户信息
	UserInfo *info = [UserInfo sharedUserInfo];
	[info loadDataFromDB];	// 重新加载数据，防止切换服务器时数据混乱
    
    // 3. 启动异步theme下载，更新theme信息
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
    [self downloadTheme:actSite.descriptionInfo.svrUrl withVer:actSite.themeVer];
}

- (void)updateTheme:(NSNotificationCenter *)noti{
    NSDictionary  *dic = [[HpThemeManager sharedThemeManager]themeDictionary];
    NSString    *themePathTmp = [dic objectForKey:@"Common"];
    NSString  *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    UIImage *imageNav = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"navigationbar_bg.png"]];
    [SCAppUtils navigationController:homeNav setImage:imageNav];
    [SCAppUtils navigationController:msgNav setImage:imageNav];
    [SCAppUtils navigationController:moreNav setImage:imageNav];
}

//构造主体框架
- (void)constructContent{
    NSDictionary *dic = nil;
    NSDictionary *pathDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"ThemePath"];
    if ([pathDic count] == 0){
        dic = [[HpThemeManager sharedThemeManager]themeDictionary];
        if ([dic count] == 0) {
            NSString *skinPath = [[NSBundle mainBundle] pathForResource:@"ThemeManager" ofType:@"plist"];
            dic = [[NSArray arrayWithContentsOfFile:skinPath] objectAtIndex:0];
        }
    }
    else{
        dic = pathDic;
    }
	NSString *themePathTmp = [dic objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    UIImage *imageNav = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"navigationbar_bg.png"]];
    mainContent = [[RXCustomTabBar alloc] init];
	//homePage
    homeTab      = [[HomePage alloc] init];
    homeNav      = [[UINavigationController alloc] initWithRootViewController:homeTab];
    [SCAppUtils navigationController:homeNav setImage:imageNav];
    //messagePage  
    msgTab    = [[MessagePage alloc] init];
    msgNav    = [[UINavigationController alloc] initWithRootViewController:msgTab];    
    [SCAppUtils navigationController:msgNav setImage:imageNav];
    //searchPage
    searchTab  = [[SearchPage alloc] init];
	searchNav = [[UINavigationController alloc] initWithRootViewController:searchTab];

    //morePage
    moreTab      = [[MorePage alloc] init];
    moreNav = [[UINavigationController alloc] initWithRootViewController:moreTab];
    [SCAppUtils navigationController:moreNav setImage:imageNav];
    
	NSArray *controllers = [NSArray arrayWithObjects:homeNav,msgNav,searchNav,moreNav,nil];
    mainContent.viewControllers= controllers;
	mainContent.view.tag = MAIN_CONTENT_VIEW_TAG;
	// 当应用程序启动的时候，若用户已经登录，则检查更新操作
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite.bUserLogin) {
		[self checkForNewMessage];
	}
	
    //[mainContent showNewMsgBubble:@"200"];
	// 2012-02-21 设置委托接收对象为自身
	[[DraftController sharedInstance] setMyDraftControllerDelegate:self];
}

//检查登陆状态
//- (void)checkLogin{    
//    NSUserDefaults *usrdefault = [NSUserDefaults standardUserDefaults];  
//    BOOL login                 = [usrdefault boolForKey:KLOGIN]; 
//    //NSString *accessToken      = [usrdefault objectForKey:KACCESSTOKEN]; 
//    CLog(@"登陆状态：%d",login);
//   // CLog(@"accessToken：%@",accessToken);
//    if (login) {   //用户登录过
//
//        CLog(@"直接进入用户个人界面");
//	// 2012-02-22 By Yi Minwen 登陆后获取收听列表		
//	 [[DraftController sharedInstance] updateFriendsFansList];
//		// 2012-02-22 By Yi Minwen 登陆后获取收听列表	
//		Database *dbase = [Database sharedManager];
//		[dbase setupDB];
//		[dbase connectDB];
//		FMDatabase *database = dbase.db;
//		[database open];
//		[self prepareDataForLoginUser];
//        NSUserDefaults *usrdefault = [NSUserDefaults standardUserDefaults];
//        [usrdefault setBool:NO  forKey:KFIRSTLOGIN];
//        [usrdefault synchronize];
//	 [self performSelector:@selector(playAnimation)];
//        [self constructMainFrame];
//	 [self.window addSubview:mainContent.view];
////		[homeTab insteadViewDidLoad];    //added by wangying 修改为viewDidLoad
//    }else
//    {
//        //[[self.window viewWithTag:999] removeFromSuperview];
//        [self performSelector:@selector(playAnimation)];
//        loginController = [[LoginPage alloc] init];
//        loginController.view.tag = LOGIN_PAGE_TAG;
//        [self.window addSubview:loginController.view];
//    }
//}
- (void)constructMainFrame
{
	iweiboAppDelegate *dele = (iweiboAppDelegate *)[[UIApplication sharedApplication] delegate];
	dele.window.backgroundColor = [UIColor whiteColor];
	// 强制刷新用户信息(存在情况: 用户退出登陆后，[UserInfo sharedUserInfo]被清空，需要重新加载)
	[[UserInfo sharedUserInfo] loadDataFromDB];
    if(mainContent == nil){
        [self constructContent];
    }
}
- (void)addMainFrame
{
	UIView *vwMainContent = [self.window viewWithTag:MAIN_CONTENT_VIEW_TAG];
	if (nil != vwMainContent) {
		[vwMainContent removeFromSuperview];
	}
	[self.window addSubview:mainContent.view];
	mainContent.selectedIndex = 0;
    mainContent.btn1.selected = TRUE;
    mainContent.btn4.selected = FALSE;
//   [homeTab insteadViewDidLoad];
}
//退出登陆
- (void)loginOut{
//	if (loginController != nil) {
//		[loginController release];
//	}
//
//	loginController = [[LoginPage alloc] init];
//	loginController.view.tag = LOGIN_PAGE_TAG;
    [LoginPage signOut];
	[homeTab setHomeButtonSelected];
	homeTab.homePageArray = [NSMutableArray array];
	[homeTab.homePageTable reloadData];
	msgTab.messageArray = [NSMutableArray array];
	[msgTab.messageTable reloadData];
	[msgTab setMessageButtonState];
    [mainContent showNewMsgBubble:@"0"];
    CLog(@"重现登陆界面");
    [self addSelectWeiboPageWithLogoutStatus:YES];
//    [self addLoginPage];
//    [self.window addSubview:loginController.view];
	/* modified by wangying  2012-02-21
    mainContent.selectedIndex = 0;
    mainContent.btn1.selected = TRUE;
    mainContent.btn4.selected = FALSE;
	 */
    CLog(@"退出成功");
}

-(void)backToSelectPage {
    shouldComeIn = NO;      // 切换微博时，不应该再加载介绍页面
	[homeTab setHomeButtonSelected];
	homeTab.homePageArray = [NSMutableArray array];
	[homeTab.homePageTable reloadData];
	msgTab.messageArray = [NSMutableArray array];
	[msgTab.messageTable reloadData];
	[msgTab setMessageButtonState];
    [mainContent showNewMsgBubble:@"0"];
	[self addSelectWeiboPageWithLogoutStatus:NO];
}

- (void)selectSite{
    [LoginPage signOut];
	[mainContent showNewMsgBubble:@"0"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{	
    // 设置并存储判断值，记录程序是否是第一次进入
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }

    self.window.backgroundColor = [UIColor blackColor];
	application.statusBarStyle = UIStatusBarStyleBlackOpaque;
	self.draws = 1;
	self.firstLaunch = YES;
    self.shouldComeIn = YES;
	// 2012-05-16 By Yiminwen 拷贝资源文件到cache目录
	[[IWBSvrSettingsManager sharedSvrSettingManager] copyDefaultIconsToCachedDir];
	// 2012-05-25 By Yiminwen 加载数据库
	[[Database sharedManager] setupDB];
	[[Database sharedManager] connectDB];
	FMDatabase *database = [Database sharedManager].db;
	[database open];
	// 数据库升级脚本执行
	[DataManager executeSQLDBUpdate];
	//self.window.backgroundColor = [UIColor clearColor];
	self.nNewMsgTimer = [NSTimer scheduledTimerWithTimeInterval:180
														target:self
													  selector:@selector(checkForNewMessage) 
													  userInfo:nil
													   repeats:YES];
	// 加载初始页面
	// 检测是否已登陆
    // 2012-06-25 by Yiminwen
    // 不论是否登陆，直接进入服务器列表页面
//	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
//	if (actSite != nil && actSite.bUserLogin) {
//		[self addLoadingImg];
//	}
//	else {
    [self addSelectWeiboPageWithLogoutStatus:NO];
//	}
	// 假如已登陆，则进入主页
//	[self performSelector:@selector(turnToMainContentIfNeed) withObject:nil afterDelay:0.1f];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification object:nil];
    
    [self.window makeKeyAndVisible];
	return YES;
    

}

- (void)dealloc
{
    CLog(@"delloc");
    [homeNav    release];
    [homeTab    release];
    [moreNav    release];
    [moreTab    release];
    [searchTab  release];
	[searchNav release];
	searchNav = nil;
    [msgNav     release];
    [msgTab     release];
    [loginController release];
    [mainContent release];
    [_window release];
	if ([nNewMsgTimer isValid]) {
		[nNewMsgTimer invalidate];
	}
	[nNewMsgTimer release];
	[self.nNewMsgApi cancelSpecifiedRequest];
	self.nNewMsgApi = nil;
	[[DraftController sharedInstance] setMyDraftControllerDelegate:nil];
    [cStatusBar release];
//    [selectPage release];
	[super dealloc];
}

- (void)playAnimation {
    CLog(@"Animation..");
    //动画过程就是删除的过程
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.8];
	UIView *vw = [self.window viewWithTag:LOADING_IMG_TAG];
	if (vw) {
		[vw removeFromSuperview];
	}
//	UIView *vwLogin = [self.window viewWithTag:LOGIN_PAGE_TAG];
//	if (vwLogin) {
//		[vwLogin removeFromSuperview];
//	}
//	UIView *vwSelect = [self.window viewWithTag:SELECT_WB_PAGE_TAG];
//	if (vwSelect) {
//		[vwSelect removeFromSuperview];
//	}
    //[UIView setAnimationDidStopSelector:@selector(checkLogin)];
//	self.window.rootViewController = nil;
    [UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView:self.window cache:YES];
	[UIView commitAnimations];
    CLog(@"Animation..end");
}

-(void)addLoadingImg {
	NSString *loadingImgPath = [[IWBSvrSettingsManager sharedSvrSettingManager].activeSite.siteMainPath stringByAppendingPathComponent:SITE_LOADING_NAME];
    NSLog(@"testimg is %@",loadingImgPath);
    NSLog(@"loadingImgPath is %@",[IWBSvrSettingsManager sharedSvrSettingManager].activeSite);
    UIImage *bgImage = [UIImage imageWithContentsOfFile:loadingImgPath];
    if (nil == bgImage) {
        // 下载图片失败的情况下用默认图片替换
        bgImage = [UIImage imageNamed:@"iWeiboLoadingDefault.png"];
    }
	UIImageView *launchPic = [[UIImageView alloc] initWithImage:bgImage];
	launchPic.frame = CGRectMake(0, 20, 320, 460);
	launchPic.tag = LOADING_IMG_TAG;
	[self.window addSubview:launchPic];
	UIView *vwLogin = [self.window viewWithTag:SELECT_WB_PAGE_TAG];
	if (vwLogin) {
		[self.window bringSubviewToFront:vwLogin];
	}
    [launchPic release];
}

-(void)addSelectWeiboPageWithLogoutStatus:(BOOL)bLogout {
    if (nil != selectPage) {
        [selectPage release];
        selectPage = nil;
    }
	selectPage = [[SelectWeiboPage alloc] init];
    //    selectPage.bLogout = bLogout;
	selectPage.view.tag = SELECT_WB_PAGE_TAG;
    selectPage.view.frame = CGRectMake(0, 20, 320, 460);
	iweiboAppDelegate *dele = (iweiboAppDelegate *)[[UIApplication sharedApplication] delegate];
	dele.window.backgroundColor = [UIColor blackColor];
	UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:selectPage];
	self.window.rootViewController = nvc;
    
    //	[self.window addSubview:selectPage.view];
	[nvc setNavigationBarHidden:TRUE];
    if (bLogout) {
        LoginPage *loginControl = [[LoginPage alloc] init];
        loginControl.view.tag = LOGIN_PAGE_TAG;
        [nvc pushViewController:loginControl animated:YES];
        [loginControl release];
    }
	[nvc release];
}

-(void)addLoginPage{
	if (loginController != nil) {
		[loginController release];
	}
	loginController = [[LoginPage alloc] init];
	loginController.view.tag = LOGIN_PAGE_TAG;
	UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:loginController];
	self.window.rootViewController = nvc;
	[nvc setNavigationBarHidden:TRUE];
	[nvc release];
}

// 假如已登陆，则进入主页
-(void)turnToMainContentIfNeed {
	// 检测是否已登陆
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {
        CLog(@"直接进入用户个人界面");
		// 1. 加载初始化信息
		[self prepareDataForLoginUser];
		// 2. 设置登陆状态
		[[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:actSite.descriptionInfo.svrUrl withUser:actSite.loginUserName loginState:YES firstLogin:NO];
		// 2012-02-22 By Yi Minwen 登陆后获取收听列表		
		[[DraftController sharedInstance] updateFriendsFansList];
		[self performSelector:@selector(playAnimation)];
        [self constructMainFrame];
		[self.window addSubview:mainContent.view];
    }
}

// 旧版逻辑
// 先生成loading页面，然后动画删除loading页面
// 假如已登陆，直接弹出主timeline
// 假如没登陆，弹出登陆页面
// 新版
// 判断登陆状态，假如已登陆，则先生成loading页面，动态删除，然后再进入主timeline
// 假如未登陆，则弹出服务器选择页面

-(void)addLoadingImage {
	NSString *loadingImgPath = [[IWBSvrSettingsManager sharedSvrSettingManager].activeSite.siteMainPath stringByAppendingPathComponent:SITE_LOADING_NAME];
	UIImageView *launchPic = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:loadingImgPath]];
	launchPic.frame = CGRectMake(0, 20, 320, 460);
	launchPic.tag = 999;
	[self.window insertSubview:launchPic aboveSubview:[self.window viewWithTag:111]];
	[self.window bringSubviewToFront:launchPic];
	[self.window setNeedsLayout];
    [launchPic release];
	[[self.window viewWithTag:111] removeFromSuperview];
	//[self performSelector:@selector(playAnimation)];
}

- (void)applicationWillResignActive:(UIApplication *)application
{   
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
	if ([self.nNewMsgTimer isValid]) {
		[self.nNewMsgTimer invalidate];
	}
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
	// 下载线程暂停
	[[IWBSvrSettingsManager sharedSvrSettingManager] CancelThemeDownLoading];
	if (isDownloadingTheme) {
		isCancelledFromBackground = YES;
	}
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{   
	self.nNewMsgTimer = [NSTimer scheduledTimerWithTimeInterval:180
														target:self
													  selector:@selector(checkForNewMessage)
													  userInfo:nil
													   repeats:YES];
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
	// 下载线程重新启动
	if (isCancelledFromBackground) {
		isCancelledFromBackground = NO;
		[self getThemeInfo];
	}
} 

- (void)applicationDidBecomeActive:(UIApplication *)application
{   
//  [self confirmationWasHidden:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{   
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
 消息更新通知相关代码
 */
// 检查消息更新
- (void)checkForNewMessage {
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithCapacity:10];
	[parameters setValue:@"json" forKey:@"format"];
	[parameters setValue:@"0" forKey:@"pageflag"];
	[parameters setValue:@"60" forKey:@"reqnum"];
	[parameters setValue:@"0" forKey:@"pagetime"];
	[parameters setValue:@"0" forKey:@"type"];
	[parameters setValue:@"0" forKey:@"contenttype"];
	[parameters setValue:URL_HOME_TIMELINE forKey:@"request_api"];
	if (nil == self.nNewMsgApi) {
        nNewMsgApi = [[IWeiboAsyncApi alloc] init];
    }
	[self.nNewMsgApi getHomeTimelineMsgWithParamters:parameters 
										   delegate:self 
										  onSuccess:@selector(checkForNewMessageSuccess:) 
										  onFailure:@selector(checkForNewMessageFailure:)];
    [parameters release];
}


- (void)informTheNumberOfNewMessages:(int)num {
	
	NSString *bubble = [NSString stringWithFormat:@"%d", num];
	[mainContent showNewMsgBubble:bubble];
}


// 检查新更新的消息的数目
- (void)checkForNumberOfNewMsgFromResult:(NSDictionary *)result {
	if (nil == result || [result isKindOfClass:[NSNull class]]) {
		return;
	}
	NSLog(@"checkForNumberOfNewMsgFromResult---------->>>>>>>>");
	NSString *timeStamp = nil;
	NSString *referTimeStamp = nil;
	if (YES == self.firstLaunch) {
		referTimeStamp = [[NSUserDefaults standardUserDefaults] objectForKey:@"NewTimeStamp"];
		self.firstLaunch = NO;
	}else {
		referTimeStamp = homeTab.newTimeStamp;
	}

	int n=0;
	for (NSDictionary *sts in result) {	
		if ([sts isKindOfClass:[NSDictionary class]] && sts) {
			timeStamp = [NSString stringWithFormat:@"%@", [sts objectForKey:@"timestamp"]];
			//
			if ([timeStamp compare:referTimeStamp]== NSOrderedDescending) {
				n++;
			}
		}	
	}
	
	[self informTheNumberOfNewMessages:n];
}


// 检查消息更新成功回调函数
- (void)checkForNewMessageSuccess:(NSDictionary *)dictionary {
	NSDictionary *data = [dictionary objectForKey:@"data"];
	if (data == nil || [data isKindOfClass:[NSNull class]] || ![data isKindOfClass:[NSDictionary class]]) {
		return;
	}
	int errCode = [[data objectForKey:@"errcode"] intValue];
	int retCode = [[data objectForKey:@"ret"] intValue];

	NSDictionary *dict = nil;
	if (0 == errCode && retCode == 0) {
		dict = [data objectForKey:@"info"];
	}else {
		NSLog(@"返回数据有错误");
	}

	if (dict != nil && [data isKindOfClass:[NSDictionary class]]) {
		[self checkForNumberOfNewMsgFromResult:dict];
	}
}


// 检查消息更新失败回调函数
- (void)checkForNewMessageFailure:(NSError *)error {
	NSLog(@"check for new message error:%@", [error localizedDescription]);
}

#pragma mark DraftControllerDelegate

-(void)DraftSendOnSuccess:(NSDictionary *)dict {
	// 异步消息发送成功回调
	NSDictionary *data = [DataCheck checkDictionary:dict forKey:HOMEDATA withType:[NSDictionary class]];
	if (![data isKindOfClass:[NSNull class]]) {
		NSNumber *draftSendTime = [data objectForKey:@"time"];
        NSString *draftId = [data objectForKey:@"id"];
		[homeTab setDraftSendTime:draftSendTime andID:draftId];
        [homeTab reloadNewDataSource:draftRequest];		//2012-03-09 addedby wangying 此处应腾讯要求在写消息后应在timeline上立即显示出来
	}
	NSNumber *ret = [dict objectForKey:@"ret"];
	NSString *msg = [dict objectForKey:@"msg"];
	NSString *msgDecode = [msg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	CLog(@"HomePage:DraftSendOnSuccess:%@ msgDecode=%@", dict, msgDecode);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDelay:3.5];
	[UIView setAnimationDuration:1.5];
	self.cStatusBar.type = statusTypeSuccess;
	if ([ret intValue] == 0) {
		[self.cStatusBar showWithStatusMessage:@"发送成功!"];
	}
	else {
		[self.cStatusBar showWithStatusMessage:msgDecode];
	}
	[self.cStatusBar setNeedsDisplay];
	[homeTab setMutex:YES];
	[UIView setAnimationDidStopSelector:@selector(successCallBack)];
	[UIView commitAnimations];
}

-(void)DraftSendOnFailure:(NSError *)error {
	// 异步消息发送失败回调
	CLog(@"HomePage:DraftSendOnFailure");
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDelay:3.5];
	[UIView setAnimationDuration:1.5];
	self.cStatusBar.type = statusTypeSuccess;
	[self.cStatusBar showWithStatusMessage:@"发送失败"];
	[self.cStatusBar setNeedsDisplay];
	[homeTab setMutex:YES];
	[UIView setAnimationDidStopSelector:@selector(successCallBack)];
	[UIView commitAnimations];
}

- (void)successCallBack{
    NSLog(@"successCallBack");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.5];
    [UIView setAnimationDuration:1.5];
    [self.cStatusBar setFrame:CGRectMake(0, -20, 320, 20)];
    [UIView commitAnimations];
}

- (void)showDraftStatus{
	if (self.cStatusBar == nil) {
		cStatusBar = [[CustomStatusBar alloc] init];
	}
	[UIView beginAnimations:nil context:nil];
	self.cStatusBar.frame = CGRectZero;
	self.cStatusBar.type = statusTypeLoading;
	[self.cStatusBar showWithStatusMessage:@"发送中..."];
	[UIView commitAnimations];
	[homeTab setMutex:NO];
}

// 用户登陆失效
-(void)onLoginUserExpired {
//	UIView *vwLogin = [self.window viewWithTag:LOGIN_PAGE_TAG];
//	if (vwLogin == nil) {
    // 2012-07-04 By Yiminwen 处理未登陆情况下，又添加了一次登陆页的问题
        CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
        if (actSite != nil && actSite.bUserLogin) {
            [self addSelectWeiboPageWithLogoutStatus:YES];
        }
//	}
}


-(void)getThemeInfo {
    isDownloadingTheme = NO;
	NSMutableDictionary *par = [NSMutableDictionary dictionaryWithCapacity:3];
	[par setObject:@"json" forKey:@"format"];
	[par setObject:@"customized/theme" forKey:@"request_api"];
    // 获取当前siteUrl的themeVer信息
    [par setObject:self.themeVer forKey:@"ver"];
    if (nil == nNewMsgApi) {
        nNewMsgApi = [[IWeiboAsyncApi alloc] init];
    }
	[nNewMsgApi getCustomizedThemeWithUrl:self.strSiteUrl Parameters:par delegate:self
                                    onSuccess:@selector(onGetThemeSuccess:) onFailure:@selector(onGetThemeFailure:)];
}

- (void) getSiteInfo{
    NSMutableDictionary *par = [NSMutableDictionary dictionaryWithCapacity:2];
	[par setObject:@"json" forKey:@"format"];
	[par setObject:@"customized/siteinfo" forKey:@"request_api"];
    [nNewMsgApi getCustomizedSiteInfoWithUrl:self.strSiteUrl 
                                  Parameters:par 
                                    delegate:self 
                                   onSuccess:@selector(onCheckSuccess:) 
                                   onFailure:@selector(onCheckFailure:)];
}

- (void)onGetThemeSuccess:(NSDictionary *)reciveData{
    NSDictionary *dicData = [DataCheck checkDictionary:reciveData forKey:@"data" withType:[NSDictionary class]];
	if ([dicData isKindOfClass:[NSDictionary class]] && [dicData count] > 0) {
		self.latestThemeVer = [NSString stringWithFormat:@"%@", [dicData objectForKey:@"version"]];
		NSDictionary *dicTheme = [dicData objectForKey:@"list"];
		if ([dicTheme isEqual:[NSNull null]] || [dicTheme count] == 0) {
            // 不做处理
            [self getSiteInfo];
		}
		else {
            isDownloadingTheme = YES;
			[[IWBSvrSettingsManager sharedSvrSettingManager] downloadTheme:self.strSiteUrl
																wiThemeDic:dicTheme 
																  delegate:self 
																  Callback:@selector(iconsDidFinishedDownloadingWithPar:)];
        }
	}
	else {
        // 不做处理
        [self getSiteInfo];
	}
}

- (void)onGetThemeFailure:(NSError *)error {
    // 不用处理
    [self getSiteInfo];
}



- (void)onCheckSuccess:(NSDictionary *)recivedData{
    NSLog(@"%s",__FUNCTION__);
	NSDictionary *dicData = [recivedData objectForKey:@"data"];
	if ([dicData isKindOfClass:[NSDictionary class]]) {
		SiteDescriptionInfo *siteDescriptionInfo = [[SiteDescriptionInfo alloc] initWithDic:dicData];
		[[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:self.strSiteUrl withDescription:siteDescriptionInfo];
		[siteDescriptionInfo release];
	}
}

- (void)onCheckFailure:(NSError *)failData{
    NSLog(@"%s", __FUNCTION__);
}

-(void)iconsDidFinishedDownloadingWithPar:(NSDictionary *)result {
	isDownloadingTheme = NO;
	CLog(@"%s", __FUNCTION__);// 更新信息theme信息
	NSString *ret = [result objectForKey:@"ret"];
	if ([ret intValue] != 0) {
		NSString *strFolder = [result objectForKey:@"PATH"];
		// 保存信息到本地文件themeDic:(NSDictionary *)dicDeltaTheme andIconFolder
		BOOL bResult = [[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:self.strSiteUrl
																		   withVer:self.latestThemeVer 
																		  themeDic:nil
																	 andIconFolder:strFolder];
        self.themeVer = self.latestThemeVer;
		if (!bResult) {
            // 不用处理
		}
        else {
            [self performSelector:@selector(getSiteInfo) withObject:nil afterDelay:0];
        }
	}
	else {
        // 不用处理
        [self performSelector:@selector(getSiteInfo) withObject:nil afterDelay:0];
	}
}

-(void)downloadTheme:(NSString *)siteUrl withVer:(NSString *)strVer {
	[[IWBSvrSettingsManager sharedSvrSettingManager] CancelThemeDownLoading];
    self.strSiteUrl = siteUrl;
    self.themeVer = strVer;
    [self getThemeInfo];
}

// 取消下载
-(void)cancelDownloadingTheme {
	[[IWBSvrSettingsManager sharedSvrSettingManager] CancelThemeDownLoading];
    isDownloadingTheme = NO;
    isCancelledFromBackground = NO;
}

@end
