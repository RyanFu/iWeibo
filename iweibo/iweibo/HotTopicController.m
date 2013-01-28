    //
//  HotTopicController.m
//  iweibo
//
//  Created by lichentao on 12-2-23.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "HotTopicController.h"
#import "HotTopicDetailController.h"
#import "HpThemeManager.h"
#import "DetailPageConst.h"
#import "HotTopicInfo.h"
#import "Canstants_Data.h"
#import "IWeiboAsyncApi.h"
#import "DataCheck.h"
#import "ColorUtil.h"
#import "SCAppUtils.h"
#import "HomePage.h"

// 热门话题与右侧间距30px
#define BETWEENNAME_COUNT 30
// 热门话题图片的宽高都是15
#define HOTTOPIC_MARK_WIDTH 15
// 热门话题图片与字数之间的距离
#define HOTTOPIC_MARK_COUNT_WIDTH 3
@implementation HotTopicController
@synthesize hotTopicTableList;
@synthesize hotTopicArray;
@synthesize hasNext,aApi,backBtn;
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
//

- (void)updateTheme:(NSNotificationCenter *)noti{
    NSDictionary *plistDict = [[HpThemeManager sharedThemeManager]themeDictionary];
	NSString *themePathTmp = [plistDict objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    UIImage *imageNav = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"navigationbar_bg.png"]];
    [SCAppUtils navigationController:self.navigationController setImage:imageNav];
    [backBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView]; 
	super.navigationController.navigationBarHidden = NO;
	self.view.backgroundColor = [UIColor whiteColor];
    
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
    
	UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
	[customLab setTextColor:[UIColor whiteColor]];
	[customLab setText:@"热门话题"];
	[customLab setTextAlignment:UITextAlignmentCenter];
	customLab.backgroundColor = [UIColor clearColor];
	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	self.navigationItem.titleView = customLab;
	[customLab release];
	// 导航条返回按钮
	backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 49, 30)];
	backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
	backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
	backBtn.titleLabel.textAlignment = UITextAlignmentCenter;
	[backBtn setTitle:@"返回" forState:UIControlStateNormal];
	[backBtn addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
	[backBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
	self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
	// 加载更多控制	// 初始化热门话题数据源数据 
	hotTopicArray = [[NSMutableArray alloc] init];
	aApi = [[IWeiboAsyncApi alloc] init];
	moreCell = [[LoadCell alloc] initWithFrame:CGRectMake(0, 0, 320, 43)];
	// 热门话题列表
	hotTopicTableList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 414)]; 
	hotTopicTableList.delegate = self;
	hotTopicTableList.dataSource = self;
	hotTopicTableList.rowHeight = 43;
	hotTopicTableList.showsVerticalScrollIndicator = YES;
	[hotTopicTableList setHidden:YES];
	hotTopicTableList.tableFooterView = moreCell;
	[self.view addSubview:hotTopicTableList];
	
	// 状态提示信息
	BOOL connectStatus = [[CommonMethod shareInstance] connectionStatus];
	if (connectStatus) {
		HUD = [[CommonMethod shareInstance] shareMBProgressHUD:load];
		// 第一次请求服务器,分页标识第一页0，向下翻页1，向上翻页2
		NSString *pageFlag = [[NSString alloc] initWithFormat:@"%d",0];
		// 本页起始local_id（第一页：填0，向上翻页：填上一次请求返回的第一条记录的local_id，向下翻页：填上一次请求返回的最后一条记录的local_id）
		NSString *lastID = [[NSString alloc] initWithFormat:@"%d",0];
		[self requestHotTopicServer:pageFlag setLastID:lastID];
		[pageFlag release];
		[lastID release];
		[self.view bringSubviewToFront:HUD];
		[self.navigationController.view addSubview:HUD];
	}else {
		HUD = [[CommonMethod shareInstance] shareMBProgressHUD:loadError];
		[self.view bringSubviewToFront:HUD];
		[self.navigationController.view addSubview:HUD];
		[self performSelector:@selector(hideHUD) withObject:nil afterDelay:0.5];
	}
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification object:nil];
}

- (void)requestHotTopicServer:(NSString *)pageFlag setLastID:(NSString *)lastid{
	// 页面呈现后请求服务器，返回热门话题数据
	NSMutableDictionary *parGetHotTopic = [NSMutableDictionary dictionaryWithCapacity:5];
	[parGetHotTopic setObject:@"json" forKey:@"format"];
	NSString	*num = [NSString stringWithFormat:@"%d", 10];
	[parGetHotTopic setObject:num forKey:@"reqnum"];
	[parGetHotTopic setObject:lastid forKey:@"lastid"];
	[parGetHotTopic setObject:pageFlag forKey:@"pageflag"];
	[parGetHotTopic setObject:URL_HOT_TOPIC forKey:@"request_api"];
	[aApi getHotTopicWithParamters:parGetHotTopic
								delegate:self
							   onSuccess:@selector(getHotTopicInfoSuccess:) 
							   onFailure:@selector(getHotTopicInfoFailure:)];	
}

// 接口回调成功
- (void)getHotTopicInfoSuccess:(NSDictionary *)dictionary {
	// 数据返回更改相应状态
	[hotTopicTableList setHidden:NO];
	LOADING = YES;
	[self hideHUD];
	// 数据解析
	NSDictionary *hotData = [DataCheck checkDictionary:dictionary forKey:@"data" withType:[NSDictionary class]];
	if ([hotData isKindOfClass:[NSDictionary class]]) {
		// 数据源信息
		NSArray *info = [DataCheck checkDictionary:hotData forKey:@"info" withType:[NSArray class]];
		if ([info isKindOfClass:[NSArray class]]) {
			NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:10];
			for (NSDictionary *dict in info) {
				HotTopicInfo *topic = [[HotTopicInfo alloc] init];
				NSString *topinCountString	= [[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"tweetnum"]];
				topic.topicCount = topinCountString;
				topic.topicName = [dict objectForKey:@"text"];
				topic.topicLastID = [dict objectForKey:@"local_id"];
				topic.hotTopicID = [dict objectForKey:@"id"];
				[array addObject:topic];
				[topic release];
				[topinCountString release];
			}
			// 将返回的数据添加到话题数组中
			for (int i = 0; i < [array count]; i ++) {
				[self.hotTopicArray addObject:[array objectAtIndex:i]];
			}
			[array release];
			[self.hotTopicTableList reloadData];
		}
	}
	// hasnext字段确定是否还能加载更多 
	hasNext = [DataCheck checkDictionary:hotData forKey:@"hasnext" withType:[NSNumber class]];	//是否还有数据
	if ([hasNext isKindOfClass:[NSNumber class]]) {
		if ([hasNext intValue] == 0) {
			[moreCell setState:loadMore1];
		}else {
			[moreCell setState:loadFinished];
		}
	}
    else {
        [moreCell setState:loadMore1];
    }
	
}

// 接口回调失败
- (void)getHotTopicInfoFailure:(NSError *)error {
	NSLog(@"getHotTopicInfoFailure:%@", [error localizedDescription]);
	[hotTopicTableList setHidden:NO];
	LOADING = YES;
	[self performSelector:@selector(hideHUD) withObject:nil afterDelay:2];
}

// 隐藏加载状态
- (void)hideHUD{
	if (HUD) {
	 [HUD	removeFromSuperview];
	}
}
// 返回上一页面
- (void)backButton:(id)sender{
	[self hideHUD];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	[self.tabBarController performSelector:@selector(showNewTabBar)];
	[self.navigationController popViewControllerAnimated:YES];
}

// 页面加载进来
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.tabBarController performSelector:@selector(hideNewTabBar)];
}

// 页面消失
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

// 加载更多
- (void)loadMoreCell{
	if ([hotTopicArray count] > 0) {
		HotTopicInfo *topicInfo = [hotTopicArray lastObject];
		[self requestHotTopicServer:@"1" setLastID:topicInfo.topicLastID];
	}else {
		[self requestHotTopicServer:@"0" setLastID:@"0"];
	}
}

#pragma mark - TableViewDelegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	HotTopicDetailController *hotTopicDetailController = [[HotTopicDetailController alloc] init];
	HotTopicInfo *topicInfo = [hotTopicArray objectAtIndex:indexPath.row];
	hotTopicDetailController.searchString = topicInfo.topicName;
	hotTopicDetailController.hotTopicIDString =topicInfo.hotTopicID;
	[self.navigationController pushViewController:hotTopicDetailController animated:YES];
	[hotTopicDetailController release];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollViewSender{
	// 滑动停止后判断tableView.y偏移量是否到最后后，查看网络状态，是则加载更多，否则提示网络错误消息43代表cell高度
	if (hotTopicTableList.contentOffset.y + self.hotTopicTableList.bounds.size.height > [hotTopicArray count] * 43){
		BOOL conncetStatus = [[CommonMethod shareInstance] connectionStatus];
		if (conncetStatus){
			if (LOADING && (![hasNext isKindOfClass:[NSNumber class]] || [hasNext intValue] == 0)) {
				// 是还有数据
				LOADING = NO;
				[moreCell setState:loading1];
				[self loadMoreCell];
			}
		}else {
			HUD = [[CommonMethod shareInstance] shareMBProgressHUD:loadError];
			[self.view bringSubviewToFront:HUD];
			[self.navigationController.view addSubview:HUD];
			[self performSelector:@selector(hideHUD) withObject:nil afterDelay:1];
			[moreCell setState:loadMore1];
		}
	}
}

#pragma mark - TableViewDateSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [hotTopicArray count];	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	// 重用cell
	NSString *CellIdentifier = @"Cell";
	UITableViewCell *hotTopicCell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (hotTopicCell == nil) {
		hotTopicCell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
		[hotTopicCell setSelectionStyle:UITableViewCellSelectionStyleGray];
		// 话题名称宽度计算
		UILabel *nameLabel = [[UILabel alloc] init];
		nameLabel.tag = 102;
		nameLabel.backgroundColor = [UIColor clearColor];
		nameLabel.font = [UIFont boldSystemFontOfSize:18];
		nameLabel.textColor = [UIColor colorStringToRGB:HotTopicTextFontColor];
		[hotTopicCell.contentView addSubview:nameLabel];
		[nameLabel release];
		// 热门话题小图片
		UIImageView *hotTopicimage = [[UIImageView alloc] init];
		hotTopicimage.tag = 101;
		hotTopicimage.backgroundColor = [UIColor clearColor];
		[hotTopicCell.contentView addSubview:hotTopicimage];
		[hotTopicimage release];
		// 热门话题数量宽度计算
		UILabel *countLabel = [[UILabel alloc] init];
		countLabel.tag = 103;
		countLabel.backgroundColor = [UIColor clearColor];
		countLabel.textColor = [UIColor colorStringToRGB:HotTopicCountFontColor];
		countLabel.font = [UIFont systemFontOfSize:16];
		[hotTopicCell.contentView addSubview:countLabel];
		[countLabel release];
	}
	// 数据封装
	HotTopicInfo *topicInfo = [hotTopicArray objectAtIndex:indexPath.row];
	// 话题
	UILabel *hotTopicLabel = (UILabel *)[hotTopicCell viewWithTag:102];
	NSString *nameString = [NSString stringWithFormat:@"#%@#",topicInfo.topicName];
	CGSize nameSize = [nameString sizeWithFont:[UIFont boldSystemFontOfSize:18]];
	hotTopicLabel.frame = CGRectMake(10, 8, nameSize.width, 30);
	hotTopicLabel.text = nameString;
	// 图像小标记
	UIImageView *iconMarkImage = (UIImageView *)[hotTopicCell.contentView viewWithTag:101];
	iconMarkImage.frame = CGRectMake(10 + nameSize.width + BETWEENNAME_COUNT, 17, 11.0f, 13.0f);
	iconMarkImage.image = [UIImage imageNamed:TOPIC_MARK];
	// 话题数目
	NSString *countString = topicInfo.topicCount;
	CGSize countSize = [countString sizeWithFont:[UIFont systemFontOfSize:16]];
	UILabel *countLabel = (UILabel *)[hotTopicCell.contentView viewWithTag:103];
	countLabel.frame = CGRectMake(10 + nameSize.width + BETWEENNAME_COUNT + 11.0f + HOTTOPIC_MARK_COUNT_WIDTH, 8, countSize.width, 30);
	countLabel.text = countString;
	// 返回 cell
	return hotTopicCell;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	aApi = nil;
	hotTopicTableList = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    [backBtn            release];
	[aApi				release];
	[hotTopicTableList	release];
	[hotTopicArray		release];
	[moreCell			release];
//	[hasNext			release];
	HUD	= nil;
    [super dealloc];
}

@end
