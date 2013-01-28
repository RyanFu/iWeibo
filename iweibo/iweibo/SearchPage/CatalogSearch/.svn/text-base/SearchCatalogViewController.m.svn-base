//
//  SearchCatalogViewController.m
//  iweibo
//
//  Created by ZhaoLilong on 2/23/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "SearchCatalogViewController.h"
#import "CustomLink.h"
#import "Reachability.h"
#import "Info.h"
#import "WebUrlViewController.h"
#import "TransInfo.h"
#import "DetailPageConst.h"
#import "AsynchronousImageView.h"
#import "DataConverter.h"
#import "PushAndRequest.h"
#import "DetailsPage.h"
#import "HotTopicDetailController.h"
#import "HpThemeManager.h"
#import "CommonMethod.h"
#import "HotTopicInfo.h"

@implementation SearchCatalogViewController

@synthesize searchType;
@synthesize searchField;
@synthesize tableData;
@synthesize navBtnArray;
@synthesize preText;
@synthesize pushType;
@synthesize reachEnd;
@synthesize catalogTable;
@synthesize textHeightDic;
@synthesize themePath;
#pragma mark -
#pragma mark 加载视图

- (void)updateTheme:(NSNotification *)noti{
    NSDictionary *plistDic = [[HpThemeManager sharedThemeManager] themeDictionary];
    NSString *themePathTmp = [plistDic objectForKey:@"SearchPageSecondImage"];
	self.themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    if(themePath){
        searchBarView.image = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"CatalogSearchBar.png"]];
        [cancelBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"CatalogSearchCancel.png"]] forState:UIControlStateNormal];
        [broadBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"CatalogSearchBroadcastSelected.png"]] forState:UIControlStateNormal];
        [topicBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"CatalogSearchTopic.png"]] forState:UIControlStateNormal];
        [userBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"CatalogSearchUser.png"]] forState:UIControlStateNormal];
        [userBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"CatalogSearchUserSelected.png"]] forState:UIControlStateSelected];

    }
}

- (void)loadView {
	[super loadView];
	NSLog(@"loadview");
	self.searchType = 0;
	
	tableData = [[NSMutableArray alloc] initWithCapacity:20];
	
	textHeightDic = [[NSMutableDictionary alloc] initWithCapacity:20];
	
	// 网络请求对象
	api = [[IWeiboAsyncApi alloc] init];
		
    NSDictionary *plistDic = nil;
    NSDictionary *pathDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"ThemePath"];
    if ([pathDic count] == 0){
        NSString *skinPath = [[NSBundle mainBundle] pathForResource:@"ThemeManager" ofType:@"plist"];
        plistDic = [[NSArray arrayWithContentsOfFile:skinPath] objectAtIndex:0];
    }
    else{
        plistDic = pathDic;
    }
        
    NSString *themePathTemp = [plistDic objectForKey:@"SearchPageSecondImage"];
    self.themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTemp];
    
	searchBarView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"CatalogSearchBar.png"]]];
	[self.view addSubview:searchBarView];
	[searchBarView release];
	
	searchField = [[UITextField alloc] initWithFrame:CGRectMake(6, 5, 265, 28)];
	self.searchField.delegate = self;
	[self.searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged]; 
	self.searchField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
	self.searchField.returnKeyType = UIReturnKeySearch;
	self.searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; 
	if ([self.preText length] != 0) {
		self.searchField.text = self.preText;
		searchEnabled = YES;
	}else {
		self.searchField.placeholder = @"搜索";
	}	
	[self.view addSubview:self.searchField];
	
	// 添加订阅按钮
	rssBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[rssBtn setFrame:CGRectMake(6, 5, 40, 30)];
	if ([self.searchField.text length] == 0) {
		rssBtn.userInteractionEnabled = NO;
	}
	self.searchField.leftView = rssBtn;
	self.searchField.leftViewMode = UITextFieldViewModeAlways;
	
	// 添加取消按钮
	cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(273, 5, 41, 28)];
	[cancelBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	[cancelBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"CatalogSearchCancel.png"]] forState:UIControlStateNormal];
	[self.view addSubview:cancelBtn];
	
	// 添加黑色遮盖视图
	blackView = [[UIView alloc] initWithFrame:CGRectMake(0, SEARCHBARHEIGHT + NAVBTNHEIGHT - 3, SEARCHBARWIDTH, CATALOGTABLEHEIGHT + 2)];
	blackView.tag = 004;
	if ([self.searchField.text length] != 0) {
		blackView.hidden = YES;
	}else {
		blackView.hidden = NO;
	}
	
	// 添加分类列表
	catalogTable = [[UITableView alloc] initWithFrame:CGRectMake(0, SEARCHBARHEIGHT + NAVBTNHEIGHT, 320, CATALOGTABLEHEIGHT) style:UITableViewStylePlain];
	catalogTable.dataSource = self;
	catalogTable.delegate = self;
	[self.view addSubview:catalogTable];
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlack:)];
	[blackView addGestureRecognizer:tapGesture];
	[tapGesture release];
	blackView.backgroundColor = [UIColor blackColor];
	[self.view addSubview:blackView];	
	
	// 添加广播分类按钮
	broadBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SEARCHBARHEIGHT, NAVBTNWIDTH,NAVBTNHEIGHT)];
	broadBtn.tag = 0;
	[broadBtn addTarget:self action:@selector(changeCatalog:) forControlEvents:UIControlEventTouchUpInside];
	[broadBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"CatalogSearchBroadcastSelected.png"]] forState:UIControlStateNormal];

	[self.view addSubview:broadBtn];
	
	// 添加话题分类按钮
	topicBtn = [[UIButton alloc]initWithFrame:CGRectMake(NAVBTNWIDTH, SEARCHBARHEIGHT, NAVBTNWIDTH, NAVBTNHEIGHT)];
	topicBtn.tag = 1;
	[topicBtn addTarget:self action:@selector(changeCatalog:) forControlEvents:UIControlEventTouchUpInside];
	[topicBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"CatalogSearchTopic.png"]] forState:UIControlStateNormal];
	[self.view addSubview:topicBtn];
	
	// 添加用户分类按钮
	userBtn = [[UIButton alloc]initWithFrame:CGRectMake(2*NAVBTNWIDTH, SEARCHBARHEIGHT, NAVBTNWIDTH, NAVBTNHEIGHT)];
	userBtn.tag = 2;
	[userBtn addTarget:self action:@selector(changeCatalog:) forControlEvents:UIControlEventTouchUpInside];
	[userBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"CatalogSearchUser.png"]] forState:UIControlStateNormal];
	[userBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"CatalogSearchUserSelected.png"]] forState:UIControlStateSelected];
	[self.view addSubview:userBtn];
	
	// 将按钮加入导航按钮数组
	navBtnArray = [[NSArray alloc] initWithObjects:broadBtn,topicBtn,userBtn,nil];
	
	// 顶端下拉刷新
	if (refreshHeaderView == nil) {
		refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - catalogTable.bounds.size.height, self.view.frame.size.width, catalogTable.bounds.size.height)];
		[refreshHeaderView setTimeState:EGOBroadCastlastTime];
	}
	[catalogTable addSubview:refreshHeaderView];
	
	// 加载更多
	loadCell = [[LoadCell alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
	catalogTable.tableFooterView = loadCell;
	cupView = [[NoWebView alloc] initWithFrame:CGRectMake(0, 0, SEARCHBARWIDTH, CATALOGTABLEHEIGHT)];
	cupView.hidden = YES;
	NSString *errorText = @"没有找到相关的结果";
	CGSize errorTextSize = [errorText sizeWithFont:[UIFont systemFontOfSize:12]];
	errorLabel = [[UILabel alloc] initWithFrame:CGRectMake((320 - errorTextSize.width)/2, 250, errorTextSize.width, errorTextSize.height)];
	errorLabel.font = [UIFont systemFontOfSize:12];
	errorLabel.backgroundColor = [UIColor clearColor];
	errorLabel.text = errorText;
	errorLabel.hidden = YES;
	[cupView addSubview:errorLabel];
	[self.catalogTable addSubview:cupView];
	
	// 添加常用关键字提示列表
	wordListViewController = [[WordListViewController alloc] initWithStyle:UITableViewStylePlain];
	[wordListViewController.view setFrame:CGRectMake(0, SEARCHBARHEIGHT + NAVBTNHEIGHT, SEARCHBARWIDTH, CATALOGTABLEHEIGHT)];
	wordListViewController.passValueDelegate = self;
	wordListViewController.hideKeyBoardDelegate = self;
	wordListViewController.view.hidden = YES;
	[self.view addSubview:wordListViewController.view];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToFront) name:@"changeValue" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification object:nil]; 
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	self.view.backgroundColor = [UIColor whiteColor];
	// 隐藏导航条
	[self.navigationController setNavigationBarHidden:YES animated:YES]; 
	if (!fromFront) {
		if ([self.preText length] == 0) {
			[self showKeyboard];
		}else {
			[loadCell setHidden:YES];
			if ([[CommonMethod shareInstance] connectionStatus]) {
				mbProgress = [[CommonMethod shareInstance] shareMBProgressHUD:load];
			}else {
				mbProgress = [[CommonMethod shareInstance] shareMBProgressHUD:loadError];
			}		
			[self.navigationController.view addSubview:mbProgress];
			self.pushType = @"2";
			[self requestData:self.preText page:@"1"];
		}
	}else {	
		fromFront = NO;
	}
	//隐藏tabbar
	[self.tabBarController performSelector:@selector(hideNewTabBar)];
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	// 显示导航条
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	//显示tabbar
	[self.tabBarController performSelector:@selector(showNewTabBar)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

// 释放资源
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeValue" object:nil];
    [themePath      release];
	[catalogTable  release];
	[textHeightDic release];
	[tableData     release];
	[api		   release];
	[searchField   release];
	[navBtnArray   release];
    [userBtn       release];
    [broadBtn      release];
    [topicBtn      release];
    [cancelBtn     release];
	[super         dealloc];
}
 
#pragma mark -
#pragma mark 搜索框方法
// 搜索框开始编辑文本
- (void) textFieldDidBeginEditing:(UITextField *)textField{
	[api cancelSpecifiedRequest];
	[self hiddenMBProgress];
	if ([self.searchField.text length] != 0) {
		searchEnabled = NO;
		wordListViewController.view.hidden = NO;
		catalogTable.hidden = YES;
		wordListViewController.searchText = self.searchField.text;
		[wordListViewController updateData];
		[self setWordListHidden:NO];
	}	
}

// 点击搜索按钮响应
- (BOOL)textFieldShouldReturn:(UITextField*)theTextField {
	self.pushType = @"2";
	// 允许搜索
	searchEnabled = YES;		
	// 隐藏搜索列表
	self.catalogTable.hidden = YES;		
	// 隐藏键盘
	[self hideKeyboard];							
	if ([theTextField.text length] != 0) {	
		// 存储搜索关键字
		[self storeSearchTextToDatabase:theTextField.text];	
		if ([[CommonMethod shareInstance] connectionStatus]) {
			mbProgress = [[CommonMethod shareInstance] shareMBProgressHUD:load];
		}else {
			mbProgress = [[CommonMethod shareInstance] shareMBProgressHUD:loadError];
		}				
		// 请求网络数据
		[self requestData:theTextField.text page:@"1"];		
	}
	return YES;
}

// 搜索框文本变化响应
- (void) textFieldDidChange:(UITextField*) TextField{
	NSString *text = [TextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	searchEnabled = NO;
	catalogTable.hidden = YES;
	if ([text length] > 0) {
		blackView.hidden = YES;
		wordListViewController.view.hidden = NO;
		wordListViewController.searchText = TextField.text;
		[wordListViewController updateData];
		[self setWordListHidden:NO];
		[rssBtn setLink:text];	
	}else {
		blackView.hidden = NO;
		wordListViewController.view.hidden = YES;
		[self setWordListHidden:YES];
	}
}	

#pragma mark -
#pragma mark 返回按钮响应
- (void)back{
	// 1. 隐藏加载提示
	[self hiddenMBProgress];
	// 2. 点击返回时，先取消当前的网络请求
	[api cancelSpecifiedRequest];
	// 3. 隐藏键盘
	[self hideKeyboard];
	// 4. 返回上一级控制器
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)storeSearchTextToDatabase:(NSString *)searchText{
	// 先判断字符串是否存在
	NSMutableArray *wordlist = [DataManager getHotSearchFromDatabase];
	if (![wordlist containsObject:searchText]) {
		[DataManager insertHotSearchToDatabase:searchText];
	}
}

// 隐藏提示列表
- (void)setWordListHidden:(BOOL)hidden {
	NSInteger height = hidden ? 0 : CATALOGTABLEHEIGHT;
	[wordListViewController.view setFrame:CGRectMake(0, 80, SEARCHBARWIDTH, height)];
	[self.view bringSubviewToFront:wordListViewController.view];
}

#pragma mark -
#pragma mark 键盘及背景相关方法
// 显示键盘
- (void)showKeyboard{
	[self.searchField becomeFirstResponder];
}

// 隐藏键盘
- (void)hideKeyboard{
	[self.searchField resignFirstResponder];
}

// 点击黑色背景
- (void)tapBlack:(UITapGestureRecognizer *)gesture{
	[self back];
}

#pragma mark -
#pragma mark 分类导航方法
- (void)changeCatalog:(id)sender{
	UIButton *btn = (UIButton *)sender;
	self.searchType = btn.tag;
	btn.userInteractionEnabled = NO;
	
	if([self.searchField.text length] != 0&&searchEnabled){	
		// 如果搜索框中有文本并且执行搜索
		[self.tableData removeAllObjects];
		[self.textHeightDic removeAllObjects];
		[self.catalogTable reloadData];
		[self hideKeyboard];
		[self dataSourceDidFinishLoadingNewData];
		[wordListViewController.view setHidden:YES];
		[loadCell setHidden:YES];
		[cupView setHidden:NO];
		[errorLabel setHidden:YES];
		[api cancelSpecifiedRequest];
		mbProgress = [[CommonMethod shareInstance] shareMBProgressHUD:load];
		if (![[CommonMethod shareInstance] connectionStatus]) {
			mbProgress = [[CommonMethod shareInstance] shareMBProgressHUD:loadError];
			[self performSelector:@selector(hiddenMBProgress) withObject:nil afterDelay:0.5];
		}
		[self.navigationController.view addSubview:mbProgress];
		[self requestData:self.searchField.text page:@"1"];
	}
	
	if([self.searchField.text length] != 0){
		blackView.hidden = YES;
	}else {
		blackView.hidden = NO;
	}
 
	switch (btn.tag) {
		case 0:
		{	
			[btn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"CatalogSearchBroadcastSelected.png"]] forState:UIControlStateNormal];
			rssBtn.userInteractionEnabled = NO;
			((UIButton *)[self.navBtnArray objectAtIndex:1]).userInteractionEnabled = YES;
			((UIButton *)[self.navBtnArray objectAtIndex:2]).userInteractionEnabled = YES;
			[((UIButton *)[self.navBtnArray objectAtIndex:1]) setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent: @"CatalogSearchTopic.png"]] forState:UIControlStateNormal];
			[((UIButton *)[self.navBtnArray objectAtIndex:2]) setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"CatalogSearchUser.png"]] forState:UIControlStateNormal];
		}
			break;
		case 1:
		{
			[btn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"CatalogSearchTopicSelected.png"]] forState:UIControlStateNormal];
			rssBtn.userInteractionEnabled = YES;
			((UIButton *)[self.navBtnArray objectAtIndex:0]).userInteractionEnabled = YES;
			((UIButton *)[self.navBtnArray objectAtIndex:2]).userInteractionEnabled = YES;
			[((UIButton *)[self.navBtnArray objectAtIndex:0]) setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"CatalogSearchBroadcast.png"]] forState:UIControlStateNormal];
			[((UIButton *)[self.navBtnArray objectAtIndex:2]) setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"CatalogSearchUser.png"]] forState:UIControlStateNormal];
		}
			break;
		case 2:
		{
			[btn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"CatalogSearchUserSelected.png"]] forState:UIControlStateNormal];
			rssBtn.userInteractionEnabled = NO;
			((UIButton *)[self.navBtnArray objectAtIndex:0]).userInteractionEnabled = YES;
			((UIButton *)[self.navBtnArray objectAtIndex:1]).userInteractionEnabled = YES;
			[((UIButton *)[self.navBtnArray objectAtIndex:0]) setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"CatalogSearchBroadcast.png"]] forState:UIControlStateNormal];
			[((UIButton *)[self.navBtnArray objectAtIndex:1]) setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"CatalogSearchTopic.png"]] forState:UIControlStateNormal];
		}
			break;
		default:
			break;
	}
}

#pragma mark -
#pragma mark 请求网络数据
- (void)requestData:(NSString *)keyWord page:(NSString *)page{
	// 初始化请求字典
	NSMutableDictionary *reqDict = [[NSMutableDictionary alloc] initWithCapacity:10];
	[reqDict setValue:@"json" forKey:@"format"];
	[reqDict setValue:keyWord forKey:@"keyword"];
	[reqDict setValue:@"20" forKey:@"pagesize"];
	[reqDict setValue:page forKey:@"page"];
	switch (self.searchType) {
		case SearchBroadType:
		{
			NSLog(@"请求广播:%@",keyWord);
			[reqDict setValue:URL_SEARCH_WEIBO forKey:@"request_api"];
			[api searchWeiboWithParamters:reqDict delegate:self onSuccess:@selector(successCallBack:) onFailure:@selector(failureCallBack:)];
		}
			break;
		case SearchTopicType:
			NSLog(@"请求话题:%@",keyWord);
			[reqDict setValue:URL_SEARCH_TOPIC forKey:@"request_api"];
			[api searchTopicWithparamters:reqDict delegate:self onSuccess:@selector(successCallBack:) onFailure:@selector(failureCallBack:)];
			break;
		case SearchUserType:
		{
			NSLog(@"请求用户:%@",keyWord);
			[reqDict setValue:URL_SEARCH_USER forKey:@"request_api"];
			[api searchUserWithParamters:reqDict delegate:self onSuccess:@selector(successCallBack:) onFailure:@selector(failureCallBack:)];
		}
			break;
		default:
			break;
	}
	[reqDict release];
}

// 请求成功回调方法
- (void)successCallBack:(NSDictionary *)result{
	[MessageViewUtility printAvailableMemory];
	NSLog(@"请求成功!\t result:%@",result);
	// 1. 隐藏加载动画
	 [self hiddenMBProgress];
	[cupView setHidden:YES];
	// 2. 隐藏提示列表
	wordListViewController.view.hidden = YES;
	// 3. 初始化
	NSMutableArray *resultArray = nil;
	Info *dataInfo = nil;
	isLoading = YES;
	NSDictionary *dict = [DataCheck checkDictionary:result forKey:@"data" withType:[NSDictionary class]];
	if ([dict isKindOfClass:[NSDictionary class]]&&![[dict objectForKey:@"info"] isEqual:[NSNull null]]) {
		resultArray = [DataConverter convertToArray:result withType:self.searchType];
		NSNumber *hasNext = nil;
		if (nil != [dict objectForKey:@"hasnext"]) {
			hasNext = [DataCheck checkDictionary:dict forKey:@"hasnext" withType:[NSNumber class]];
		}
		if ([hasNext isKindOfClass:[NSNumber class]]) {
			NSUInteger next = [[[result objectForKey:@"data"] objectForKey:@"hasnext"] intValue];
			if (next == 0||next == 2) {
				isHasNext = NO;
			}else if (next == 1) {
				isHasNext = YES;
			}
		}else {
			if ([resultArray count] < 20) {
				isHasNext = NO;
			}else {
				isHasNext = YES;
			}
		}
		[loadCell setHidden:NO];
		NSLog(@"isHasNext:%d",isHasNext);
		// 设置加载更多状态
		if (isHasNext) {    
			// 如果有下一条，设置状态为更多
			[loadCell setState:loadMore1];
		}
		else {			
			// 否则设置状态为加载完成
			[loadCell setState:loadFinished];
		}
		
		//下拉刷新
		if ([pushType isEqualToString:@"0"]) {
			[textHeightDic removeAllObjects];
			[self.tableData removeAllObjects];
			if ([resultArray count] == 0) {
				[errorLabel setHidden:NO];
				[cupView setHidden:NO];
				[loadCell setHidden:YES];
			}
			for (int i=0; i<[resultArray count]; i++) {
				dataInfo = [resultArray objectAtIndex:i];
				[self.tableData addObject:dataInfo];
			}
			[self dataSourceDidFinishLoadingNewData];
		}
		
		//加载更多
		if ([pushType isEqualToString:@"1"]) {
			for (int i=0; i<[resultArray count]; i++) {
				dataInfo = [resultArray objectAtIndex:i];
				[self.tableData addObject:dataInfo];
			}
		}		
		
		//首次请求网络
		if ([pushType isEqualToString:@"2"]) {
			// 清空存高度的字典
			[textHeightDic removeAllObjects];			
			[self.tableData removeAllObjects];
			if ([resultArray count] == 0) {
				[errorLabel setHidden:NO];
				[cupView setHidden:NO];
				[loadCell setHidden:YES];
			}
			for (int i=0; i<[resultArray count]; i++) {          
				dataInfo = [resultArray objectAtIndex:i];
				[self.tableData addObject:dataInfo];
			}
		}
		if ([dict objectForKey:@"user"] != nil) {
			// 存储用户昵称
			NSDictionary *userNicks = [DataCheck checkDictionary:dict forKey:@"user" withType:[NSDictionary class]];
			if ([userNicks isKindOfClass:[NSDictionary class]]) {
				// 存到数据库
				[DataManager insertUserInfoToDBWithDic:userNicks];
				// 存到本地字典
				[HomePage insertNickNameToDictionaryWithDic:userNicks];
			}			
		}
				
		[self.catalogTable reloadData];
	}else {
		[textHeightDic removeAllObjects];
		[self.tableData removeAllObjects];
		[self.catalogTable reloadData];
		[self dataSourceDidFinishLoadingNewData];
		[errorLabel setHidden:NO];
		[cupView setHidden:NO];
		[loadCell setHidden:YES];
	}
}

// 请求失败回调方法
- (void)failureCallBack:(NSError *)error{
	NSLog(@"getHotTopicInfoFailure:%@", [error localizedDescription]);
	if ([error code] == ASIRequestTimedOutErrorType || [error code] == ASIConnectionFailureErrorType) {
		[wordListViewController.view setHidden:YES];
		[loadCell setHidden:YES];
		[errorLabel setHidden:NO];
		[cupView setHidden:NO];
		mbProgress = [[CommonMethod shareInstance] shareMBProgressHUD:loadError];
		[self.navigationController.view addSubview:mbProgress];
	}	
	[self performSelector:@selector(hiddenMBProgress) withObject:nil afterDelay:0.3];
	[self dataSourceDidFinishLoadingNewData];
}

#pragma mark -
#pragma mark 隐藏加载动画
- (void) hiddenMBProgress{
    [self.catalogTable setHidden:NO];
    [mbProgress hide:YES];
}

//延迟隐藏
- (void)hideDelayed{
	[progressHUD hide:YES];
}
 
#pragma mark -
#pragma mark PassValueDelegate Method
- (void)passValue:(NSString *)value{
	if (value) {
		self.searchField.text = value;
		[self textFieldShouldReturn:self.searchField];
	}else {
		
	}
}

#pragma mark -
#pragma mark HideKeyBoardDelegate Method
- (void)hide{
	[self hideKeyboard];
}

#pragma mark -
#pragma mark UITableViewDataSource Method
// 列表行数
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if ([self.tableData count] > 0) {
		return [self.tableData count];
	}else {
		return 0;
	}
}

// 列表行高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat height = 0.0f;
	switch (self.searchType) {
		case SearchBroadType:
			if (indexPath.row < [self.tableData count]) {
				height = [self getRowHeight:indexPath.row];
			}
			else {
				height = self.catalogTable.bounds.size.height+BOTTOMHEIGHT;  
			}			
			break;
		case SearchTopicType:
			height = TOPICLISTHEIGHT;
			break;
		case SearchUserType:
			height = USERLISTHEIGHT;
			break;
		default:
			break;
	}
	return height;
}

// 列表内容呈现
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSUInteger row = indexPath.row;
	UITableViewCell *tableViewCell = nil;
	if (row < [self.tableData count]) {
		switch (self.searchType) {
			case SearchBroadType:
			{		
				static NSString *broadIdentifier = @"broadIdentifier";
				HomelineCell *cell = (HomelineCell *)[tableView dequeueReusableCellWithIdentifier:broadIdentifier];
				if (cell == nil) {
					cell = [[[HomelineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:broadIdentifier showStyle:HomeShowSytle sourceStyle:HomeSourceSytle containHead:YES] autorelease];
					cell.myHomelineCellVideoDelegate = self;
					cell.contentView.backgroundColor = [UIColor clearColor];
					cell.rootContrlType = 3;
				}
				Info *info = [self.tableData objectAtIndex:row];
					
				cell.heightDic = self.textHeightDic;
				cell.remRow = [NSString stringWithFormat:@"%d", row];
				cell.homeInfo = info;
				[cell setLabelInfo:info];
				
				if (![[[self.tableData objectAtIndex:row] source] isMemberOfClass:[NSNull class]]){
					if (info.source != nil) {
						TransInfo *transInfo = [self convertSourceToTransInfo:info.source];
						cell.sourceInfo = transInfo;
					}else {
						[cell remove];
					}
				}
				tableViewCell = cell;
			}
				break;
			case SearchTopicType:
			{
				static NSString *topicIdentifier = @"topicIdentifier";
				UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topicIdentifier];
				if (cell == nil) {
					cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topicIdentifier] autorelease];
					UIView *selectedView = [[UIView alloc] initWithFrame:cell.contentView.frame];
					selectedView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:0.933];
					cell.selectedBackgroundView = selectedView; 
					[selectedView release];					
				}
				HotTopicInfo *hotTopicInfo =  [self.tableData objectAtIndex:row];
				cell.textLabel.text = hotTopicInfo.topicName;
				tableViewCell = cell;
			}
				break;
			case SearchUserType:
			{
				NSString *userIdentifier = [NSString stringWithFormat:@"userIdentifier%d",row];
				UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userIdentifier];
				if (cell == nil) {
					cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier] autorelease];
				
					UIView *selectedView = [[UIView alloc] initWithFrame:cell.contentView.frame];
					selectedView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:0.933];
					cell.selectedBackgroundView = selectedView; 
					[selectedView release];					
					
					// 头像图片
					AsynchronousImageView *headImage = [[AsynchronousImageView alloc] initWithFrame:CGRectMake(6, 7, 46, 46)];
					headImage.tag = 100;
					CALayer *layer = [headImage layer];
					layer.masksToBounds = YES;
					layer.cornerRadius = 8;
					[cell.contentView addSubview:headImage];
					[headImage release];
					
					// 昵称标签
					UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 4, 180, 30)];
					nickLabel.tag = 101;
					nickLabel.backgroundColor = [UIColor clearColor];
					nickLabel.font = [UIFont systemFontOfSize:16];
					nickLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
					[cell.contentView addSubview:nickLabel];
					[nickLabel release];
					
					// 用户名标签
					UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 31, 180, 20)];
					nameLabel.tag = 102;
					nameLabel.backgroundColor = [UIColor clearColor];
					nameLabel.font = [UIFont systemFontOfSize:12];
					nameLabel.textColor = [UIColor colorWithRed:99/255 green:99/255 blue:99/255 alpha:0.6];
					[cell.contentView addSubview:nameLabel];
					[nameLabel release];	
				}
			 
				if ([self.tableData count] > 0) {
					Info *info = [self.tableData objectAtIndex:row];
					AsynchronousImageView *headView = (AsynchronousImageView *)[cell.contentView viewWithTag:100];
					UILabel *_nickLabel = (UILabel *)[cell.contentView viewWithTag:101];
					UILabel *_nameLabel = (UILabel *)[cell.contentView viewWithTag:102];
					_nickLabel.text = info.nick;
					_nameLabel.text = info.name;
					BOOL bIsVip = [info.isvip boolValue] == 0 ? NO:YES;
					headView.isVip = bIsVip;
					[headView loadHeadImageFromURLString:info.head WithRequestType:RequestFromFriendsFansSearch];
				}		
				tableViewCell = cell;
			}
				break;
			default:
				break;
		}
	}else {
		NSString *cellIdentifier = @"cellIdentifier";
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		}
		tableViewCell = cell;
	}	
	return tableViewCell;
}

#pragma mark -
#pragma mark  UITableViewDelegate Method
// 列表点击响应
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSUInteger row = indexPath.row;
	Info *info = [self.tableData objectAtIndex:row];
	if (row < [self.tableData count]) {
		switch (self.searchType) {
			case SearchBroadType:
			{
				fromFront = YES;
				DetailsPage  *details = [[DetailsPage alloc] init];
				details.rootContrlType = 3;
				details.homeInfo = info;
				if (![info.source isMemberOfClass:[NSNull class]]){
					if (info.source != nil) {
						TransInfo *transInfo = [self convertSourceToTransInfo:info.source];
						details.sourceInfo = transInfo;
					}
				}
				[self.navigationController pushViewController:details animated:YES];
				[self.tabBarController performSelector:@selector(hideNewTabBar)];//隐藏tabbar
				[details release];
			}
				break;
			case SearchTopicType:
			{
				fromFront = YES;
				HotTopicInfo *hotTopicInfo = [self.tableData objectAtIndex:row];
				HotTopicDetailController *hotTopicDetailController = [[HotTopicDetailController alloc] init];
				hotTopicDetailController.searchString = hotTopicInfo.topicName;
				hotTopicDetailController.hotTopicIDString = hotTopicInfo.hotTopicID;
				[self.navigationController pushViewController:hotTopicDetailController animated:YES];
				[self.tabBarController performSelector:@selector(hideNewTabBar)];//隐藏tabbar
				[hotTopicDetailController release];				
			}
				break;
			case SearchUserType:
				fromFront = YES;
				[[PushAndRequest shareInstance] pushControllerType:3 withName:info.name];
				break;
			default:
				break;
			}
	}else {
		[self loadMoreStatuses];
		NSArray *indexPathes = [tableView indexPathsForVisibleRows];
		NSIndexPath *lastIndexPath = [indexPathes objectAtIndex:indexPathes.count-1];
		[tableView reloadData];
		[tableView scrollToRowAtIndexPath:lastIndexPath
						 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
}

#pragma mark -
#pragma mark 滑动tableView响应
- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
	[self hideKeyboard];
	if (scrollView.isDragging) {
		if (!reloading) {
			if (scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f ) {
				[refreshHeaderView setState:EGOOPullRefreshNormal];
				[refreshHeaderView setCurrentDate:EGOBroadCastlastTime withDateUpdated:NO];
			}
			else {
				[refreshHeaderView setState:EGOOPullRefreshPulling];
				NSTimeInterval now=[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
				[refreshHeaderView setLasttimeState:EGOBroadCastlastTime :now];
			}
		}
	}
 }

// 滚动视图结束拖拽，将要减速时调用
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (scrollView.contentOffset.y <= - 65.0f && !reloading) {
		reloading = YES;
		[api cancelSpecifiedRequest];
		[refreshHeaderView setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		catalogTable.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		if (![[CommonMethod shareInstance] connectionStatus]) {
			[self.catalogTable reloadData];
			mbProgress = [[CommonMethod shareInstance] shareMBProgressHUD:load];
		}else {
			[self hiddenMBProgress];
		}
		errorLabel.hidden = YES;
		[self performSelector:@selector(reloadNewDataSource) withObject:nil afterDelay:0.25];	
	}
}

// 滚动视图停止滑动时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	// 1. 获取tableview
	UITableView *tableView = (UITableView *)scrollView;		
	// 2. 获取tableview中可见的cell
	NSArray *indexPathes = [tableView indexPathsForVisibleRows];	
	if (indexPathes.count > 0) {									
		// 3. 如果可见的行大于0
		int rowCounts = [tableView numberOfRowsInSection:0];		
		NSIndexPath *lastIndexPath = [indexPathes objectAtIndex:indexPathes.count-1]; 
		if (rowCounts - lastIndexPath.row < 2 && isLoading) {		
			[loadCell setState:loading1];
			BOOL conncetStatus = [[CommonMethod shareInstance] connectionStatus];
			if (conncetStatus){
				// 是否还有数据
				if (isHasNext) {
					isLoading = NO;
					[loadCell setState:loadMore1];
					[self performSelector:@selector(handleTimer:) withObject:nil afterDelay:1];	
				}else {
					[loadCell setState:loadFinished];
				}
			}
		}
	}
}

#pragma mark -
#pragma mark 数据刷新
// 下拉刷新完成恢复原位
- (void)dataSourceDidFinishLoadingNewData{
	reloading = NO;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[catalogTable setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	[refreshHeaderView setState:EGOOPullRefreshNormal];
}

//加载获取更多
- (void)loadMoreStatuses{  
	if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable) 
		&& ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
		[self hiddenMBProgress];
		[loadCell setState:errorInfo];
		catalogTable.tableFooterView = loadCell;
	}
	else {
		self.pushType = @"1";
		NSString *pageNum = @"1";
		pageNum = [NSString stringWithFormat:@"%d",[self.tableData count]/20 + 1];
		[self requestData:self.searchField.text page:pageNum];
	}
}

- (void)reloadNewDataSource{
	if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable) 
		&& ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
		[self.tableData removeAllObjects];
		[self dataSourceDidFinishLoadingNewData];
		[cupView setHidden:NO];
		[errorLabel setHidden:NO];
		[loadCell setHidden:YES];
		[self.tableData removeAllObjects];
		[self.textHeightDic removeAllObjects];
		[self.catalogTable reloadData];
		if (![[CommonMethod shareInstance] connectionStatus]) {
			mbProgress = [[CommonMethod shareInstance] shareMBProgressHUD:loadError];
			[self performSelector:@selector(hiddenMBProgress) withObject:nil afterDelay:0.5];
		}
	}
	else {
		self.pushType = @"0";
		[self requestData:self.searchField.text page:@"1"];
		if ([self.tableData count] == 0) {
			if ([[CommonMethod shareInstance] connectionStatus]) {
				mbProgress = [[CommonMethod shareInstance] shareMBProgressHUD:load];
			}else {
				mbProgress = [[CommonMethod shareInstance] shareMBProgressHUD:loadError];
			}
		}
	}
}

- (void)handleTimer:(NSTimer *)timer{
	reloading = NO;
	[loadCell setState:loading1];
	[self loadMoreStatuses];
}

#pragma mark -
#pragma mark 计算广播高度
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
		Info *info = [self.tableData objectAtIndex:row];
		CGFloat origHeight = 0.0f;
		CGFloat sourceHeight = 0.0f;
		CGFloat retValue = 0.0f;
		origHeight = [MessageViewUtility getTimelineOriginViewHeight:info];
		if (info.source != nil) {
			TransInfo *transInfo = [self convertSourceToTransInfo:info.source];
			sourceHeight = [MessageViewUtility getTimelineSourceViewHeight:transInfo];
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

#pragma mark -
#pragma mark 数据类型转换
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

- (void)backToFront{
	fromFront = YES;
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

#pragma mark protocol HomelineCellVideoDelegate<NSObject> 视频点击事件
- (void)HomelineCellVideoClicked:(NSString *)urlVideo {	
	CLog(@"HomelineCellVideoClicked:%@", urlVideo); 
	WebUrlViewController *webUrlViewController = [[WebUrlViewController alloc] init];
	webUrlViewController.webUrl = urlVideo;
	[self.navigationController pushViewController:webUrlViewController animated:YES];
	[webUrlViewController release];
}


@end
