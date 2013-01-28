//
//  MyListenTo.m
//  iweibo
//
//  Created by LiQiang on 11-12-27.
//  Copyright 2011年 Beyondsoft. All rights reserved.
//

#import "MyListenTo.h"
#import "IWeiboAsyncApi.h"
#import "Canstants_Data.h"
#import "EGORefreshTableHeaderView.h"
#import "iweiboAppDelegate.h"
#import "Reachability.h"
#import "LoadCell.h"
#import "ListenIdolList.h"
#import "ListenCell.h"
#import "Canstants.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "DataSave.h"
#import "NoWebView.h"
#import "Info.h"
#import "HpThemeManager.h"
#import "PushAndRequest.h"

#define REQNUMLISTEN 10

@implementation MyListenTo
@synthesize aApi,listenDataSave,name,listenNewTime,lastSaveArray;
@synthesize listenTable,listenArray,pushType,controllerType,lisNum;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithName:(NSString *)name1 {
	self = [super init];
	if (self) {
		self.name = name1;// 初始化赋值
	}
	return self;
}

// 初始化方法
- (id)init {
	self = [super init];
	if (self) {
		self.name = nil;
	}
	return self;
}

- (void)dealloc
{
//	NSLog(@"before dealloc aApi");
    [aApi cancelSpecifiedRequest];
	[aApi release];
    aApi = nil;
//	NSLog(@"after dealloc aApi");
	//aApi = nil;
	[lastSaveArray release];
	lastSaveArray = nil;
//    [leftButton release];
	[listenDataSave release];
	[listenTable release];
	[listenArray release];
	[refreshHeaderView release];
	[listenMore release];
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
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.];
	broadCastImage.frame = CGRectMake(0, 0, 320, 30);
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(moveUp)];
	[UIView commitAnimations];
}

// 返回响应
- (void)backBtnAction
{
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

// 返回上一级控制器
- (void)backAction {
//	NSLog(@"before backAction");
	hasBack = YES;
	[aApi cancelSpecifiedRequest];
//	NSLog(@"after backAction");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark requestWebService
// 请求网络数据
-(void) requstWebService:(NSString *)startindex {
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
		[parameters setValue:URL_USER_IDOLLIST forKey:@"request_api"];
		NSLog(@"before server request");
		[aApi getUserIdolListWithParamters:parameters 
								delegate:self 
							    onSuccess:@selector(idolListSuccess:) 
							      onFailure:@selector(idolListFailure:)];
		NSLog(@"after server request");
	}
	else {
		[parameters setValue:URL_IDOLLIST forKey:@"request_api"];
		[aApi getMyIdolListWithParamters:parameters
							     delegate:self
							  onSuccess:@selector(idolListSuccess:) onFailure:@selector(idolListFailure:)];
	}
	[parameters release];
}
 
// 将返回数据封装进数组
- (void)recordingNewTimestamp:(NSArray *) infoQueue{
	if ([infoQueue count] != 0) {
		self.listenNewTime = [NSString stringWithFormat:@"%@",[[infoQueue objectAtIndex:0] objectForKey:HOMETIME]];
		[[NSUserDefaults standardUserDefaults] setObject:self.listenNewTime forKey:@"ListenNewTimeStamp"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void)storeListenInfoToArray:(NSDictionary *)info{
	ListenIdolList *dataInfo;
	NSArray *mesArray = [listenDataSave storeIntoClass:info:@"0"];
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
				[listenArray addObject:dataInfo];
			}
		}
		else {
			[listenArray addObject:dataInfo];
		}
	}
	self.lastSaveArray = mesArray;  //记录上次存储的
}

- (void)idolListSuccess:(NSDictionary *)info{
//	NSLog(@"dic   =%@",info);
	isLoading = YES;
	_reloading = NO;
	currentPage++;
	NSDictionary *data =[DataCheck checkDictionary:info forKey:HOMEDATA withType:[NSDictionary class]];
	NSArray *listenArr = [DataCheck checkDictionary:data forKey:HOMEINFO withType:[NSArray class]];

	if (![listenArr isEqual:[NSNull null]] && listenArr) {
		hasNext = [[data objectForKey:HOMEHASNEXT]boolValue];
		switch (pushType) {
			case listenRequestFirst:
				[self storeListenInfoToArray:info];
				[self recordingNewTimestamp:listenArr];
				break;
			case listenRequestLoadMore:
				[self storeListenInfoToArray:info];
				break;
			case listenRequestPullRefresh:
				if ([listenArray count] != 0) {
					[listenArray removeAllObjects];
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
		[listenTable reloadData];
		listenTable.hidden = NO;
		[self hiddenMBProgress];
		if (!hasNext) {
			[listenMore setState:loadMore1];
		}
		else {
			[listenMore setState:loadFinished];
		}
	}
	else {
		broadCastLabel.text = @"网络错误，请重试";
		errorCastImage.hidden = NO;
		IconCastImage.hidden = YES;
		if ([self.listenArray count] == 0) {
			[self setNoData];
		}
		[self moveDown];
		[self doneLoadingTableViewData];
	}
}

// 返回出错
- (void)idolListFailure:(NSError *)error{
	if ([error code] == ASIRequestTimedOutErrorType || [error code] == ASIConnectionFailureErrorType) {
		broadCastLabel.text = @"网络错误，请重试";
		errorCastImage.hidden = NO;
		IconCastImage.hidden = YES;
	}
	if ([self.listenArray count] == 0) {
		[self setNoData];
	}
	[self moveDown];
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

#pragma mark -
#pragma mark viewDidLoad

- (void)updateTheme:(NSNotification *)noti{
    NSDictionary  *plistDict = [[HpThemeManager sharedThemeManager]themeDictionary];
    NSString *themePathTmp = [plistDict objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    [leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
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
	[customLab setText:@"收听"];
	[customLab setTextAlignment:UITextAlignmentCenter];
	customLab.backgroundColor = [UIColor clearColor];
	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	self.navigationItem.titleView = customLab;
	[customLab release];
	//self.navigationItem.title = @"收听";
	self.view.backgroundColor = [UIColor whiteColor];
	//UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
	//self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonSystemItemFastForward  target:self action:@selector(backBtnAction)] autorelease];
	//self.navigationItem.backBarButtonItem = item;
//	[item release];
//	[self addBarBtn];
	
	leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
	leftButton.frame = CGRectMake(0, 0, 50, 30);
	[leftButton setTitle:@"返回" forState:UIControlStateNormal];
	leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
	[leftButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 5)];
    [leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
	[leftButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
	self.navigationItem.leftBarButtonItem = leftBar;
	[leftBar release];	
	
	aApi = [[IWeiboAsyncApi alloc] init];
	listenDataSave = [[DataSave alloc] init];
	listenArray = [[NSMutableArray alloc]initWithCapacity:10];
	lastSaveArray = [[NSArray alloc] init];
	
	if (listenTable == nil) {
		listenTable  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStylePlain];
		listenTable.delegate = self;
		listenTable.dataSource = self;
	}
	listenTable.separatorColor = [UIColor colorWithRed:0.827 green:0.843 blue:0.855 alpha:1];
	[self.view addSubview:listenTable];
	
	currentPage = 1;

	if (refreshHeaderView == nil) {
		refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - listenTable.bounds.size.height, self.view.frame.size.width, listenTable.bounds.size.height)];
		[refreshHeaderView setTimeState:EGOListenlastTime];
	}
	[listenTable addSubview:refreshHeaderView];

	listenMore = [[LoadCell alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
	listenTable.tableFooterView = listenMore;
	
	cupView = [[NoWebView alloc] initWithFrame:CGRectZero];
	
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
	IconCastImage.frame =  CGRectMake(100, 8, 15, 15);
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
	[broadCastImage release];
	
	pushType = listenRequestFirst;
	[self requstWebService:@"0"];
	listenTable.hidden = YES;
}

// 无数据进行的操作
- (void)setNoData{
	[self hiddenMBProgress];
	[self setErrorState];
	listenTable.hidden = NO;
	listenTable.tableFooterView = nil;
	listenTable.separatorColor = [UIColor clearColor];
	[cupView setState:listenType];
	//[refreshHeaderView setHidden:YES];
	[self.listenTable addSubview:cupView];
	[self.listenTable bringSubviewToFront:cupView];
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[[UIApplication sharedApplication] delegate];
	delegate.window.backgroundColor = [UIColor whiteColor];
	if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable) 
		&& ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
		[self setNoData];
		[self moveDown];
	}
    if (showProgress) {
        [self showMBProgress];
    }
//	if ([self.lisNum intValue] != 0&&showProgress) {
//		[self showMBProgress];
//	}	
}

// 设置错误状态
- (void)setErrorState{
	broadCastLabel.text = @"加载失败，请重试";   
	errorCastImage.hidden = NO;
	IconCastImage.hidden = YES;
}

// 显示加载提示
- (void)showMBProgress{
//	CLog(@"xiansihi loading....");
    if (MBprogress == nil) {
        MBprogress = [[MBProgressHUD alloc] initWithFrame:CGRectMake(30, 80, 260, 200)]; 
    }
    [self.view addSubview:MBprogress];  
    [self.view bringSubviewToFront:MBprogress];  
    MBprogress.labelText = @"载入中...";  
    MBprogress.removeFromSuperViewOnHide = YES;
    [MBprogress show:YES];  
}

// 隐藏加载提示
- (void) hiddenMBProgress{
    [listenTable setHidden:NO];
    [MBprogress hide:YES];
}

// 数据加载完成提示
- (void)dataSourceDidFinishLoadingNewData{
	_reloading = NO;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[listenTable setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[refreshHeaderView setState:EGOOPullRefreshNormal];
	[refreshHeaderView setTimeState:EGOListenlastTime];
//	[refreshHeaderView setCurrentDate:EGOListenlastTime];
}

- (void)handleTimer{
	[listenMore setState:loading1];
	pushType = listenRequestLoadMore;
	CLog(@"handleTimer-------");
	[self requstWebService:[NSString stringWithFormat:@"%d",(currentPage-1)*REQNUMLISTEN]];

}

// 滑动tableview时执行的操作
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (scrollView.isDragging) {
		if (!_reloading) {
			if (scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f ) {
				[refreshHeaderView setState:EGOOPullRefreshNormal];
				[refreshHeaderView setCurrentDate:EGOListenlastTime withDateUpdated:NO];
			}
			else {
				[refreshHeaderView setState:EGOOPullRefreshPulling];
				NSTimeInterval now=[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
				[refreshHeaderView setLasttimeState:EGOListenlastTime :now];
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
						[listenMore setState:loadMore1];	
						[self performSelector:@selector(handleTimer) withObject:nil afterDelay:2];	
//						
//						[tableView scrollToRowAtIndexPath:lastIndexPath
//										 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
					}
					
					else {
						[listenMore setState:loadFinished];
					}
				}
			}
		}
	}
}

- (void)loadImagesForOnscreenRows
{
	NSArray *visiblePaths = [listenTable indexPathsForVisibleRows];
	for (NSIndexPath *indexPath in visiblePaths) {
		ListenCell *cell = (ListenCell *)[listenTable cellForRowAtIndexPath:indexPath];
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
// 滑动结束时显示提示信息
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (scrollView.contentOffset.y <= - 65.0f && !_reloading) {
		_reloading = YES;
		[self reloadNewDataSource];
		[refreshHeaderView setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		listenTable.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
	if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)doneLoadingTableViewData{
//  暂时不做这个效果
/*	if (listenDataSave.nL>0) {
		if(listenDataSave.nL >0 && listenDataSave.nL <=30) {
			broadCastLabel.text = [NSString stringWithFormat:@"%d条新广播",listenDataSave.nL];
		}
		errorCastImage.hidden = YES;
		IconCastImage.hidden = NO;
	}
	else{
		broadCastLabel.text = @"没有新广播";
		errorCastImage.hidden = YES;
		IconCastImage.hidden = NO;
	}*/
//	[self moveDown];
	[self dataSourceDidFinishLoadingNewData ];
}

// 网络错误提示
- (void)doneLoadingTableViewDataWithNetError{
	broadCastLabel.text = @"网络错误，请重试";   
	errorCastImage.hidden = NO;
	IconCastImage.hidden = YES;
	[self moveDown];
	[self dataSourceDidFinishLoadingNewData];
}

// 重新加载新数据
- (void)reloadNewDataSource{
	if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable) 
		&& ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
		[self performSelector:@selector(doneLoadingTableViewDataWithNetError) withObject:nil afterDelay:2.0];
	}
	else {
		pushType = listenRequestPullRefresh;
		currentPage = 1;
		[self requstWebService:@"0"];
	}
}


#pragma mark -
#pragma mark UITableViewDataSource Method
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
		return [listenArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSUInteger row = indexPath.row;												// 取得cell行					
	NSString *cellIdentifier = @"listenIdentifier";
	ListenCell *cell = (ListenCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];	
	if (cell == nil) {
		cell = [[[ListenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
		// 添加在cell被选中的时候的背景颜色
	UIView *aView = [[UIView alloc] initWithFrame:cell.contentView.frame];
	aView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:0.933];
	cell.selectedBackgroundView = aView; 
	[aView release];
	
	//这里往cell里添加数据
	cell.listenIdolList = [listenArray objectAtIndex:row];
    if (tableView.dragging == NO && tableView.decelerating == NO)
    {
        [cell startIconDownload];
    }
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	//NSLog(@"点击了%d行",indexPath.row);
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	ListenIdolList *nameList =[self.listenArray objectAtIndex:indexPath.row];
	NSString *pname = nameList.name;
	//CLog(@"nameList");
	NSLog(@"pname=======%@",pname);
	showProgress = NO;
	[[PushAndRequest shareInstance] pushControllerType:self.controllerType withName:pname];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.row < [listenArray count]){
		return 59;
	}
	else {
		return 460;
	}

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

@end
