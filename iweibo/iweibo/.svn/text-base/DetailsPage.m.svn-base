//
//  DetailsPage.m
//  iweibo
//
//  Created by LiQiang on 11-12-23.
//  Copyright 2011年 Beyondsoft. All rights reserved.
//

#import "DetailsPage.h"
#import "CommOrTrans.h"
#import "DetailView.h"
#import "HomelineCell.h"
#import "DetailCell.h"
#import "LoadCell.h"
#import "Canstants_Data.h"
#import "CommOrTransInfo.h"
#import "ComposeViewControllerBuilder.h"
#import "WebUrlViewController.h"
#import "IWeiboAsyncApi.h"
#import "CalculateUtil.h"
#import "DetailPageConst.h"
#import "MessageViewUtility.h"
#import "PushAndRequest.h"
#import "HpThemeManager.h"
#import "CustomNavigationbar.h"
#import "DisaplayMapViewController.h"
#import "SCAppUtils.h"

@implementation DetailsPage
@synthesize detailHeaderView,listView,loadMoreCell;
@synthesize homeInfo,sourceInfo,heightDiction;
@synthesize oHeight,sHeight,aApi,detailArray;
@synthesize oldTimeStamp;
@synthesize plistDic,leftButton;
@synthesize broadCastImage,errorCastImage,IconCastImage,broadCastLabel;
@synthesize rootContrlType;
@synthesize actionType;
//@synthesize heightx;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:kThemeDidChangeNotification 
                                                  object:nil];
	[errorCastImage release];
	[IconCastImage release];
	[broadCastImage release];
	[broadCastLabel release];
	[detailHeaderView release];
	[leftButton release];
	[listView release];
	[detailArray release];
	[loadMoreCell release];
	[aApi release];
	aApi = nil;
	[oldTimeStamp release];
//	CLog(@"%s", __FUNCTION__);
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"WebUrlClicked" object:nil];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
//点击转播触发
- (void)transmitBtnAction{
    CLog(@"点击转播按钮");
	ComposeBaseViewController	*composeViewController =  [ComposeViewControllerBuilder createWithComposeMsgType:FORWORD_MESSAGE];
	[self initSendDraft:composeViewController draftType:FORWORD_MESSAGE];
	UINavigationController		*composeNavController = [[[UINavigationController alloc] initWithRootViewController:composeViewController] autorelease];
    [self presentModalViewController:composeNavController animated:YES];
	// composeViewController无需手动释放
	//[ComposeViewControllerBuilder desposeViewController:composeViewController];	
}

//点击评论触发
- (void)commentBtnAction{
    CLog(@"点击评论按钮");
	ComposeBaseViewController	*composeViewController =  [ComposeViewControllerBuilder createWithComposeMsgType:COMMENT_MESSAGE];
	[self initSendDraft:composeViewController draftType:COMMENT_MESSAGE];
	UINavigationController		*composeNavController = [[[UINavigationController alloc] initWithRootViewController:composeViewController] autorelease];
    [self presentModalViewController:composeNavController animated:YES];
	// composeViewController无需手动释放
	//[ComposeViewControllerBuilder desposeViewController:composeViewController];
	
}

//点击对XX说触发
- (void)speakToBtnAction{
	Draft *draft = [[Draft alloc] init];
	draft.uid = homeInfo.uid;
	draft.timeStamp = homeInfo.timeStamp;
	draft.draftType = TALK_TO_MESSAGE;
	draft.draftTitle = homeInfo.nick;
	draft.talkToUserName = homeInfo.name;
	draft.draftForwardOrCommentText = homeInfo.origtext;
	// lichentao 2012-03-06 对话部分，判断转发内容是否有图片,在草稿部分进行标记
	BOOL hasOriginViewPic = [homeInfo.image length] > 0 ? YES: NO;
	if (hasOriginViewPic) {
		NSNumber *hasPic = [[NSNumber alloc] initWithInt:1];
		draft.isHasPic = hasPic;// 对xx说originView有图片
		[hasPic release];
	}else {
		NSNumber *hasPic = [[NSNumber alloc] initWithInt:0];
		draft.isHasPic = hasPic;// 对xxx说originView没有图片
		[hasPic release];
	}
	// textView中显示空内容
	draft.draftText = @"";
	draft.fromDraftString = draft.draftText;
	ComposeBaseViewController	*composeViewController =  [ComposeViewControllerBuilder createWithDraft:draft];
	[draft release];
	UINavigationController		*composeNavController = [[[UINavigationController alloc] initWithRootViewController:composeViewController] autorelease];
    [self presentModalViewController:composeNavController animated:YES];
	// composeViewController无需手动释放
	//[ComposeViewControllerBuilder desposeViewController:composeViewController];
}

// 点击转播||评论||对someBody说 显示草稿内容
- (BOOL)initSendDraft :(ComposeBaseViewController *)composeBaseViewController draftType:(ComposeMsgType)draftType{	 
	Draft *draft = [[Draft alloc] init];
	draft.uid = homeInfo.uid;			  // 转发部分的唯一id
	draft.timeStamp = homeInfo.timeStamp; // 转发的时间
	draft.draftType = draftType;		  // 发送的类型	
	draft.draftTitle = homeInfo.nick;	  // nick	
	draft.draftForwardOrCommentText = homeInfo.origtext;
	BOOL hasOriginViewPic = [homeInfo.image length] > 0 ? YES: NO;
	if (hasOriginViewPic) {
		draft.isHasPic = [NSNumber numberWithInt:1];// 表示转发或者评论originView部分有图片
	}else {
		draft.isHasPic = [NSNumber numberWithInt:0];// 标识转发或者评论originView部分没有图片
	}
	// 判断是否是原创，如果是则在textView中不在显示文本信息,直接转播出去
	if (sourceInfo.transNick != nil) {
		NSString *textViewString = [[NSString alloc] initWithFormat:@"|| @%@:%@",homeInfo.name,homeInfo.origtext];
		draft.draftText = textViewString;
		[textViewString release];		
	}else {
	// textView中显示空内容
		draft.draftText = [NSString stringWithFormat:@" "];
	}	
	draft.fromDraftString = draft.draftText;// 拷贝从转播或者评论进入消息页面lichnetao 2012 - 03-10
	[composeBaseViewController initWithDraft:draft];
	[draft release];
	return YES;
}

//点击更多按钮触发
- (void)moreMsgBtnAction{
	/*
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择要进行的操作"
                                                             delegate:self 
                                                    cancelButtonTitle:@"取消" 
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"对话",@"复制文本",nil];
    actionSheet.tag = 001;
    //actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	// 显示有问题
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet release];
	*/
	UIActionSheet *sheet = [[UIActionSheet alloc]
							initWithTitle: @"请选择要进行的操作"
							delegate:self
							cancelButtonTitle:nil
							destructiveButtonTitle:nil
							otherButtonTitles:nil];
		// 逐个添加按钮（比如可以是数组循环）  
	sheet.tag = 001; 
	[sheet addButtonWithTitle:@"对话"];
	[sheet addButtonWithTitle:@"复制文本"];
	
		// 同时添加一个取消按钮  
	[sheet addButtonWithTitle:@"取消"];  
		// 将取消按钮的index设置成我们刚添加的那个按钮，这样在delegate中就可以知道是那个按钮  
	sheet.cancelButtonIndex = sheet.numberOfButtons-1;  
	[sheet showFromRect:self.view.bounds inView:self.view animated:YES];  
	[sheet release];  
	
}

#pragma mark -
#pragma mark UIActionSheetDelegate Method
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    CLog(@"button索引%d",buttonIndex);
	switch (actionSheet.tag) {
		case 001:
			switch (buttonIndex) {
				case 0:						// 对话
					[self speakToBtnAction];
					break;
				case 1:						// 复制文本
				{
					UIPasteboard *pb = [UIPasteboard generalPasteboard];
//					CLog(@"%@", homeInfo.origtext);
					NSString *strCopy = [homeInfo.origtext copy];
					[strCopy release];
						// 需要组合字符串(未完成)
					[pb setString:homeInfo.origtext];
				}
					break;
				default:					// 取消
					break;
			}			
			break;
		case 002:
//			NSLog(@"buttonIndex:%d",buttonIndex);
			switch (buttonIndex) {
				case 0:				// 个人资料
				{
					[self toWhere:[detailArray objectAtIndex:rowNum] withType:personalDataAction];
				}
					break;
				case 1:				// 转播处理
				{		
					[self toWhere:[detailArray objectAtIndex:rowNum] withType:broadcastAction];
				}
					break;
				case 2:				// 评论处理
				{
					[self toWhere:[detailArray objectAtIndex:rowNum] withType:commentsAction];
				}
					break;
				case 3:				// 对话处理
				{
					[self toWhere:[detailArray objectAtIndex:rowNum] withType:dialogueAction];
				}
					break;
				default:
					break;
			}
			break;
		default:
			break;
	}
}

#pragma mark - View lifecycle

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

#pragma mark -
#pragma mark storeIntoClass
-(NSMutableArray *)storeIntoClass:(NSDictionary *)dic{
	NSDictionary *listen = [[dic objectForKey:@"data"] objectForKey:@"info"];
	NSMutableArray *detailArr = [NSMutableArray arrayWithCapacity:5];
	if (![listen isEqual:[NSNull null]]) {
		for (NSDictionary *l in listen) {
			NSString  *text = nil;
			NSString *time = [[NSString alloc] initWithFormat:@"%@",[l objectForKey:HOMETIME]]; 
			self.oldTimeStamp = time;
			[time release];
			CommOrTransInfo *lis = [[CommOrTransInfo alloc] init];
			if ([l isKindOfClass:[NSDictionary class]] && l) {
				//NSString *text = [[l objectForKey:@"text"]stringByReplacingOccurrencesOfString:@" " withString:@""];  
				//NSString *text = [[l objectForKey:@"text"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				NSString *originText = [l objectForKey:@"text"];
				NSArray *array = [originText componentsSeparatedByString:@"||"];
				if ([array count]!=0) {
					text = [[array objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				}
	
				if ([text length] > 0) {
					lis.uid = [l objectForKey:@"id"];
					lis.nick = [l objectForKey:@"nick"];  
					lis.name = [l objectForKey:@"name"];
					lis.text = text;
					lis.isvip = [NSString stringWithFormat:@"%@",[l valueForKey:@"isvip"]];
					lis.localAuth = [NSString stringWithFormat:@"%@",[l valueForKey:@"is_auth"]];
					lis.type = [NSString stringWithFormat:@"%@",[l valueForKey:@"type"]];
					lis.time = [NSString stringWithFormat:@"%@",[l valueForKey:@"timestamp"]];
					[detailArr addObject:lis];
				}
			}
			[lis release];
		}
//		if ([detailArr count]!=0) {
//			self.newTimeStamp = [NSString stringWithFormat:@"%@",[[detailArr objectAtIndex:0] time]];
//			self.oldTimeStamp = [NSString stringWithFormat:@"%@",[[detailArr objectAtIndex:[detailArr count]-1] time]];
//		}
	}
	return detailArr;
}

#pragma mark -
#pragma mark caculate Row count and Row height 

- (void)refreshTable{
	[listView reloadData];
}

//计算返回的行数
- (NSUInteger)returnCount:(NSDictionary *)dic{
	NSDictionary *infoDic = [[dic objectForKey:@"data"] objectForKey:@"info"];
	NSUInteger sum = 0;
	if (![infoDic isMemberOfClass:[NSNull class]]) {
		sum = [infoDic count];
	}
	return sum;
}

- (void)changeState{
	[loadMoreCell setState:loading1];
}

#pragma mark -
#pragma mark requestCallback

- (void)reListSuccess:(NSDictionary *)reDic{
	NSLog(@"%@",[reDic objectForKey:@"msg"]);
	isLoading = YES;
	NSDictionary *data =[DataCheck checkDictionary:reDic forKey:HOMEDATA withType:[NSDictionary class]];
	if ([data isKindOfClass:[NSNull class]]) {
		[loadMoreCell setState:loadMore1];
		return;
	}
	BOOL hasnext = [[data objectForKey:HOMEHASNEXT]boolValue];
	NSMutableArray *arr = [self storeIntoClass:reDic];
	NSUInteger sum =[self returnCount:reDic];
	for (int i = 0; i<[arr count]; i++) {
		[detailArray addObject:[arr objectAtIndex:i]];
	}
	if (!hasnext) {
		[loadMoreCell setState:loadMore1];
		if (firstLogin) {
			firstLogin = NO;
			[self performSelector:@selector(changeState) withObject:nil afterDelay:0.5];
		}
		[listView reloadData];
	}
	else {
		if (0 == sum && 0 ==[detailArray count]) {
			[loadMoreCell setState:intermitCom];
		}
		else {
			[loadMoreCell setState:loadFinished];
			[listView reloadData];
		}
	}
	if ([data isKindOfClass:[NSDictionary class]]&&nil != [data objectForKey:@"user"]) {
			// 存储用户昵称
		NSDictionary *userNicks = [DataCheck checkDictionary:data forKey:@"user" withType:[NSDictionary class]];
		if ([userNicks isKindOfClass:[NSDictionary class]]) {
				// 存到数据库
			[DataManager insertUserInfoToDBWithDic:userNicks];
				// 存到本地字典
			[HomePage insertNickNameToDictionaryWithDic:userNicks];
		}
	}	
}

- (void)reListFailure:(NSError *)error{
//	[self hiddenMBProgress];
	broadCastLabel.text = @"网络错误，请重试";
	errorCastImage.hidden = NO;
	IconCastImage.hidden = YES;
	[loadMoreCell setState:loadMore1];
	[self moveDown];
}

-(void) requstWebService:(NSString *)rootid:(NSString *)pagetime:(NSString *)pageflag{
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithCapacity:10];
	[parameters setValue:@"json" forKey:@"format"];
	[parameters setValue:@"2" forKey:@"flag"];
	[parameters setValue:rootid forKey:@"rootid"];
	[parameters setValue:pageflag forKey:@"pageflag"];
	[parameters setValue:pagetime forKey:@"pagetime"];
	[parameters setValue:@"30" forKey:@"reqnum"];
	[parameters setValue:@"0" forKey:@"twitterid"];
	[parameters setValue:URL_RE_LIST forKey:@"request_api"];
	
	[aApi getWeiboRelistWithParamteers:parameters
							delegate:self
						   onSuccess:@selector(reListSuccess:) onFailure:@selector(reListFailure:)];
	[parameters release];
}

- (void)handleTimer{
	[loadMoreCell setState:loading1];
	[self requstWebService:homeInfo.uid :oldTimeStamp :@"1"];
}

- (void)goBack:(id)sender {
	self.sourceInfo.sourceImageData = nil;
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark viewDidLoad
- (void)updateTheme:(NSNotificationCenter *)noti{
    self.plistDic = [[HpThemeManager sharedThemeManager] themeDictionary];
    NSString *themePathTmp = [plistDic objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    if (themePath) {
        [leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
	firstLogin = YES;
	self.view.backgroundColor = [UIColor clearColor];
    
    NSDictionary *pathDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"ThemePath"];
    if ([pathDic count] == 0){
        NSString *skinPath = [[NSBundle mainBundle] pathForResource:@"ThemeManager" ofType:@"plist"];
        self.plistDic = [[NSArray arrayWithContentsOfFile:skinPath] objectAtIndex:0];
    }
    else{
        self.plistDic = pathDic;
    }
    NSString *themePathTmp = [plistDic objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    
    NSString *themePathTmpSingleMessage = [plistDic objectForKey:@"SingleMessageImage"];
	NSString *themePathSingle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmpSingleMessage];
    
    UIImage *navImage = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"navigationbar_bg.png"]];
    [SCAppUtils navigationController:self.navigationController setImage:navImage];
    
	UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
	[customLab setTextColor:[UIColor whiteColor]];
	
	if ([self.homeInfo.type isEqualToString:@"1"]) {
		[customLab setText:@"广播"];
	}
	else if([self.homeInfo.type isEqualToString:@"2"]){
		[customLab setText:@"转播"];
	}
	else if([self.homeInfo.type isEqualToString:@"7"]){
		[customLab setText:@"评论"];
	}
	else if([self.homeInfo.type isEqualToString:@"4"]){
		[customLab setText:@"对话"];
	}
	[customLab setTextAlignment:UITextAlignmentCenter];
	customLab.backgroundColor = [UIColor clearColor];
	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	self.navigationItem.titleView = customLab;
	[customLab release];
	
// 导航条返回按钮
	leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
	[leftButton setTitle:@"返回" forState:UIControlStateNormal];
	leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
	[leftButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 5)];
    if (themePath) {
        [leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
    }
	
	[leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
	self.navigationItem.leftBarButtonItem = leftBar;
	[leftBar release];
	
	aApi = [[IWeiboAsyncApi alloc] init];
	detailArray = [[NSMutableArray alloc] init];
	CGRect rc = CGRectMake(0, 0, 320, 416);
	if (listView == nil)
	{
		listView = [[UITableView alloc] initWithFrame:rc style:UITableViewStylePlain];
		listView.editing = NO;
		listView.separatorColor = [UIColor colorWithRed:0.827 green:0.843 blue:0.855 alpha:1];
		listView.delegate = self;
		listView.dataSource = self;
	}
	else
	{
		listView.frame = rc;
	}
	
	loadMoreCell = [[LoadCell alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
	listView.tableFooterView = loadMoreCell;
	[self.view addSubview:listView];

	if (detailHeaderView == nil) {
		detailHeaderView = [[DetailView alloc] initWithFrame:CGRectMake(0, 0, 320, 69)];
		detailHeaderView.rootContrlType = self.rootContrlType;
        UIImage *singleUpImage = [UIImage imageWithContentsOfFile:[themePathSingle stringByAppendingPathComponent:@"cellBg.png"]];
		UIImageView *imgBg = [[UIImageView alloc] initWithImage: singleUpImage];
		[detailHeaderView addSubview:imgBg];
		[detailHeaderView sendSubviewToBack:imgBg]; 
		[imgBg release];
		detailHeaderView.backgroundColor = [UIColor clearColor];
		
		detailHeaderView.baseInfo = self.homeInfo;
		detailHeaderView.parentController = self;
	}
	listView.tableHeaderView = detailHeaderView;
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"bgLabel" ofType:@"png"];
	broadCastImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
	broadCastImage.frame = CGRectMake(0, -30, 320, 30);
	
	NSString *pathError = [[NSBundle mainBundle] pathForResource:@"errorler" ofType:@"png"];
	errorCastImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:pathError]];
	errorCastImage.frame = CGRectMake(90, 5, 20, 20);
	errorCastImage.backgroundColor = [UIColor clearColor];
	errorCastImage.hidden = YES;
	[broadCastImage addSubview:errorCastImage];
	//[errorCastImage release];
	
	NSString *pathIcon = [[NSBundle mainBundle] pathForResource:@"iconPull" ofType:@"png"];
	IconCastImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:pathIcon]];
	IconCastImage.frame = CGRectMake(100, 8, 15, 15);
	IconCastImage.backgroundColor = [UIColor clearColor];
	IconCastImage.hidden = YES;
	[broadCastImage addSubview:IconCastImage];
	//[IconCastImage release];
	
	broadCastLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 180, 30)];
	broadCastLabel.backgroundColor = [UIColor clearColor];
	broadCastLabel.textColor = [UIColor colorWithRed:166/255.0 green:137/255.0 blue:67/255.0 alpha:1.];
	broadCastLabel.font = [UIFont systemFontOfSize:15];
	[broadCastImage addSubview:broadCastLabel];
	//[broadCastLabel release];
	[self.view addSubview:broadCastImage];
	//[broadCastImage release];
	
	[self requstWebService:homeInfo.uid:@"0":@"0"];
	
	// 2012-02-03 By Yi Minwen
	// 增加点击url时相关相应时间
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WebUrlClicked:) name:@"WebUrlClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:YES];
	[aApi cancelCurrentRequest];
}

// 点击网页链接时响应时间
- (void)WebUrlClicked:(NSNotification *)notification {
	NSString *urlString = (NSString *)notification.object;
	CLog(@"urlString:%@", urlString);
	WebUrlViewController *webUrlViewController = [[WebUrlViewController alloc] init];
	webUrlViewController.webUrl = urlString;
	
	[self.navigationController pushViewController:webUrlViewController animated:YES];
	[webUrlViewController release];
}

- (void)BackAction:(id)sender{
    [self.tabBarController performSelector:@selector(showNewTabBar) withObject:nil afterDelay:0.2f];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark scrollViewDidScroll

// lichentao 2012-02-16滑动列表发送通知，刷新originView，消除文字背景色
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOriginView" object:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if ([scrollView isKindOfClass:[UITableView class]]) {
		UITableView *tableView = (UITableView *)scrollView;
		NSArray *indexPathes = [tableView indexPathsForVisibleRows];
		if (indexPathes.count > 0) {
			int rowCounts = [tableView numberOfRowsInSection:1];
			NSIndexPath *lastIndexPath = [indexPathes objectAtIndex:indexPathes.count-1];
			if (rowCounts - lastIndexPath.row <2 && isLoading && tableView.contentOffset.y > 0) {
				isLoading = NO;
//				CLog(@"performSelector");
				[self performSelector:@selector(handleTimer) withObject:nil afterDelay:1];	
			}
		}
	}
}

#pragma mark -
#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 2;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	if (section ==0) {
		return 1;
	}
	else {
		return [detailArray count];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//	static NSString *string = @"cellIdentifier";
	UITableViewCell *tableViewCell = nil;
	int section = indexPath.section;
	if (section == 0) {
		NSString *string = @"detailIdentifer";
		DetailCell *cell = (DetailCell *)[tableView dequeueReusableCellWithIdentifier:string];
		if (cell == nil) {
			cell = [[[DetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string showStyle:BroadShowSytle] autorelease];
			// 无法在cell销毁时将委托置nil，倒也没多大影响
			cell.myDetailCellDelegate = self;
		}
	 	cell.rContrlType = self.rootContrlType;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		if (self.sourceInfo != nil) {
			cell.sourceHeight = sHeight;	
		}
		if (self.homeInfo != nil) {
			cell.originHeight = oHeight;
		}
		if (self.sourceInfo != nil) {
			cell.sourceInfo = self.sourceInfo;
		}
		if (self.homeInfo != nil) {;
			cell.homeInfo = self.homeInfo;
		}
		[cell startIconDownload];
		tableViewCell = cell;
	}else {
		NSUInteger row = indexPath.row;
		CommOrTransInfo *info = [detailArray objectAtIndex:row];
		//NSString *cellIdentifier = [NSString stringWithFormat:@"%d",indexPath.row];
		static NSString *cellIdentifier = @"commentIdentifier";
		CommOrTrans *cell = (CommOrTrans *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		if (cell == nil) {
			cell = [[[CommOrTrans alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		} 
		cell.uid = info.uid;
		cell.nick = info.nick;
		cell.isvip = info.isvip;
		cell.text = info.text;
		cell.time = info.time;
		cell.type = info.type;
		cell.localAuth = info.localAuth;			
		[cell setMsg];			
		tableViewCell = cell;
	}
	return tableViewCell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == 0) {
		// 主消息高度
		oHeight = [MessageViewUtility getDetailPageOriginViewHeight:self.homeInfo];
		// 来自...高度
		CGFloat fromHeight = [@"来自..." sizeWithFont:[UIFont systemFontOfSize:12]].height + VSpaceBetweenOriginFrameAndFrom;
		// 源消息高度
		if (self.sourceInfo != nil) {
			sHeight = [MessageViewUtility getDetailPageSourceViewHeight:self.sourceInfo];
		}
		CLog(@"%s, sHeight:%f", __FUNCTION__, sHeight);
		// 转播次数高度
		CGFloat commentCnt = 0.0f;
		if ([self.sourceInfo.transCount intValue] + [self.sourceInfo.transCommitcount intValue] > 0) {
			commentCnt += [@"本文共...转播" sizeWithFont:[UIFont systemFontOfSize:12]].height + VSBetweenOriginFrameAndOriginCommentCnt;
		}
		return oHeight + sHeight + VSBetweenOriginCommentCntAndText + commentCnt + fromHeight;

	}
	else {
		CommOrTransInfo *commOrTransInfo = [detailArray objectAtIndex:indexPath.row];
		CalculateUtil *calculate = [[[CalculateUtil alloc] init] autorelease];
		CGFloat height = [calculate calculateHeight:commOrTransInfo.text fontSize:16 andWidth:DPCommentTextWidth];
		return height + DPCommentHeigntBetweenNickAndLine + DPCommentHeightBetweenContenAndNick + DPCommentHeigntBetweenConteenAndBottonLine + DPCommentTimeLeftWidth - 4;
	}
}

#pragma mark -
#pragma mark UITableViewDelegate Method
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSUInteger row = indexPath.row;
	if (indexPath.section == 1) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		NSLog(@"详细内容:%@",[detailArray objectAtIndex:row]);
		rowNum = row;
		[self presentSheet];
	}
}

- (void) presentSheet
{
    UIActionSheet *sheet = [[UIActionSheet alloc]
                           initWithTitle: @"请选择要进行的操作"
                           delegate:self
                           cancelButtonTitle:nil
                           destructiveButtonTitle:nil
                           otherButtonTitles:nil];
	// 逐个添加按钮（比如可以是数组循环）  
    sheet.tag = 002;
    [sheet addButtonWithTitle:@"个人资料"];  
    [sheet addButtonWithTitle:@"转播"];  
    [sheet addButtonWithTitle:@"评论"];  
    [sheet addButtonWithTitle:@"对话"];
	
	// 同时添加一个取消按钮  
    [sheet addButtonWithTitle:@"取消"];  
	// 将取消按钮的index设置成我们刚添加的那个按钮，这样在delegate中就可以知道是那个按钮  
    sheet.cancelButtonIndex = sheet.numberOfButtons-1;  
    [sheet showFromRect:self.view.bounds inView:self.view animated:YES];  
    [sheet release];  
}

- (void)toWhere:(CommOrTransInfo *)info withType:(NSUInteger)type{
	switch (type) {
		case personalDataAction:
			NSLog(@"进入个人资料页%@",info.name);
			 [[PushAndRequest shareInstance] pushControllerType:self.rootContrlType withName:info.name];
			break;
		case broadcastAction:
			NSLog(@"进入转播页%@",info.text);
			ComposeBaseViewController	*broadcastViewController =  [ComposeViewControllerBuilder createWithComposeMsgType:FORWORD_MESSAGE];
			[self initDraft:broadcastViewController withInfo:info draftType:FORWORD_MESSAGE];
			break;
		case commentsAction:
			NSLog(@"进入评论页%@",info.text);
			ComposeBaseViewController	*commentsViewController =  [ComposeViewControllerBuilder createWithComposeMsgType:COMMENT_MESSAGE];
			[self initDraft:commentsViewController withInfo:info draftType:COMMENT_MESSAGE];
			break;
		case dialogueAction:
			NSLog(@"进入对话页%@",info.name);
			Draft *draft = [[Draft alloc] init];
			draft.uid = info.uid;
			draft.timeStamp = info.time;
			draft.draftType = TALK_TO_MESSAGE; 
			draft.draftTitle = info.nick;
			draft.talkToUserName = info.name;
			draft.draftForwardOrCommentText = info.text;
			draft.isHasPic = [NSNumber numberWithInt:0];
			// textView中显示空内容
			draft.draftText = @"";	
			ComposeBaseViewController	*dialogueViewController =  [ComposeViewControllerBuilder createWithDraft:draft];
			[draft release];
			UINavigationController *composeNavController = [[[UINavigationController alloc] initWithRootViewController:dialogueViewController] autorelease];
			[self presentModalViewController:composeNavController animated:YES];
			// composeViewController无需手动释放
			//[ComposeViewControllerBuilder desposeViewController:dialogueViewController];
			break;
 		default:
			break;
	}
}

- (void)initDraft :(ComposeBaseViewController *)composeBaseViewController withInfo:(CommOrTransInfo *)info draftType:(ComposeMsgType)draftType{	 
	Draft *draft = [[Draft alloc] init];
	draft.uid = info.uid;
	draft.timeStamp = info.time;
	draft.draftType = draftType; 
	draft.draftForwardOrCommentText = @"";	
	draft.draftTitle = info.nick;
	draft.isHasPic = [NSNumber numberWithInt:0];
	draft.fromDraftString = draft.draftText;
	// textView中显示空内容
	NSString *textViewString = [[NSString alloc] initWithFormat:@"|| @%@:%@",info.name,info.text];
	draft.draftText = textViewString;
	[textViewString release];		
	[composeBaseViewController initWithDraft:draft];
	[draft release];	
	UINavigationController *composeNavController = [[[UINavigationController alloc] initWithRootViewController:composeBaseViewController] autorelease];
	[self presentModalViewController:composeNavController animated:YES];
	// composeViewController无需手动释放
	//[ComposeViewControllerBuilder desposeViewController:composeBaseViewController];	
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark protocol DetailCellDelegate<NSObject> 
// 图片点击委托事件
- (void)DetailCellUrlClicked:(NSString *)urlSource {
	WebUrlViewController *webUrlViewController = [[WebUrlViewController alloc] init];
	webUrlViewController.webUrl = urlSource;
	[self.navigationController pushViewController:webUrlViewController   animated:YES];
	// 2012-02-08这里有个bug，不调用下边这步正常，调用以后WebUrlViewController会执行两次dealloc操作
	// 2012-02-13 已修正，引起原因是webView控件的delegate在dealloc方法里没置空
	[webUrlViewController release];
}

// 视频点击事件
- (void)DetailCellVideoClicked:(NSString *)urlVideo {
	WebUrlViewController *webUrlViewController = [[WebUrlViewController alloc] init];
	webUrlViewController.webUrl = urlVideo;
	[self.navigationController pushViewController:webUrlViewController animated:YES];
	[webUrlViewController release];
}

// 图片加载完毕事件
- (void)DetailCellImageHasLoadedImage {
	[listView reloadData];
	// lichentao 2012-01-21 发送通知，告诉DetailCell图片从本地加载,第一次从网络加载图片回调
	[[NSNotificationCenter defaultCenter] postNotificationName:@"getPictureDownLoadingFinished" object:nil];
}

// 地图缩略图点击事件
-(void)DetailCellMapClicked:(CLLocationCoordinate2D)center{

    DisaplayMapViewController * disMap = [[DisaplayMapViewController alloc] init];
    disMap.theUserCenter = center;
    [self.navigationController pushViewController:disMap animated:YES];
    [disMap release];
}

@end
