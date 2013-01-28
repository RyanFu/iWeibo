    //
//  FriendSearchController.m
//  iweibo
//
//  Created by LICHENTAO on 11-12-31.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import "FriendSearchController.h"
#import "pinyin.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "NetSearchController.h"
#import "MyFriendsFansInfo.h"
#import "AsynchronousImageView.h"
#import "FMDatabase.h"
#import "HpThemeManager.h"
#import "SCAppUtils.h"
#import "CustomNavigationbar.h"

@implementation FriendSearchController
@synthesize friendTableList;
@synthesize friendSearchBar;
@synthesize friendArray;		
@synthesize filterFriendArray;
@synthesize sectionArray;		// section
@synthesize cCopySectionArray;
@synthesize comnonContact;
@synthesize count,leftButton;
@synthesize blackCoverView;
@synthesize myFriendSearchControllerDelegate;
@synthesize bNeedReturn;

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

#pragma 数据获取

- (void) showMBProgress{
    if (MBprogress == nil) {
        MBprogress = [[MBProgressHUD alloc] initWithFrame:CGRectMake(30, 80, 260, 200)]; 
        [self.view addSubview:MBprogress];  
        MBprogress.removeFromSuperViewOnHide = YES;
        MBprogress.labelText = @"载入中...";
        MBprogress.alpha = 0.6;
    }
    [self.view bringSubviewToFront:MBprogress];  
    [MBprogress show:YES];  
}

- (void) hiddenMBProgress{
    [MBprogress hide:YES];
    [MBprogress release];
    MBprogress = nil;
}

///
// nUpdateStatus:
- (void)getFriendsFansListWithUpdateStatus:(BOOL)bNeedUpdateFromSvr {
    // lichentao 2012-02-17读取本地数据库好友列表时候重新创建数组和保存到数据库的数组区分开 
	NSMutableArray *LocalFriendsFansArray = [[NSMutableArray alloc] initWithCapacity:10];
	NSMutableArray *arrayAll = [MyFriendsFansInfo mySimpleFriendsFansListFromDB];
	for (MyFriendsFansInfo *infoItem in arrayAll) {
		NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithCapacity:6];
		[infoDic setObject:infoItem.fansname forKey:@"name"];
		[infoDic setObject:infoItem.nick forKey:@"nick"];
		[infoDic setObject:infoItem.head forKey:@"head"];
		[infoDic setObject:infoItem.isvip forKey:@"isvip"];
		[LocalFriendsFansArray addObject:infoDic];
	}
	// 2012-02-23 检测数据，假如没有好友，则去网络获取
	if ([LocalFriendsFansArray count] == 0) {
        if (bNeedUpdateFromSvr) {
            [self getFriendsFansListFromServer];
        }	
        else
            [self hiddenMBProgress];
	}
	else {
		self.friendArray = LocalFriendsFansArray;
        [self initData];
        [self.friendTableList reloadData];
        [self hiddenMBProgress];
	}
	// 删除数组
	[LocalFriendsFansArray release];
}

- (void)getFriendsFansListFromServer {
	if (!bStartGettingFriends) {
		bStartGettingFriends = YES;
		unFriendsCnt = 0;
	}
	NSMutableDictionary *parGetFriends = [NSMutableDictionary dictionaryWithCapacity:5];
	[parGetFriends setObject:@"json" forKey:@"format"];
	NSString	*num = [NSString stringWithFormat:@"%d", FriendFansListCountEachTime];
	[parGetFriends setObject:num forKey:@"reqnum"];
	NSString	*index = [NSString stringWithFormat:@"%d", unFriendsCnt];
	[parGetFriends setObject:index forKey:@"startindex"];
	[parGetFriends setObject:URL_IDOLLIST forKey:@"request_api"];
	[requestApi getMyIdolListWithParamters:parGetFriends
								 delegate:self
								onSuccess:@selector(getFriendsFansListOnSuccessCallback:)  
								onFailure:@selector(getFriendsFansListOnFailureCallback:)];
}
// 获取好友列表成功回调函数
- (void)getFriendsFansListOnSuccessCallback:(NSDictionary *)dict {
	//NSLog(@"dict is %@",dict);
	// 好友列表返回数据不能为空逻辑处理
	//lichentao 2012-03-02修改数据类型去掉msg字段的逻辑判断
    NSDictionary *friendsData = [DataCheck checkDictionary:dict forKey:@"data" withType:[NSDictionary class]];
    NSNumber *hasNext = [DataCheck checkDictionary:friendsData forKey:@"hasnext" withType:[NSNumber class]];
    NSArray *infoArray = [DataCheck checkDictionary:friendsData forKey:@"info" withType:[NSArray class]];
    if (![infoArray isKindOfClass:[NSNull class]]) {
        // 接收数据
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:10];
        for (NSDictionary *infoItem in infoArray) {
            [tempArray addObject:infoItem];
        }
        // 保存到数据库
        [MyFriendsFansInfo updateMyFriendsFansInfoToDB:tempArray];
        [tempArray release];
    }
    // 服务器还有好友数据继续发送请求
    if (![hasNext isKindOfClass:[NSNull class]] && [hasNext intValue] != 1) {
        // 继续要数据
        // 2012-02-08 修正一个服务器返回数据少于FriendFansListCountEachTime导致下一次请求异常的问题
        unFriendsCnt += FriendFansListCountEachTime;
        [self getFriendsFansListFromServer];
    }
    else {		// 接收完成
        NSLog(@"接收好友列表完成");
        bStartGettingFriends = NO;
        unFriendsCnt = 0;
        // 刷新数据
        [self getFriendsFansListWithUpdateStatus:NO];
    }
}

// 获取好友列表失败回调函数
- (void)getFriendsFansListOnFailureCallback:(NSError *)error {
	CLog(@"error:%@", error);
    // 提示错误(未完成)
    bStartGettingFriends = NO;
    unFriendsCnt = 0;
}


#pragma -

- (void)updateTheme:(NSNotification *)noti{
    NSDictionary *dic = [[HpThemeManager sharedThemeManager] themeDictionary];
    NSString *themePathTemp = [dic objectForKey:@"Common"];
    NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTemp];
    UIImage *imageNav = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"navigationbar_bg.png"]];
    [SCAppUtils navigationController:self.navigationController setImage:imageNav];
    [leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView{
	[super loadView];
	self.navigationItem.title = @"好友列表";
    
    NSDictionary *plistDict = nil;
    NSDictionary *pathDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"ThemePath"];
    if ([pathDic count] == 0){
        NSString *skinPath = [[NSBundle mainBundle] pathForResource:@"ThemeManager" ofType:@"plist"];
        plistDict = [[NSArray arrayWithContentsOfFile:skinPath] objectAtIndex:0];
    }
    else{
        plistDict = pathDic;
    }
	NSString *themePathTmp = [plistDict objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    UIImage *imageNav = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"navigationbar_bg.png"]];
    [SCAppUtils navigationController:self.navigationController setImage:imageNav];

	// 导航条返回按钮
	leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
	[leftButton setTitle:@"返回" forState:UIControlStateNormal];
	leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
	[leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
	[leftButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
	self.navigationItem.leftBarButtonItem = leftBar;
	[leftBar release];
	// 初始化表格数据
	[self initData];
	// 数据列表
	UITableView *friendTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, 380)];
	[friendTable setDelegate:self];
	[friendTable setDataSource:self];
	friendTable.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:friendTable];
	self.friendTableList = friendTable;
	[friendTable release];
	// 选中搜索框时候添加蒙版
	blackCoverView = [[UIView alloc] initWithFrame:self.friendTableList.frame];
	blackCoverView.backgroundColor = [UIColor blackColor];
	blackCoverView.alpha = 0.7;
	UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
	coverButton.frame = blackCoverView.frame;
	[coverButton addTarget:self action:@selector(removeaView:) forControlEvents:UIControlEventTouchUpInside];
	[blackCoverView addSubview:coverButton];
	// 搜索框
	UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
//    [[searchBar.subviews objectAtIndex:0]removeFromSuperview];
	searchBar.delegate = self;
	searchBar.placeholder = @"搜索";
	self.friendSearchBar = searchBar;
	[self.view addSubview:friendSearchBar];
	[searchBar release];
	// 数据为空的时候提示没有好友
//	if ([self.friendArray count] == 0) {
//		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"系统提示" message:@"您还没有添加好友!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
//		[av show];
//	}
    // 更新数据
    requestApi = [[IWeiboAsyncApi alloc] init];
    friendArray = [[NSMutableArray alloc] initWithCapacity:20];
    [self showMBProgress];
    [self getFriendsFansListWithUpdateStatus:YES];
	// 搜索好友网络搜索页面，选择一个好友，进入消息页面@xx
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fanhui:) name:@"fanhui" object:nil];	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification object:nil];
}

//	返回上一页面
- (void)fanhui:(id)sender{
	[self dismissModalViewControllerAnimated:NO];
//	[self.navigationController.parentViewController dismissModalViewControllerAnimated:YES];
}

// 返回
- (void)back:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
}

// 初始化数据
- (void)initData{
	filterFriendArray = [[NSMutableArray alloc] initWithArray:self.friendArray];
	self.sectionArray = [[NSMutableArray alloc] init];
	self.cCopySectionArray = [[NSMutableArray alloc] init];
	// sectionArray数据数组(常~z)
	for(int i = 0; i < 29; i ++) {
		[self.sectionArray addObject:[NSMutableArray array]];
		[self.cCopySectionArray addObject:[NSMutableArray array]];
	}
	// 常用联系人
	[self getComonContactList];	
	// 字母_a~z姓名排序
	for (int i = 0; i < [friendArray count]; i ++) {
		NSString *nickString = [[self.friendArray objectAtIndex:i] objectForKey:@"nick"];//首字字母分组
		sectionName = [NSString stringWithFormat:@"%c",pinyinFirstLetter([nickString characterAtIndex:0])];
		NSUInteger firstLetter = [ALPHA rangeOfString:[sectionName substringToIndex:1]].location;
		
		if (firstLetter != NSNotFound){
		[[self.sectionArray objectAtIndex:firstLetter] addObject:[self.friendArray objectAtIndex:i]];
		[[self.cCopySectionArray objectAtIndex:firstLetter] addObject:[self.friendArray objectAtIndex:i]];
		}
	}
}

// 加载常用联系人
- (void) getComonContactList{
	NSMutableArray *comnonContactArray = [MyFriendsFansInfo mySimpleCommonFriendsFansListFromDB];	
	for (MyFriendsFansInfo *infoItem in comnonContactArray) {
		NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithCapacity:6];
		[infoDic setObject:infoItem.fansname forKey:@"name"];
		[infoDic setObject:infoItem.nick forKey:@"nick"];
		[infoDic setObject:infoItem.head forKey:@"head"];
		[infoDic setObject:infoItem.isvip forKey:@"isvip"];
		[[self.sectionArray objectAtIndex:0] addObject:infoDic];
	}
}

#pragma mark - TableViewDelegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[self.friendSearchBar resignFirstResponder];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
		//	搜索框有内容选中第一行将输入内容返回到发送框
		if (indexPath.row == 0 && [self.friendSearchBar.text length] > 0) {
			NSString *firstNameItem = [[NSString alloc] initWithFormat:@"@%@ ",[[self.friendArray objectAtIndex:indexPath.row] objectForKey:@"nick"]];
			[myFriendSearchControllerDelegate FriendsFansItemClicked:firstNameItem];
			[firstNameItem release];
			[self back:nil];
			}
		else if (indexPath.row == [self.friendArray count] - 1 && [self.friendSearchBar.text length] > 0) {
			progressHD = [[MBProgressHUD alloc] initWithView:self.view];
			[self.navigationController.view addSubview:progressHD];
			progressHD.labelText = @"载入中...";
			progressHD.alpha = 0.6;
			[progressHD show:YES];	
			
			NSNumber *pageIndex = [[NSNumber alloc] initWithInt:1];
			[[DraftController sharedInstance] setMyDraftCtllerSearchUserDelegate:self];
			[[DraftController sharedInstance] searchUserWithKeyword:friendSearchBar.text AndPageIndex:pageIndex];
			[pageIndex release];
		}
		else {
			NSString *name = @"";
			NSString *nickString = @"";
			NSString *headString = @"";
			if ([self.friendSearchBar.text length] > 0) {
				name = [NSString stringWithFormat:@"%@",[[self.friendArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
			}else {
				name = [NSString stringWithFormat:@"%@",[[[self.sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"]];
			}
			if ([self.friendSearchBar.text length] > 0) {
				nickString = [NSString stringWithFormat:@"%@",[[self.friendArray objectAtIndex:indexPath.row] objectForKey:@"nick"]];
				headString = [NSString stringWithFormat:@"%@",[[self.friendArray objectAtIndex:indexPath.row] objectForKey:@"head"]];
			}else {
				nickString = [NSString stringWithFormat:@"%@",[[[self.sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"nick"]];
				headString = [NSString stringWithFormat:@"%@",[[[self.sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"head"]];
			}
			NSMutableDictionary *comnonDic = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:name,nickString,headString,nil] forKeys:[NSArray arrayWithObjects:@"name",@"nick",@"head",nil]];
			// 常用联系人到数据库
			NSMutableArray *arrAll = [[NSMutableArray alloc] initWithObjects:comnonDic,nil];
			// 常用联系人更新: 更新是否为常用联系人
			[MyFriendsFansInfo updateFans:name WithStatus:YES];
			[arrAll release];
 
			NSString *actualName = [NSString stringWithFormat:@"@%@ ",name];
			[myFriendSearchControllerDelegate FriendsFansItemClicked:actualName];
			[self dismissModalViewControllerAnimated:YES];
		}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 55;
}

#pragma mark - TableViewDateSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([self.friendSearchBar.text length] > 0) {
		return 1;
	}else {
		return 28;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ([self.friendSearchBar.text length] > 0) {
		return [self.friendArray count];
	}else {
        NSArray *secArray = [self.sectionArray objectAtIndex:section];
		return [secArray count];
	}

}
// 右侧字母索引
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return [ALPHA rangeOfString:title].location;
}

// 右侧导航数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
	if ([self.friendSearchBar.text length] > 0) {
		return nil;
	}else {
		NSMutableArray *indices = [NSMutableArray array];
		for (int i = 0; i < [self.sectionArray count]; i++){ 
            NSArray *tempArray = [[NSArray alloc] initWithArray:[self.sectionArray objectAtIndex:i]];
			if ([tempArray count]){
				[indices addObject:[[ALPHA substringFromIndex:i] substringToIndex:1]];
			}
            [tempArray release];
		}
		return indices;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	
	if ([self.friendSearchBar.text length] > 0) {
		return nil;
	}else {
        NSArray *tempArray = [[NSArray alloc] initWithArray:[self.sectionArray objectAtIndex:section]];
        if ([tempArray count] == 0){
            [tempArray release];
            return nil;
        }
        [tempArray release];
        NSString *subFir = [[NSString alloc] initWithString:[ALPHA substringFromIndex:section]];
        NSString *subSec = [[NSString alloc] initWithString:[subFir substringToIndex:1]];
        [subFir release];
        NSString *string = [NSString stringWithString:subSec];
        [subSec release];
		return string;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier", [indexPath section], [indexPath row]];
	FriendSearchTableViewCell *friendCell = (FriendSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (!friendCell) {
		friendCell = [[[FriendSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		[friendCell setSelectionStyle:UITableViewCellSelectionStyleGray];
		
//		UIImageView *bgView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"draftBroadcastBg.png"]];
//		bgView1.frame = CGRectMake(0, 0, 320, 54);
//		bgView1.alpha = 0.2;
//		[friendCell.contentView addSubview:bgView1];
//		[friendCell.contentView sendSubviewToBack:bgView1];
//		[bgView1 release];
//		
//		UIImageView *lineBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separatorLine.png"]];
//		lineBg.frame = CGRectMake(0, 54, 320, 1);
//		lineBg.alpha = 0.6;
//		[friendCell.contentView addSubview:lineBg];
//		[lineBg release];
//		
//		UIImageView *bgView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"outline.png"]];
//		bgView.tag = 112;
//		CALayer *bgLayer = [bgView layer];
//		bgLayer.masksToBounds = YES;
//		bgLayer.cornerRadius = 8;
//		bgView.frame = CGRectMake(5, 6, 42, 42);
//		[friendCell.contentView addSubview:bgView];
//		[bgView release];
//		
//		// 头像图片
//		AsynchronousImageView *headImage = [[AsynchronousImageView alloc] initWithFrame:CGRectMake(6, 7, 40, 40)];
//		headImage.tag = 100;
//		[friendCell.contentView addSubview:headImage];
//		[headImage release];
//		
//		//	昵称标签
//		UILabel *nick = [[UILabel alloc] initWithFrame:CGRectMake(60, 4, 180, 30)];
//		nick.tag = 101;
//		nick.backgroundColor = [UIColor clearColor];
//		nick.font = [UIFont systemFontOfSize:16];
//		nick.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
//		[friendCell.contentView addSubview:nick];
//		[nick release];
//		
//		// 搜索输入第一行
//		UILabel *indexrow1 = [[UILabel alloc] initWithFrame:CGRectMake(6, 0, 320, 50)];
//		indexrow1.tag = 110;
//		indexrow1.backgroundColor = [UIColor clearColor];
//		indexrow1.font = [UIFont systemFontOfSize:22];
//		indexrow1.textColor = [UIColor blueColor];
//		[friendCell.contentView addSubview:indexrow1];
//		[indexrow1 release];
//		
//		// 去网络搜索
//		UILabel *indexLast = [[UILabel alloc] initWithFrame:CGRectMake(105, 4, 220, 50)];
//		indexLast.tag = 111;
//		indexLast.backgroundColor = [UIColor clearColor];
//		indexLast.font = [UIFont systemFontOfSize:20];
//		indexLast.textColor = [UIColor grayColor];
//		[friendCell.contentView addSubview:indexLast];
//		[indexLast release];
//		
//		// 用户名标签
//		UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(60, 31, 180, 20)];
//		name.tag = 102;
//		name.backgroundColor = [UIColor clearColor];
//		name.font = [UIFont systemFontOfSize:12];
//		name.textColor = [UIColor colorWithRed:99/255 green:99/255 blue:99/255 alpha:0.6];
//		[friendCell.contentView addSubview:name];
//		[name release];
	}
//	UILabel *nick = (UILabel *)[friendCell.contentView viewWithTag:101];
//	UILabel *name = (UILabel *)[friendCell.contentView viewWithTag:102];
//	UILabel *indexRow1 = (UILabel *)[friendCell.contentView viewWithTag:110];
//	UILabel *indexLast = (UILabel *)[friendCell.contentView viewWithTag:111];
//	AsynchronousImageView *imageView = (AsynchronousImageView *)[friendCell.contentView viewWithTag:100];
//	UIImageView *bgView = (UIImageView *)[friendCell.contentView viewWithTag:112];
	
	if ([self.friendSearchBar.text length] > 0) {
		friendCell.headImageViewBg.hidden = NO;
		friendCell.bgView.hidden = NO;
		friendCell.lbIndexLast.text = nil;
		friendCell.lbIndexFirst.text = nil;
		friendCell.lbNick.text = [NSString stringWithFormat:@"%@",[[self.friendArray objectAtIndex:indexPath.row] objectForKey:@"nick"]];
		friendCell.lbName.text = [NSString stringWithFormat:@"%@",[[self.friendArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
		NSString *url = [NSString stringWithFormat:@"%@",[[self.friendArray objectAtIndex:indexPath.row] objectForKey:@"head"]];
		NSNumber *isVip = [NSString stringWithFormat:@"%@",[[self.friendArray objectAtIndex:indexPath.row] objectForKey:@"isvip"]];
		BOOL bIsVip = [isVip intValue] == 0 ? NO:YES;
		[friendCell setIsVip:bIsVip];		
        friendCell.strUrlHead = url;
		if (friendTableList.dragging == NO && friendTableList.decelerating == NO)
		{
            [friendCell startIconDownload];
        }
	}else {
		friendCell.lbIndexFirst.text = nil;
		friendCell.lbIndexLast.text = nil;
		friendCell.headImageViewBg.hidden = NO;
		friendCell.bgView.hidden = NO;
		friendCell.lbNick.text = [NSString stringWithFormat:@"%@",[[[self.sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"nick"]];
		friendCell.lbName.text = [NSString stringWithFormat:@"%@",[[[self.sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"]];
		NSString *url = [NSString stringWithFormat:@"%@",[[[self.sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"head"]];
		NSNumber *isVip =[NSString stringWithFormat:@"%@",[[[self.sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"isvip"]];
		BOOL bIsVip = [isVip intValue] == 0 ? NO:YES;
		[friendCell setIsVip:bIsVip];	
		friendCell.strUrlHead = url;
		if (friendTableList.dragging == NO && friendTableList.decelerating == NO)
		{
            [friendCell startIconDownload];
        }
	}
	
	if (indexPath.row == 0 && [self.friendSearchBar.text length] > 0) {
		friendCell.headImageViewBg.hidden = YES;
		friendCell.bgView.hidden = YES;
		friendCell.lbNick.text = nil;
		friendCell.lbName.text = nil;
		friendCell.lbIndexFirst.text = self.friendSearchBar.text;
	}
	
	if (indexPath.row == [self.friendArray count] - 1 && [self.friendSearchBar.text length] > 0) {
		friendCell.headImageViewBg.hidden = YES;
		friendCell.bgView.hidden = YES;
		friendCell.lbNick.text = nil;
		friendCell.lbName.text = nil;
		friendCell.lbIndexLast.text = [[self.friendArray objectAtIndex:[self.friendArray count] - 1] objectForKey:@"nick"];
	}
	return friendCell;
}

#pragma mark searchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
	self.friendSearchBar.placeholder = @"";
	[self.friendSearchBar setShowsCancelButton:YES animated:YES];
	if ([self.friendSearchBar.text length] == 0) {
		[self.view addSubview:blackCoverView];
	}
}
// 隐藏蒙版
- (void)removeaView:(id)sender{
	[self.friendSearchBar setShowsCancelButton:NO animated:YES];
	if (blackCoverView) {
		[blackCoverView removeFromSuperview];
	}
	[self.friendSearchBar resignFirstResponder];
}
// 有输入滑动消失键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	if ([self.friendSearchBar.text length] > 0) {
		[self.friendSearchBar resignFirstResponder];
		// 找到searchBar上的按钮,将其属性置为enabled = YES
		NSLog(@"self.friendSearchBar is %@",self.friendSearchBar);
		for(id cc in [self.friendSearchBar subviews])
		{
			if([cc isKindOfClass:[UIButton class]])
			{
				UIButton *btn = (UIButton *)cc;
				btn.enabled = YES;
			}
		}
	}
}
// cancel按钮响应事件
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
	[self.friendSearchBar setShowsCancelButton:NO animated:YES];
	self.friendSearchBar.placeholder = @"搜索";
	self.friendSearchBar.text = nil;
	if (blackCoverView) {
		[blackCoverView removeFromSuperview];
	}
	[self.friendSearchBar resignFirstResponder];
	// 有文本输入的时候，点击cancel按钮，重新刷新数据
	self.sectionArray = [NSMutableArray arrayWithArray:cCopySectionArray];
	[[self.sectionArray objectAtIndex:0] removeAllObjects];
	// 加载常用联系人
	[self getComonContactList];
	[self.friendTableList reloadData];
}

// 按nick与name中出现与搜索关键字相同的进行搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	[sectionArray removeAllObjects];
	[friendArray removeAllObjects];
	if ([searchText length] > 0) {
		if (blackCoverView) {
			[blackCoverView removeFromSuperview];
		}
		for (int i = 0; i < [filterFriendArray count]; i ++) {
			NSString *nickString = [[filterFriendArray objectAtIndex:i] objectForKey:@"nick"];
			NSString *nameString = [[filterFriendArray objectAtIndex:i] objectForKey:@"name"];
			NSRange nickRange = [nickString rangeOfString:searchText options:NSCaseInsensitiveSearch];
			NSRange nameRange = [nameString rangeOfString:searchText options:NSCaseInsensitiveSearch];
			if (nickRange.length > 0 || nameRange.length > 0) {
				[self.friendArray addObject:[filterFriendArray objectAtIndex:i]];
			}
		}
		// 添加首尾行
		NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"",[NSString stringWithFormat:@"%@",searchText],@"123456",nil] forKeys:[NSArray arrayWithObjects:@"name",@"nick",@"head",nil]];
		NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"",@"去网络搜索",@"123456",nil] forKeys:[NSArray arrayWithObjects:@"name",@"nick",@"head",nil]];
		if ([dic count]!=0) {
			[self.friendArray insertObject:dic atIndex:0];
			[self.friendArray addObject:dic1];
		}
	}
	else {
		[self.view addSubview:blackCoverView];
		self.sectionArray = [NSMutableArray arrayWithArray:cCopySectionArray];
		count ++;
		if (count == 1) {
			// 加载常用联系人
			[self getComonContactList];
		}
	}
	[self.friendTableList reloadData];
}

#pragma mark DraftCtrllerSearchUserDelegate
// 搜索用户回调方法
-(void)searchUserOnSuccess:(NSArray *)info totalNumber:(NSString *)totalNumCount {	
	[self hideProgressHD];
	// 网络好友列表
	NetSearchController *netSearch = [[NetSearchController alloc] init];
	netSearch.netArray = [NSMutableArray arrayWithArray:info];
	//NSLog(@"netArray count is is %d",[netSearch.netArray count]);
	netSearch.moreString = self.friendSearchBar.text;
	netSearch.totalNum = totalNumCount;
    netSearch.parentID = self;
	[netSearch setMyNetsearchControllerDelegate:self];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:netSearch];
	[self presentModalViewController:nav animated:YES];
    [nav release];
	[netSearch release];	
}

// 旋转框消失释放对象
- (void)hideProgressHD{
	[progressHD hide:YES];
	[progressHD release];
	progressHD = nil;
}

-(void)searchUserOnFailure:(NSError *)error {
	CLog(@"%@", error);
	[self hideProgressHD];
	// 网络好友列表
	NetSearchController *netSearch = [[NetSearchController alloc] init];
	netSearch.netArray = [NSMutableArray arrayWithArray:nil];
    netSearch.parentID = self;
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:netSearch];
	[self presentModalViewController:nav animated:YES];
	[netSearch release];
	[nav release];
}

#pragma mark NetSearchControllerDelegate <NSObject>
- (void)NetSearchItemClicked:(NSDictionary *)ItemDic {
	[[DraftController sharedInstance] setMyDraftCtllerSearchUserDelegate:nil];
	// 转发到父级窗体
	NSString *actualName = [ItemDic objectForKey:@"name"];
	// 保存到数据库
	[MyFriendsFansInfo addFanToCommonContact:actualName WithDicInfo:ItemDic];
	NSString *name = [[NSString alloc] initWithFormat:@"@%@ ",actualName];
	[myFriendSearchControllerDelegate FriendsFansItemClicked:name];
	[name release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    CLog(@"%s", __FUNCTION__);
    [requestApi cancelSpecifiedRequest];
    [requestApi release];
    requestApi = nil;
    [friendTableList removeFromSuperview];
	[friendTableList   release];
    friendTableList = nil;
	[friendArray	   release];
    friendArray = nil;
	[filterFriendArray release];
    filterFriendArray = nil;
	[sectionArray	   release];
    sectionArray = nil;
	[cCopySectionArray  release];
    cCopySectionArray = nil;
	[blackCoverView	   release];
    blackCoverView = nil;
	[progressHD		   release];
    progressHD = nil;
    [leftButton        release];
    leftButton = nil;
//	//NSLog(@"friendSearchBar retainCount is %d",[self.friendSearchBar retainCount]);
	[friendSearchBar   release];
    friendSearchBar = nil;
	myFriendSearchControllerDelegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"fanhui" object:nil];	
    [super dealloc];
    CLog(@"%s", __FUNCTION__);
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (bNeedReturn) {
        [self performSelector:@selector(back:) withObject:nil afterDelay:0.0f];
    }
}


- (void)loadImagesForOnscreenRows
{
	NSArray *visiblePaths = [friendTableList indexPathsForVisibleRows];
	for (NSIndexPath *indexPath in visiblePaths) {
		FriendSearchTableViewCell *cell = (FriendSearchTableViewCell *)[friendTableList cellForRowAtIndexPath:indexPath];
		if (cell) {
			[cell startIconDownload];
		}
		else {
			CLog(@"cell not found");
		}
		
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForOnscreenRows];
}

@end
