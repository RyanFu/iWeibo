    //
//  HotTopicDetailController.m
//  iweibo
//
//  Created by lichentao on 12-2-27.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "HotTopicDetailController.h"
#import "EGORefreshTableHeaderView.h"
#import "DataManager.h"
#import "MessagePage.h"
#import "HomelineCell.h"
#import "Canstants_Data.h"
#import "Canstants.h"
#import "LoadCell.h"
#import "IWeiboSyncApi.h"
#import "DataSave.h"
#import "TransInfo.h"
#import "Info.h"
#import "Canstants.h"
#import "TransInfo.h"
#import "DetailsPage.h"
#import "MessageViewUtility.h"
#import "DetailPageConst.h"
#import "WebUrlViewController.h"
#import "CommonMethod.h"
#import "ComposeBaseViewController.h"
#import "ComposeViewControllerBuilder.h"
#import "MyFavTopicInfo.h"
#import "HomePage.h"
#import "SCAppUtils.h"
#import "HpThemeManager.h"
#import "CustomNavigationbar.h"
#import "UserInfo.h"

#define REQNUM 30													//请求个数
#define HEIGHTFOOTER   50											//表尾高度
#define PARAMETERMESSAGETYPE		@"0"							//0参数
#define MESSAGENEWTIMESTAMP			@"MessageNewTimeStamp"
#define MESSAGENEWWEIBOID			@"MessageNewWeiboId"

@implementation HotTopicDetailController
@synthesize hotTopicDetailTableList, refreshMessageView, messageMore,IconCastImage;
@synthesize aApi, messageSaveToClass, hotTopicDetailArray, textHeightDic;
@synthesize messageNewTime, messageOldTime, oldWeiboId, pushType;
@synthesize nnewWeiboId;
@synthesize searchString,pageInfoString,hasNext,hotTopicIDString,errorCastImage,broadCastLabel;
@synthesize broadCastImage;	

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		// 存放高度的字典
		textHeightDic = [[NSMutableDictionary alloc] initWithCapacity:30];
    }
    return self;
}

- (void)dealloc{
//	NSLog(@"hotTopicDetailTableList is %d",[hotTopicDetailTableList retainCount]);
//	NSLog(@"broadCastImage is %d",[broadCastImage retainCount]);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
	[messageSaveToClass			release];
	[refreshMessageView			release];
	[messageMore				release];
	[hotTopicDetailArray		release];
	[errorCastImage				release];
	[IconCastImage				release];
    [aApi                       cancelSpecifiedRequest];
	[aApi						release];
	[textHeightDic				release];
    [writeWeiboBtn              release];
	textHeightDic = nil;
	[hotTopicIDString			release];
	[pageInfoString				release];
	MBpro	= nil;
	[hotTopicDetailTableList	release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

// 记录时间戳,更新和下拉刷新时候更新状态
- (void)recordingNewTimestamp:(NSArray *) infoQueue{
	if ([infoQueue count]!=0) {
		self.messageNewTime = [NSString stringWithFormat:@"%@",[[infoQueue objectAtIndex:0] timeStamp]];
		self.nnewWeiboId = [NSString stringWithFormat:@"%@",[[infoQueue objectAtIndex:0]uid]];
		[[NSUserDefaults standardUserDefaults] setObject:self.messageNewTime forKey:MESSAGENEWTIMESTAMP];
		[[NSUserDefaults standardUserDefaults] setObject:self.nnewWeiboId forKey:MESSAGENEWWEIBOID];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void)recordingOldTimestamp:(NSArray *) infoQueue{
	if ([infoQueue count]!=0) {
		self.messageOldTime = [NSString stringWithFormat:@"%@",[[infoQueue objectAtIndex:[infoQueue count] - 1]timeStamp]];
		self.oldWeiboId = [NSString stringWithFormat:@"%@",[[infoQueue objectAtIndex:[infoQueue count]-1] uid]];
	}
}

- (void)recordingTimestamp:(NSArray *)infoQueue{
	switch (pushType) {
		case mesFirstRequest:
			[self recordingNewTimestamp:infoQueue];
			[self recordingOldTimestamp:infoQueue];
			break;
		case mesLoadMoreRequest:
			[self recordingOldTimestamp:infoQueue];
			break;
		case mesPullRefreshRequest:
			[self recordingNewTimestamp:infoQueue];
			break;
		default:
			break;
	}	
}

// 保存服务器返回的数据
- (void)caculateHomeline:(NSDictionary *)result{
	// 返回来数据将数组封装Info类型，保存到本地数组
	NSArray *infoQueue =[messageSaveToClass storeInfoToClass:result];
	Info *dataInfo;
	for (int i=0; i<[infoQueue count]; i++) {
		dataInfo = [infoQueue objectAtIndex:i];
		[hotTopicDetailArray addObject:dataInfo];
	}	
	[self recordingTimestamp:infoQueue];
}

// 提示条动画效果
- (void)moveUp{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2.0];
	broadCastImage.frame = CGRectMake(0, -31, 320, 30);
	[UIView commitAnimations];
}

- (void)moveDown{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.1];
	broadCastImage.frame = CGRectMake(0, 0, 320, 30);
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(moveUp)];
	[UIView commitAnimations];
}

//下拉刷新请求完毕后的处理
- (void)dataSourceDidFinishLoadingNewData{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[hotTopicDetailTableList setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	[refreshMessageView setState:EGOOPullRefreshNormal];
}
#pragma mark -

//下拉刷新后黄色提示条处理
- (void)doneLoadingTableViewData{
	if (hotPullRefreshCount > 0) {
		if(hotPullRefreshCount >0 && hotPullRefreshCount <=30) {
			broadCastLabel.text = [NSString stringWithFormat:@"%d条新数据",messageSaveToClass.n];
		}
		errorCastImage.hidden = YES;
		IconCastImage.hidden = NO;
	}
	else{
		broadCastLabel.text = @"没有新广播";
		errorCastImage.hidden = YES;
		IconCastImage.hidden = NO;
	}
	[self moveDown];
	[self dataSourceDidFinishLoadingNewData];	
}

- (void)doneLoadingTableViewDataWithNetError{
	broadCastLabel.text = @"网络错误，请重试";   
	errorCastImage.hidden = NO;
	IconCastImage.hidden = YES;
	isLoading = YES;
	[self moveDown];
	[self dataSourceDidFinishLoadingNewData];
}

#pragma mark -
/*	向服务器请求话题相关数据 hotTopicText  pageFlag  pageInfo
httext 话题名字
pageflag 分页标识
pageflag = 1，表示向后（下一页）查找；pageflag = 2，表示向前（上一页）查找；pageflag = 4，表示跳到最前面一页）；(第一次请求填4)
pageinfo 分页标识（第一页：填空，继续翻页：填上次返回的 pageinfo）
reqnum 每次请求记录的条数（1-100条）
*/
- (void)requesetHotTopicDetailServer:(NSString *)hotTopicText setPageFlag:(NSString *)pageFlag setPageInfo:(NSString *)pageinfo{
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithCapacity:10];
	[parameters setValue:@"json" forKey:@"format"];
	[parameters setValue:pageFlag forKey:@"pageflag"];
	[parameters setValue:@"30" forKey:@"reqnum"];
	[parameters setValue:hotTopicText forKey:@"httext"];
	[parameters setValue:pageinfo forKey:@"pageinfo"];
	[parameters setValue:URL_HT_TIMELINE forKey:@"request_api"];
	[aApi getHTTimelineWithParamters:parameters
							delegate:self
						   onSuccess:@selector(hotTopicListSuccess:) onFailure:@selector(hotTopicListFailure:)];
	[parameters release];
}

#pragma mark -
#pragma mark requestCallBack

//计算返回的新的微博数
-(int)returnNewCount:(NSDictionary *)result timestampNew:(NSString *)timeStamp{
	int newWeiboCount = 0;
	NSDictionary *data =[DataCheck checkDictionary:result forKey:HOMEDATA withType:[NSDictionary class]];
	NSArray *info = [DataCheck checkDictionary:data forKey:HOMEINFO withType:[NSArray class]];
	if (![info isKindOfClass:[NSNull class]]) {
		for (NSDictionary *sts in info) {
			if ([sts isKindOfClass:[NSDictionary class]] && sts) {
				NSString *time = [NSString stringWithFormat:@"%@",[sts objectForKey:HOMETIME]];
				if ([time compare: timeStamp]== NSOrderedDescending) {
					newWeiboCount++;
				}
				
			}
		}
	}
	return newWeiboCount;
}

- (void)hotTopicListSuccess:(NSDictionary *)dic{
	[MessageViewUtility printAvailableMemory];
	hotPullRefreshCount = 0;
	//NSLog(@"dic is %@",dic);
	NSNumber *ret = [DataCheck checkDictionary:dic forKey:@"ret" withType:[NSNumber class]];
	if ([ret isKindOfClass:[NSNumber class]] && [ret intValue] != 4) {
		NSDictionary *hotData = [DataCheck checkDictionary:dic forKey:@"data" withType:[NSDictionary class]];
		if ([hotData isKindOfClass:[NSDictionary class]]) {
			// 数据返回来后更改加载更多状态为加载更多
			self.hasNext = [DataCheck checkDictionary:hotData forKey:@"hasnext" withType:[NSNumber class]];//[hotData objectForKey:HOMEHASNEXT];// 数据读取
			if ([self.hasNext isKindOfClass:[NSNumber class]]) {
				if ([hasNext intValue] == 0 || [hasNext intValue] == 2) {
					[messageMore setState:loadMore1];	
				}else {
					[messageMore setState:loadFinished];
				}
			}
			NSString *pageString = [DataCheck checkDictionary:hotData forKey:@"pageinfo" withType:[NSString class]];
			if ([pageString isKindOfClass:[NSString class]]) {
				self.pageInfoString = pageString;
			}
			switch (pushType) {
				case mesLoadMoreRequest:				// 加载更多:将返回的数据加载到数组后面
					[self caculateHomeline:dic];
					break;
				case mesFirstRequest:					// 第一次请求保证数据源之前没有任何数据
					[textHeightDic removeAllObjects];
					[self.hotTopicDetailArray removeAllObjects];
					[self caculateHomeline:dic];
					break;
				case mesPullRefreshRequest:				// 下拉刷新逻辑：将之前数据清空，请求服务器最新数据30条
					[self.textHeightDic removeAllObjects];
					[self.hotTopicDetailArray removeAllObjects];
					hotPullRefreshCount = [self returnNewCount:dic timestampNew:self.messageNewTime];
					[self caculateHomeline:dic];
					[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
					break;
					
				default:
					break;
			}				
			// 2012-03-10 By Yi Minwen 添加昵称显示
			NSDictionary *userNicks = [DataCheck checkDictionary:hotData forKey:@"user" withType:[NSDictionary class]];
			if ([userNicks isKindOfClass:[NSDictionary class]]) {
				// 存到数据库
				[DataManager insertUserInfoToDBWithDic:userNicks];
				// 存到本地字典
				[HomePage insertNickNameToDictionaryWithDic:userNicks];
			}
			isLoading = YES;							// 逻辑控制置为YES，表示可以加载更多
			[self hiddenMBProgress];
			[self.hotTopicDetailTableList setHidden:NO];// 数据表显示tableView
			totalCellHeight = 0.0f;						// 将cell总高度置为0,如果加载更多，每次重新计算高度
			subscriptionButton.hidden = NO;				// 数据加载回来后订阅按钮显示出来
			[hotTopicDetailTableList reloadData];		// 刷新数据
		}				
	}else {
		MBpro = [[CommonMethod shareInstance] shareMBProgressHUD:noThisTopic];
		[self.view bringSubviewToFront:MBpro];
		[self.navigationController.view addSubview:MBpro];
		[self performSelector:@selector(hiddenMBProgress) withObject:nil afterDelay:1];
        [messageMore setState:loadMore1];	
	}
}
// 请求失败
- (void)hotTopicListFailure:(NSError *)error{
	NSLog(@"error is %@",[error description]);
	isLoading = YES;
	self.hotTopicDetailTableList.hidden = NO;
	[self hiddenMBProgress];
	if ([error code] == ASIRequestTimedOutErrorType || [error code] == ASIConnectionFailureErrorType) {
		broadCastLabel.text = @"网络错误，请重试";
		errorCastImage.hidden = NO;
		IconCastImage.hidden = YES;
		MBpro = [[CommonMethod shareInstance] shareMBProgressHUD:loadError];
		[self.view bringSubviewToFront:MBpro];
		[self.navigationController.view addSubview:MBpro];
	}
	[self moveDown];
	[self dataSourceDidFinishLoadingNewData];
}

// 下拉刷新
- (void)reloadNewDataSource{
	BOOL connectStatus = [[CommonMethod shareInstance] connectionStatus];
	if (!connectStatus){
		[self performSelector:@selector(doneLoadingTableViewDataWithNetError) withObject:nil afterDelay:2.0];
	}
	else {
		pushType = mesPullRefreshRequest;
		[self requesetHotTopicDetailServer:self.searchString setPageFlag:@"4" setPageInfo:@""];
	}
}

#pragma mark -
#pragma mark viewDidLoad

- (void)updateTheme:(NSNotificationCenter *)noti{
    NSDictionary *plistDict = [[HpThemeManager sharedThemeManager]themeDictionary];
	NSString *themePathTmp = [plistDict objectForKey:@"Common"];
    NSString *themeWritePathTmp = [plistDict objectForKey:@"TimelineIamge"];
    NSString *themeWritePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themeWritePathTmp];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    UIImage *imageNav = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"navigationbar_bg.png"]];
    [SCAppUtils navigationController:self.navigationController setImage:imageNav];
    [leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
    [writeWeiboBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themeWritePath stringByAppendingPathComponent:WRITEWEIBO]] forState:UIControlStateNormal];
    [writeWeiboBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themeWritePath stringByAppendingPathComponent:WRITEWEIBOSEL]] forState:UIControlStateHighlighted];

}

- (void)viewDidLoad{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	self.title = [NSString stringWithFormat:@"#%@#",self.searchString];
	isLoading = YES;// 下拉刷新，加载更多，逻辑控制器
	//[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_bg.png"]];// zhaolilong 2012-03-10 改变导航条背景色
	// 导航条返回按钮
    
    NSDictionary *dic = nil;
    NSDictionary *pathDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"ThemePath"];
    if ([pathDic count] == 0){
        NSString *skinPath = [[NSBundle mainBundle] pathForResource:@"ThemeManager" ofType:@"plist"];
        dic = [[NSArray arrayWithContentsOfFile:skinPath] objectAtIndex:0];
    }
    else{
        dic = pathDic;
    }
    NSString *themePathTmp = [dic objectForKey:@"Common"];
    NSArray *pathArray = [themePathTmp componentsSeparatedByString:@"/"];
    NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];

    UIImage *navImage = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"navigationbar_bg.png"]];
    [SCAppUtils navigationController:self.navigationController setImage:navImage];
    
	leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
	leftButton.frame = CGRectMake(0, 0, 50, 30);
	[leftButton setTitle:@"返回" forState:UIControlStateNormal];
	leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
	leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
	[leftButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
	self.navigationItem.leftBarButtonItem = leftBar;
	[leftBar release];
	// 导航控制器话题按钮
     NSString *themeWritePathTmp = [dic objectForKey:@"TimelineImage"];
        NSString *themeWritePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themeWritePathTmp];
	writeWeiboBtn = [[UIButton alloc]initWithFrame:CGRectMake(290, 5, 32, 32)];
    [writeWeiboBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themeWritePath stringByAppendingPathComponent:WRITEWEIBO]] forState:UIControlStateNormal];
    [writeWeiboBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themeWritePath stringByAppendingPathComponent:WRITEWEIBOSEL]] forState:UIControlStateHighlighted];
    [writeWeiboBtn addTarget:self action:@selector(writeWeiboFromTopic) forControlEvents:UIControlEventTouchUpInside];
    if([[pathArray objectAtIndex:0] isEqualToString:@"FirstSkin"]){
        writeWeiboBtn.frame = CGRectMake(290, 5, 32, 32);
    }
    else{
        writeWeiboBtn.frame = CGRectMake(290, 5, 50, 32);
    }
    UIBarButtonItem *writeWeiboBarbBtn = [[UIBarButtonItem alloc] initWithCustomView:writeWeiboBtn];
    self.navigationItem.rightBarButtonItem = writeWeiboBarbBtn;
    [writeWeiboBarbBtn release];
	aApi = [[IWeiboAsyncApi alloc] init];
	// 将返回来的数据进行格式封装
	messageSaveToClass = [[DataSave alloc] init];
	// 存放数据源数组
	hotTopicDetailArray  = [[NSMutableArray alloc] init];
	// hotTopicDetailTableList数据表//self.view.bounds.size.height460-44
	CGRect rc = CGRectMake(0, 0, 320, self.view.bounds.size.height - 44);
	UITableView *hotTopicDetailTableList1 = [[UITableView alloc] initWithFrame:rc style:UITableViewStylePlain];
	hotTopicDetailTableList1.backgroundColor = [UIColor clearColor];
	hotTopicDetailTableList1.separatorColor = [UIColor colorWithRed:0.827 green:0.843 blue:0.855 alpha:1];
	hotTopicDetailTableList1.delegate = self;
	hotTopicDetailTableList1.dataSource = self;
	[self.view addSubview:hotTopicDetailTableList1];
	self.hotTopicDetailTableList = hotTopicDetailTableList1;
	[hotTopicDetailTableList1 release];
	
	// 订阅按钮.数据库中是否有该话题
	isSubscription = [self isHasHotTopic];
	subscriptionButton = [UIButton buttonWithType:UIButtonTypeCustom];
	subscriptionButton.frame = CGRectMake(230, 380, 80, 30);
	[subscriptionButton addTarget:self action:@selector(showSubButton:) forControlEvents:UIControlEventTouchUpInside];
	if (isSubscription) {
		[subscriptionButton setTitle:@"取消订阅" forState:UIControlStateNormal];
	}else {
		[subscriptionButton setTitle:@"订阅" forState:UIControlStateNormal];
	}
	[subscriptionButton setBackgroundImage:[UIImage imageNamed:@"describe.png"] forState:UIControlStateNormal];
	subscriptionButton.titleLabel.font = [UIFont systemFontOfSize:18];
	[subscriptionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	subscriptionButton.backgroundColor = [UIColor clearColor];
	subscriptionButton.hidden = YES;
	subscriptionButton.alpha = 0.8;
	[self.view addSubview:subscriptionButton];
	
	// 数据加载成功或者失败，网络不好提示相应的信息,提示资源图片
	NSString *path = [[NSBundle mainBundle] pathForResource:@"bgLabel" ofType:@"png"];
	UIImageView *broadCastImage1 = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
	broadCastImage1.frame = CGRectMake(0, -30, 320, 30);
	self.broadCastImage = broadCastImage1;
	[broadCastImage1 release];
	
	NSString *pathError = [[NSBundle mainBundle] pathForResource:@"errorler" ofType:@"png"];
	UIImageView *errorCastImage1 = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:pathError]];
	errorCastImage1.frame = CGRectMake(90, 5, 20, 20);
	errorCastImage1.backgroundColor = [UIColor clearColor];
	errorCastImage1.hidden = YES;
	self.errorCastImage = errorCastImage1;
	[self.broadCastImage addSubview:errorCastImage1];
	[errorCastImage1 release];

	NSString *pathIcon = [[NSBundle mainBundle] pathForResource:@"iconPull" ofType:@"png"];
	UIImageView *iconCastImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:pathIcon]];
	iconCastImage.frame = CGRectMake(100, 8, 15, 15);
	iconCastImage.backgroundColor = [UIColor clearColor];
	iconCastImage.hidden = YES;
	[self.broadCastImage addSubview:iconCastImage];
	self.IconCastImage = iconCastImage;
	[iconCastImage release];
	// 下拉刷新提示条完毕后
	UILabel *broadCastLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 180, 30)];
	broadCastLabel1.backgroundColor = [UIColor clearColor];
	broadCastLabel1.textColor = [UIColor colorWithRed:166/255.0 green:137/255.0 blue:67/255.0 alpha:1.];
	broadCastLabel1.font = [UIFont systemFontOfSize:15];
	[broadCastImage addSubview:broadCastLabel1];
	self.broadCastLabel = broadCastLabel1;
	[broadCastLabel1 release];
	[self.view addSubview:broadCastImage];
	// 下拉刷新View
	if (refreshMessageView == nil) {
		refreshMessageView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0-hotTopicDetailTableList.bounds.size.height, 320.0f, hotTopicDetailTableList.bounds.size.height)];
		[refreshMessageView setTimeState:EGOMessagelastTime]; 
	}
	[hotTopicDetailTableList addSubview:refreshMessageView];
	// 加载更多cell,tableView的tableFooterView
	messageMore = [[LoadCell alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
	hotTopicDetailTableList.tableFooterView = messageMore;
	[refreshMessageView setHidden:NO];
	hotTopicDetailTableList.tableFooterView = messageMore;
	BOOL isconnect = [[CommonMethod shareInstance] connectionStatus];
	// 没有网络则提示显示错误信息
	if (!isconnect){
		[self setNoData];
		[self moveDown];
	}
	else  {
	// 请求网络服务器，加载话题数据,第一次请求pushType = mesFirstRequest 
	[hotTopicDetailTableList setHidden:YES];
	MBpro	= [[CommonMethod shareInstance] shareMBProgressHUD:load];
	[self.view bringSubviewToFront:MBpro];
	[self.navigationController.view addSubview:MBpro];
	pushType = mesFirstRequest;		//首次请求网络
	[self requesetHotTopicDetailServer:self.searchString setPageFlag:@"4" setPageInfo:@""];
	}
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification object:nil];
}

// 数据库中是否有该话题
- (BOOL)isHasHotTopic{	
	isSubscription = NO;
	NSMutableArray *subCriptionArray = [DataManager getHotWordSearchFromDatabase:@"0"];// 0标识已经订阅的
	NSString *subString = [[NSString alloc] initWithFormat:@"%@",self.searchString];
	if ([subCriptionArray count] > 0) {
		for (int i = 0; i < [subCriptionArray count]; i ++) {
			if ([subString isEqualToString:[[subCriptionArray objectAtIndex:i] objectForKey:@"hotWord"]]) {
				isSubscription = YES;
			}
		}
		
	}else {
		isSubscription = NO;
	}

	[subString release];
	return isSubscription;
}	

// 显示订阅按钮文字
- (void)showSubButton:(id)sender{
    if (bInSubscription) {
        return;
    }
    bInSubscription = YES;
    MBpro	= [[CommonMethod shareInstance] shareMBProgressHUD:inSubScription];
    [self.view bringSubviewToFront:MBpro];
    [self.navigationController.view addSubview:MBpro];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:3];
        IWeiboAsyncApi *ap = [[IWeiboAsyncApi alloc] init];
        if (!isSubscription) {
            // 将该话题上传到服务器
            [dict setObject:@"json" forKey:@"format"];
            [dict setObject:URL_ADD_HT forKey:@"request_api"];
            [dict setObject:self.hotTopicIDString forKey:@"id"];
            NSDictionary *result = [ap addHUWithParamters:dict];
            NSNumber *subSuccess = [result objectForKey:@"ret"];
            if ([subSuccess intValue] == 0) {// ret==0表示订阅成功
                MBpro	= [[CommonMethod shareInstance] shareMBProgressHUD:subScription];
                NSString *subString = [[NSString alloc] initWithFormat:@"%@",self.searchString];
                NSString *userName = [UserInfo sharedUserInfo].name;
                // 保存此话题到本地数据库
                [DataManager insertHotWordSearchToDatabase:userName hotWord:subString hotType:@"0"];
                [subString release];
                dispatch_async(dispatch_get_main_queue(), ^{ 
                    [subscriptionButton setTitle:@"取消订阅" forState:UIControlStateNormal];
                });    
                // 重置上次更新时间为0，使下次插入话题时，强制去网络更新 minwen yi
                [MyFavTopicInfo resetMyFavTopicsLastUpdatedTime];
                isSubscription = !isSubscription;
            }else {
                MBpro	= [[CommonMethod shareInstance] shareMBProgressHUD:subScriptionFail];
            }
        }else {
            // 删除此话题从服务器上
            [dict setObject:@"json" forKey:@"format"];
            [dict setObject:URL_DEL_HT forKey:@"request_api"];
            [dict setObject:self.hotTopicIDString forKey:@"id"];
            NSDictionary *result = [ap delHTWithParamters:dict];
            NSNumber *cancelSub = [result objectForKey:@"ret"];
            if ([cancelSub intValue] == 0) {//取消订阅成功
                MBpro	= [[CommonMethod shareInstance] shareMBProgressHUD:cancelScription];
                NSString *subString = [[NSString alloc] initWithFormat:@"%@",self.searchString];
                // 删除此话题从本地数据库
                [DataManager removeHotWordSearch:subString hotype:@"0"];
                // 从本地库中移除minwen yi
                [MyFavTopicInfo removeTopicFromDB:self.searchString];
                [subString release];
                dispatch_async(dispatch_get_main_queue(), ^{ 
                    [subscriptionButton setTitle:@"订阅" forState:UIControlStateNormal];	
                });    
                isSubscription = !isSubscription;
            }else {
                MBpro	= [[CommonMethod shareInstance] shareMBProgressHUD:cancelScriptionFail];
            }
            
        }
        [dict release];
        [ap	  release];
        dispatch_async(dispatch_get_main_queue(), ^{    
            [MBpro setNeedsLayout];
            [self performSelector:@selector(hiddenMBProgress) withObject:nil afterDelay:0.8];
            bInSubscription = NO;
        });    
    });
}

// 广播页面，文本内容为当前话题
- (void)writeWeiboFromTopic{
	CLog(@"发表话题广播");
	Draft *draft = [[Draft alloc] init];
	draft.draftType = BROADCAST_MESSAGE; 
	// textView中显示空内容
	NSString *draftString = [[NSString alloc] initWithFormat:@"#%@#",self.searchString];
	draft.draftText = draftString;
	draft.isFromHotTopic = YES;
	[draftString release];
	ComposeBaseViewController	*composeViewController =  [ComposeViewControllerBuilder createWithDraft:draft];
	[draft release];
	UINavigationController		*composeNavController = [[[UINavigationController alloc] initWithRootViewController:composeViewController] autorelease];
    [self presentModalViewController:composeNavController animated:YES];
	// composeViewController无需手动释放
	//[ComposeViewControllerBuilder desposeViewController:composeViewController];
}
// 返回
- (void)backButton:(id)sender{
	[MBpro hide:YES];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)setErrorState{
	broadCastLabel.text = @"加载失败，请重试";   
	errorCastImage.hidden = NO;
	IconCastImage.hidden = YES;
}

- (void)setNoData{
	[self setErrorState];
	[self hiddenMBProgress];
	hotTopicDetailTableList.hidden = NO;
	hotTopicDetailTableList.tableFooterView = nil;
	hotTopicDetailTableList.separatorColor = [UIColor clearColor];
	[refreshMessageView setHidden:YES];
}

// 加载更多请求服务器
- (void)loadMoreCell{
	pushType = mesLoadMoreRequest;
	[self requesetHotTopicDetailServer:self.searchString setPageFlag:@"1" setPageInfo:self.pageInfoString];
}

#pragma mark -
#pragma mark scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (scrollView.isDragging) {
		if (scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f ) {
			[refreshMessageView setState:EGOOPullRefreshNormal];
			[refreshMessageView setCurrentDate:EGOMessagelastTime withDateUpdated:NO];
		}
		else {
			[refreshMessageView setState:EGOOPullRefreshPulling];
			NSTimeInterval now=[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
			[refreshMessageView setLasttimeState:EGOMessagelastTime :now];
		}
	}
}
// 上拉刷新
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (scrollView.contentOffset.y <= - 65.0f && isLoading) {
		isLoading = NO;
		[refreshMessageView setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		hotTopicDetailTableList.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		[self reloadNewDataSource];
	}
}
// 加载更多
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollViewSender{
	// 滑动停止后判断tableView.y偏移量是否到最后后，查看网络状态，YES则加载更多 totalCellHeight = hotTopicDetailTableList.contentOffset.y + 416
	// 416 = self.view.bounds.height - searchBar.height = tableView高度
	if (hotTopicDetailTableList.contentOffset.y + 416 > totalCellHeight) {
		BOOL conncetStatus = [[CommonMethod shareInstance] connectionStatus];
		if (conncetStatus){
			if (isLoading) {
				// 是否还有数据
                    if (![self.hasNext isKindOfClass:[NSNumber class]] || [hasNext intValue] == 0 || [hasNext intValue] == 2) {
                        // 是还有数据
                        isLoading = NO;
                        [messageMore setState:loading1];
                        [self loadMoreCell];
                    }
                    else {
                        CLog(@"%s %@",__FUNCTION__, hasNext);
                    }
			}
		}else {
			MBpro = [[CommonMethod shareInstance] shareMBProgressHUD:loadError];
			[self.view bringSubviewToFront:MBpro];
			[self.navigationController.view addSubview:MBpro];
			[self performSelector:@selector(hiddenMBProgress) withObject:nil afterDelay:1];
			[messageMore setState:loadMore1];
		}		
	}
}

// 加载完毕
- (void)loadFinished{
	[messageMore setState:loadFinished];
}

// 状态信息消失
- (void) hiddenMBProgress{
	if (MBpro) {
		[MBpro removeFromSuperview];
	}
}
#pragma mark -
#pragma mark tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	return [hotTopicDetailArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *tableViewCell= nil;
	NSUInteger row = indexPath.row;
	//NSString *string = [NSString stringWithFormat:@"%d",indexPath.row];
	NSString *string = @"cell";
	HomelineCell *cell = (HomelineCell *)[tableView dequeueReusableCellWithIdentifier:string];
	if (cell == nil) {
		cell = [[[HomelineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string showStyle:MsgShowSytle sourceStyle:MsgSourceSytle containHead:YES] autorelease];
		cell.myHomelineCellVideoDelegate = self;
		cell.rootContrlType = 3;
	}	
	
	cell.contentView.backgroundColor = [UIColor clearColor];
	UIView *aView = [[UIView alloc] initWithFrame:cell.contentView.frame];
	aView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:0.933];
	cell.selectedBackgroundView = aView; 
	[aView release];
	cell.remRow = [NSString stringWithFormat:@"%d", row];
	cell.heightDic = self.textHeightDic;
	cell.homeInfo = (Info *)[hotTopicDetailArray objectAtIndex:row];
	[cell setLabelInfo:[hotTopicDetailArray objectAtIndex:row]];
	Info *info = [hotTopicDetailArray objectAtIndex:row];
	if (![info.source isMemberOfClass:[NSNull class]]){
		if (info.source != nil) {
			TransInfo *transInfo = [self convertSourceToTransInfo:info.source];
			cell.sourceInfo = transInfo;
		}else {
			[cell remove];
		}
	}else {
		[cell remove];
	}
	tableViewCell = cell;
	return tableViewCell;
}

// 数据类型转
- (TransInfo *)convertSourceToTransInfo:(NSDictionary *)tSource{
	TransInfo *transInfo = [[[TransInfo alloc] init] autorelease];
	if ([tSource valueForKey:@"name"] != nil) {
		transInfo.transName = [tSource valueForKey:@"name"];
	}
	if ([tSource valueForKey:@"nick"] != nil) {
		transInfo.transNick = [tSource valueForKey:@"nick"];
	}
	if ([tSource valueForKey:@"isvip"] != nil) {
		transInfo.transIsvip = [tSource valueForKey:@"isvip"];
	}
	if ([tSource valueForKey:@"origtext"] != nil) {
		transInfo.transOrigtext = [tSource valueForKey:@"origtext"];
		//CLog(@"%s,transInfo.transNick:%@, text: %@", __FUNCTION__, transInfo.transNick, transInfo.transOrigtext);
	}
	if ([tSource valueForKey:@"id"] != nil) {
		transInfo.transId = [tSource valueForKey:@"id"];
	}
	if ([tSource valueForKey:@"image"] != nil&&![[tSource valueForKey:@"image"] isEqual:[NSNull null]]) {
		transInfo.transImage = [[tSource valueForKey:@"image"] objectAtIndex:0];
	}
	if ([tSource valueForKey:@"video"] != nil&&![[tSource valueForKey:@"video"] isEqual:[NSNull null]]) {
		if ([[tSource valueForKey:@"video"] valueForKey:@"picurl"] != nil) {
			transInfo.transVideo = [[tSource valueForKey:@"video"] valueForKey:@"picurl"];
		}
		transInfo.transVideoRealUrl = [[tSource valueForKey:@"video"] valueForKey:@"realurl"];
	}

	if ([tSource valueForKey:@"from"] != nil&&![[tSource valueForKey:@"from"] isEqual:[NSNull null]]) {
		transInfo.transFrom = [tSource valueForKey:@"from"];
	}
	if ([tSource valueForKey:@"timestamp"] != nil&&![[tSource valueForKey:@"timestamp"] isEqual:[NSNull null]]){
		transInfo.transTime = (NSString *)[tSource valueForKey:@"timestamp"];
	}
	if ([tSource valueForKey:@"count"] != nil) {
		transInfo.transCount = (NSString *)[tSource valueForKey:@"count"];
	}
	if ([tSource valueForKey:@"mcount"] != nil) {
		transInfo.transCommitcount = (NSString *)[tSource valueForKey:@"mcount"];
	}
	if ([tSource valueForKey:@"is_auth"] != nil) {
		transInfo.translocalAuth = [NSString stringWithFormat:@"%@",[tSource objectForKey:@"is_auth"]];
	}
	return transInfo;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat height = 0.0f;
	if (indexPath.row < [hotTopicDetailArray count]) {
		height = [self getRowHeight:indexPath.row];
	}
	totalCellHeight += height;
	return height ;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.tabBarController performSelector:@selector(hideNewTabBar)];//隐藏tabbar
	if (indexPath.row < [hotTopicDetailArray count]) {
		Info *info = [hotTopicDetailArray objectAtIndex:indexPath.row];
		DetailsPage   *details = [[DetailsPage alloc] init];
		details.rootContrlType = 3;
		details.homeInfo = info;
		if (![info.source isMemberOfClass:[NSNull class]]){
			if (info.source != nil) {
				// 判断是否有转发内容
				TransInfo *transInfo = [self convertSourceToTransInfo:info.source];
				details.sourceInfo = transInfo;
			}
		}
		[self.navigationController pushViewController:details animated:YES];
		[details release];
	}
}

// 获取每一行的高度
- (CGFloat)getRowHeight:(NSUInteger)row{
	NSString *rowString = [[NSString alloc] initWithFormat:@"%d", row];
	if ([self.textHeightDic objectForKey:rowString]!=nil) {							// 如果高度字典不为空
		NSMutableDictionary *dic = [self.textHeightDic objectForKey:rowString];
		assert(dic);
		CGFloat origHeight = [[dic objectForKey:@"origHeight"] floatValue];		// 从字典中取得原创高度
		CGFloat sourceHeight = [[dic objectForKey:@"sourceHeight"] floatValue];	// 从字典中取得转发高度
		//CLog(@"rowString First:%@ origHeight:%f, sourceHeight:%f", rowString, origHeight, sourceHeight);
		[rowString release];
		CGFloat retValue = 0.0f;
		if (sourceHeight > 1) {
			retValue += sourceHeight + VSBetweenSourceFrameAndFrom;
		}
		CGFloat fromHeight = [@"来自..." sizeWithFont:[UIFont systemFontOfSize:12]].height + VSpaceBetweenOriginFrameAndFrom;
		retValue += origHeight + fromHeight;
		return retValue;
	}
	else {																	// 如果高度字典为空，则根据当前文本算出每一行的高度并存储到高度字典中
		Info *info = [hotTopicDetailArray objectAtIndex:row];
		CGFloat origHeight = 0.0f;
		CGFloat sourceHeight = 0.0f;
		CGFloat retValue = 0.0f;
		origHeight = [MessageViewUtility getTimelineOriginViewHeight:info];
		
		// 计算转发内容高度
		if (info.source != nil) {
			TransInfo *transInfo = [self convertSourceToTransInfo:info.source];
			sourceHeight = [MessageViewUtility getTimelineSourceViewHeight:transInfo];
			retValue += sourceHeight + VSBetweenSourceFrameAndFrom;
		}
		
		// 2012-02-20 By Yi Minwen 修正首次登陆时，界面乱的问题
		// 来自...高度
		CGFloat fromHeight = [@"来自..." sizeWithFont:[UIFont systemFontOfSize:12]].height + VSpaceBetweenOriginFrameAndFrom;
		retValue += origHeight + fromHeight;
		
		NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
		NSString *origHeightStr = [[NSString alloc] initWithFormat:@"%f", origHeight];
		NSString *sourceHeightStr = [[NSString alloc] initWithFormat:@"%f", sourceHeight];
		[dic setObject:origHeightStr forKey:@"origHeight"];
		[dic setObject:sourceHeightStr forKey:@"sourceHeight"];
		[self.textHeightDic setObject:dic forKey:rowString];
		//CLog(@"rowString First:%@ origHeight:%f, sourceHeight:%f", rowString, origHeight, sourceHeight);
		[origHeightStr release];
		[sourceHeightStr release];
		[dic release];
		[rowString release];
		return retValue;
	}
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark protocol HomelineCellVideoDelegate<NSObject> 视频点击事件
- (void)HomelineCellVideoClicked:(NSString *)urlVideo {	
	CLog(@"HomelineCellVideoClicked:%@", urlVideo);
	WebUrlViewController *webUrlViewController = [[WebUrlViewController alloc] init];
	webUrlViewController.webUrl = urlVideo;
	[self.navigationController pushViewController:webUrlViewController animated:YES];
	[webUrlViewController release];
}

@end
