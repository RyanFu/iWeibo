//
//  HotBroadcastTableViewController.m
//  iweibo
//
//  Created by Minwen Yi on 2/24/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "HotBroadcastTableViewController.h"
#import "HotBroadcastInfo.h"
#import "DetailsPage.h"
#import "WebUrlViewController.h"
#import "HpThemeManager.h"
#import "SCAppUtils.h"

@implementation HotBroadcastTableViewController
@synthesize lastID, hasNext;
@synthesize isLoadFromDB;
@synthesize leftButton;
#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/
- (void)updateTheme:(NSNotificationCenter *)noti{
    NSDictionary *plistDict = [[HpThemeManager sharedThemeManager]themeDictionary];
	NSString *themePathTmp = [plistDict objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    UIImage *imageNav = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"navigationbar_bg.png"]];
    [SCAppUtils navigationController:self.navigationController setImage:imageNav];
    [leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	// 成员初始化
	self.showPullDown = YES;
	self.showLoadMore = YES;
	self.tableCellType = HotBroadcastCellType;
	self.requestNumEachTime = HotBroadcastInfoReqNum;
	self.egoLastTime = EGOHotBroadCastLastTime;
	asyncApi = [[IWeiboAsyncApi alloc] init];
	// 导航栏
    
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
    NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    UIImage *imageNav = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"navigationbar_bg.png"]];
    [SCAppUtils navigationController:self.navigationController setImage:imageNav];
    
	self.navigationController.title = @"热门话题";
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
	[leftButton setTitle:@"返回" forState:UIControlStateNormal];
	leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 5)];
	[leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
	[leftButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
	self.navigationItem.leftBarButtonItem = leftBar;
    [leftBar release];
	UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
	[customLab setTextColor:[UIColor whiteColor]];
	[customLab setText:@"最新广播"];
	[customLab setTextAlignment:UITextAlignmentCenter];
	customLab.backgroundColor = [UIColor clearColor];
	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	self.navigationItem.titleView = customLab;
	[customLab release];
	//self.navigationItem.title = @"最新广播";
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	//self.lastID = [[NSUserDefaults standardUserDefaults] objectForKey:HotBroadcastOldestLocalID];
//	// 假如从来没有更新过,用０替代
//	if (self.lastID == nil || self.lastID = [NSNull null]}) {
//		self.lastID = @"0";
//	}
	self.lastID = @"0";
	[self initData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification object:nil];
}

// 返回按钮处理
- (void)backAction:(id)sender{
	self.showLabel = NO;			// 2012-03-19 zhaolilong 当退出该界面时隐藏label
	[self.tabBarController performSelector:@selector(showNewTabBar)];// 隐藏tabbar
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (nil != cellInfoArray && [cellInfoArray count] > indexPath.section ) {
		// 获取当前section对应的数组
		NSArray *arrayCurSection = [cellInfoArray objectAtIndex:indexPath.section];
		if ([arrayCurSection isKindOfClass:[NSArray class]] && [arrayCurSection count] > indexPath.row) {
			MessageViewCellInfo *cellInfo = [arrayCurSection objectAtIndex:indexPath.row];
			DetailsPage   *details = [[DetailsPage alloc] init];
			details.rootContrlType = 3;
			details.homeInfo = cellInfo.originInfo;
			details.sourceInfo = cellInfo.sourceInfo;
			[self.navigationController pushViewController:details animated:YES];
			[details release];
		}
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    [leftButton release];
	[asyncApi release];
	asyncApi = nil;
	self.lastID = nil;
	self.hasNext = nil;
    [super dealloc];
}

#pragma mark -

// 格式化数据进行更新处理
-(void)formatDataWithArr:(NSArray *)infoArray{
	if (![infoArray isKindOfClass:[NSArray class]]) {
		return ;
	}
	if ([infoArray count] > 0) {
		// 包装原始数据
		NSMutableArray *cellItemArray = [NSMutableArray arrayWithCapacity:[infoArray count]];
		for (HotBroadcastInfo *item in infoArray) {
			MessageViewCellInfo *cellItem = [[[MessageViewCellInfo alloc] init] autorelease];
			cellItem.originInfo = item;
			// 转换sourceInfo(假如为从数据库读取数据，则需要重新从库中加载对应数据)
			if (isLoadFromDB) {
				// 从数据库加载sourceInfo
				NSMutableArray *res = [DataManager getFromHotBroadTransWeibo:item.uid];
				if ([res isKindOfClass:[NSMutableArray class]] && [res count] > 0) {
					cellItem.sourceInfo = [res objectAtIndex:0];
				}
				else {
					cellItem.sourceInfo = nil;
				}

			}
			else {
				// 从字典解析数据
				cellItem.sourceInfo = [HotBroadcastInfo sourceInfoItemFromDic:item.source infoID:item.uid];
			}
			[cellItemArray addObject:cellItem];
		}
		// 判断加载类型(由于没有上拉刷新，保存的永远为最后一条记录id)
		// 更新lastid
		self.lastID = [[infoArray objectAtIndex:[infoArray count] - 1] localID];
		CLog(@"%s, lastID:%@", __FUNCTION__, self.lastID);
		[[NSUserDefaults standardUserDefaults] setObject:self.lastID forKey:HotBroadcastOldestLocalID];
		[[NSUserDefaults standardUserDefaults] synchronize];
				if (LoadMoreLoadingStatus == self.loadingStatus) {
			// 查找lastID　向下翻页：填上一次请求返回的最后一条记录的local_id
			//HotBroadcastInfo *lastItem = [infoArray objectAtIndex:[infoArray count] - 1];
//			self.lastID = lastItem.localID;
			[self addObjectsToTail:cellItemArray forSection:0];
		}
		else {
			// 查找lastID　向上翻页：填上一次请求返回的第一条记录的local_id，
			//HotBroadcastInfo *lastItem = [infoArray objectAtIndex:0];
//			self.lastID = lastItem.localID;
			[self addObjectsToHead:cellItemArray forSection:0];
		}

	}
}

// 界面进入时数据初始化
-(BOOL)initData {
	if (![super initData]) {
		return NO;
	}	
	// 1. 初始状态
	self.loadingStatus = FirstLoadingStatus;
	[self showMBProgress];
	NSMutableArray *itemsArray = [DataManager getLatestBroadCast];
	//if (NO) {
	// 假如: 数据库中有数据
	if ([itemsArray isKindOfClass:[NSArray class]] && [itemsArray count] > 0) {
		isLoadFromDB = YES;
		// 2. 更新数组(同时更新lastID)
		[self formatDataWithArr:itemsArray];
		isLoadFromDB = NO;
		// 4. 更新状态
		[self hiddenMBProgress];
		[self dataSourceDidFinishLoadingNewData];
		// 假如已加载完毕则更新状态
		if ([itemsArray count] < HotBroadcastInfoReqNum) {
			self.hasNext = [NSNumber numberWithInt:1];
			self.loadMoreStatus = loadFinished;
		}
		else {
			self.hasNext = [NSNumber numberWithInt:0];
		}
	}
	else {	// 否则
		// 假如: 网络不正常
		if ([self checkNetWorkStatus]){
			//self.loadingStatus = FirstLoadingStatus;
//			[self showMBProgress];
			// 加载最新数据
			[self loadHotBroadcastWithPageflag:@"0" lastID:@"0" andType:@"0"];
		}
		else{
			// 网络错误提示(大的提示框)
			[self dataSourceDidFinishLoadingNewData];
			[self hiddenMBProgress];
			NSString *errorMsg = @"网络错误，请重试"; 
			[self showErrorView:errorMsg]; 
		}
	}
	return YES;
}

// 父类方法继承
// 手动刷新事件(演示用法，无实际意义)
-(BOOL)refreshBtnClicked {
	if ([super refreshBtnClicked]) {
		// your additional web request.
		[self loadHotBroadcastWithPageflag:@"0" lastID:@"0" andType:@"0"];
	}
	return YES;
}

// 下拉刷新事件
-(BOOL)pullDownCellActived {
	BOOL bResult = [super pullDownCellActived];
	if (bResult) {
		// 从网络加载
		[self loadHotBroadcastWithPageflag:@"0" lastID:@"0" andType:@"0"];
	}
	else {
		// 其他异常情况(底层已经处理)
	}
	return bResult;
}

- (void)loadDataFromDB {
	// 假如一个数据都没加载过，则加载最新30条
	NSMutableArray *itemsArray = nil;
	if ([self.lastID isEqualToString:@"0"]) {
		itemsArray = [DataManager getLatestBroadCast];
	}
	else {
		itemsArray = [DataManager getHotBroadCastLessThanLocalID:self.lastID];
	}
	isLoadFromDB = YES;
	if ([itemsArray isKindOfClass:[NSArray class]] && [itemsArray count] > 0) {
		[self formatDataWithArr:itemsArray];
	}
	isLoadFromDB = NO;
	[self dataSourceDidFinishLoadingNewData];
	// 假如已加载完毕则更新状态
	if ([itemsArray count] < HotBroadcastInfoReqNum) {
		self.hasNext = [NSNumber numberWithInt:1];
		self.loadMoreStatus = loadFinished;
	}
	else {
		self.hasNext = [NSNumber numberWithInt:0];
	}	
}

// 加载更多事件
-(BOOL)loadMoreCellActived {
	BOOL bResult = [super loadMoreCellActived];
	if (bResult) {
		if ([self checkNetWorkStatus]) {
			// 从网络加载
			[self loadHotBroadcastWithPageflag:@"1" lastID:self.lastID andType:@"0"];
		}
		else {
			// 从数据库加载
			[self performSelector:@selector(loadDataFromDB) withObject:nil afterDelay:0.2f];	
		}
	}
	return bResult;
}

#pragma mark-
#pragma mark 网络数据处理
// 获取数据
- (void)loadHotBroadcastWithPageflag:(NSString *)pageflag lastID:(NSString *)lastIDString andType:(NSString *)type {
	CLog(@"%s self.loadingStatus:%d", __FUNCTION__, self.loadingStatus);
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithCapacity:10];
	[parameters setValue:@"json" forKey:@"format"];
	NSString *num = [[NSString alloc] initWithFormat:@"%d", HotBroadcastInfoReqNum];
	[parameters setValue:num forKey:@"reqnum"];
	[num release];
	[parameters setValue:pageflag forKey:@"pageflag"];
	[parameters setValue:lastIDString forKey:@"lastid"];
	[parameters setValue:type forKey:@"type"];
	// 发送请求
	[parameters setValue:URL_LATEST_TIMELINE forKey:@"request_api"];
	[asyncApi getLatestTimelineWithParamters:parameters 
									 delegate:self 
									onSuccess:@selector(onSuccessCallBack:) 
									onFailure:@selector(onFailureCallback:)]; 
	[parameters release];
}

// 发送成功回调函数
- (void)onSuccessCallBack:(NSDictionary *)dict {
	CLog(@"%s", __FUNCTION__);
	// 首次加载需要隐藏提示框
	if (FirstLoadingStatus == self.loadingStatus) {
		[self hiddenMBProgress];
	}
	// 获取当前最新信息的id
	NSString *latestID = @"0";
	if (nil != cellInfoArray && [cellInfoArray count] > 0 ) {
		// 获取当前section对应的数组
		NSArray *arrayCurSection = [cellInfoArray objectAtIndex:0];
		if ([arrayCurSection isKindOfClass:[NSArray class]] && [arrayCurSection count] > 0) {
			MessageViewCellInfo *cellInfo = [arrayCurSection objectAtIndex:0];
			latestID = ((HotBroadcastInfo *)cellInfo.originInfo).localID;
		}
	}
	NSInteger newNumbers = 0;	// 保存最后更新数据个数
	NSDictionary *hotBroadcastData = [DataCheck checkDictionary:dict forKey:@"data" withType:[NSDictionary class]];
	if ([hotBroadcastData isKindOfClass:[NSDictionary class]]) {
		self.hasNext = [DataCheck checkDictionary:hotBroadcastData forKey:@"hasnext" withType:[NSNumber class]];
		if (![self.hasNext isKindOfClass:[NSNumber class]]) {
			self.hasNext = [NSNumber numberWithInt:0];		// 处理hasNext状态
		}
		NSArray *infoArrayResult = [DataCheck checkDictionary:hotBroadcastData forKey:@"info" withType:[NSArray class]];
		if (![infoArrayResult isKindOfClass:[NSNull class]]) {
			// 转换数据
			
			NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:HotBroadcastInfoReqNum];
			for (NSDictionary *dic in infoArrayResult) {
				// 解析成对象类型
				HotBroadcastInfo *item = [[HotBroadcastInfo alloc] init];
				[item updateWithDic:dic];
				// 添加到数据库
				DataManager *dbManager = [[DataManager alloc] init];
				[dbManager insertHotBroadCastToDatabase:item];
				[dbManager release];
				// 判断是否为新数据
				if (PullDownLoadingStatus == self.loadingStatus 
					|| FirstLoadingStatus == self.loadingStatus
					|| RefreshLoadingStatus == self.loadingStatus) {
					if ([latestID longLongValue] < [[item localID] longLongValue]) {
						newNumbers++;
						[itemArray addObject:item];
					}
				}
				else {
					[itemArray addObject:item];
				}
				[item release];
			}
			[self formatDataWithArr:itemArray];

		}
		NSDictionary *userNicks = [DataCheck checkDictionary:hotBroadcastData forKey:@"user" withType:[NSDictionary class]];
		if ([userNicks isKindOfClass:[NSDictionary class]]) {
			// 存到数据库
			[DataManager insertUserInfoToDBWithDic:userNicks];
			// 存到本地字典
			[HomePage insertNickNameToDictionaryWithDic:userNicks];
		}
	}
	else {
		self.hasNext = [NSNumber numberWithInt:0];		// 处理hasNext状态
	}
	// 保存加载状态(请注意不可变更顺序，因为在dataSourceDidFinishLoadingNewData里边有重置loadMoreStatus状态)
	BOOL bFinishedLoadingMore = (LoadMoreLoadingStatus == self.loadingStatus) && ([self.hasNext intValue] != 0);
	BOOL bPullDown = (PullDownLoadingStatus == self.loadingStatus) ? YES:NO;
	// 更新状态
	[self dataSourceDidFinishLoadingNewData];
	// 下拉刷新模式下提示最新广播个数(与当前最新id比较，求得差数)
	if (bPullDown) {
		[self performSelector:@selector(showBroadcastCount:) withObject:[NSNumber numberWithInt: newNumbers] afterDelay:1.1f];	
	}
	// 假如已加载完毕则更新状态
	if (bFinishedLoadingMore) {
		self.loadMoreStatus = loadFinished;
	}
}

// 发送失败回调函数
- (void)onFailureCallback:(NSError *)error {
	CLog(@"%s", __FUNCTION__);
	// 首次加载需要隐藏提示框
	if (FirstLoadingStatus == self.loadingStatus) {
		[self hiddenMBProgress];
	}
	[self dataSourceDidFinishLoadingNewData];
}

// 点击视频url
-(void)videoImageClicked:(NSString *)urlString {
	CLog(@"HomelineCellVideoClicked:%@", urlString);
	WebUrlViewController *webUrlViewController = [[WebUrlViewController alloc] init];
	webUrlViewController.webUrl = urlString;
	[self.navigationController pushViewController:webUrlViewController animated:YES];
	[webUrlViewController release];
}
@end

