//
//  WeiboDetailsPage.m
//  iweibo
//
//  Created by Cui Zhibo on 12-5-15.
//  Copyright (c) 2012年 Beyondsoft. All rights reserved.
//

#import "WeiboDetailsPage.h"
#import "iweiboAppDelegate.h"
#import "IWBSvrSettingsManager.h"
#import "SBJsonBase.h"
#import "CustomizedSiteInfo.h"
#import "IWeiboAsyncApi.h"
#import "LoginPage.h"
#import "NSString+CaclHeight.h"
#import "ComposeBaseViewController.h"

@implementation WeiboDetailsPage


@synthesize customizedSiteInfo;
@synthesize idParentController;
@synthesize dicThemeResult;
@synthesize imgLogo;
@synthesize isGetInfoFailure;
- (void) dealloc{
	CLog(@"%s", __FUNCTION__);
	printf("WeiboDetailsPage dealloc");
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
	[[IWBSvrSettingsManager sharedSvrSettingManager] CancelThemeDownLoading];
    [iWeiboAsyncApi cancelCurrentRequest];
    [iWeiboAsyncApi release];
    [customizedSiteInfo release];
	self.imgLogo = nil;
    [super dealloc];
}

- (void) loadView{
    [super loadView];
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, -24.0f, 320.0f, 21.0f)];
    tempView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:tempView];
    [tempView release];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detailsBig_bg.png"]];
    [self.view addSubview:bgView];
    [bgView release];
    UIImage *viewSearchImg = [UIImage imageNamed:@"subScribeTitleBg.png"];
	UIImageView	*viewSearchBG = [[UIImageView alloc] initWithImage:viewSearchImg];
    viewSearchBG.frame = CGRectMake(-5, 0, 330, topImageHeight);
	[bgView addSubview:viewSearchBG];
	viewSearchBG.userInteractionEnabled = YES;
	[viewSearchBG release];
	UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
	leftButton.frame = CGRectMake(5,4, 50, 30);
	[leftButton setTitle:@"返回" forState:UIControlStateNormal];
	leftButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    leftButton.titleLabel.textColor = [UIColor whiteColor];
    leftButton.titleLabel.shadowOffset = CGSizeMake(-1.0f, 2.0f);
    leftButton.titleLabel.shadowColor = [UIColor blackColor];
	[leftButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 12, 5, 5)];
	[leftButton setBackgroundImage:[UIImage imageNamed:@"subScribeNav.png"] forState:UIControlStateNormal];
	[leftButton addTarget:self action:@selector(backTopage) forControlEvents:UIControlEventTouchUpInside];
    UILabel *midoleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65.0f, 11, 200, 20)];
    midoleLabel.textColor = [UIColor whiteColor];
    midoleLabel.text = @"详情";
    midoleLabel.textAlignment = UITextAlignmentCenter;
    midoleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    midoleLabel.backgroundColor = [UIColor clearColor];
    [viewSearchBG addSubview:midoleLabel];
    [midoleLabel release];
	[bgView addSubview:leftButton];

    UIImageView *bgContUpImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topImageHeight - 2, 320, 113)];
    [bgContUpImgView setImage:[UIImage imageNamed:@"detailPagebgbgcontup.png"]];
    [self.view addSubview:bgContUpImgView];
    [bgContUpImgView release];
    
    UIImageView *bgContDownImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailPagebgcontdown.png"]];
    [self.view addSubview:bgContDownImgView];
    [bgContDownImgView release];
    
    UIImageView *logoImage  = [[UIImageView alloc] initWithFrame:CGRectMake(17 , 50 , 67, 67)];
	if (self.imgLogo != nil) {
		logoImage.image = self.imgLogo;
	}
	else {
		logoImage.image = [UIImage imageWithContentsOfFile:customizedSiteInfo.logoIconPath];
        if (nil == logoImage.image) {
            logoImage.image = [UIImage imageNamed:@"icon.png"];
        }
	}
    [self.view addSubview:logoImage];
    [logoImage release];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(17 + 67 + 8, 16 + topImageHeight, 70, 20)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = customizedSiteInfo.descriptionInfo.svrName;
    nameLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:22];
    nameLabel.textColor = [UIColor colorWithRed:33.0/255.0 green:65.0/255.0 blue:95.0/255.0 alpha:1];
    [nameLabel sizeToFit];
    [self.view addSubview:nameLabel];
    [nameLabel release];
    
    UILabel *urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(17 + 67 + 8, 16 + 20 + 6 + topImageHeight, 200, 20)];
    urlLabel.backgroundColor = [UIColor clearColor];
    urlLabel.font = [UIFont fontWithName:@"Arial" size:15];
    urlLabel.textColor = [UIColor colorWithRed:33.0/255.0 green:65.0/255.0 blue:95.0/255.0 alpha:1];
    NSString *str = [customizedSiteInfo.descriptionInfo.svrUrl stringByReplacingOccurrencesOfString:HOST_SUB_PATH_COMPONENT withString:@""];
    urlLabel.text = str;
    [self.view addSubview:urlLabel];
    [urlLabel release];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 124, 250, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Verdana" size:18];
    titleLabel.textColor = [UIColor colorWithRed:55.0/ 255.0 green:55.0/ 255.0 blue:55.0/ 255.0 alpha:1.0];
    NSString *strr = @"关于";
    titleLabel.text = [strr stringByAppendingString:customizedSiteInfo.descriptionInfo.svrName];
    [self.view addSubview:titleLabel];
    [titleLabel release];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textAlignment = UITextAlignmentLeft;
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font = [UIFont fontWithName:@"Verdana" size:15];
    contentLabel.textColor = [UIColor colorWithRed:55.0/ 255.0 green:55.0/ 255.0 blue:55.0/ 255.0 alpha:1.0];
    contentLabel.text = customizedSiteInfo.descriptionInfo.svrDescription;
    int length = [ComposeBaseViewController calcStrWordCount:contentLabel.text];
    // 描述文字小于三行的时候，背景图为默认高度75，文字每涨一行，背景图高度增加20，背景图最大高度为155，如果文字过多则省略
    // 18是每行字的最大长度
    if (length <= 18 * 2) {
        bgContDownImgView.frame  = CGRectMake(0, topImageHeight - 2 + 113, 320, 75);
        contentLabel.frame = CGRectMake(24, 162, 285, 75);
        contentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        contentLabel.numberOfLines = 0;
        [contentLabel sizeToFit];
    }else if (length <= 18 * 3){
        bgContDownImgView.frame  = CGRectMake(0, topImageHeight - 2 + 113, 320, 75);
        contentLabel.frame = CGRectMake(24, 162, 280, 75);
        contentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        contentLabel.numberOfLines = 0;
        [contentLabel sizeToFit];
    }else if (length <= 18 * 4){
        bgContDownImgView.frame  = CGRectMake(0, topImageHeight - 2 + 113, 320, 75 + 20);
        contentLabel.frame = CGRectMake(24, 162, 280, 75);
        contentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        contentLabel.numberOfLines = 0;
        [contentLabel sizeToFit];
    }else if(length <= 18 * 5){
        bgContDownImgView.frame  = CGRectMake(0, topImageHeight - 2 + 113, 320, 75 + 40);
        contentLabel.frame = CGRectMake(24, 162, 280, 75);
        contentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        contentLabel.numberOfLines = 0;
        [contentLabel sizeToFit];
    }else if(length <= 18 * 6){
        bgContDownImgView.frame  = CGRectMake(0, topImageHeight - 2 + 113, 320, 75 + 60);
        contentLabel.frame = CGRectMake(24, 162, 280, 75);
        contentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        contentLabel.numberOfLines = 0;
        [contentLabel sizeToFit];
    }else if (length <= 18 *7){
        bgContDownImgView.frame  = CGRectMake(0, topImageHeight - 2 + 113, 320, 75 + 80);
        contentLabel.frame = CGRectMake(24, 162, 280, 75);
        contentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        contentLabel.numberOfLines = 0;
        [contentLabel sizeToFit];
    }else {
        bgContDownImgView.frame  = CGRectMake(0, topImageHeight-2  + 113, 320, 75 + 80);
        contentLabel.frame = CGRectMake(25, 154, 280, 155);
        contentLabel.lineBreakMode = UILineBreakModeTailTruncation;
        contentLabel.numberOfLines = 7;
    }
    [self.view addSubview:contentLabel];
    [contentLabel release];
    // 承载站点描述内容的背景图高度
    float bgContDownImgwH = bgContDownImgView.frame.size.height;
    UIImageView *startImage = [[UIImageView alloc] init];
    startImage.image = [UIImage imageNamed:@"detailPageStartbtn.png"];
    startImage.userInteractionEnabled = YES;
    startImage.frame = CGRectMake(17, topImageHeight + 113 + bgContDownImgwH + 17, 286, 39);
    [bgView addSubview:startImage];
    UITapGestureRecognizer *clickStart = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startWeibo)];
    [startImage addGestureRecognizer:clickStart];
    [clickStart release];
    [startImage release];
    checkView = [[UIView alloc] init];
    checkView.frame = CGRectMake(110, topImageHeight + 113 + bgContDownImgwH + 17 + 39 + 15, 40, 200);
    checkView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:checkView];
    [checkView release];

    iWeiboAsyncApi = [[IWeiboAsyncApi alloc] init];
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
		[self getThemeInfo];
	}
}
- (void) backTopage{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)hideenCheckView{
    checkView.alpha = 0;
}

// 启动规则
// 先判断是否要下载theme，假如已存在theme则无需下载，在获取siteInfo成功后再下载，具体在[iweiboAppDelegate prepareDataForLoginUser]中
// 不存在theme情况，一是首次添加，二是首次添加后theme下载失败
- (void) startWeibo{
    if (isTouch) {
        return;
    }
    checkView.alpha = 1.0;
    isTouch = YES;
    UILabel *checkLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 150, 30)];
    checkLabel.text = @"检查配置中...";
    checkLabel.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0];
    checkLabel.font = [UIFont systemFontOfSize:14];
    checkLabel.backgroundColor = [UIColor clearColor];
    [checkView addSubview:checkLabel];
    [checkLabel release];
    
    UIActivityIndicatorView *ActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];  
    [ActivityIndicatorView startAnimating];
    ActivityIndicatorView.frame = CGRectMake(6, 5, 20, 20);
    [checkView addSubview:ActivityIndicatorView];
    [ActivityIndicatorView release];
	CustomizedSiteInfo *siteInfo = [[IWBSvrSettingsManager sharedSvrSettingManager] getSiteInfoByUrl:self.customizedSiteInfo.descriptionInfo.svrUrl];
    CLog(@"%s, siteInfo:%@", __FUNCTION__, siteInfo);
//    if (NO) {
	if (siteInfo == nil || [siteInfo.themeVer isEqualToString:@"-1"]) {
        [self performSelector:@selector(getThemeInfo) withObject:nil afterDelay:0.0f];
	}
	else {
        [self performSelector:@selector(achieveInfoFromServer) withObject:nil afterDelay:0];
    }
}


- (void)checkConfiguration{
    if (self.isGetInfoFailure) {
        [self hideenCheckView];
        isTouch = NO;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
                                                            message:@"网络错误，请重试" 
                                                           delegate:self 
                                                  cancelButtonTitle:@"确定" 
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];

    }else{
        [[IWBSvrSettingsManager sharedSvrSettingManager] updateAndSetSiteActive:self.customizedSiteInfo.descriptionInfo.svrUrl];
        [self performSelectorOnMainThread:@selector(donePreparation) withObject:nil waitUntilDone:YES];
    }
}

-(void)getResultFailedWithDes:(NSString *)strDes {
    [self hideenCheckView];
    isTouch = NO;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
                                                        message:strDes
                                                       delegate:self 
                                              cancelButtonTitle:@"确定" 
                                              otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

-(void)getThemeInfo {
	NSMutableDictionary *par = [NSMutableDictionary dictionaryWithCapacity:3];
	[par setObject:@"json" forKey:@"format"];
	[par setObject:@"customized/theme" forKey:@"request_api"];
	[par setObject:customizedSiteInfo.themeVer forKey:@"ver"];
	[iWeiboAsyncApi getCustomizedThemeWithUrl:customizedSiteInfo.descriptionInfo.svrUrl Parameters:par delegate:self
                         onSuccess:@selector(onGetThemeSuccess:) onFailure:@selector(onGetThemeFailure:)];
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
		BOOL bResult = [[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:customizedSiteInfo.descriptionInfo.svrUrl
																		   withVer:strVer 
																		  themeDic:dicTheme
																	 andIconFolder:strFolder];
		if (!bResult) {
			[self getResultFailedWithDes:@"保存数据异常"];	// 异常情况下，不可继续执行
		}
        else {
            customizedSiteInfo.themeVer = strVer;
            [self performSelectorOnMainThread:@selector(achieveInfoFromServer) withObject:nil waitUntilDone:NO];
        }
	}
	else {
//		[self getResultFailedWithDes:@"下载文件超时"];	// 下载超时情况下，可继续执行
		NSString *strFolder = [result objectForKey:@"PATH"];
        if ([customizedSiteInfo.themeVer isEqualToString:@"-1"]) {
            BOOL bResult = [[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:customizedSiteInfo.descriptionInfo.svrUrl
                                                                               withVer:@"-1" 
                                                                              themeDic:nil
                                                                         andIconFolder:strFolder];
            if (!bResult) {
                [self getResultFailedWithDes:@"保存数据异常"];	// 保存数据异常，不可继续执行
                [self hideenCheckView];
                isTouch = NO;
                return;
            }
        }
        [self performSelectorOnMainThread:@selector(achieveInfoFromServer) withObject:nil waitUntilDone:NO];
	}
}

-(NSString *)randFileName {
    // 获取系统时间  
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];  
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];  
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];  
    [dateFormatter setDateFormat:@"yyMMddHHmmssSSSSSS"];  
    // 时间字符串  
    NSString *datestr = [dateFormatter stringFromDate:[NSDate date]];  
    [dateFormatter release];  
    return datestr;
}

- (void)onGetThemeSuccess:(NSDictionary *)reciveData{
   NSDictionary *dicData = [DataCheck checkDictionary:reciveData forKey:@"data" withType:[NSDictionary class]];
	if ([dicData isKindOfClass:[NSDictionary class]] && [dicData count] > 0) {
		self.dicThemeResult = dicData;
		NSDictionary *dicTheme = [dicData objectForKey:@"list"];
		if ([dicTheme isEqual:[NSNull null]] || [dicTheme count] == 0) {
			// 最新版本，或者获取异常
            if ([dicTheme isEqual:[NSNull null]]) {
                // 数据异常情况下, 假如为通过添加站点首次进入，则需要刷新ver信息
                if ([customizedSiteInfo.themeVer isEqualToString:@"-1"]) {
                    BOOL bResult = [[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:customizedSiteInfo.descriptionInfo.svrUrl
                                                                                       withVer:@"-1" 
                                                                                      themeDic:nil
                                                                                 andIconFolder:[self randFileName]];
                    if (!bResult) {
                        [self hideenCheckView];
                        isTouch = NO;
                        [self getResultFailedWithDes:@"保存数据异常"];	// 保存数据异常，不可继续执行
                        return;
                    }
                }
            }
            [self performSelectorOnMainThread:@selector(achieveInfoFromServer) withObject:nil waitUntilDone:NO];
		}
		else {
            isDownloadingTheme = YES;
			[[IWBSvrSettingsManager sharedSvrSettingManager] downloadTheme:customizedSiteInfo.descriptionInfo.svrUrl
																wiThemeDic:dicTheme 
																  delegate:self 
																  Callback:@selector(iconsDidFinishedDownloadingWithPar:)];
					}
	}
	else {
        // 数据异常情况下, 假如为通过添加站点首次进入，则需要刷新ver信息
        if ([customizedSiteInfo.themeVer isEqualToString:@"-1"]) {
            BOOL bResult = [[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:customizedSiteInfo.descriptionInfo.svrUrl
                                                                               withVer:@"-1" 
                                                                              themeDic:nil
                                                                         andIconFolder:[self randFileName]];
            if (!bResult) {
                [self getResultFailedWithDes:@"保存数据异常"];	// 保存数据异常，不可继续执行
                [self hideenCheckView];
                isTouch = NO;
                return;
            }
        }
        [self performSelectorOnMainThread:@selector(achieveInfoFromServer) withObject:nil waitUntilDone:NO];
	}
}

- (void)onGetThemeFailure:(NSError *)error {
    NSLog(@"ERROR!");
    [self hideenCheckView];
    isTouch = NO;
    // 获取主题失败不影响登陆
    [self performSelector:@selector(achieveInfoFromServer) withObject:nil afterDelay:0];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
//                                                        message:@"网络错误，请重试" 
//                                                       delegate:self 
//                                              cancelButtonTitle:@"确定" 
//                                              otherButtonTitles:nil, nil];
//    [alertView show];
//    [alertView release];
}

- (void) achieveInfoFromServer{
    NSLog(@"come in fromServer!");
    NSMutableDictionary *par = [NSMutableDictionary dictionaryWithCapacity:2];
	[par setObject:@"json" forKey:@"format"];
	[par setObject:@"customized/siteinfo" forKey:@"request_api"];
    [iWeiboAsyncApi getCustomizedSiteInfoWithUrl:customizedSiteInfo.descriptionInfo.svrUrl 
                                        Parameters:par 
                                        delegate:self 
                                        onSuccess:@selector(onCheckSuccess:) 
                                       onFailure:@selector(onCheckFailure:)];
}

- (void)onCheckFailure:(NSError *)failData{
    NSLog(@"ERROR!");
    [self hideenCheckView];
    isTouch = NO;
    // 非首次登陆的情况下允许继续登陆
    if (![customizedSiteInfo.themeVer isEqualToString:@"-1"]) {
        NSString *strUrl = [customizedSiteInfo.descriptionInfo.svrUrl copy];
		[[IWBSvrSettingsManager sharedSvrSettingManager] updateAndSetSiteActive:strUrl];
		[strUrl release];
        [self performSelectorOnMainThread:@selector(donePreparation) withObject:nil waitUntilDone:YES];
        // 点击开始使用的时候，站点页面就要生成相应的icon了,所以要根据数组里面的内容，重新刷新视图
        iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.selectPage showViewAgain];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
                                                            message:@"网络错误，请重试" 
                                                           delegate:self 
                                                  cancelButtonTitle:@"确定" 
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}

-(void)donePreparation {
	if ([idParentController respondsToSelector:@selector(doneServerPreparation)]) {
		[idParentController performSelectorOnMainThread:@selector(doneServerPreparation) withObject:nil waitUntilDone:YES];
		[self.navigationController popViewControllerAnimated:NO];
	}
}

- (void)onCheckSuccess:(NSDictionary *)recivedData{
    [self hideenCheckView];
    isTouch = NO;
    NSLog(@"recive = %@",recivedData);

	NSDictionary *dicData = [recivedData objectForKey:@"data"];
	if ([dicData isKindOfClass:[NSDictionary class]]) {
		SiteDescriptionInfo *siteDescriptionInfo = [[SiteDescriptionInfo alloc] initWithDic:dicData];
		NSString *strUrl = [customizedSiteInfo.descriptionInfo.svrUrl copy];
		customizedSiteInfo.descriptionInfo = siteDescriptionInfo;
		[[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:strUrl withDescription:customizedSiteInfo.descriptionInfo];
		[[IWBSvrSettingsManager sharedSvrSettingManager] updateAndSetSiteActive:strUrl];
		[siteDescriptionInfo release];
		[strUrl release];
        
	}
	else {
		// 失败情况下也要设置激活站点
		NSString *strUrl = [customizedSiteInfo.descriptionInfo.svrUrl copy];
		[[IWBSvrSettingsManager sharedSvrSettingManager] updateAndSetSiteActive:strUrl];
		[strUrl release];
	}

	[self performSelectorOnMainThread:@selector(donePreparation) withObject:nil waitUntilDone:YES];
    // 点击开始使用的时候，站点页面就要生成相应的icon了,所以要根据数组里面的内容，重新刷新视图
    iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.selectPage showViewAgain];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
//- (void) initWithCustomizedSiteInfo:(CustomizedSiteInfo*)customizedSiteInfo{
//    self
//}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
//    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"subScribeTitleBg.png"] forBarMetrics:UIBarMetricsDefault];
//    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillDisappear:(BOOL)animated {
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
	delegate.draws = 1;
	[super viewWillDisappear:animated];
	
}
@end
