//
//  UITableViewControllerEx.m
//  iweibo
//
//  Created by Minwen Yi on 2/24/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "UITableViewControllerEx.h"
#import "TableCellBuilder.h"
#import "Reachability.h"

@implementation UITableViewControllerEx
@synthesize tableCellType, loadingStatus, requestNumEachTime;
@synthesize isDragging, showLoadMore, showPullDown, loadMoreStatus;
@synthesize refreshHeaderView, loadMoreCell;
@synthesize cellInfoArray;
@synthesize broadCastLabel,succeedStringFormat, noResultString, broadCastImage, errorCastImage, iconCastImage;
@synthesize errorView, MBprogress;
@synthesize showLabel;
@synthesize egoLastTime;

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


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	// 设置分割线颜色
	self.tableView.separatorColor = [self sepColor];
	self.showLabel = YES;						// 2012-03-19 zhaolilong 当退出该界面时隐藏label
	// 下拉刷新
	if (refreshHeaderView == nil) {
		refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.tableView.frame.size.width, self.tableView.bounds.size.height)];
		//[refreshHeaderView setTimeState:EGOHomelinelastTime];
	}
	[self.tableView addSubview:refreshHeaderView];
	refreshHeaderView.hidden = !showPullDown;
	// 表头(目前没有)
	//LoadCell *headerCell = [[LoadCell alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
//	self.tableView.tableHeaderView = headerCell;
//	self.tableView.tableHeaderView.hidden = NO; 
	// 加载更多
	loadMoreCell = [[LoadCell alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
	self.tableView.tableFooterView = loadMoreCell;
	self.tableView.tableFooterView.hidden = !showLoadMore;
 	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"bgLabel" ofType:@"png"];
	broadCastImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
	broadCastImage.frame = CGRectMake(0, 64 - 30, 320, 30);	//20+44
	
	NSString *pathError = [[NSBundle mainBundle] pathForResource:@"errorler" ofType:@"png"];
	errorCastImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:pathError]];
	errorCastImage.frame = CGRectMake(90, 5, 20, 20);
	errorCastImage.backgroundColor = [UIColor clearColor];
	errorCastImage.hidden = YES;
	[broadCastImage addSubview:errorCastImage];
	[errorCastImage release];
	
	NSString *pathIcon = [[NSBundle mainBundle] pathForResource:@"iconPull" ofType:@"png"];
	iconCastImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:pathIcon]];
	iconCastImage.frame = CGRectMake(100, 8, 15, 15);
	iconCastImage.backgroundColor = [UIColor clearColor];
	iconCastImage.hidden = YES;
	[broadCastImage addSubview:iconCastImage];
	[iconCastImage release];
	
	broadCastLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 180, 30)];
	broadCastLabel.backgroundColor = [UIColor clearColor];
	broadCastLabel.textColor = [UIColor colorWithRed:166/255.0 green:137/255.0 blue:67/255.0 alpha:1.];
	broadCastLabel.font = [UIFont systemFontOfSize:15];
	[broadCastImage addSubview:broadCastLabel];
	[broadCastLabel release];
	succeedStringFormat = @"%d条新广播";
	noResultString = @"没有新广播";
	//[self.view addSubview:broadCastImage];
	[self.navigationController.view addSubview:broadCastImage];
	broadCastImage.hidden = YES;
	[broadCastImage release];
	
	// 成员初始化
	cellInfoArray = [[NSMutableArray alloc] initWithCapacity:1];
	self.loadMoreStatus = loadMore1;
	loadingStatus = InvalidLoadingStatus;
	isDragging = NO;	// 拖动时更新状态
	egoLastTime = EGOHotBroadCastLastTime;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


 - (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	 broadCastImage.hidden = NO;
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

 - (void)viewWillDisappear:(BOOL)animated {
	 broadCastImage.hidden = YES;
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	NSInteger num = 1;
    if (nil != cellInfoArray && [cellInfoArray isKindOfClass:[NSArray class]]) {
		num = [cellInfoArray count];
	}
	if (num == 0) {
		self.tableView.tableFooterView.hidden = YES;
	}
	else {
		self.tableView.tableFooterView.hidden = !showLoadMore;
	}
	return num;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSInteger num = 0;
    if (nil != cellInfoArray ) {
		if ([cellInfoArray count] > section) {
			// 获取当前section对应的数组
			NSArray *arrayCurSection = [cellInfoArray objectAtIndex:section];
			if ([arrayCurSection isKindOfClass:[NSArray class]] ) {
				num = [arrayCurSection count];
			}
		}
	}
	return num;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
	//NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d|%d", [indexPath section], [indexPath row]];
//	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [TableCellBuilder getCellwithStyle:UITableViewCellStyleDefault 
								  reuseIdentifier:CellIdentifier 
										  section:indexPath.section
										  AndType:tableCellType];
		UIView *aView = [[UIView alloc] initWithFrame:cell.contentView.frame];
		aView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:0.933];
		cell.selectedBackgroundView = aView; 
		[aView release];

	}
    
    // Configure the cell...
	if (nil != cellInfoArray && [cellInfoArray count] > indexPath.section ) {
		// 获取当前section对应的数组
		NSArray *arrayCurSection = [cellInfoArray objectAtIndex:indexPath.section];
		if ([arrayCurSection isKindOfClass:[NSArray class]] && [arrayCurSection count] > indexPath.row) {
			[self configCell:(UITableViewCellEx *)cell withInfo:[arrayCurSection objectAtIndex:indexPath.row] andSection:indexPath.section];
			if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
            {
                [(UITableViewCellEx *)cell startIconDownload];
            }
		}
	}
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	//TimeTrack* timeTrack = [[TimeTrack alloc] initWithName:[NSString stringWithFormat:@"tableView:heightForRowAtIndexPath: row:%d", indexPath.row]];
	CGFloat height = 0.0f;
	if (nil != cellInfoArray && [cellInfoArray count] > indexPath.section ) {
		// 获取当前section对应的数组
		NSArray *arrayCurSection = [cellInfoArray objectAtIndex:indexPath.section];
		if ([arrayCurSection isKindOfClass:[NSArray class]] && [arrayCurSection count] > indexPath.row) {
			MessageViewCellInfo *baseCell = (MessageViewCellInfo *)[arrayCurSection objectAtIndex:indexPath.row];
			height = [baseCell calcCellHeight];
		}
		else {
			assert(NO);
		}

	}
	else {
		assert(NO);
	}

	return height;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


//#pragma mark -
//#pragma mark Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//    [self.navigationController pushViewController:detailViewController animated:YES];
//    [detailViewController release];
//    */
//}


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
	[cellInfoArray release];
	[refreshHeaderView release];
	refreshHeaderView = nil;
	[loadMoreCell release];
	loadMoreCell = nil;
	self.noResultString = nil;
	self.succeedStringFormat = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark 成员set方法
- (void)setLoadMoreStatus:(LoadMoreStatus)loadStatus {
	loadMoreStatus = loadStatus;
	[loadMoreCell setState:loadMoreStatus];
}

- (void)setShowPullDown:(BOOL)bShow {
	showPullDown = bShow;
	refreshHeaderView.hidden = !showPullDown;
}

- (void)setShowLoadMore:(BOOL)bShow {
	showLoadMore = bShow;
	self.tableView.tableFooterView.hidden = !showLoadMore;
}

// 设置数据
-(void)updateWithObjects:(NSArray *)infoArr forSection:(NSInteger)sect {
	if ([infoArr isKindOfClass:[NSArray class]]) {
		[self.cellInfoArray insertObject:infoArr atIndex:sect];
		[self.tableView reloadData];
	}
}

// 插入数据到头部
-(void)addObjectsToHead:(NSArray *)infoArr forSection:(NSInteger)sect {
	if ([infoArr isKindOfClass:[NSArray class]]) {
		if ([cellInfoArray count] > sect) {
			NSMutableArray *arrayCurSection = [cellInfoArray objectAtIndex:sect];
			if (![arrayCurSection isKindOfClass:[NSMutableArray class]]) {
				arrayCurSection = [NSMutableArray arrayWithArray:infoArr];
				[self.cellInfoArray insertObject:arrayCurSection atIndex:sect];
			}
			else {
				// 假如数据等于最大条，则需要清除前边的数据
//				if ([infoArr count] >= requestNumEachTime) {
//					[arrayCurSection removeAllObjects];
//					[self.cellInfoArray insertObject:arrayCurSection atIndex:sect];
//				}
//				else {
					// 插在前边
					for (int i = [infoArr count] - 1; i >= 0; i--) {
						// 插入数据库(未完成)
						// 添加到数组
						[arrayCurSection insertObject:[infoArr objectAtIndex:i] atIndex:0];
					}
				//}

			}
		}
		else {
			[self.cellInfoArray insertObject:infoArr atIndex:sect];
		}
		
		[self.tableView reloadData];
	}
}

// 插入数据到尾部
-(void)addObjectsToTail:(NSArray *)infoArr forSection:(NSInteger)sect {
	if ([infoArr isKindOfClass:[NSArray class]]) {
		if ([cellInfoArray count] > sect) {
			NSMutableArray *arrayCurSection = [cellInfoArray objectAtIndex:sect];
			if (![arrayCurSection isKindOfClass:[NSMutableArray class]]) {
				arrayCurSection = [NSMutableArray arrayWithArray:infoArr];
				[self.cellInfoArray insertObject:arrayCurSection atIndex:sect];
			}
			else {
				[arrayCurSection addObjectsFromArray:infoArr];
			}
		}
		else {
			[self.cellInfoArray insertObject:infoArr atIndex:sect];
		}

		[self.tableView reloadData];
	}
}

#pragma mark -
#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	if (showPullDown && scrollView.isDragging) {
		// 处理下拉刷新状态更新
		
		//CLog(@"%s, scrollView.contentOffset.y:%f", __FUNCTION__, scrollView.contentOffset.y);
		// 非刷新模式下状态更新
		if (!loadingStatus) {
			// 假如_refreshHeaderView偏移度处于-65.0f到0之间，则状态为"下拉刷新"，并更新上次到现在的时间间隔
			if (scrollView.contentOffset.y <= 0.0f) {
				if (scrollView.contentOffset.y <= 5.0f) {
					// 加到navigationcotroller上边，就不用隐藏了
					//[self hidebroadcastImage];
				}
				if (scrollView.contentOffset.y > -65.0f ) {
					if (!isDragging) {
						isDragging = YES;
						[refreshHeaderView setState:EGOOPullRefreshNormal];
						// 计算距离上一次更新的时间间隔并更新界面
						[refreshHeaderView setCurrentDate:egoLastTime withDateUpdated:NO];
					}
				}
				else {
					[refreshHeaderView setState:EGOOPullRefreshPulling];
				}
			}
		}
	}	
}

- (void)loadImagesForOnscreenRows
{
	NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
	for (NSIndexPath *indexPath in visiblePaths) {
		UITableViewCellEx *cell = (UITableViewCellEx *)[self.tableView cellForRowAtIndexPath:indexPath];
		if (cell) {
			[cell startIconDownload];
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	isDragging = NO;
	if (showPullDown && scrollView.contentOffset.y <= - 65.0f && !loadingStatus) {
		// 1 变换状态
		// 1.1 加载状态
		loadingStatus = PullDownLoadingStatus;		
		// 1.2 最后一次更新时间状态
		NSTimeInterval now=[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
		[refreshHeaderView setLasttimeState:egoLastTime :now];
		// 2 设置tableview位置
		[refreshHeaderView setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		// 3 测试加载数据
		[self pullDownCellActived];
	}
	
	// 处理加载更多状态更新
	if (showLoadMore && !loadingStatus && [scrollView isKindOfClass:[UITableView class]]) {
		UITableView *tableView = (UITableView *)scrollView;
		NSArray *indexPathes = [tableView indexPathsForVisibleRows];
		if (indexPathes.count > 0) {
			int rowCounts = 0;
			for (NSInteger i = 0; i < tableView.numberOfSections; i++) {
				rowCounts += [tableView numberOfRowsInSection:i];
			}
			NSIndexPath *lastIndexPath = [indexPathes objectAtIndex:indexPathes.count-1];
			// 最后一行
			if (rowCounts == lastIndexPath.row + 1) {
				if ( loadMore1 == self.loadMoreStatus) {
					// 数据加载状态
					loadingStatus = LoadMoreLoadingStatus;
					// 视图状态
					self.loadMoreStatus = loading1;
					self.tableView.tableFooterView.hidden = NO;  //added by wangying 解决首次进入会显示表尾的问题
					[self performSelector:@selector(loadMoreCellActived) withObject:nil afterDelay:2];	
					//NSArray *indexPathes = [tableView indexPathsForVisibleRows];
					//					NSIndexPath *lastIndexPath = [indexPathes objectAtIndex:indexPathes.count-1];
					//					[tableView reloadData];
					//					[tableView scrollToRowAtIndexPath:lastIndexPath
					//									 atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
				}
				else if (loadFinished == self.loadMoreStatus) {
					self.loadMoreStatus = loadFinished;	// 可有可无的操作，强制更新状态
				}
				//else {
//					self.loadMoreStatus = loadMore1;
//				}
				
				
			}
		}
	}
	
	if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

#pragma mark -

- (void)resetRefreshHeaderStatus {
	[refreshHeaderView setState:EGOOPullRefreshNormal];
	self.loadMoreStatus = loadMore1;
}

-(void)dataSourceDidFinishLoadingNewData{
	loadingStatus = InvalidLoadingStatus;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:1.0];
	//self.tableView.contentOffset = CGPointMake(0, 0);
	[self.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	// 加载完成后，变换状态
	[UIView setAnimationDidStopSelector:@selector(resetRefreshHeaderStatus)];
	[UIView commitAnimations];
}

// 分割线颜色
-(UIColor *)sepColor {
	return [UIColor colorWithRed:0.827 green:0.843 blue:0.855 alpha:1];
}
// 检测网路状态

-(BOOL)checkNetWorkStatus {
	BOOL bResult = YES;
	if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable) 
		&& ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
		bResult = NO; 
	}
	return bResult;
}
/*
+(BOOL)checkShowMapNetWorkStatus {
	BOOL bResult = YES;
	if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable) 
		&& ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
		bResult = NO; 
	}
	return bResult;
}
*/

// 界面进入时数据初始化
-(BOOL)initData {
	return YES;
}

#pragma mark -
#pragma mark  状态变换
- (void)hidebroadcastImage {
	broadCastImage.hidden = YES;
}

- (void)moveUp{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2.0];
	//broadCastImage.frame = CGRectMake(0, -31, 320, 30);
	broadCastImage.frame = CGRectMake(0, 64-30, 320, 30);
	//[UIView setAnimationDidStopSelector:@selector(hidebroadcastImage)];
	[UIView commitAnimations];
	[self performSelector:@selector(hidebroadcastImage) withObject:nil afterDelay:2.0f];
	//broadCastImage.hidden = YES;
}

- (void)moveDown{
	if (self.showLabel) {					// 2012-03-19 zhaolilong 当退出该界面时隐藏label
		broadCastImage.hidden = NO;
	}
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.1];
    broadCastImage.frame = CGRectMake(0, 64, 320, 30);
	[UIView setAnimationDelegate:self];
	//[UIView setAnimationDidStopSelector:@selector(moveUp)];
	[UIView commitAnimations];
	[self performSelector:@selector(moveUp) withObject:nil afterDelay:1.2f];	
	
}
- (void)showBroadcastCount:(NSNumber *)num {
	NSInteger numInt = [num intValue];
	if (numInt>0) {
		broadCastLabel.text = [NSString stringWithFormat:succeedStringFormat, numInt];
		errorCastImage.hidden = YES;
		iconCastImage.hidden = NO;
	}
	else{
		broadCastLabel.text = noResultString;
		errorCastImage.hidden = YES;
		iconCastImage.hidden = NO;
	}
	if (self.showLabel) {				// 2012-03-19 zhaolilong 当退出该界面时隐藏label
		broadCastImage.hidden = NO;
	}
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.1];
    broadCastImage.frame = CGRectMake(0, 64, 320, 30);
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];
	[self performSelector:@selector(moveUp) withObject:nil afterDelay:1.2f];
}

- (void)showMBProgress{
	//	CLog(@"xiansihi loading....");
   // if (MBprogress == nil) {
	// 从后台隐藏后就被删除掉了，不用做非空判断
    MBprogress = [[MBProgressHUD alloc] initWithFrame:CGRectMake(30, 80, 260, 200)]; 
   // }
    [self.view addSubview:MBprogress];  
    [self.view bringSubviewToFront:MBprogress];  
    MBprogress.labelText = @"载入中...";  
    MBprogress.removeFromSuperViewOnHide = YES;
    [MBprogress show:YES];  
}

- (void) hiddenMBProgress{
	//	CLog(@"yincang loading....");
    [self.tableView setHidden:NO];
    [MBprogress hide:YES];
}

- (void)hiddenAlertView{
	[errorView hide:YES];
}
// 显示网络错误信息
- (void)showErrorView:(NSString *)errorMsg{
    UIImageView *errorBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]];
   // if (errorView != nil) {
//        [errorView release];
//    }
    errorView = [[MBProgressHUD alloc] initWithFrame:CGRectMake(80, 148, 160, 125)]; 
    [self.view addSubview:errorView];  
    [self.view bringSubviewToFront:errorView];  
    errorView.labelText = errorMsg;  
    errorView.labelFont = [UIFont systemFontOfSize:12];
    errorView.removeFromSuperViewOnHide = YES;
    errorView.customView = errorBg;
    errorView.mode = MBProgressHUDModeCustomView;
    [errorView show:YES];  
    [errorBg release];
    [self performSelector:@selector(hiddenAlertView) withObject:nil afterDelay:2];
}
#pragma mark -

- (void)doneLoadingTableViewDataWithNetError{
	broadCastLabel.text = @"网络错误，请重试";   
	if (self.showLabel) {
		errorCastImage.hidden = NO;		// 2012-03-19 zhaolilong 当退出该界面时隐藏label
	}
	iconCastImage.hidden = YES;
	[self moveDown];
}

// 手动刷新事件
-(BOOL)refreshBtnClicked {
	BOOL bResult = NO;
	if (!loadingStatus 
		//&& homePageTable.contentOffset.y >=0.0f 
		) {
        loadingStatus = RefreshLoadingStatus;
		// 视图状态
        [refreshHeaderView setState:EGOOPullRefreshLoading];
		// 最后一次更新时间状态
		NSTimeInterval now=[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
		[refreshHeaderView setLasttimeState:egoLastTime :now];
		// 下移tableview
		if (showPullDown) {
			self.tableView.contentOffset = CGPointMake(0, -60);
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:2.0];
			//	homePageTable.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
			self.tableView.contentOffset = CGPointMake(0, 0);
			// 加载完成后，变换状态
			[UIView setAnimationDidStopSelector:@selector(resetRefreshHeaderStatus)];
			[UIView commitAnimations];
		}
        if (![self checkNetWorkStatus]) {
			// 弹出网络异常
			CLog(@"%s, networkStatus error", __FUNCTION__);
			// 置换状态
			[self performSelector:@selector(dataSourceDidFinishLoadingNewData) withObject:nil afterDelay:2];	
			[self performSelector:@selector(doneLoadingTableViewDataWithNetError) withObject:nil afterDelay:3.1];
		}
		else {
			bResult = YES;
		}
	}
	return bResult;
}

// 下拉刷新事件
-(BOOL)pullDownCellActived {
	// 测试程序
	//[self performSelector:@selector(dataSourceDidFinishLoadingNewData) withObject:nil afterDelay:2];	
	BOOL bResult = NO;
	// 检测网络状态,假如网络不同则显示网络错误
	if (![self checkNetWorkStatus]) {
		// 弹出网络异常
		CLog(@"%s, networkStatus error", __FUNCTION__);
		[self performSelector:@selector(dataSourceDidFinishLoadingNewData) withObject:nil afterDelay:2];	
		[self performSelector:@selector(doneLoadingTableViewDataWithNetError) withObject:nil afterDelay:3.1];
	}
	else {
		bResult = YES;
	}
	return bResult;
}

// 加载更多事件
-(BOOL)loadMoreCellActived {
	// 测试程序
	//[self performSelector:@selector(dataSourceDidFinishLoadingNewData) withObject:nil afterDelay:2];	
	return YES;
}

// 更新cell数据
-(void)configCell:(UITableViewCellEx *)tableCell withInfo:(id)infoId andSection:(NSInteger)sect {
	// Configure the cell...
	tableCell.cellInfo = infoId;
	tableCell.controllerID = self;
	[tableCell configCell];
}

@end

