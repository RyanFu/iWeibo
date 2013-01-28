//
//  MyAudience.m
//  iweibo
//
//  Created by LiQiang on 11-12-27.
//  Copyright 2011年 Beyondsoft. All rights reserved.
//

#import "MyAudience.h"
#import "EGORefreshTableHeaderView.h"
#import "iweiboAppDelegate.h"
#import "Reachability.h"
#import "LoadCell.h"
#import "IWeiboAsyncApi.h"
#import "DataSave.h"
#import "Canstants_Data.h"
#import "Canstants.h"
#import "ListenCell.h"
#import "MyAudience.h"
#import "MyListenTo.h"
#import "MBProgressHUD.h"
#import "NoWebView.h"
#import "PushAndRequest.h"
#import "DetailPageConst.h"
#import "HpThemeManager.h"
#import "UserInfo.h"
#define REQNUMLISTEN 10

@implementation MyAudience
@synthesize aApi,audienceArray,audienceTable,name,pushType,controllerType,audienNewTime,lastSaveArray,audNum;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (id)initWithName:(NSString *)name1 {
	self = [super init];
	if (self) {
		self.name = name1;  // 用户名初始化
	}
	return self;
}

// 初始化方法
- (id)init {
	self = [super init];
	if (self) {
		isLoading = NO;
		self.name = nil;
	}
	return self;
}

// 释放资源
- (void)dealloc
{
	NSLog(@"dealloc");
    [aApi cancelSpecifiedRequest];
	[aApi release];
	aApi = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
	[lastSaveArray release];
	lastSaveArray = nil;
	[audienceArray release];
    audienceArray = nil;
	[audienceMore release];
    audienceMore = nil;
	[refreshHeaderView release];
    refreshHeaderView = nil;
	[audienceTable release];
    audienceTable = nil;
	[audienceSave release];
    [leftButton  release];
    [super dealloc];
}

// 接收内存警告
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
// 更新提示标签上移
- (void)moveUp{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:3.];
	broadCastImage.frame = CGRectMake(0, -30, 320, 30);
	[UIView commitAnimations];
}

// 更新提示标签下移
- (void)moveDown{
    // 修改：如果听众数为0，不显示“网络错误，请重试”这个提示框
    if([self.audNum intValue] != 0){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.];
        broadCastImage.frame = CGRectMake(0, 0, 320, 30);
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(moveUp)];
        [UIView commitAnimations];
    }
}

// 返回按钮响应
- (void)backBtnAction
{
	// 获取导航控制器中我的听众的上一级控制器，如果不是更多页面，则不显示下方的tabbar，否则显示下方的tabbar
	NSArray *array = self.navigationController.viewControllers;
	NSInteger index = [array count] - 2;
	if (index >= 0) {
		UIViewController *controller = [array objectAtIndex:index];
		if ([controller isKindOfClass:[MorePage class]]) {
			[self.tabBarController performSelector:@selector(showNewTabBar) withObject:nil afterDelay:0.2f];
		}
	}
    //[self.tabBarController performSelector:@selector(showNewTabBar) withObject:nil afterDelay:0.2f];
    [self.navigationController popViewControllerAnimated:YES];
}

// 数据更新完毕
- (void)dataSourceDidFinishLoadingNewData{
	_reloading = NO;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[audienceTable setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[refreshHeaderView setState:EGOOPullRefreshNormal];
	[refreshHeaderView setCurrentDate:EGOAudiencelastTime];
}

// 返回成功
- (void)storeListenInfoToArray:(NSDictionary *)info{
	ListenIdolList *dataInfo;
	NSArray *mesArray = [audienceSave storeIntoClass:info:@"0"];
	for (int i=0; i<[mesArray count]; i++) {
		dataInfo = [mesArray objectAtIndex:i];
		//增加判断，去掉重复的听众或收听		
		if ([self.lastSaveArray count] != 0) {
			int j;
			for (j = 0; j< [lastSaveArray count]; j++) {
				NSString *text = [[lastSaveArray objectAtIndex:j] text];
				NSString *nick = [[lastSaveArray objectAtIndex:j] nick];
				if ([dataInfo.text isEqualToString:text] && [dataInfo.nick isEqualToString:nick] ) {
					break;
				}
			}
			if (j == 10) {
				[audienceArray addObject:dataInfo];
			}
		}
		else {
			[audienceArray addObject:dataInfo];
		}
	}
	self.lastSaveArray = mesArray;  //记录上次存储的
}

- (void)recordingNewTimestamp:(NSArray *) infoQueue{
	if ([infoQueue count] != 0) {
		self.audienNewTime = [NSString stringWithFormat:@"%@",[[infoQueue objectAtIndex:0] objectForKey:HOMETIME]];
		[[NSUserDefaults standardUserDefaults] setObject:self.audienNewTime forKey:@"AudienceNewTimeStamp"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void)fansListSuccess:(NSDictionary *)info{
//	NSLog(@"audience   =%@",info);
	isLoading = YES;
	_reloading = NO;
	currentPage++;
	NSDictionary *data =[DataCheck checkDictionary:info forKey:HOMEDATA withType:[NSDictionary class]];
	NSArray *listenArr = [DataCheck checkDictionary:data forKey:HOMEINFO withType:[NSArray class]];
	if (![listenArr isEqual:[NSNull null]] && listenArr) {
		hasNext = [[data objectForKey:HOMEHASNEXT]boolValue];
		switch (pushType) {
			case audienRequestFirst:
				[self storeListenInfoToArray:info];
				[self recordingNewTimestamp:listenArr];
				break;
			case audienRequestLoadMore:
				[self storeListenInfoToArray:info];
				break;
			case audienRequestPullRefresh:
				if ([audienceArray count]!=0) {
					[audienceArray removeAllObjects];
				}
				if ([self.lastSaveArray count]!=0) {
					self.lastSaveArray = [NSArray array];
				}
				[cupView setHidden:YES];
				[self storeListenInfoToArray:info];
				[self recordingNewTimestamp:listenArr];
				[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
				break;

			default:
				break;
		}
		[audienceTable reloadData];	
		audienceTable.hidden = NO;
		[self hiddenMBProgress];
		if (!hasNext) {
			[audienceMore setState:loadMore1];
		}
		else {
			[audienceMore setState:loadFinished];
		}
	}
	else {
		broadCastLabel.text = @"网络错误，请重试";
		errorCastImage.hidden = NO;
		IconCastImage.hidden = YES;
		if ([self.audienceArray count] == 0) {
			[self setNoData];
		}
        [self moveDown];
		[self doneLoadingTableViewData];
	}
}

// 完成列表数据更新并显示提示
- (void)doneLoadingTableViewData{
	[self dataSourceDidFinishLoadingNewData];
}

// 返回失败
- (void)fansListFailure:(NSError *)error{
	if ([error code] == ASIRequestTimedOutErrorType || [error code] == ASIConnectionFailureErrorType) {
		broadCastLabel.text = @"网络错误，请重试";
		errorCastImage.hidden = NO;
		IconCastImage.hidden = YES;
	}
	if ([self.audienceArray count] == 0) {
		[self setNoData];
	}
	[self moveDown];
}

// 请求网络数据
- (void)requstWebService:(NSString *)startindex{
	if (hasBack == YES) {
		hasBack = NO;
		return;
	}
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithCapacity:10];
	[parameters setValue:@"json" forKey:@"format"];
	[parameters setValue:startindex forKey:@"startindex"];
	[parameters setValue:@"10" forKey:@"reqnum"];
	if (name) {
		[parameters setValue:name forKey:@"name"];
		[parameters setValue:URL_USER_FANLIST forKey:@"request_api"];
		[aApi getUserFanListWithParamters:parameters 
								 delegate:self  
								onSuccess:@selector(fansListSuccess:) 
								onFailure:@selector(fansListFailure:)];
	}
	else {
		[parameters setValue:URL_FRIENDS_FANSLIST forKey:@"request_api"];
		[aApi getFanslistOfFriendsWithparamters:parameters
									   delegate:self
									  onSuccess:@selector(fansListSuccess:) onFailure:@selector(fansListFailure:)];
	}
	[parameters release];
}

// 返回
- (void)backAction {
	hasBack = YES;
	[aApi cancelSpecifiedRequest];
    [self.navigationController popViewControllerAnimated:YES];
}

// 添加返回按钮
- (void)addBarBtn {
	UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[backBtn setBackgroundImage:[UIImage imageNamed:PBACKBTN2] forState:UIControlStateNormal];
	[backBtn setBackgroundImage:[UIImage imageNamed:PBACKBTN1] forState:UIControlStateHighlighted];
	[backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
	backBtn.frame =  CGRectMake(0, 0, 48, 30);
	[backBtn setTitle:@"返回" forState:UIControlStateNormal];
	backBtn.titleLabel.font = [UIFont systemFontOfSize:12];
	[backBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 5)];
	
	UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
	self.navigationItem.leftBarButtonItem = backBarBtn;
	[backBarBtn release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)updateTheme:(NSNotification *)noti{
    NSDictionary  *plistDict = [[HpThemeManager sharedThemeManager]themeDictionary];
    NSString *themePathTmp = [plistDict objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    [leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
	NSLog(@"myaudience view did load");
	[super viewDidLoad]; 
	showProgress = YES;
	hasBack = NO;
    
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
	[customLab setText:@"听众"];
	[customLab setTextAlignment:UITextAlignmentCenter];
	customLab.backgroundColor = [UIColor clearColor];
	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	self.navigationItem.titleView = customLab;
	[customLab release];
	//self.navigationItem.title = @"听众";	
	self.view.backgroundColor = [UIColor whiteColor];
	//self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonSystemItemFastForward  target:self action:@selector(backBtnAction)] autorelease];
	//self.navigationItem.backBarButtonItem = item;
//	[item release];
	leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
	[leftButton setTitle:@"返回" forState:UIControlStateNormal];
	leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
	[leftButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 5)];
	[leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
	[leftButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
	self.navigationItem.leftBarButtonItem = leftBar;
	[leftBar release];	
	

	//[self addBarBtn];
	currentPage = 1;
	aApi = [[IWeiboAsyncApi alloc] init];
	audienceSave = [[DataSave alloc] init];
	audienceArray = [[NSMutableArray alloc]initWithCapacity:10];
	lastSaveArray = [[NSArray alloc] init];
	// 添加听众列表
	audienceTable  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStylePlain];
	audienceTable.delegate = self;
	audienceTable.dataSource = self;
	audienceTable.separatorColor = [UIColor colorWithRed:0.827 green:0.843 blue:0.855 alpha:1];
	[self.view addSubview:audienceTable];
	
	// 添加顶端刷新视图
	if (refreshHeaderView == nil) {
		refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - audienceTable.bounds.size.height, self.view.frame.size.width, audienceTable.bounds.size.height)];
		[refreshHeaderView setTimeState:EGOAudiencelastTime];
	}
	[audienceTable addSubview:refreshHeaderView];

	audienceMore = [[LoadCell alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
	audienceTable.tableFooterView = audienceMore;
	cupView = [[NoWebView alloc] initWithFrame:CGRectZero];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"bgLabel" ofType:@"png"];
	broadCastImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
	broadCastImage.frame = CGRectMake(0, -30, 320, 30);
	
	// 添加错误时的提示图
	NSString *pathError = [[NSBundle mainBundle] pathForResource:@"errorler" ofType:@"png"];
	errorCastImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:pathError]];
	errorCastImage.frame = CGRectMake(90, 5, 20, 20);
	errorCastImage.backgroundColor = [UIColor clearColor];
	errorCastImage.hidden = YES;
	[broadCastImage addSubview:errorCastImage];
	[errorCastImage release];
	
	// 添加蒲公英的提升图
	NSString *pathIcon = [[NSBundle mainBundle] pathForResource:@"iconPull" ofType:@"png"];
	IconCastImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:pathIcon]];
	IconCastImage.frame =  CGRectMake(100, 8, 15, 15);
	IconCastImage.backgroundColor = [UIColor clearColor];
	IconCastImage.hidden = YES;
	[broadCastImage addSubview:IconCastImage];
	[IconCastImage release];
	
	// 添加顶端更新提示标签
	broadCastLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 180, 30)];
	broadCastLabel.backgroundColor = [UIColor clearColor];
	broadCastLabel.textColor = [UIColor colorWithRed:166/255.0 green:137/255.0 blue:67/255.0 alpha:1.];
	broadCastLabel.font = [UIFont systemFontOfSize:15];
	[broadCastImage addSubview:broadCastLabel];
	[broadCastLabel release];
	[self.view addSubview:broadCastImage];
	[broadCastImage release];

	pushType = audienRequestFirst;
	[self requstWebService:@"0"];
	audienceTable.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification object:nil];
}

// 当没有数据返回时调用该方法
- (void)setNoData{
        [self hiddenMBProgress];
        [self setErrorState];
	audienceTable.hidden = NO;
	audienceTable.tableFooterView = nil;
	audienceTable.separatorColor = [UIColor clearColor];
	[cupView setState:audienceType];
	[refreshHeaderView setHidden:YES];
	[self.view addSubview:cupView];
	[self.view bringSubviewToFront:cupView];
}

// 视图呈现之前调用该方法
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[[UIApplication sharedApplication]delegate];
	delegate.window.backgroundColor = [UIColor whiteColor];
	if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable) 
		&& ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
		[self setNoData];
		[self moveDown];
	}
////    if (showProgress && [self.audienceArray count] != 0) {
////        NSLog(@"userInfo is %@",[UserInfo sharedUserInfo].fansnum);
////        [self showMBProgress];
//    }
	if ([self.audNum intValue] != 0&&showProgress) {
		[self showMBProgress];
	}	
}

// 网络错误时调用该方法
- (void)doneLoadingTableViewDataWithNetError{
	broadCastLabel.text = @"网络错误，请重试";   
	errorCastImage.hidden = NO;
	IconCastImage.hidden = YES;
	[self moveDown];
	[self dataSourceDidFinishLoadingNewData];
}

// 请求新数据
- (void)reloadNewDataSource{
	if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable) 
		&& ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
		//[self performSelector:@selector(doneLoadingTableViewDataWithNetError) withObject:nil afterDelay:2.0];
		[self performSelector:@selector(doneLoadingTableViewDataWithNetError)];
	}
	else {
		pushType = audienRequestPullRefresh;
		currentPage = 1;
		[self requstWebService:@"0"];
	}
}

// 设置错误提示
- (void)setErrorState{
	broadCastLabel.text = @"加载失败，请重试";   
	errorCastImage.hidden = NO;
	IconCastImage.hidden = YES;
}

- (void)handleTimer{
	isLoading = NO;
	[audienceMore setState:loading1];
	pushType = audienRequestLoadMore;
//	CLog(@"%s", __FUNCTION__);
	[self requstWebService:[NSString stringWithFormat:@"%d",(currentPage-1)*REQNUMLISTEN]];
}

// 滚动tableview时调用该方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (scrollView.isDragging) {
		if (!_reloading) {
			if (scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f ) {
				[refreshHeaderView setState:EGOOPullRefreshNormal];
				[refreshHeaderView setCurrentDate:EGOAudiencelastTime withDateUpdated:NO];
			}
			else {
				[refreshHeaderView setState:EGOOPullRefreshPulling];
				NSTimeInterval now=[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
				[refreshHeaderView setLasttimeState:EGOAudiencelastTime :now];
			}
		}
	
		if ([scrollView isKindOfClass:[UITableView class]]) {
			UITableView *tableView = (UITableView *)scrollView;
			NSArray *indexPathes = [tableView indexPathsForVisibleRows];
			if (indexPathes.count > 0) {
				int rowCounts = [tableView numberOfRowsInSection:0];
				NSIndexPath *lastIndexPath = [indexPathes objectAtIndex:indexPathes.count-1];
				//		CLog(@"rowCount:%d,lastcount:%d",rowCounts,lastIndexPath.row);
				if (rowCounts - lastIndexPath.row <2 && isLoading) {
					isLoading = NO;
					if (!hasNext) {
						[audienceMore setState:loadMore1];
						tableView.tableFooterView = audienceMore;
						[self performSelector:@selector(handleTimer) withObject:nil afterDelay:3];	
//						[tableView scrollToRowAtIndexPath:lastIndexPath
//										 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
					}
					else {
						[audienceMore setState:loadFinished];
					}
				}
			}
		}
	}
}

- (void)loadImagesForOnscreenRows
{
	NSArray *visiblePaths = [audienceTable indexPathsForVisibleRows];
	for (NSIndexPath *indexPath in visiblePaths) {
		ListenCell *cell = (ListenCell *)[audienceTable cellForRowAtIndexPath:indexPath];
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
}
// 滑动结束后调用该方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	//NSLog(@"stop");
	if (scrollView.contentOffset.y <= - 65.0f && !_reloading) {
		_reloading = YES;
		[self reloadNewDataSource];
		[refreshHeaderView setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		audienceTable.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
	if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}


#pragma mark -
#pragma mark UITableViewDataSource Method
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [audienceArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSUInteger row = indexPath.row;
	//NSString *cellIdentifier = [NSString stringWithFormat:@"%d",row];
	static NSString *cellIdentifier = @"audienceIdentifier";
	ListenCell *cell = (ListenCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[[ListenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} 	
		// 修改当cell被选中的时候的背景颜色
	UIView *aView = [[UIView alloc] initWithFrame:cell.contentView.frame];
	aView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:0.933];
	cell.selectedBackgroundView = aView; 
	[aView release];
	
	//这里往cell里添加数据
	cell.listenIdolList = [audienceArray objectAtIndex:row];
    if (tableView.dragging == NO && tableView.decelerating == NO)
    {
        [cell startIconDownload];
    }
	return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.row < [audienceArray count]) {
		return 59;
	}
	return 460;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	//NSLog(@"点击了%d行",indexPath.row);
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	ListenIdolList *nameList =[self.audienceArray objectAtIndex:indexPath.row];
	NSString *pname = nameList.name;
	//CLog(@"nameList");
	//NSLog(@"pname=======%@",pname);
	showProgress = NO;
	[[PushAndRequest shareInstance] pushControllerType:self.controllerType withName:pname];
}

- (void)showMBProgress{
	//CLog(@"xiansihi loading....");
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
	[audienceTable setHidden:NO];
	[MBprogress hide:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewDidDisappear:YES];
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

- (CGFloat)getMaxWidth:(CGSize)nameSize andLocationSize:(CGSize)locationSize{
	CGFloat nameWidth = nameSize.width;
	CGFloat locationWidth = locationSize.width;
	return nameWidth > locationWidth?nameWidth:locationWidth;
}

@end
