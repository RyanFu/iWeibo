    //
//  NetSearchController.m
//  TableDemo
//
//  Created by lichentao on 12-1-11.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NetSearchController.h"
#import "ComposeBaseViewController.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "CustomNavigationbar.h"
#import "HpThemeManager.h"
#import "SCAppUtils.h"

@implementation NetSearchController
@synthesize netTableList;
@synthesize netArray;
@synthesize moreString;
@synthesize infoMoreArray;
@synthesize totalNum;
@synthesize myNetsearchControllerDelegate;
@synthesize parentID;
static BOOL	LOADING;// 加载更多，避免多次滑动带来的加载
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (void)updateTheme:(NSNotification *)noti{
    NSDictionary  *plistDict = [[HpThemeManager sharedThemeManager]themeDictionary];
    NSString *themePathTmp = [plistDict objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    [leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
	[customLab setTextColor:[UIColor whiteColor]];
	[customLab setText:@"搜索结果"];
	[customLab setTextAlignment:UITextAlignmentCenter];
	customLab.backgroundColor = [UIColor clearColor];
	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	self.navigationItem.titleView = customLab;
	[customLab release];
	//self.title = @"搜索结果";
    
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
    [SCAppUtils navigationController:self.navigationController setImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"navigationbar_bg.png"]]];
	leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
	leftButton.frame = CGRectMake(0, 0, 50, 30);
	[leftButton setTitle:@"返回" forState:UIControlStateNormal];
	leftButton.titleLabel.font = [UIFont systemFontOfSize:12];
     [leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
	[leftButton addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
	self.navigationItem.leftBarButtonItem = leftBar;
    [leftBar release];
	moreCell = [[LoadCell alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
	// 如果第一次搜索的数据小于每次搜索的数目,更改加载跟多的状态为加载完毕
	if ([totalNum intValue] < 20) {
		[moreCell setState:loadFinished];
	}
	LOADING = YES;
	count = 1;		// 请求服务器次数，初始值为1
	proHD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(self.view.center.x - 110, self.view.center.y - 100, 200, 180)];
    UIImageView *iView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:LOGINERROR]];
	proHD.customView =  iView;
    [iView release];
	proHD.mode = MBProgressHUDModeCustomView;
	proHD.labelText = @"网络错误,请重试";
	// 按关键字没有搜索到数据
	if ([netArray count] == 0) {
		UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 370)];
		[scrollView setAlwaysBounceVertical:YES];
		[scrollView setContentSize:CGSizeMake(320, 370)];
		self.view = scrollView;
		scrollView.backgroundColor = [UIColor whiteColor];
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(89, 50, 150, 180)];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90, 240, 320, 60)];
		label.text = @"没有找到相关的结果";
		label.font = [UIFont systemFontOfSize:16];
		label.textColor = [UIColor colorWithRed:0.3 green:0.6 blue:0.7 alpha:1];
		imageView.image = [UIImage imageNamed:@"cup.png"];
		[self.view addSubview:imageView];
		[self.view addSubview:label];
		[label release];
		[imageView release];
		[scrollView release];
		// 检测网络连接状态
		BOOL conncetStatus = [self connectionStatus];
		if (!conncetStatus){
		 	[self.navigationController.view addSubview:proHD];
			[self performSelector:@selector(showHUD) withObject:nil afterDelay:0.5];
			[self performSelector:@selector(hideHUD) withObject:nil afterDelay:1];
		}
		
	}else {
		// 数据表
		netTableList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
		netTableList.delegate = self;
		netTableList.dataSource = self;
		netTableList.rowHeight = 55;
		netTableList.tableFooterView = moreCell;
		[self.view addSubview:netTableList];
	}
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification object:nil];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/
// 返回按钮处理
- (void)popViewController:(id)sender{
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollViewSender{
	// 滑动停止后判断tableView.y偏移量是否到最后后，查看网络状态，是则加载更多，否则提示网络错误消息55是cell高度420TableView高度
	if (self.netTableList.contentOffset.y + 420 > [netArray count] * 55){
		[moreCell setState:loading1];
		[moreCell.spinner startAnimating];
		BOOL conncetStatus = [self connectionStatus];
		if (conncetStatus){
			if (LOADING) {
				if ((count * 20) < [totalNum intValue]) {
					LOADING = NO;
					[self loadMoreCell];
				}else {
					[self performSelector:@selector(loadFinished:) withObject:nil afterDelay:0.5];
				}
			}
		}else {
			[self.navigationController.view addSubview:proHD];
			[self performSelector:@selector(showHUD) withObject:nil afterDelay:0.5];
			[self performSelector:@selector(hideHUD) withObject:nil afterDelay:1];
		}
	}
}

// 加载更多向服务器发送关键字和页码
- (void)loadMoreCell{
	NSNumber *pageIndex = [[NSNumber alloc] initWithInt:++count];
	[[DraftController sharedInstance] setMyDraftCtllerSearchUserDelegate:self];
	[[DraftController sharedInstance] searchUserWithKeyword:moreString AndPageIndex:pageIndex];
	[pageIndex release];
}

// 判断连接网络状态WiFi和3G
- (BOOL)connectionStatus{
	if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable) 
		&& ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
		return NO;
	}else {
		return YES;
	}
}

// 加载完毕,更改状态
- (void)loadFinished:(id)sender{
	[moreCell setState:loadFinished];
}	

// 显示网络提示信息
- (void)showHUD{
	[proHD show:YES];
}

// 隐藏网络提示信息
- (void)hideHUD{
	[moreCell.spinner stopAnimating];
	[moreCell setState:loadMore1];
	[proHD hide:YES];
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [netArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  	
		NSString *CellIdentifier = [NSString stringWithFormat:@"%d",indexPath.row];
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			// cell背景图片
			UIImageView *bgView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"draftBroadcastBg.png"]];
			bgView1.frame = CGRectMake(0, 0, 320, 54);
			bgView1.alpha = 0.2;
			[cell.contentView addSubview:bgView1];
			[cell.contentView sendSubviewToBack:bgView1];
			[bgView1 release];
			//  cell分割线
			UIImageView *lineBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separatorLine.png"]];
			lineBg.frame = CGRectMake(0, 54, 320, 1);
			lineBg.alpha = 0.6;
			[cell.contentView addSubview:lineBg];
			[lineBg release];
			
			// 头像图片
			AsynchronousImageView *headImage = [[AsynchronousImageView alloc] initWithFrame:CGRectMake(6, 7, 46, 46)];
			headImage.tag = 100;
			CALayer *layer = [headImage layer];
			layer.masksToBounds = YES;
			layer.cornerRadius = 8;
			[cell.contentView addSubview:headImage];
			[headImage release];
				
			//	昵称标签
			UILabel *nick = [[UILabel alloc] initWithFrame:CGRectMake(60, 4, 180, 30)];
			nick.tag = 101;
			nick.backgroundColor = [UIColor clearColor];
			nick.font = [UIFont systemFontOfSize:16];
			nick.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
			[cell.contentView addSubview:nick];
			[nick release];
			
			// 用户名标签
			UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(60, 31, 180, 20)];
			name.tag = 102;
			name.backgroundColor = [UIColor clearColor];
			name.font = [UIFont systemFontOfSize:12];
			name.textColor = [UIColor colorWithRed:99/255 green:99/255 blue:99/255 alpha:0.6];
			[cell.contentView addSubview:name];
			[name release];
		}
		UILabel *nick = (UILabel *)[cell.contentView viewWithTag:101];
		UILabel *name = (UILabel *)[cell.contentView viewWithTag:102];
		AsynchronousImageView *imageView = (AsynchronousImageView *)[cell.contentView viewWithTag:100];
		nick.text = [NSString stringWithFormat:@"%@",[[self.netArray objectAtIndex:indexPath.row] objectForKey:@"nick"]];
		name.text = [NSString stringWithFormat:@"%@",[[self.netArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
		NSString *url = [NSString stringWithFormat:@"%@",[[self.netArray objectAtIndex:indexPath.row] objectForKey:@"head"]];
		NSNumber *isVip = [[self.netArray objectAtIndex:indexPath.row] objectForKey:@"isvip"];
		BOOL bIsVip = [isVip intValue] == 0 ? NO:YES;
		imageView.isVip = bIsVip;
		[imageView loadHeadImageFromURLString:url WithRequestType:RequestFromFriendsFansSearch];
		return cell;
}

#pragma mark -
#pragma mark Table view delegate

-(void)notifyParentController {
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath row] < [netArray count]) {
//		[[NSNotificationCenter defaultCenter] postNotificationName:@"fanhui" object:nil];
		if ([self.myNetsearchControllerDelegate respondsToSelector:@selector(NetSearchItemClicked:)]) {
            [self dismissModalViewControllerAnimated:YES];
            [self.myNetsearchControllerDelegate NetSearchItemClicked:[netArray objectAtIndex:[indexPath row]]];
			[[DraftController sharedInstance] setMyDraftCtllerSearchUserDelegate:nil];
            if ([parentID respondsToSelector:@selector(setBNeedReturn:)]) {
                [parentID setBNeedReturn:YES];
            }
		}
		else {
			//assert(NO);
		}
	}else {
		NSLog(@"indexPath is %d",indexPath.row);
	}

}

#pragma mark DraftCtrllerSearchUserDelegate
// 搜索用户回调方法
-(void)searchUserOnSuccess:(NSArray *)info totalNumber:(NSString *)totalNumCount{
	LOADING = YES;
	infoMoreArray = [NSMutableArray arrayWithArray:info];
	// 网络好友列表
	for (int i = 0; i < [infoMoreArray count]; i ++) {
		[netArray addObject:[infoMoreArray objectAtIndex:i]];
	}
	[moreCell setState:loadMore1];
	[self.netTableList reloadData];
}

-(void)searchUserOnFailure:(NSError *)error {
	LOADING = YES;
	[self.navigationController.view addSubview:proHD];
	[self performSelector:@selector(showHUD) withObject:nil afterDelay:0.5];
	[self performSelector:@selector(hideHUD) withObject:nil afterDelay:1];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    [netTableList release];
	[moreCell	  release];
    [super dealloc];
}

@end
