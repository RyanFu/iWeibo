//
//  MyBroadcast.m
//  iweibo
//
//  Created by LiQiang on 11-12-27.
//  Copyright 2011年 Beyondsoft. All rights reserved.
//

#import "MyBroadcast.h"
#import "Reachability.h"
#import "EGORefreshTableHeaderView.h"
#import "iweiboAppDelegate.h"
#import "WebUrlViewController.h"
#import "MessageViewUtility.h"
#import "HomelineCell.h"
#import "HpThemeManager.h"
#import "DetailPageConst.h"
#import "DetailsPage.h"
#import "Canstants.h"

@implementation MyBroadcast

//@synthesize api;
@synthesize broadcastTable,saveBroadcast;
@synthesize infoArray,broadTimer;
@synthesize broadImage,errorImage,iconImage,broadLabel;
@synthesize oldTime,lastid,nNewTime,sinceTime,pushType,api,reachEnd;
@synthesize textHeightDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		reachEnd = NO;
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    [leftButton release];
	[api release];
	api = nil;
    [MBprogress release];
	[textHeightDic release];
	textHeightDic = nil;
    [broadcastTable release];
    broadcastTable = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)backBtnAction{
    [self.tabBarController performSelector:@selector(showNewTabBar) withObject:nil afterDelay:0.2f];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark viewDidLoad

- (void)updateTheme:(NSNotification *)noti{
    NSDictionary  *plistDict = [[HpThemeManager sharedThemeManager]themeDictionary];
    NSString *themePathTmp = [plistDict objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    [leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
	[super viewDidLoad];
    
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
	
	UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
	[customLab setTextColor:[UIColor whiteColor]];
	[customLab setText:@"我的广播"];
	[customLab setTextAlignment:UITextAlignmentCenter];
	customLab.backgroundColor = [UIColor clearColor];
	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	self.navigationItem.titleView = customLab;
	[customLab release];
	//self.navigationItem.title = @"我的广播";
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
	delegate.window.backgroundColor = [UIColor whiteColor];
	_reloading = NO;
	isLoading = YES;
	textHeightDic = [[NSMutableDictionary alloc] initWithCapacity:30];
	
	//UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
	//self.navigationItem.backBarButtonItem = item;
	//[item release];	
	
	leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
	[leftButton setTitle:@"返回" forState:UIControlStateNormal];
	leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
	[leftButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 5)];
    [leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
	[leftButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
	self.navigationItem.leftBarButtonItem = leftBar;
	[leftBar release];		
	
	_reloading = NO;
	UITableView *_broadcastTable  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStylePlain];
	_broadcastTable.delegate = self;
	_broadcastTable.dataSource = self;
	self.broadcastTable = _broadcastTable;
	self.broadcastTable.separatorColor = [UIColor colorWithRed:0.827 green:0.843 blue:0.855 alpha:1];
	[self.view addSubview:self.broadcastTable];

	if (_refreshHeaderView == nil) {
		_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - broadcastTable.bounds.size.height, self.view.frame.size.width, broadcastTable.bounds.size.height)];
		[_refreshHeaderView setTimeState:EGOBroadCastlastTime];
	}
	[broadcastTable addSubview:_refreshHeaderView];

	if (broadLoadmore == nil) {
		broadLoadmore = [[LoadMoreCell alloc]init];
	}
	NSString *path = [[NSBundle mainBundle] pathForResource:@"bgLabel" ofType:@"png"];
	broadImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
	broadImage.frame = CGRectMake(0, -30, 320, 30);
	
	NSString *pathError = [[NSBundle mainBundle] pathForResource:@"errorler" ofType:@"png"];
	errorImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:pathError]];
	errorImage.frame = CGRectMake(90, 5, 20, 20);
	errorImage.backgroundColor = [UIColor clearColor];
	errorImage.hidden = YES;
	[broadImage addSubview:errorImage];
	[errorImage release];
	
	NSString *pathIcon = [[NSBundle mainBundle] pathForResource:@"iconPull" ofType:@"png"];
	iconImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:pathIcon]];
	iconImage.frame = CGRectMake(100, 8, 15, 15);
	iconImage.backgroundColor = [UIColor clearColor];
	iconImage.hidden = YES;
	[broadImage addSubview:iconImage];
	[iconImage release];
	
	broadLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 180, 30)];
	broadLabel.textColor = [UIColor colorWithRed:166/255.0 green:137/255.0 blue:67/255.0 alpha:1.];
	broadLabel.backgroundColor = [UIColor clearColor];
	broadLabel.font = [UIFont systemFontOfSize:15];
	[broadImage addSubview:broadLabel];
	[broadLabel release];
	[self.view addSubview:broadImage];
	[broadImage release];
	
	// 加载更多
	loadCell = [[LoadCell alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
	broadcastTable.tableFooterView = loadCell;
	cupView = [[NoWebView alloc] init];
	self.infoArray = [NSMutableArray arrayWithCapacity:100];
	
	[broadcastTable setHidden:YES];
    [self showMBProgress];
    
	api = [[IWeiboAsyncApi alloc] init];
}

- (void) showMBProgress{
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
    [broadcastTable setHidden:NO];
    [MBprogress hide:YES];
}

- (void)moveUp{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:3.];
	broadImage.frame = CGRectMake(0, -30, 320, 30);
	[UIView commitAnimations];
}

- (void)moveDown{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.];
	broadImage.frame = CGRectMake(0, 0, 320, 30);
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(moveUp)];
	[UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:YES];
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
	delegate.window.backgroundColor = [UIColor whiteColor];
	if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable) 
		&& ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
		broadLabel.text = @"加载失败，请重试";   
		errorImage.hidden = NO;
		iconImage.hidden = YES;
		[self moveDown];
		[self hiddenMBProgress];
		broadcastTable.tableFooterView = nil;
		broadcastTable.separatorColor = [UIColor clearColor];
		[cupView setState:broadCastType];
		[_refreshHeaderView setHidden:YES];
		if ([infoArray count] == 0) {
			[self.view addSubview:cupView];
		}
		[self.view bringSubviewToFront:cupView];
	}
	else {
		self.pushType = @"2";
		[self requstWebService:@"0":@"0":@"0x0":@"0"];
	}
}

#pragma mark -
#pragma mark requestWeiService

-(void) requstWebService:(NSString *)pageflag:(NSString *)pagetime:(NSString *)type:(NSString *)contenttype{
	
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithCapacity:10];
	[parameters setValue:@"json" forKey:@"format"];
	[parameters setValue:pageflag forKey:@"pageflag"];
	[parameters setValue:@"30" forKey:@"reqnum"];
	[parameters setValue:pagetime forKey:@"pagetime"];
	[parameters setValue:type forKey:@"type"];
	[parameters setValue:self.lastid forKey:@"lastid"];
	[parameters setValue:contenttype forKey:@"contenttype"];
	[parameters setValue:URL_BROADCAST_TIMELINE forKey:@"request_api"];
	
	
	[api getBroadcastFromIweiboWithParamters:parameters delegate:self onSuccess:@selector(requestSuccessCallBack:) onFailure:@selector(requestFailureCallBack:)]; 
	[parameters release];
}

- (void)loadMoreStatuses{  //加载获取更多
	if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable) 
		&& ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
		broadLabel.text = @"加载失败，请重试";   
		errorImage.hidden = NO;
		iconImage.hidden = YES;
		[self moveDown];
		[self hiddenMBProgress];
		[loadCell setState:errorInfo];
		broadcastTable.tableFooterView = loadCell;
	}
	else {
		self.pushType = @"1";
		[self requstWebService:@"1":self.oldTime:@"0x0":@"0"];
	}
}

- (void)reloadNewDataSource{
	if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable) 
		&& ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
		broadLabel.text = @"加载失败，请重试";   
		errorImage.hidden = NO;
		iconImage.hidden = YES;
		[self moveDown];
	}
	else {
		self.pushType = @"0";
		[self requstWebService:@"0":nNewTime:@"0x0":@"0"];
	}	
}

#pragma mark -
#pragma mark scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	if (scrollView.isDragging) {
		if (!_reloading) {
			if (scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f ) {
				[_refreshHeaderView setState:EGOOPullRefreshNormal];
				[_refreshHeaderView setCurrentDate:EGOBroadCastlastTime withDateUpdated:NO];
			}
			else {
				[_refreshHeaderView setState:EGOOPullRefreshPulling];
				NSTimeInterval now=[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
				[_refreshHeaderView setLasttimeState:EGOBroadCastlastTime :now];
			}
		}
	}
	if ([scrollView isKindOfClass:[UITableView class]]) {
		UITableView *tableView = (UITableView *)scrollView;
		NSArray *indexPathes = [tableView indexPathsForVisibleRows];
		if (indexPathes.count > 0) {
			int rowCounts = [tableView numberOfRowsInSection:0];
			NSIndexPath *lastIndexPath = [indexPathes objectAtIndex:indexPathes.count-1];
			if (rowCounts - lastIndexPath.row < 2 && isLoading) {
				isLoading = NO;
				if (!isHasNext) {
					[loadCell setState:loadMore1];
					[self performSelector:@selector(handleTimer:) withObject:nil afterDelay:2];	
					NSArray *indexPathes = [tableView indexPathsForVisibleRows];
					NSIndexPath *lastIndexPath = [indexPathes objectAtIndex:indexPathes.count-1];
				//	[tableView reloadData];
					[tableView scrollToRowAtIndexPath:lastIndexPath
									 atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
				}
				else {
					[loadCell setState:loadFinished];
				}
			}
		}
	}
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
//	NSArray *indexPathes = [broadcastTable indexPathsForVisibleRows];
//	if (indexPathes.count > 0) {
//		int rowCounts = [broadcastTable numberOfRowsInSection:0];
//		NSIndexPath *lastIndexPath = [indexPathes objectAtIndex:indexPathes.count-1];
//		if (_reloading && rowCounts - lastIndexPath.row < 2) {
//			// 拉去完毕
//			if (reachEnd) {
//			}
//			else {
//			//	[loadCell setState:loadMore1];
//				[self performSelector:@selector(handleTimer:) withObject:nil afterDelay:3];
//			}
//
//		}
//	}
	
	if (scrollView.contentOffset.y <= - 65.0f && !_reloading) {
		_reloading = YES;
		[self reloadNewDataSource];
		[_refreshHeaderView setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		broadcastTable.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
}

- (void)handleTimer:(NSTimer *)timer{
	_reloading = NO;
	[loadCell setState:loading1];
	[self loadMoreStatuses];
}


- (void)viewDidUnload
{
	[api release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UITableViewDataSource Method
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if ([self.infoArray count] > 0) {
		return [infoArray count];
	}else {
		return 0;
	}
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

	NSUInteger row = indexPath.row;

	UITableViewCell *tableViewCell = nil;
		
	if (row < [infoArray count]) {
		//NSString *cellIdentifier = [NSString stringWithFormat:@"%d",row];
			// = (HomelineCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		static NSString *cellIdentifier = @"broadcastCellIdentifier";
		HomelineCell *cell = (HomelineCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		if (cell == nil) {
			cell = [[[HomelineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier showStyle:HomeShowSytle sourceStyle:HomeSourceSytle containHead:NO] autorelease];
			cell.myHomelineCellVideoDelegate = self;
			cell.rootContrlType = 4;
			cell.contentView.backgroundColor = [UIColor clearColor];
		} 
		Info *info = [infoArray objectAtIndex:row];
		
		cell.heightDic = self.textHeightDic;
		cell.remRow = [NSString stringWithFormat:@"%d", row];
		cell.homeInfo = info;
		[cell setLabelInfo:[infoArray objectAtIndex:row]];

		CLog(@"%s, info.source:%@", __FUNCTION__, info.source);
		if (![[[infoArray objectAtIndex:row] source] isMemberOfClass:[NSNull class]]){
			if (info.source != nil) {
				CLog(@"%s, info.source != NULL", __FUNCTION__);
				TransInfo *transInfo = [self convertSourceToTransInfo:info.source];
				cell.sourceInfo = transInfo;
			}else {
				[cell remove];
			}
		}
		tableViewCell = cell;
	}
	else {
		NSString *cellIdentifier = @"cellIdentifier";
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		}
		tableViewCell = cell;
	}

	return tableViewCell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.row < [self.infoArray count]) {
		return [self getRowHeight:indexPath.row];
	}else {
		return broadcastTable.bounds.size.height;
	}
}

#pragma mark - 
#pragma mark UITableViewDelegate Method
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSUInteger row = indexPath.row;
		// 设置发送状态代理
	// 2012-02-21 放到iweiboAppDelegate里边处理
	//[[DraftController sharedInstance] setMyDraftControllerDelegate:self];
	[self.tabBarController performSelector:@selector(hideNewTabBar)];//隐藏tabbar
	if (indexPath.row < [infoArray count]) {
		Info *info = [infoArray objectAtIndex:row];
		DetailsPage   *details = [[DetailsPage alloc] init];
		details.rootContrlType = 4;
		details.homeInfo = info;
		if (![info.source isMemberOfClass:[NSNull class]]){
			if (info.source != nil) {
				TransInfo *transInfo = [self convertSourceToTransInfo:info.source];
				details.sourceInfo = transInfo;
			}
		}
		[self.navigationController pushViewController:details animated:YES];
		[details release];
	}
	else {
		[self loadMoreStatuses];
		NSArray *indexPathes = [tableView indexPathsForVisibleRows];
		NSIndexPath *lastIndexPath = [indexPathes objectAtIndex:indexPathes.count-1];
		[tableView reloadData];
		[tableView scrollToRowAtIndexPath:lastIndexPath
						 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
}

- (NSArray *)storeInfoToClass:(NSDictionary *)result{
	n = 0;
	NSMutableArray *syncInfoQueue = [NSMutableArray arrayWithCapacity:30];
	NSDictionary *data =[DataCheck checkDictionary:result forKey:HOMEDATA withType:[NSDictionary class]];
	NSArray *info = [DataCheck checkDictionary:data forKey:HOMEINFO withType:[NSArray class]];
	if (![info isKindOfClass:[NSNull class]]) {
		for (NSDictionary *sts in info) {	
			if (sts && [sts isKindOfClass:[NSDictionary class]]  ) {
				Info *weiboInfo = [[Info alloc] init];
				weiboInfo.uid = [sts objectForKey:HOMEID];
				weiboInfo.name = [sts objectForKey:HOMENAME];
				weiboInfo.nick = [sts objectForKey:HOMENICK];
				weiboInfo.isvip = [NSString stringWithFormat:@"%@",[sts objectForKey:HOMEISVIP]];
				weiboInfo.origtext = [sts objectForKey:HOMEORITEXT];
				weiboInfo.from = [sts objectForKey:HOMEFROM];
				weiboInfo.timeStamp = [NSString stringWithFormat:@"%@",[sts objectForKey:HOMETIME]];
				weiboInfo.emotionType = [sts objectForKey:HOMEEMOTION];
				weiboInfo.type = [NSString stringWithFormat:@"%@",[sts objectForKey:HOMETYPE]];
				weiboInfo.count = [NSString stringWithFormat:@"%@",[sts objectForKey:HOMECOUNT]];
				weiboInfo.mscount = [NSString stringWithFormat:@"%@",[sts objectForKey:HOMEMCOUNT]];
				weiboInfo.head = [sts objectForKey:HOMEHEAD];
				weiboInfo.localAuth = [NSString stringWithFormat:@"%@",[sts objectForKey:HOTISAUTH]];
				weiboInfo.userLatitude = [[sts objectForKey:LATITUDE] doubleValue];
				weiboInfo.userLongitude = [[sts objectForKey:LONGITUDE] doubleValue];
				
				if (![[sts objectForKey:HOMEIMAGE]isEqual:[NSNull null]]) {
					NSArray *imagelist = [[NSArray alloc]initWithArray:[sts objectForKey:HOMEIMAGE]];
					if ([imagelist count]!=0) {
						NSString *image = [imagelist objectAtIndex:0];
						weiboInfo.image = image;
					}
					[imagelist release];
				}
				
				if (![[sts objectForKey:HOMEVIDEO] isEqual:[NSNull null]]) {
					NSDictionary *video = [[NSDictionary alloc]initWithDictionary:[sts objectForKey:HOMEVIDEO]];
					weiboInfo.video = video;
					[video release];
				}
				
				if (![[sts objectForKey:HOMEMUSIC] isEqual:[NSNull null]]) {
					NSDictionary *musci = [[NSDictionary alloc] initWithDictionary:[sts objectForKey:HOMEMUSIC]];
					weiboInfo.music = musci;	
					[musci release];
				}
				
				if (![[sts objectForKey:HOMESOURCE] isEqual:[NSNull null]]){
					NSDictionary *source = [[NSDictionary alloc] initWithDictionary:[sts objectForKey:HOMESOURCE]];
					weiboInfo.source =[NSDictionary dictionaryWithDictionary:[sts objectForKey:HOMESOURCE]];
					[source release];
				}
				
				[syncInfoQueue addObject:weiboInfo];
				
				if ([weiboInfo.timeStamp compare: nNewTime]== NSOrderedDescending) {
					n++;
				}
				[weiboInfo release];	
			}	
			else {
				CLog(@"++++++++++%s, data error result:%@", __FUNCTION__, result);
			}
		}
	}
	else {
		CLog(@"++++++++++%s, data error result:%@", __FUNCTION__, result);
	}
	return syncInfoQueue;
}

#pragma mark -
#pragma mark requestCallBack

-(void)requestSuccessCallBack:(NSDictionary *)result{
//	CLog(@"%@",result);
	NSArray *infoQu = nil;
	Info *dataInfo ;
	isLoading = YES;
	if ([result count] != 0) {
		infoQu =[self storeInfoToClass:result];
	}
	
	NSDictionary *data =[DataCheck checkDictionary:result forKey:@"data" withType:[NSDictionary class]];
	NSNumber *hasNext = [DataCheck checkDictionary:data forKey:@"hasnext" withType:[NSNumber class]];
	if ([hasNext isKindOfClass:[NSNumber class]]) {
		isHasNext = [hasNext boolValue];
	}
	else {
		isHasNext = 0;
	}
	
	if ([pushType isEqualToString:@"2"]) {//首次请求网络
		[textHeightDic removeAllObjects];
		for (int i=0; i<[infoQu count]; i++) {
			dataInfo = [infoQu objectAtIndex:i];
			[infoArray addObject:dataInfo];
		}
		
		if (infoQu && [infoQu count] > 0) {
            self.sinceTime = [NSString stringWithFormat:@"%@",[[infoQu objectAtIndex:0] timeStamp]];
            self.nNewTime = self.sinceTime;
            self.oldTime = [NSString stringWithFormat:@"%@",[[infoQu objectAtIndex:[infoQu count]-1]timeStamp]];
            self.lastid = [[infoQu objectAtIndex:[infoQu count]-1] uid];
        }
		[[NSUserDefaults standardUserDefaults] setObject:nNewTime forKey:@"NewTime"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	if ([pushType isEqualToString:@"1"]) {//加载更多
		for (int i=0; i<[infoQu count]; i++) {
			dataInfo = [infoQu objectAtIndex:i];
			[infoArray addObject:dataInfo];
		}
		if (infoQu && [infoQu count] > 0) {
            self.oldTime = [NSString stringWithFormat:@"%@",[[infoQu objectAtIndex:[infoQu count]-1] timeStamp]];
            self.lastid = [[infoQu objectAtIndex:[infoQu count]-1] uid];
            self.sinceTime = [NSString stringWithFormat:@"%@",[[infoQu objectAtIndex:0] timeStamp]];
        }
	}
	
	if ([pushType isEqualToString:@"0"]) {//下拉刷新
		[textHeightDic removeAllObjects];
		for (int i=n-1; i>=0; i--) {
			dataInfo = [infoQu objectAtIndex:i];
			[infoArray insertObject:dataInfo atIndex:0];
		}
        
		if (infoQu && [infoQu count] > 0) {
            self.nNewTime = [NSString stringWithFormat:@"%@",[[infoQu objectAtIndex:0] timeStamp]];
            self.lastid = [[infoQu objectAtIndex:[infoQu count]-1] uid];
        }
		[[NSUserDefaults standardUserDefaults] setObject:nNewTime forKey:@"NewTime"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
	}
	
    [self hiddenMBProgress];
	
	[self.broadcastTable reloadData];
	
	// By Yiminwen
	// workarround: 服务器返回数据有问题，当前做一个
	//reachEnd = ([infoQu count] == 30) ? NO:YES;
//	if (reachEnd) {
//		[loadCell setState:loadFinished];
//		[loadCell.spinner stopAnimating];
//	}
	
	if (!isHasNext) {
		[loadCell setState:loadMore1];
	}
	else {
		[loadCell setState:loadFinished];
	}
	
		// 存储用户昵称
	NSDictionary *userNicks = [DataCheck checkDictionary:data forKey:@"user" withType:[NSDictionary class]];
	if ([userNicks isKindOfClass:[NSDictionary class]]) {
			// 存到数据库
		[DataManager insertUserInfoToDBWithDic:userNicks];
			// 存到本地字典
		[HomePage insertNickNameToDictionaryWithDic:userNicks];
	}
}

- (void)requestFailureCallBack:(NSError *)error{
	if ([error code] == ASIRequestTimedOutErrorType || [error code] == ASIConnectionFailureErrorType) {
		broadLabel.text = @"加载失败，请重试";
		errorImage.hidden = NO;
		iconImage.hidden = YES;
	}
	[self moveDown];
}

#pragma mark -
#pragma mark pullrefresh

- (void)doneLoadingTableViewData{
	if (n>0) {
		broadLabel.text = [NSString stringWithFormat:@"%d条新广播",n];
		errorImage.hidden = YES;
		iconImage.hidden = NO;
	}
	else{
		broadLabel.text = @"没有新广播";
		errorImage.hidden = YES;
		iconImage.hidden = NO;
	}
	[self moveDown];
	[self dataSourceDidFinishLoadingNewData];
}

- (void)dataSourceDidFinishLoadingNewData{
	
	_reloading = NO;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[broadcastTable setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[_refreshHeaderView setState:EGOOPullRefreshNormal];
//	[_refreshHeaderView setCurrentDate:EGOBroadCastlastTime];  
}

- (CGFloat)getRowHeight:(NSUInteger)row{

	NSString *rowString = [[NSString alloc] initWithFormat:@"%d", row];
	if ([textHeightDic objectForKey:rowString]) {
		NSMutableDictionary *dic = [textHeightDic objectForKey:rowString];
		CGFloat origHeight = [[dic objectForKey:@"origHeight"] floatValue];
		CGFloat sourceHeight = [[dic objectForKey:@"sourceHeight"] floatValue];
		[rowString release];
		CGFloat retValue = 0.0f;
		if (sourceHeight > 1) {
			retValue += sourceHeight + VSBetweenSourceFrameAndFrom;
		}
		CGFloat fromHeight = [@"来自..." sizeWithFont:[UIFont systemFontOfSize:12]].height + VSpaceBetweenOriginFrameAndFrom;
		retValue += origHeight + fromHeight;
		return retValue;
	}
	else {
		Info *info = [infoArray objectAtIndex:row];
		CGFloat origHeight = 0.0f;
		CGFloat sourceHeight = 0.0f;
		CGFloat retValue = 0.0f;
		origHeight = [MessageViewUtility getBroadcastOriginViewHeight:info];
		if (info.source != nil) {
				TransInfo *transInfo = [self convertSourceToTransInfo:info.source];
				sourceHeight = [MessageViewUtility getBroadcastSource:transInfo];
				retValue += sourceHeight + VSBetweenSourceFrameAndFrom;
		}
		// 来自...高度
		CGFloat fromHeight = [@"来自..." sizeWithFont:[UIFont systemFontOfSize:12]].height + VSpaceBetweenOriginFrameAndFrom;
		retValue += origHeight + fromHeight;
		
		NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
		NSString *origHeightStr = [[NSString alloc] initWithFormat:@"%f", origHeight];
		NSString *sourceHeightStr = [[NSString alloc] initWithFormat:@"%f", sourceHeight];
		[dic setObject:origHeightStr forKey:@"origHeight"];
		[dic setObject:sourceHeightStr forKey:@"sourceHeight"];
		[textHeightDic setObject:dic forKey:rowString];
		[origHeightStr release];
		[sourceHeightStr release];
		[dic release];
		[rowString release];
		return retValue;
	}
	
}

- (TransInfo *)convertSourceToTransInfo:(NSDictionary *)tSource{
	TransInfo *transInfo = [[[TransInfo alloc] init] autorelease];
	if ([tSource valueForKey:HOMENAME] != nil) {
		transInfo.transName = [tSource valueForKey:HOMENAME];
	}
	if ([tSource valueForKey:HOMENICK] != nil) {
		transInfo.transNick = [tSource valueForKey:HOMENICK];
	}
	if ([tSource valueForKey:HOMEISVIP] != nil) {
		transInfo.transIsvip = [tSource valueForKey:HOMEISVIP];
	}
	if ([tSource valueForKey:HOMEORITEXT] != nil) {
		transInfo.transOrigtext = [tSource valueForKey:HOMEORITEXT];
		//CLog(@"%s,transInfo.transNick:%@, text: %@", __FUNCTION__, transInfo.transNick, transInfo.transOrigtext);
	}
	if ([tSource valueForKey:HOMEID] != nil) {
		transInfo.transId = [tSource valueForKey:HOMEID];
	}
	if ([tSource valueForKey:HOMEIMAGE] != nil&&![[tSource valueForKey:HOMEIMAGE] isEqual:[NSNull null]]) {
		transInfo.transImage = [[tSource valueForKey:HOMEIMAGE] objectAtIndex:0];
	}
	if ([tSource valueForKey:HOMEVIDEO] != nil&&![[tSource valueForKey:HOMEVIDEO] isEqual:[NSNull null]]) {
		if ([[tSource valueForKey:HOMEVIDEO] valueForKey:VIDEOPICURL] != nil) {
			transInfo.transVideo = [[tSource valueForKey:HOMEVIDEO] valueForKey:VIDEOPICURL];
		}
		transInfo.transVideoRealUrl = [[tSource valueForKey:HOMEVIDEO] valueForKey:VIDEOREALURL];
	}
	if ([tSource valueForKey:HOMEFROM] != nil&&![[tSource valueForKey:HOMEFROM] isEqual:[NSNull null]]) {
		transInfo.transFrom = [tSource valueForKey:HOMEFROM];
	}
	if ([tSource valueForKey:HOMETIME] != nil&&![[tSource valueForKey:HOMETIME] isEqual:[NSNull null]]){
		transInfo.transTime = (NSString *)[tSource valueForKey:HOMETIME];
	}
	if ([tSource valueForKey:HOMECOUNT] != nil) {
		transInfo.transCount = (NSString *)[tSource valueForKey:HOMECOUNT];
	}
	if ([tSource valueForKey:HOMEMCOUNT] != nil) {
		transInfo.transCommitcount = (NSString *)[tSource valueForKey:HOMEMCOUNT];
	}
	if ([tSource valueForKey:HOTISAUTH] != nil) {
		transInfo.translocalAuth = [NSString stringWithFormat:@"%@",[tSource objectForKey:HOTISAUTH]];
	}
	return transInfo;
}

#pragma mark -
#pragma mark protocol OriginViewUrlDelegate<NSObject> 图片点击委托事件
- (void)OriginViewUrlClicked:(NSString *)urlSource {
	CLog(@"OriginViewUrlClicked:%@", urlSource);
	WebUrlViewController *webUrlViewController = [[WebUrlViewController alloc] init];
	webUrlViewController.webUrl = urlSource;
	[self.navigationController pushViewController:webUrlViewController animated:YES];
	[webUrlViewController release];
}

#pragma mark protocol OriginViewVideoDelegate<NSObject> 视频点击事件
- (void)OriginViewVideoClicked:(NSString *)urlVideo {
	CLog(@"OriginViewVideoClicked:%@", urlVideo);
	WebUrlViewController *webUrlViewController = [[WebUrlViewController alloc] init];
	webUrlViewController.webUrl = urlVideo;
	[self.navigationController pushViewController:webUrlViewController animated:YES];
	[webUrlViewController release];
}

#pragma mark protocol SourceViewUrlDelegate<NSObject> 图片点击委托事件
- (void)SourceViewUrlClicked:(NSString *)urlSource {
	CLog(@"SourceViewUrlClicked:%@", urlSource);
	WebUrlViewController *webUrlViewController = [[WebUrlViewController alloc] init];
	webUrlViewController.webUrl = urlSource;
	[self.navigationController pushViewController:webUrlViewController animated:YES];
	[webUrlViewController release];
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
