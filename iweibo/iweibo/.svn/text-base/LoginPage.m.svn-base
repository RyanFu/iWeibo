//
//  LoginPage.m
//  iweibo
//
//  Created by LiQiang on 11-12-22.
//  Copyright 2011年 Beyondsoft. All rights reserved.
//

#import "LoginPage.h"
#import "iweiboAppDelegate.h"
#import "FMDatabase.h"
#import "Database.h"
#import "MyFavTopicInfo.h"
#import "MyFriendsFansInfo.h"
#import "UserInfo.h"
#import "NSString+QEncoding.h"
#import "IWBGifImageCache.h"
#import "IWBSvrSettingsManager.h"
#import "UserAuthBindingWebViewController.h"
#import "RegisterUserViewController.h"

#define kScreenWidth 320
#define kScreenHeight 435
#define CREATED @"created"

@implementation LoginPage
@synthesize dicDetailInfoCopy;
@synthesize loginBg, MBprogress;
@synthesize usrTextField, pwdTextField;

+ (void)signOut{
    CLog(@"清空登陆信息");
//	FMDatabase *db = [Database sharedManager].db;
	// 删除我的听众信息
	[MyFriendsFansInfo removeFriendsFansFromDB];	
	// 删除我的话题数据
	[MyFavTopicInfo removeTopicsFromDB];
	//清除微博信息
	[DataManager removeWeiboInfoFromDB];
	[DataManager removeMessageWeiboInfoFromDB];
	//清除微博源信息
	[DataManager removeSourceInfoFromDB];
	[DataManager removeMessageSourceInfoFromDB];
	//清除订阅话题
	[DataManager removeHotWordSearch];
    [DataManager removeCachedImagesFromDB];
	//清除gif图
	[[IWBGifImageCache sharedImageCache] clearMemory];
	[[IWBGifImageCache sharedImageCache] clearDisk];
	//清除视频，音频信息
//	[DataManager removeVideoInfoFromDB];
	// 删除昵称信息
	[DataManager removeAllUserNameNickInfo];
//	[db close];
}


- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[MBprogress release];
	MBprogress = nil;
    [loginState release];
    loginState = nil;
	[loginBg release];
	loginBg = nil;
	[api cancelSpecifiedRequest];
	[api release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) showAlert: (NSString *) theMessage{
    bBtnLoginClicked = NO;
    UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"错误" message:theMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [av show];
}

- (void) showWarning: (NSString *) theMessage{
    bBtnLoginClicked = NO;
    UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"提示" message:theMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [av show];
}

- (void) showMBProgress{
    if (MBprogress == nil) {
        MBprogress = [[MBProgressHUD alloc] initWithFrame:CGRectMake(30, 80, 260, 200)]; 
    }
    [self.view addSubview:MBprogress];  
    [self.view bringSubviewToFront:MBprogress];  
    MBprogress.labelText = @"登录中";  
    MBprogress.removeFromSuperViewOnHide = YES;
    [MBprogress show:YES];  
}
- (void) hiddenMBProgress{
    [MBprogress hide:YES];
}

-(void)clearLoginState {
	// 清除登陆状态
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil) {
		[[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:actSite.descriptionInfo.svrUrl withUser:@"" loginState:NO firstLogin:NO];
        actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
		[[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:actSite.descriptionInfo.svrUrl withUser:@"" accessToken:@"" accessKey:@""];
	}
}

/*
 获取当前用户详细信息成功时的回调函数
 */
- (void)getMyDetailInfoSuccess:(NSDictionary *)info {	
	// 将数据保存在本地，并且初始化UserInfo对象
	id code = [DataCheck checkDictionary:info forKey:@"ret" withType:[NSNumber class]];
	if (code == [NSNull null]) {
		[self clearLoginState];
        [self hiddenMBProgress];
		[self showAlert:@"网络数据异常"];
		return;
	}
    NSLog(@"%s,[code intValue] =%d ", __FUNCTION__, [code intValue]);
	if ([code intValue] == 0) {
		// 请求结果正常
        id dataRs = [DataCheck checkDictionary:info forKey:@"data" withType:[NSDictionary class]];
        if (dataRs == [NSNull null]) {
			[self clearLoginState];
			[self hiddenMBProgress];
			[self showAlert:@"网络数据异常"];
            return;
        }
		NSDictionary *userInfo1 = [NSDictionary dictionaryWithDictionary:[info objectForKey:@"data"]];
		NSString *userName = [userInfo1 objectForKey:@"name"];
		// 1. 先更新登陆状态
		if ([userName isKindOfClass:[NSString class]]) {
			CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
			if (actSite != nil) {
				[[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:actSite.descriptionInfo.svrUrl withUser:userName loginState:YES firstLogin:YES];
			}
		}
		// 2. 存储数据
        NSLog(@"------------------------------------------------------nick0 is %@,tweetnum0 is %@, fans is %@,idom is %@, head is %@",[userInfo1 objectForKey:@"nick"],[userInfo1 objectForKey:@"tweetnum"],[userInfo1 objectForKey:@"fansnum"],[info objectForKey:@"idolnum"],[info objectForKey:@"head"]);
		[[UserInfo sharedUserInfo] saveUserDataToUserInfo:userInfo1];
	}else {
		// 数据结果有错误，要进行容错处理
		[self clearLoginState];
		NSString *msg = [info objectForKey:@"msg"];
		NSString *msgDecode = [msg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		[self showAlert:msgDecode];
		[self hiddenMBProgress];
		return;
		
	}
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
	// 准备工作
	[delegate prepareDataForLoginUser];
	[delegate performSelector:@selector(constructMainFrame)];
	[delegate performSelector:@selector(playAnimation)];
	[delegate performSelector:@selector(addMainFrame)];
    delegate.window.rootViewController = nil;
	[self hiddenMBProgress];
	//	
	// 2012-02-22 By Yi Minwen 登陆后获取收听列表		
	[[DraftController sharedInstance] updateFriendsFansList];
	[[DraftController sharedInstance] getHotTopicList];
	[[DraftController sharedInstance] getSubscibedTopicList];
    
    bBtnLoginClicked = NO;
}

/*
 获取当前用户详细信息失败时的回调函数
 */
- (void)getMyDetailInfoFailure:(NSError *)error {
    if (error != nil) {
        [self hiddenMBProgress];
        [self showAlert:@"网络数据异常"];
        return;
    }
}

- (void)onSuccess:(NSDictionary *)result {
	NSString *msg = [result objectForKey:@"msg"];
	NSString *msgDecode = [msg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *ret = [DataCheck checkDictionary:result forKey:@"ret" withType:[NSNumber class]];
	if ([ret isKindOfClass: [NSNull class]]) {
        [self hiddenMBProgress];
		[self showAlert:@"网络数据异常"];
		return;
	}
	CLog(@"msg:%@， retValue:%@", msgDecode, ret);
    NSInteger retValue = [ret intValue];
    if(retValue == 0)
    {
		id infoclass = [DataCheck checkDictionary:result forKey:@"data" withType:[NSDictionary class]];
		// 登陆态模式
		if ([infoclass isKindOfClass:[NSNull class]]) {
			CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
			if (actSite != nil) {
				[[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:actSite.descriptionInfo.svrUrl withUser:@"" loginState:YES firstLogin:YES];
			}
		}
		else {		//OAuth模式
			//用户和密码正确
			NSDictionary *usrInfo = [result objectForKey:@"data"];
			
			id tokenClass = [DataCheck checkDictionary:usrInfo forKey:@"oauth_token" withType:[NSString class]];
			id secretClass = [DataCheck checkDictionary:usrInfo forKey:@"oauth_token_secret" withType:[NSString class]];
			if (tokenClass == [NSNull null] || secretClass == [NSNull null]) {
				[self hiddenMBProgress];
				[self showAlert:@"网络数据异常"];
				return;
			}
			NSString *accessToken = [usrInfo objectForKey:@"oauth_token"];
			NSString *accessTokenSecret = [usrInfo objectForKey:@"oauth_token_secret"];
			CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
			if (actSite != nil) {
				[[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:actSite.descriptionInfo.svrUrl withUser:@"" loginState:YES firstLogin:YES];
                actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
				[[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:actSite.descriptionInfo.svrUrl withUser:@"" accessToken:accessToken accessKey:accessTokenSecret];
			}
		}
		[api getUserInfoWithDelegate:self onSuccess:@selector(getMyDetailInfoSuccess:) onFailure:@selector(getMyDetailInfoFailure:)];
	}else
    {
        [self hiddenMBProgress];
        switch (retValue) {
            case 1:
                [self showAlert:@"本地帐号不存在"];
                break;
            case 2:
                [self showAlert:@"密码错误，再试一次？"];
                break;
            case 3: {
                // 跳转到授权页面
//                [usrTextField resignFirstResponder];
//                [pwdTextField resignFirstResponder];
//                [self performSelectorOnMainThread:@selector(scrollIfNeeded:) withObject:[NSNumber numberWithFloat:230.0f] waitUntilDone:NO];
                [self showWarning:@"请先绑定腾讯微博账号"];
                UserAuthBindingWebViewController *webUrlViewController = [[UserAuthBindingWebViewController alloc] init];
                NSString *str = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite.descriptionInfo.svrUrl;
                webUrlViewController.parentViewControllerId = self;
                NSString *strEncodeName =[usrTextField.text URLEncodedString];
                webUrlViewController.webUrl = [NSString stringWithFormat:@"%@private/authorize?user=%@", str, strEncodeName];
                [self.navigationController pushViewController:webUrlViewController animated:YES];
                [webUrlViewController release];
            }
                break;
            case 4:
                [self showAlert:@"系统错误"];
                break;
            default:
			{
				NSString *msg = [result objectForKey:@"msg"];
				[self showAlert:[msg URLDecodedString]];
			}
                break;
        }
        return;
    }
}

- (void)onFailure:(NSError *)error {
    CLog(@"error = %@",error);
    if (error != nil) {
        [self hiddenMBProgress];
        [self showAlert:@"请检查网络链接"];
        return;
    }
}

- (void)didLogin{
    if (bBtnLoginClicked) {
        return;
    }
    bBtnLoginClicked = YES;
    [self performSelectorOnMainThread:@selector(scrollIfNeeded:) withObject:[NSNumber numberWithFloat:230.0f] waitUntilDone:NO];
	// 检测后台host地址
	[pwdTextField resignFirstResponder];
	[usrTextField resignFirstResponder];
    [self showMBProgress];
    NSString *usrName = usrTextField.text;
    NSString *usrPwd  = pwdTextField.text;
    if (![usrName length]) {
        [self hiddenMBProgress];
        [self showAlert:@"您似乎忘记输入账号啦"];
        return;
    }
    if (![usrPwd length]) {
        [self hiddenMBProgress];
        [self showAlert:@"您似乎忘记输入密码啦"];
        return;
    }
	[[Database sharedManager] setupDB];
	[[Database sharedManager] connectDB];
	FMDatabase *database = [Database sharedManager].db;
	[database open];
	//数据表增加userName和site两个字段
	NSString *isCreated = [[NSUserDefaults standardUserDefaults] objectForKey:CREATED];
	if (!isCreated) {
		BOOL isAlterWordSiteOK = [DataManager alterHotWordSearchColoum:@"site"];
		BOOL is = [DataManager alterHotSearchColoum:@"userName"];
		BOOL isAlterSearchSiteOK = [DataManager alterHotSearchColoum:@"site"];
		if (isAlterWordSiteOK && isAlterSearchSiteOK && is) {
			[[NSUserDefaults standardUserDefaults] setObject:@"OK" forKey:CREATED];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
	}
	if (api == nil) {
		api = [[IWeiboAsyncApi alloc] init];
	}
    [api iweiboLoginWithUserName:usrName password:usrPwd delegate:self
                       onSuccess:@selector(onSuccess:) onFailure:@selector(onFailure:)];
}

-(void)onRegisterSuccess:(NSDictionary *)result {
	NSString *msg = [result objectForKey:@"msg"];
    if ([[result objectForKey:@"ret"] intValue] != 0) {
        [self showAlert:[msg URLDecodedString]];
    }
	CLog(@"%s,result:%@, msg:%@", __FUNCTION__, result, [msg URLDecodedString]);
}

-(void)onRegisterFailure:(NSError *)error {
    [self showAlert:[error localizedDescription]];
	CLog(@"%s,result:%@", __FUNCTION__, [error localizedDescription]);
}

-(void)onRegister {
//    [usrTextField resignFirstResponder];
//    [pwdTextField resignFirstResponder];
//    [self performSelectorOnMainThread:@selector(scrollIfNeeded:) withObject:[NSNumber numberWithFloat:230.0f] waitUntilDone:NO];
    RegisterUserViewController *registerController = [[RegisterUserViewController alloc] init];
    registerController.parentViewControllerId = self;
    [self.navigationController pushViewController:registerController animated:YES];
    [registerController release];
}

-(void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	[super viewWillAppear:animated];
    if (enumAuthStatus == SUCCEED_AUTH) {
        [self performSelector:@selector(didLogin) withObject:nil afterDelay:0.5f];
        enumAuthStatus = NEVER_AUTH;
    }
}

-(void)back {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)rememberState {
    if(isSelect == NO){
        loginState.image = [UIImage imageNamed:@"selected.png"];
        isSelect = YES;
    }else{
        loginState.image = [UIImage imageNamed:@"select.png"];
        isSelect = NO;
    }
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// 背景贴图
	NSString *themePath = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite.siteMainPath;
	if (themePath) {
		UIImage *bgImage = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:LOGINBG]];
        if (nil == bgImage) {
            // 下载图片失败的情况下用默认图片替换
            bgImage = [UIImage imageNamed:@"iWeiboLoginBgDefault.png"];
        }
		UIImageView *imgView= [[UIImageView alloc] initWithImage:bgImage];
//        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subScribeBg.png"]];
		self.loginBg = imgView;
        [imgView release];
		loginBg.userInteractionEnabled = YES; //是否相应用户事件
		loginBg.frame = CGRectMake(0, 0, 320, 460);
		[self.view addSubview:loginBg];
	}
//    UIImage *viewSearchImg = [UIImage imageNamed:@"subScribeTitleBg.png"];
//	UIImageView	*viewSearchBG = [[UIImageView alloc] initWithImage:viewSearchImg];
//	[loginBg addSubview:viewSearchBG];
//	viewSearchBG.userInteractionEnabled = YES;
//	[viewSearchBG release];
//	UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	leftButton.frame = CGRectMake(20, 5, 50, 30);
//	[leftButton setTitle:@"返回" forState:UIControlStateNormal];
//	leftButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
//	[leftButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 5)];
//	[leftButton setBackgroundImage:[UIImage imageNamed:@"subScribeNav.png"] forState:UIControlStateNormal];
//	[leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//	[loginBg addSubview:leftButton];
//    UIImage *viewSearchImg = [UIImage imageNamed:@"subScribeTitleBg.png"];
//	UIImageView	*viewSearchBG = [[UIImageView alloc] initWithImage:viewSearchImg];
//	[self.view addSubview:viewSearchBG];
//    [self.view bringSubviewToFront:viewSearchBG];
//	viewSearchBG.userInteractionEnabled = YES;
//	UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	leftButton.frame = CGRectMake(4, 5, 50, 30);
//	[leftButton setTitle:@"返回" forState:UIControlStateNormal];
//	leftButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
//	[leftButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 5)];
//	[leftButton setBackgroundImage:[UIImage imageNamed:@"subScribeNav.png"] forState:UIControlStateNormal];
//	[leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//	[viewSearchBG addSubview:leftButton];
//	UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 11, 200, 20)];
//	[customLab setTextColor:[UIColor whiteColor]];
//	[customLab setText:@"登录"];
//	[customLab setTextAlignment:UITextAlignmentCenter];
//	customLab.backgroundColor = [UIColor clearColor];
//	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
//    [viewSearchBG addSubview:customLab];
//	[customLab release];
//	[viewSearchBG release];
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	leftButton.frame = CGRectMake(10, 410, 50, 30);
//	[leftButton setTitle:@"返回" forState:UIControlStateNormal];
//	leftButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
//	[leftButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 5)];
//	[leftButton setBackgroundImage:[UIImage imageNamed:@"subScribeNav.png"] forState:UIControlStateNormal];
//	[leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//	[self.view addSubview:leftButton];
	UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
	leftButton.frame = CGRectMake(18, 402, 44, 43);
	[leftButton setBackgroundImage:[UIImage imageNamed:@"loginReturnBtn.png"] forState:UIControlStateNormal];
	[leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:leftButton];	
    usrTextField = [self getTextFieldNormal:PLACEUSRNAME];
    pwdTextField = [self getTextFieldSecure:PLACEPWD];
    
/////////
    CGRect bgFrameUsr = CGRectMake(18.0f, 205, 280.0f, 37.0f);
    UIImageView *textUsrBg = [[UIImageView alloc] initWithFrame:bgFrameUsr];
    textUsrBg.image = [UIImage imageNamed:@"input.png"];
    textUsrBg.userInteractionEnabled = YES;
    // 显示用户图像的图片
	UIImageView *nameHead = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registerUser.png"]];
	nameHead.frame = CGRectMake(10.0f, 9.0f, 15.0f, 18.0f);
	[textUsrBg addSubview:nameHead];
	[nameHead release];
    [textUsrBg addSubview:usrTextField];
    // 间隔10px
    CGRect bgFramePwd = CGRectMake(18.0f, textUsrBg.frame.size.height + textUsrBg.frame.origin.y + 10.0f, 280.0f, 37.0f);
    UIImageView *textPwdBg = [[UIImageView alloc] initWithFrame:bgFramePwd];
    textPwdBg.image = [UIImage imageNamed:@"input.png"];
    textPwdBg.userInteractionEnabled = YES;
	
    // 显示密码的图片
	UIImageView *pwdHead = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registerLock.png"]];
	pwdHead.frame = CGRectMake(10.0f, 9.0f, 15.0f, 18.0f);
	[textPwdBg addSubview:pwdHead];
	[pwdHead release];
    [textPwdBg addSubview:pwdTextField];
    
	[loginBg addSubview:textUsrBg];
	[loginBg addSubview:textPwdBg];
	[textUsrBg release];
    [textPwdBg release];
	UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn addTarget:self action:@selector(didLogin) forControlEvents:UIControlEventTouchDown];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"loginClickBtn.png"] forState:UIControlStateNormal];
	
	//    loginBtn.frame = CGRectMake(18, 237, 283, 40);
    //    loginBtn.frame = CGRectMake(18.0f, loginState.frame.size.height + loginState.frame.origin.y + 15.0f, 280.0f, 40);
    // 10px
    loginBtn.frame = CGRectMake(18.0f, textPwdBg.frame.size.height + textPwdBg.frame.origin.y + 10.0f, 280.0f, 40);
    [loginBg addSubview:loginBtn];
    
    loginState = [[UIImageView alloc] initWithFrame:CGRectMake(19.0f, loginBtn.frame.size.height + loginBtn.frame.origin.y + 11.0f, 13, 13)];
    loginState.image = [UIImage imageNamed:@"select.png"];
    loginState.userInteractionEnabled = YES;
//    isSelect = NO;
    UITapGestureRecognizer *stateClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rememberState)];
    [loginState addGestureRecognizer:stateClick];
    [stateClick release];
    [loginBg addSubview:loginState];
    
    
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(35.0f, textPwdBg.frame.size.height + textPwdBg.frame.origin.y + 9.0f, 120, 20)];
    leftLabel.text = @"记住密码";
	leftLabel.textColor = [UIColor colorWithRed:55.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1.0];
//    leftLabel.textColor = [UIColor blackColor];
    leftLabel.backgroundColor = [UIColor clearColor];
    leftLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
	CGSize leftSize = [leftLabel.text sizeWithFont:leftLabel.font];		// 文本高度
	leftLabel.frame = CGRectMake(34, loginBtn.frame.size.height + loginBtn.frame.origin.y + 8.0f, leftSize.width, leftSize.height);
    [loginBg addSubview:leftLabel];
	leftLabel.userInteractionEnabled = YES;
	UITapGestureRecognizer *stateClick2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rememberState)];
	[leftLabel addGestureRecognizer:stateClick2];
    [stateClick2 release];
    [leftLabel release];
	UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, loginBtn.frame.size.height + loginBtn.frame.origin.y + 8.0f, 90, 20)];
    rightLabel.text = @"立即注册";
    rightLabel.textColor = [UIColor colorWithRed:42.0/255.0 green:75.0/255.0 blue:126.0/255.0 alpha:1.0];
    rightLabel.backgroundColor = [UIColor clearColor];
    rightLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
	leftSize = [rightLabel.text sizeWithFont:rightLabel.font];		// 文本高度
	rightLabel.frame = CGRectMake(240, loginBtn.frame.size.height + loginBtn.frame.origin.y + 8.0f, leftSize.width, leftSize.height);
    rightLabel.userInteractionEnabled = YES;
    UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, leftSize.height-1, leftSize.width, 1)];
    imv.backgroundColor = [UIColor colorWithRed:42.0/255.0 green:75.0/255.0 blue:126.0/255.0 alpha:1.0];
    [rightLabel addSubview:imv];
    [imv release];
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRegister)];
    [rightLabel addGestureRecognizer:click];
    [loginBg addSubview:rightLabel];
    [click release];
    [rightLabel release];
    
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHidden)
												 name:UIKeyboardWillHideNotification
											   object:nil];
    return;
/////////
    
    
	// 显示用户名的背景图片
//	UIImageView *nameBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userNameBg.png"]];
////	nameBg.frame = CGRectMake(18, 140, 283, 43);
//	nameBg.frame = CGRectMake(18, 50, 283, 43);
//	[loginBg addSubview:nameBg];
//	[nameBg release];
//	
//	// 显示密码的背景图片
//	UIImageView *pwdBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pwdBg.png"]];
////	pwdBg.frame = CGRectMake(18, 185, 283, 43);
//	pwdBg.frame = CGRectMake(18, 95, 283, 43);
//	[loginBg addSubview:pwdBg];
//	[pwdBg release];
//	
//	// 显示用户图像的图片
//	UIImageView *nameHead = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user.png"]];
////	nameHead.frame = CGRectMake(23, 155, 14, 12);
//	nameHead.frame = CGRectMake(23, 65, 14, 12);
//	[loginBg addSubview:nameHead];
//	[nameHead release];
//	
//	// 显示用户名的文字
////	UILabel *nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(42, 155, 50, 14)];
//	UILabel *nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(42, 65, 50, 14)];
//	nameTitle.text = @"用户名";
//	nameTitle.backgroundColor = [UIColor clearColor];
//	nameTitle.font = [UIFont systemFontOfSize:14];
//	[loginBg addSubview:nameTitle];
//	[nameTitle release];
//	
//	// 显示用户密码的图片
//	UIImageView *pwdHead = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lck.png"]];
////	pwdHead.frame = CGRectMake(23, 201, 11, 11);
//	pwdHead.frame = CGRectMake(23, 111, 11, 11);
//	[loginBg addSubview:pwdHead];
//	[pwdHead release];
//	
//	// 显示密码文本
////	UILabel *pwdTitle = [[UILabel alloc] initWithFrame:CGRectMake(42, 201, 50, 14)];
//	UILabel *pwdTitle = [[UILabel alloc] initWithFrame:CGRectMake(42, 111, 50, 14)];
//	pwdTitle.text = @"密   码";
//	pwdTitle.backgroundColor = [UIColor clearColor];
//	pwdTitle.font = [UIFont systemFontOfSize:14];
//	[loginBg addSubview:pwdTitle];
//	[pwdTitle release];
//	
//	[loginBg addSubview:usrTextField];
//	[loginBg addSubview:pwdTextField];
//    
//    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
////    [loginBtn setTitle:@"登录微博" forState:UIControlStateNormal];
//    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [loginBtn addTarget:self action:@selector(didLogin) forControlEvents:UIControlEventTouchDown];
//	[loginBtn setBackgroundImage:[UIImage imageNamed:@"loginClickBtn.png"] forState:UIControlStateNormal];
////    loginBtn.frame = CGRectMake(18, 237, 283, 40);
//    loginBtn.frame = CGRectMake(18, 170, 283, 40);
//    [loginBg addSubview:loginBtn];
//    //[usrTextField becomeFirstResponder];
//	
//    loginState = [[UIImageView alloc] initWithFrame:CGRectMake(54, 152, 13, 13)];
//    loginState.image = [UIImage imageNamed:@"select.png"];
//    loginState.userInteractionEnabled = YES;
////    isSelect = NO;
//    UITapGestureRecognizer *stateClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rememberState)];
//    [loginState addGestureRecognizer:stateClick];
//    [stateClick release];
//    [loginBg addSubview:loginState];
//    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 150, 120, 20)];
//    leftLabel.text = @"记住密码";
//	leftLabel.textColor = [UIColor colorWithRed:42.0/255.0 green:75.0/255.0 blue:126.0/255.0 alpha:1.0];
//    leftLabel.backgroundColor = [UIColor clearColor];
//    leftLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
//	CGSize leftSize = [leftLabel.text sizeWithFont:leftLabel.font];		// 文本高度
//	leftLabel.frame = CGRectMake(70, 150, leftSize.width, leftSize.height);
//    [loginBg addSubview:leftLabel];
//	leftLabel.userInteractionEnabled = YES;
//	UITapGestureRecognizer *stateClick2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rememberState)];
//	[leftLabel addGestureRecognizer:stateClick2];
//    [stateClick2 release];
//    [leftLabel release];
//	UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 150, 90, 20)];
//    rightLabel.text = @"立即注册？";
//    rightLabel.textColor = [UIColor colorWithRed:42.0/255.0 green:75.0/255.0 blue:126.0/255.0 alpha:1.0];
//    rightLabel.backgroundColor = [UIColor clearColor];
//    rightLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
//	leftSize = [rightLabel.text sizeWithFont:rightLabel.font];		// 文本高度
//	rightLabel.frame = CGRectMake(200, 150, leftSize.width, leftSize.height);
//    rightLabel.userInteractionEnabled = YES;
//    UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, leftSize.height-1, leftSize.width - 8, 1)];
//    imv.backgroundColor = [UIColor colorWithRed:42.0/255.0 green:75.0/255.0 blue:126.0/255.0 alpha:1.0];
//    [rightLabel addSubview:imv];
//    [imv release];
//    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRegister)];
//    [rightLabel addGestureRecognizer:click];
//    [loginBg addSubview:rightLabel];
//    [click release];
//    [rightLabel release];
//    
//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(keyboardWillShow)
//												 name:UIKeyboardWillShowNotification
//											   object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(keyboardWillHidden)
//												 name:UIKeyboardWillHideNotification
//											   object:nil];
	
}

// 键盘出现的时候调用
- (void)keyboardWillShow {
//	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationDuration:0.3f];
//	loginBg.frame = CGRectMake(0, -70, 320, 460);
//	[UIView commitAnimations];
}

// 键盘将要隐藏的时候调用
- (void)keyboardWillHidden {
//	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationDuration:0.3f];
//	loginBg.frame = CGRectMake(0, 0, 320, 460);
//	[UIView commitAnimations];
}

- (UITextField *)getTextFieldNormal:(NSString *)placeMsg{
//    CGRect frame = CGRectMake(92, 153, 180, 25);
//    CGRect frame = CGRectMake(92, 63, 180, 25);
//    CGRect frame = CGRectMake(7, 7, 198, 21);
    CGRect frame = CGRectMake(32.0f, 11.0f, 240.0f, 25.0f);
    UITextField *textFieldNormal= [[[UITextField alloc] initWithFrame:frame] autorelease];
    
    textFieldNormal.borderStyle = UITextBorderStyleNone;
    textFieldNormal.textColor = [UIColor blackColor];
    textFieldNormal.font = [UIFont systemFontOfSize:14.0];
    textFieldNormal.placeholder = placeMsg;
    textFieldNormal.backgroundColor = [UIColor clearColor];
    textFieldNormal.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
    textFieldNormal.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
    textFieldNormal.returnKeyType = UIReturnKeyDone;
    
    textFieldNormal.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
    textFieldNormal.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
	return textFieldNormal;
}
- (UITextField *)getTextFieldSecure:(NSString *)placeMsg{
	
//        CGRect frame = CGRectMake(92, 196, 180, 25);
//    CGRect frame = CGRectMake(92, 106, 180, 25);
//    CGRect frame = CGRectMake(7, 7, 198, 21);
    CGRect frame = CGRectMake(32.0f, 11.0f, 240.0f, 25.0f);
    UITextField *textFieldSecure = [[[UITextField alloc] initWithFrame:frame] autorelease];
    textFieldSecure.borderStyle = UITextBorderStyleNone;
    textFieldSecure.textColor = [UIColor blackColor];
    textFieldSecure.font = [UIFont systemFontOfSize:14.0];
    textFieldSecure.placeholder = placeMsg;
    textFieldSecure.backgroundColor = [UIColor clearColor];
    
    textFieldSecure.keyboardType = UIKeyboardTypeDefault;
    textFieldSecure.returnKeyType = UIReturnKeyDone;	
    textFieldSecure.secureTextEntry = YES;	// make the text entry secure (bullets)
    
    textFieldSecure.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
    
    textFieldSecure.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
	return textFieldSecure;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.loginBg = nil;
	self.MBprogress = nil;
}
- (void)scrollIfNeeded:(NSNumber *)yCenterPos {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
    loginBg.center = CGPointMake(loginBg.center.x, [yCenterPos floatValue]);
	[UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self performSelectorOnMainThread:@selector(scrollIfNeeded:) withObject:[NSNumber numberWithFloat:80.0f] waitUntilDone:NO];

}
//改变输入框焦点
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    if(textField == usrTextField)
    {
        [usrTextField resignFirstResponder];
        //[pwdTextField becomeFirstResponder];  
    }else
    {
        [pwdTextField resignFirstResponder];  
    }
    
    [self performSelectorOnMainThread:@selector(scrollIfNeeded:) withObject:[NSNumber numberWithFloat:230.0f] waitUntilDone:NO];
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// 更新授权状态
-(void)updateAuthStatus:(ENUMAUTHSTATUS)status {
    enumAuthStatus = status;
}
@end
