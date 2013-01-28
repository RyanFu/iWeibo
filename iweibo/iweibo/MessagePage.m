//
//  MessagePage.m
//  iweibo
//
//  Created by LiQiang on 11-12-22.
//  Copyright 2011年 Beyondsoft. All rights reserved.
//

#import "Info.h"
#import "TransInfo.h"
#import "Canstants.h"
#import "DataSave.h"
#import "LoadCell.h"
#import "Canstants.h"
#import "NoWebView.h"
#import "DetailsPage.h"
#import "MessagePage.h"
#import "HomelineCell.h"
#import "Canstants_Data.h"
#import "IWeiboSyncApi.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "DetailPageConst.h"
#import "MessageViewUtility.h"
#import "WebUrlViewController.h"
#import "IWBSvrSettingsManager.h"
#import "EGORefreshTableHeaderView.h"
#import "CustomNavigationbar.h"
#import "HomelineCellEx.h"

#define SEGMENTBAR_HEIGHT 30
#define REQNUM 30													//请求个数
#define HEIGHTFOOTER   50											//表尾高度
#define PARAMETERMESSAGETYPE		@"0"							//0参数
#define MESSAGENEWTIMESTAMP			@"MessageNewTimeStamp"
#define MESSAGENEWWEIBOID			@"MessageNewWeiboId"
#define MESSAGEOLDTIMEFROMDATABASE	@"MesOldTimeFromDatabase"
#define MESSAGEOLDWEIBOID			@"MessageOldWeiboId"

#define MESSAGEISCREATED			@"messageIsCreated"

@implementation MessagePage
@synthesize messageTable, refreshMessageView, messageMore;
@synthesize aApi, messageSaveToClass, messageArray, textHeightDic, messageToDatabase;
@synthesize messageNewTime, messageOldTime, nnewWeiboId, oldWeiboId, pushType;
@synthesize mesOldTimeFromDatabase, cupView;
@synthesize userNameInfo,siteInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		textHeightDic = [[NSMutableDictionary alloc] initWithCapacity:30];
    }
    return self;
}

- (void)dealloc{
	[messageSaveToClass release];
	[refreshMessageView release];
	[messageToDatabase release];
	[textHeightDic release];
	[messageArray release];
	[messageTable release];
	[messageMore release];
    [aApi cancelSpecifiedRequest];
	[aApi release];
	self.textHeightDic = nil;
	
	[siteInfo release];
	[userNameInfo release];
	[broadCastImage release];
	[errorCastImage release];
	[broadCastLabel release];
	[IconCastImage release];
	[MBprogress release];
	[cupView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)loadView{
	[super loadView];  
}

#pragma mark -
#pragma mark - readDatabase

- (void)dbSetState{
	[messageMore setState:loadMore1];
}

//从数据库中加载
-(void)messageReStructerFromDB:(readDatabase)readType{    
	NSArray *infoWeibo = nil;
	NSArray *info ;
	NSString *typeM = @"messageType";
	isLoading = YES;
	if (readType == readDataFirst) {
		if ([messageToDatabase.transSource count]!=0) {
			[messageToDatabase.transSource removeAllObjects];
		}
	//	self.messageNewTime = [[NSUserDefaults standardUserDefaults] objectForKey:MESSAGENEWTIMESTAMP];
		self.messageNewTime = [DataManager readMessageNewTimeWithUser:self.userNameInfo andSite:self.siteInfo];
		infoWeibo = [messageToDatabase getDataFromWeibo:self.messageNewTime type:typeM userName:self.userNameInfo site:self.siteInfo];
	}else {
		if (readType == readDataMore) {
			self.mesOldTimeFromDatabase = [[NSUserDefaults standardUserDefaults]objectForKey:MESSAGEOLDTIMEFROMDATABASE];
			infoWeibo = [messageToDatabase getDataFromWeibo:self.mesOldTimeFromDatabase type:typeM userName:self.userNameInfo site:self.siteInfo];
		}
	}

	if ([infoWeibo count]>0) {
		for (int i = 0; i<[infoWeibo count]; i++) {
			[messageArray addObject:[infoWeibo objectAtIndex:i]];
			info = [messageToDatabase getDataFromTransWeibo:[[infoWeibo objectAtIndex:i] uid] type:typeM];
			if ([info count]!=0) {
				[messageToDatabase.transSource addObject:[info objectAtIndex:0]];
			}
		}
		self.mesOldTimeFromDatabase = [[infoWeibo objectAtIndex:[infoWeibo count]-1] timeStamp];
		self.oldWeiboId = [[infoWeibo objectAtIndex:[infoWeibo count]-1] uid];
		//因为这里与首次从数据库加载判断相冲突，故减1操作
		self.mesOldTimeFromDatabase = [NSString stringWithFormat:@"%lld",[self.mesOldTimeFromDatabase longLongValue]-1];
		//要考虑到会从网络加载，所以要给出加载的时间和id值
		self.oldWeiboId = [NSString stringWithFormat:@"%lld",[self.oldWeiboId longLongValue]-1];
		self.messageOldTime = self.mesOldTimeFromDatabase;
		
		[[NSUserDefaults standardUserDefaults] setObject:self.mesOldTimeFromDatabase forKey:MESSAGEOLDTIMEFROMDATABASE];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[messageTable reloadData];  
		[self hiddenMBProgress];
	}
	else {
		fingerView.hidden = NO;
		if(readType == readDataFirst)
			firstNull = YES;
	//	[self doneLoadingTableViewDataWithNetError];
	}

	[self performSelector:@selector(dbSetState) withObject:nil afterDelay:2];
}

- (NSUInteger)returnCount:(NSDictionary *)dic{
	NSUInteger sum = 0;
	NSDictionary *infoDic = [[dic objectForKey:HOMEDATA] objectForKey:HOMEINFO];
	if (![infoDic isMemberOfClass:[NSNull class]]) {
		sum = [infoDic count];
	}
	return sum;
}

#pragma mark -
#pragma mark requestCallBack

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

- (void)messageListSuccess:(NSDictionary *)dic{
	NSDictionary *data =[DataCheck checkDictionary:dic forKey:HOMEDATA withType:[NSDictionary class]];
	if ([data isKindOfClass:[NSDictionary class]]) {
			// 存储用户昵称
		NSDictionary *userNicks = [DataCheck checkDictionary:data forKey:@"user" withType:[NSDictionary class]];
		if ([userNicks isKindOfClass:[NSDictionary class]]) {
				// 存到数据库
			[DataManager insertUserInfoToDBWithDic:userNicks];
				// 存到本地字典
			[HomePage insertNickNameToDictionaryWithDic:userNicks];
		}
	}
		
	isLoading = YES;
	cupView.hidden = YES;
	messageMore.hidden = NO;
	messageButtonSelected = YES;
	if (![data isKindOfClass:[NSNull class]]) {
		hasNext = [[[dic objectForKey:HOMEDATA] objectForKey:HOMEHASNEXT] boolValue];
	}
	switch (pushType) {
		case mesLoadMoreRequest:
			[self caculateHomeline:dic];
			break;
		case mesFirstRequest:
			[textHeightDic removeAllObjects];
			[self caculateHomeline:dic];
			if (firstNull) {
				firstNull = NO;
				[self performSelector:@selector(dataSourceDidFinishLoadingNewData) withObject:nil afterDelay:2.0];
			}
			break;
		case mesPullRefreshRequest:
			[textHeightDic removeAllObjects];
			pullRefreshMessageCount = [self returnNewCount:dic timestampNew:self.messageNewTime];
			[self caculateHomeline:dic];
			[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
			break;

		default:
			break;
	}

	if (!hasNext) {
		[messageMore setState:loadMore1];
	}
	else {
		[messageMore setState:loadFinished];
	}

	[messageToDatabase deleteSuperfluousData];
	if ([messageArray count] == 0) {
		fingerView.hidden = NO;
		cupView.hidden = YES;
		messageMore.hidden = NO;
	}
	else {
		fingerView.hidden = YES;
	}

	[messageTable reloadData]; 
	[self hiddenMBProgress];
}

- (void)recordingNewTimestamp:(NSArray *) infoQueue{
	if ([infoQueue count]!=0) {
		self.messageNewTime = [NSString stringWithFormat:@"%@",[[infoQueue objectAtIndex:0] timeStamp]];
		self.nnewWeiboId = [NSString stringWithFormat:@"%@",[[infoQueue objectAtIndex:0]uid]];
		[[NSUserDefaults standardUserDefaults] setObject:messageNewTime forKey:MESSAGENEWTIMESTAMP];
		[[NSUserDefaults standardUserDefaults] setObject:nnewWeiboId forKey:MESSAGENEWWEIBOID];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void)recordingOldTimestamp:(NSArray *) infoQueue{
	if ([infoQueue count]!=0) {
		self.messageOldTime = [NSString stringWithFormat:@"%@",[[infoQueue objectAtIndex:[infoQueue count] - 1]timeStamp]];
		self.oldWeiboId = [NSString stringWithFormat:@"%@",[[infoQueue objectAtIndex:[infoQueue count]-1] uid]];
		[[NSUserDefaults standardUserDefaults] setObject:self.oldWeiboId forKey:MESSAGEOLDWEIBOID];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}	
}

//记录时间戳
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

- (void)storeInfoToArray:(NSArray *)infoQueue{
	Info *dataInfo;
	for (int i=0; i<[infoQueue count]; i++) {
		dataInfo = [infoQueue objectAtIndex:i];
		[messageArray addObject:dataInfo];
		[messageToDatabase insertMessageToDatabase:dataInfo];
		[messageToDatabase updateMessageWithSite:self.userNameInfo site:self.siteInfo withWhere:dataInfo.uid];
	}
}

- (void)caculateHomeline:(NSDictionary *)result {
	Info *dataInfo = nil;
	int i = 0;
	NSArray *infoQueue =[messageSaveToClass storeInfoToClass:result];
	[self recordingTimestamp:infoQueue];
	if ([infoQueue count]>0) {
		if (pushType == mesPullRefreshRequest) {
			if (pullRefreshMessageCount < 30) {
				i = pullRefreshMessageCount - 1;
			}
			else {
				i = [infoQueue count]-1;
			}
		}
		switch (pushType) {
			case mesFirstRequest:
			case mesLoadMoreRequest:
				[self storeInfoToArray:infoQueue];
				break;
			case mesPullRefreshRequest:
				for ( ; i >= 0; i--) {
					dataInfo = [infoQueue objectAtIndex:i];
					[messageArray insertObject:dataInfo atIndex:0];
					[messageToDatabase insertMessageToDatabase:dataInfo];
					[messageToDatabase updateMessageWithSite:self.userNameInfo site:self.siteInfo withWhere:dataInfo.uid];
				}
				break;
			default:
				break;
		}
	}
}

- (void)messageListFailure:(NSError *)error{
//	[self hiddenMBProgress];
	if ([error code] == ASIRequestTimedOutErrorType || [error code] == ASIConnectionFailureErrorType) {
		broadCastLabel.text = @"网络错误，请重试";
		errorCastImage.hidden = NO;
		IconCastImage.hidden = YES;
	}
	[self moveDown];
	[self dataSourceDidFinishLoadingNewData];
	[self setNoData];
}

#pragma mark -
#pragma mark manager Refresh PullView
//下拉刷新请求完毕后的处理
- (void)dataSourceDidFinishLoadingNewData{
	reloading = NO;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[messageTable setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[refreshMessageView setState:EGOOPullRefreshNormal];
//	[_refreshMessageView setCurrentDate:EGOMessagelastTime]; 
}

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

//下拉刷新后黄色提示条处理
- (void)doneLoadingTableViewData{
	if (pullRefreshMessageCount > 0) {
		if(pullRefreshMessageCount >0 && pullRefreshMessageCount <=30) {
			broadCastLabel.text = [NSString stringWithFormat:@"%d条提及我的",pullRefreshMessageCount];
		}
		errorCastImage.hidden = YES;
		IconCastImage.hidden = NO;
	}
	else{
		broadCastLabel.text = @"没有提及我的";
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
	[self moveDown];
	[self dataSourceDidFinishLoadingNewData];
}

#pragma mark -
#pragma mark requestWebService

- (void)requstWebService:(NSString *)pageflag pagetime:(NSString *)pagetime lastid:(NSString *)lastid type:(NSString *)type{
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithCapacity:10];
	[parameters setValue:@"json" forKey:@"format"];
	[parameters setValue:pageflag forKey:@"pageflag"];
	[parameters setValue:pagetime forKey:@"pagetime"];
	[parameters setValue:@"30" forKey:@"reqnum"];
	[parameters setValue:lastid forKey:@"lastid"];
	[parameters setValue:type forKey:@"type"];
	[parameters setValue:PARAMETERMESSAGETYPE forKey:@"contenttype"];
	[parameters setValue:URL_MENTIONS_TIMELINE forKey:@"request_api"];
	
	[aApi getMentionsTimeLineWithParamters:parameters
							delegate:self
						   onSuccess:@selector(messageListSuccess:) onFailure:@selector(messageListFailure:)];
	[parameters release];
}

//下拉刷新时请求网络
- (void)reloadNewDataSource{
	if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable) 
		&& ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
		[self performSelector:@selector(doneLoadingTableViewDataWithNetError) withObject:nil afterDelay:2.0];
	}
	else {
		if (firstNull) {
			pushType = mesFirstRequest;
		}
		else {
			pushType = mesPullRefreshRequest;
		}
	//	[self requstWebService:PARAMETERMESSAGETYPE pagetime:self.messageNewTime lastid:self.nnewWeiboId type:PARAMETERMESSAGETYPE];
		[self requstWebService:PARAMETERMESSAGETYPE pagetime:PARAMETERMESSAGETYPE lastid:PARAMETERMESSAGETYPE type:PARAMETERMESSAGETYPE];
	}
}

//首次加载请求网络
- (void)firstRequest{
	[messageTable setHidden:YES];
	[self showMBProgress];
	pushType = mesFirstRequest;
	[self requstWebService:PARAMETERMESSAGETYPE pagetime:PARAMETERMESSAGETYPE lastid:PARAMETERMESSAGETYPE type:PARAMETERMESSAGETYPE];
}

//loadMore时请求网络
- (void)handleTimer{
	[messageMore setState:loading1];
	if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable) 
		&& ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
		[self messageReStructerFromDB:readDataMore];
	}
	else {
		pushType = mesLoadMoreRequest;
		[self requstWebService:@"1" pagetime:self.messageOldTime lastid:self.oldWeiboId type:PARAMETERMESSAGETYPE];
	}
}

#pragma mark -
#pragma mark viewDidLoad

- (void)viewDidLoad{
    [super viewDidLoad];
	UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
	[customLab setTextColor:[UIColor whiteColor]];
	[customLab setText:@"@提及我的"];
	[customLab setTextAlignment:UITextAlignmentCenter];
	customLab.backgroundColor = [UIColor clearColor];
	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	self.navigationItem.titleView = customLab;
	[customLab release];
	//self.title = @"@提及我的";
	self.view.backgroundColor = [UIColor whiteColor];
	isLoading = YES;
	messageButtonSelected = NO;
	
	aApi = [[IWeiboAsyncApi alloc] init];
	messageSaveToClass = [[DataSave alloc] init];
	messageToDatabase = [[DataManager alloc] init];
	messageArray  = [[NSMutableArray alloc] init];
	
	CGRect rc = CGRectMake(0, 0, 320, self.view.bounds.size.height-90);
	messageTable = [[UITableView alloc] initWithFrame:rc style:UITableViewStylePlain];
	messageTable.backgroundColor = [UIColor clearColor];
	messageTable.separatorColor = [UIColor colorWithRed:0.827 green:0.843 blue:0.855 alpha:1];
	messageTable.delegate = self;
	messageTable.dataSource = self;
	[self.view addSubview:messageTable];

	NSString *path = [[NSBundle mainBundle] pathForResource:@"bgLabel" ofType:@"png"];
	broadCastImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
	broadCastImage.frame = CGRectMake(0, -30, 320, 30);
	
	NSString *pathError = [[NSBundle mainBundle] pathForResource:@"errorler" ofType:@"png"];
	errorCastImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:pathError]];
	errorCastImage.frame = CGRectMake(90, 5, 20, 20);
	errorCastImage.backgroundColor = [UIColor clearColor];
	errorCastImage.hidden = YES;
	[broadCastImage addSubview:errorCastImage];
	[errorCastImage release];
	
	NSString *pathIcon = [[NSBundle mainBundle] pathForResource:@"iconPull" ofType:@"png"];
	IconCastImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:pathIcon]];
	IconCastImage.frame = CGRectMake(100, 8, 15, 15);
	IconCastImage.backgroundColor = [UIColor clearColor];
	IconCastImage.hidden = YES;
	[broadCastImage addSubview:IconCastImage];
	[IconCastImage release];
	
	broadCastLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 180, 30)];
	broadCastLabel.backgroundColor = [UIColor clearColor];
	broadCastLabel.textColor = [UIColor colorWithRed:166/255.0 green:137/255.0 blue:67/255.0 alpha:1.];
	broadCastLabel.font = [UIFont systemFontOfSize:15];
	[broadCastImage addSubview:broadCastLabel];
	[broadCastLabel release];
	[self.view addSubview:broadCastImage];
	
	if (refreshMessageView == nil) {
		refreshMessageView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0-messageTable.bounds.size.height, 320.0f, messageTable.bounds.size.height)];
		[refreshMessageView setTimeState:EGOMessagelastTime]; 
	}
	[messageTable addSubview:refreshMessageView];

	messageMore = [[LoadCell alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
	messageTable.tableFooterView = messageMore;
	
	cupView = [[NoWebView alloc] init];
	cupView.hidden = YES;
	[cupView setState:messageType];
	//[self.view addSubview:cupView];
	[self.messageTable addSubview:cupView];
	
	fingerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pullRefreshTip.png"]];
	fingerView.hidden = YES;
	[messageTable addSubview:fingerView];
	
	//数据表增加userName和site两个字段
	NSString *isCreated = [[NSUserDefaults standardUserDefaults] objectForKey:MESSAGEISCREATED];
	if (!isCreated) {
		BOOL isAlterUserNameOK = [DataManager alterWeiboColoum:USERNAME andType:messageWeibo];
		BOOL isAlterSiteOK = [DataManager alterWeiboColoum:SITE andType:messageWeibo];
		BOOL isSourceUserNameOK = [DataManager alterWeiboColoum:USERNAME andType:sourceMessageWeibo];
		BOOL isSourceSiteOK = [DataManager alterWeiboColoum:SITE andType:sourceMessageWeibo];
		if (isAlterSiteOK && isAlterUserNameOK && isSourceUserNameOK && isSourceSiteOK) {
			[[NSUserDefaults standardUserDefaults] setObject:@"OK" forKey:MESSAGEISCREATED];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
		CLog(@"%d,%d",isAlterUserNameOK,isAlterSiteOK);
	}
	
	self.userNameInfo = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite.loginUserName;
	self.siteInfo = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite.descriptionInfo.svrName;
	
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (!actSite.bUserFirstLogin) {
		[[Database sharedManager] setupDB];
		[[Database sharedManager] connectDB];
		FMDatabase *database = [Database sharedManager].db;
		[database open];
		[self messageReStructerFromDB:readDataFirst];
    }
}

- (void)setErrorState{
	broadCastLabel.text = @"加载失败，请重试";   
	errorCastImage.hidden = NO;
	IconCastImage.hidden = YES;
}

- (void)setNoData{
	[self setErrorState];
	[self hiddenMBProgress];
	messageTable.hidden = NO;
	if ([messageArray count] == 0) {
		cupView.hidden = NO;
		messageMore.hidden = YES;
		fingerView.hidden = YES;
		[self.messageTable bringSubviewToFront:cupView];
	}
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
//	[textHeightDic removeAllObjects];

	[refreshMessageView setHidden:NO];
	self.userNameInfo = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite.loginUserName;
	self.siteInfo = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite.descriptionInfo.svrName;
	
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite.bUserFirstLogin) {
		if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable) 
			&& ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
			[self setNoData];
			[self moveDown];
		}
		else {
			if (!messageButtonSelected) {
				[self firstRequest];
			}
		}
	}
	[self.tabBarController performSelector:@selector(showNewTabBar)];
}

- (void)setMessageButtonState{
	messageButtonSelected = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
//	[self.textHeightDic removeAllObjects];
}

#pragma mark -
#pragma mark scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (scrollView.isDragging) {
		if (!reloading) {
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
	if ([scrollView isKindOfClass:[UITableView class]]) {
		UITableView *tableView = (UITableView *)scrollView;
		NSArray *indexPathes = [tableView indexPathsForVisibleRows];
		if (indexPathes.count > 0) {
			int rowCounts = [tableView numberOfRowsInSection:0];
			NSIndexPath *lastIndexPath = [indexPathes objectAtIndex:indexPathes.count-1];
			if (rowCounts - lastIndexPath.row <2 && isLoading) {
				isLoading = NO;
				if (!hasNext) {
//					againLoading = YES;
					[self performSelector:@selector(handleTimer) withObject:nil afterDelay:2];
				}
			}
		}
	}
}


- (void)loadImagesForOnscreenRows
{
	NSArray *visiblePaths = [messageTable indexPathsForVisibleRows];
	//CLog(@"visiblePaths:%@",visiblePaths);
	for (NSIndexPath *indexPath in visiblePaths) {
		HomelineCellEx *cell = (HomelineCellEx *)[messageTable cellForRowAtIndexPath:indexPath];
		if (cell) {
			[cell startIconDownload];
		}
		else {
			CLog(@"cell not found");
		}
		
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForOnscreenRows];
	if (reloading) {
		[self dataSourceDidFinishLoadingNewData];
	}
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (scrollView.contentOffset.y <= - 65.0f && !reloading) {
		reloading = YES;
		[self reloadNewDataSource];
		[refreshMessageView setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		messageTable.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
	if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}


- (void)showMBProgress{
    if (MBprogress == nil) {
        MBprogress = [[MBProgressHUD alloc] initWithFrame:CGRectMake(30, 80, 260, 200)]; 
    }
    [self.view addSubview:MBprogress];  
    [self.view bringSubviewToFront:MBprogress];  
    MBprogress.labelText = @"载入中...";  
    MBprogress.removeFromSuperViewOnHide = YES;
    [MBprogress show:YES];  
}

- (void) hiddenMBProgress{
    [messageTable setHidden:NO];
    [MBprogress hide:YES];
}

- (void)writeWeibo{
}

#pragma mark -
#pragma mark tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	return [messageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSUInteger row = indexPath.row;
	UITableViewCell *tableViewCell= nil;
		//NSString *string = [NSString stringWithFormat:@"%d",indexPath.row];
		static NSString *cellIdentifier = @"messageCellIdentifier";
		HomelineCell *cell = (HomelineCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[[HomelineCellEx alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier showStyle:HomeShowSytle sourceStyle:HomeSourceSytle containHead:YES] autorelease];
		cell.myHomelineCellVideoDelegate = self;
		cell.rootContrlType = 2;
		cell.contentView.backgroundColor = [UIColor clearColor];
	}
		Info *info = [messageArray objectAtIndex:row];
	
		cell.heightDic = self.textHeightDic;
		cell.remRow = [NSString stringWithFormat:@"%d", row];
		cell.homeInfo = info;
		
		[cell setLabelInfo:info];

	if (![[[messageArray objectAtIndex:row] source] isMemberOfClass:[NSNull class]]){
		if ([messageToDatabase.transSource count]!=0) {
			for (TransInfo *transInfo in messageToDatabase.transSource) {
				if ([transInfo.transId isEqualToString:[[messageArray objectAtIndex:row] uid]]) {
					cell.sourceInfo = transInfo;
					break;
				}
				[cell remove];//将转播源从屏幕移除
			}
		}
	}
	if (tableView.dragging == NO && tableView.decelerating == NO)
    {
		//	CLog(@"indexPath:%@, startIconDownload", indexPath);
        [cell startIconDownload];
    }
	tableViewCell = cell;
	return tableViewCell;

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat height = 0.0f;
	if (indexPath.row < [messageArray count]) {
		height = [self getRowHeight:indexPath.row];
	}else {
		height = messageTable.bounds.size.height+HEIGHTFOOTER;  //added by wangying
	}
	return height ;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	// 设置发送状态代理
	//[[DraftController sharedInstance] setMyDraftControllerDelegate:self];
	[self.tabBarController performSelector:@selector(hideNewTabBar)];//隐藏tabbar
	if (indexPath.row < [messageArray count]) {
		DetailsPage   *details = [[DetailsPage alloc] init];
		details.rootContrlType = 2;
		details.homeInfo = [messageArray objectAtIndex:indexPath.row];
		if (![[[messageArray objectAtIndex:indexPath.row] source] isEqual:[NSNull null]]){
			if ([messageToDatabase.transSource count]!=0) {
				for (TransInfo *transInfo in messageToDatabase.transSource) {
					if ([transInfo.transId isEqualToString:[[messageArray objectAtIndex:indexPath.row] uid]]) {
						details.sourceInfo = transInfo;
						break;
					}
				}
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
		Info *info = [messageArray objectAtIndex:row];
		CGFloat origHeight = 0.0f;
		CGFloat sourceHeight = 0.0f;
		CGFloat retValue = 0.0f;
		origHeight = [MessageViewUtility getTimelineOriginViewHeight:info];
		if ([messageToDatabase.transSource count] > 0) {
			for (TransInfo *transInfo in messageToDatabase.transSource) {
				if ([[transInfo transNick] length] > 0 && [transInfo.transId isEqualToString:info.uid]) {
					sourceHeight = [MessageViewUtility getTimelineSourceViewHeight:transInfo];
					retValue += sourceHeight + VSBetweenSourceFrameAndFrom;
					break;
				}
			}
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
