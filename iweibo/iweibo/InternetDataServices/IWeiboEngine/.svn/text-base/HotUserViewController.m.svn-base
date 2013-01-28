#import "HotUserViewController.h"
#import "PersonalMsgViewController.h"
#import "HpThemeManager.h"
#import "PushAndRequest.h"
#import "SCAppUtils.h"
#import "UserInfo.h"

#define kCustomRowHeight    59.0 // 规定行高为59
#define kCustomRowCount     7
#define kCustomRowRequestNums @"20"

#define tagForNick		101
#define tagForFansnum	102
#define tagForListenBtn 103
#define tagForHead		104
#define tagForVip		105

@implementation CustomeHotuserCell
@synthesize delegate;

//
- (void)listenBtnClicked:(id)sender {

	if ([delegate respondsToSelector:@selector(cellBtnClicked:)]) {
		[delegate cellBtnClicked:sender];
	}

	NSLog(@"sdjklflslfkdj");
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (nil != self) {
		// 显示头像
		UIImageView *head = [[[UIImageView alloc] initWithFrame:CGRectMake(9, 6, 40, 40)] autorelease];
		head.tag = tagForHead;
		head.layer.masksToBounds = YES;
		head.layer.cornerRadius = 3.0f;
		[self.contentView addSubview:head];
		
		// 显示vip标记
		UIImageView *vipTag = [[[UIImageView alloc] initWithFrame:CGRectMake(41, 38, 16, 16)] autorelease];
		vipTag.tag = tagForVip;
		[self.contentView addSubview:vipTag];
		
		// 显示昵称
		UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, 7, 176, 17)];
		nickLabel.font = [UIFont systemFontOfSize:14];
		nickLabel.backgroundColor = [UIColor clearColor];
		nickLabel.tag = tagForNick;
		[self.contentView addSubview:nickLabel];
		[nickLabel release];
		
		// 显示听众数
		UILabel *fansNum = [[UILabel alloc] initWithFrame:CGRectMake(58, 29, 176, 12)];
		fansNum.font = [UIFont systemFontOfSize:12];
		fansNum.backgroundColor = [UIColor clearColor];
		fansNum.textColor = [UIColor colorWithRed:99.0f / 255.0f green:99.0f /255.0f blue:99.0f / 255.0f alpha:1.0f];
		fansNum.tag = tagForFansnum;
		[self.contentView addSubview:fansNum];
		[fansNum release];
		
		// 收听按钮和已收听按钮
		UIButton *listen = [UIButton buttonWithType:UIButtonTypeCustom];
		listen.frame = CGRectMake(234, 11, 76, 30);
		listen.tag = tagForListenBtn;
		[listen addTarget:self action:@selector(listenBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:listen];
	}
	
	return self;
}

- (void)refreshCellWithData:(HotUserInfo *)info atIndexPath:(NSIndexPath *)indexPath {
	
	HotUserInfo *appRecord = info;
	
	UILabel *nick = (UILabel *)[self.contentView viewWithTag:tagForNick];
	nick.text = appRecord.userNick;
	
	UILabel *fans = (UILabel *)[self.contentView viewWithTag:tagForFansnum];
	fans.text = [NSString stringWithFormat:@"听众数:%@", appRecord.numberOfFans];
	
	UIButton *hasListen = (UIButton *)[self.contentView viewWithTag:tagForListenBtn];
	
	// 如果热门用户是自己，则右边没有收听或已收听按钮,否则，要显示两个按钮中的一个
	if ([appRecord.userName isEqualToString:[UserInfo sharedUserInfo].name]) {
		hasListen.hidden = YES;
	}else {
		hasListen.hidden = NO;
	}

	if ([appRecord.hasListen intValue] == 0) {
		[hasListen setBackgroundImage:[UIImage imageNamed:@"hotUserListen.png"] forState:UIControlStateNormal];
		hasListen.userInteractionEnabled = YES;
	}else {
		[hasListen setBackgroundImage:[UIImage imageNamed:@"hotUserAlreadyListen.png"] forState:UIControlStateNormal];
		hasListen.userInteractionEnabled = NO;
	}
	
	UIImageView *headImg = (UIImageView *)[self.contentView viewWithTag:tagForHead];
	if (!appRecord.userhead) {             
		headImg.image = [UIImage imageNamed:@"headDefault.png"];
	}
	else {
		headImg.image = appRecord.userhead;
	}
	
	UIImageView *vipImg = (UIImageView *)[self.contentView viewWithTag:tagForVip];
	if (1 == [appRecord.is_auth intValue]) {
		vipImg.image = [UIImage imageNamed:@"vip-btn.png"];
	}else {
		vipImg.image = nil;
	}

}


@end


@interface HotUserViewController ()
- (void)startIconDownload:(HotUserInfo *)appRecord forIndexPath:(NSIndexPath *)indexPath;
@end

@implementation HotUserViewController
@synthesize entries;
@synthesize imageDownloadsInProgress;
@synthesize currentIndexPath;
@synthesize backBtn;
// 点击返回按钮时调用
- (void)backAction: (id)sender {
	//[self.navigationController setNavigationBarHidden:YES animated:NO];
	[self.tabBarController performSelector:@selector(showNewTabBar)];
	
	[self.navigationController popViewControllerAnimated:YES];
}

// 获取热门用户信息
- (void)getHotUserInfoWithFlag:(UserInfoType)type {
	isLoading = YES;
	
	NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithCapacity:10];
	[paramters setValue:@"json" forKey:@"format"];
	[paramters setValue:kCustomRowRequestNums forKey:@"reqnum"];
	[paramters setValue:@"0" forKey:@"random"];
	[paramters setValue:URL_RECOMMEND_USER forKey:@"request_api"];
	
	switch (type) {
		case UserInfoTypeFirst:
			[paramters setValue:@"0" forKey:@"pageflag"];
			[paramters setValue:@"0" forKey:@"lastid"];
			break;
		case UserInfoTypeMore:
		{
			HotUserInfo *appRecord = [self.entries lastObject];	
			[paramters setValue:@"1" forKey:@"pageflag"];
			[paramters setValue:appRecord.local_id forKey:@"lastid"];
		}
			break;
		default:
			break;
	}
	
	[requestApi getRecommendUserWithParamters:paramters
									 delegate:self
									onSuccess:@selector(getHotUserInfoSuccess:) 
									onFailure:@selector(getHotUserInfoFailure:)];
}

- (void)updateTheme:(NSNotificationCenter *)noti{
    NSDictionary *plistDict = [[HpThemeManager sharedThemeManager]themeDictionary];
	NSString *themePathTmp = [plistDict objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    UIImage *imageNav = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"navigationbar_bg.png"]];
    [SCAppUtils navigationController:self.navigationController setImage:imageNav];
    [backBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
}

#pragma mark 
- (void)viewDidLoad {
    [super viewDidLoad];
	
	hasNext = NO;
	isLoading = YES;
    
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
	[customLab setText:@"热门用户"];
	[customLab setTextAlignment:UITextAlignmentCenter];
	customLab.backgroundColor = [UIColor clearColor];
	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	self.navigationItem.titleView = customLab;
	[customLab release];
	//self.title = @"热门用户";
	
	selectedIndexPath = nil;
	self.tableView.hidden = YES;
	backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 49, 30)];
	backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
	//backBtn.titleLabel.text = @"返回";
	backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
	backBtn.titleLabel.textAlignment = UITextAlignmentCenter;
	[backBtn setTitle:@"返回" forState:UIControlStateNormal];
	[backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
	[backBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
	
	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
	self.navigationItem.leftBarButtonItem = leftItem;
	[leftItem release];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    self.tableView.rowHeight = kCustomRowHeight;
	[self showMBProgress];
	requestApi = [[IWeiboAsyncApi alloc] init];
	[self getHotUserInfoWithFlag:UserInfoTypeFirst];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification object:nil];
}

// 显示加载框
- (void)showMBProgress{
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (hud == nil) {
        hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(30, 80, 260, 200)];  
    }
	[delegate.window addSubview:hud];  
	[delegate.window bringSubviewToFront:hud];
    hud.labelText = @"载入中...";  
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];  
}

// 隐藏加载框
- (void) hiddenMBProgress{
    [hud hide:YES];
}

// 检查获取到的热门用户数据的合法性
- (id)checkHotUserDataValidation:(NSDictionary *)dictionary {
	if (nil == dictionary) {
		return nil;
	}
	
	id ret = [dictionary objectForKey:@"ret"];
	if ([ret intValue] != 0) {
		NSLog(@"getHotUserFailed:%@", [dictionary objectForKey:@"msg"]);
		return nil;
	}
	
	NSDictionary *data = [dictionary objectForKey:@"data"];
	if (nil == data || ![data isKindOfClass:[NSDictionary class]]) {
		return nil;
	}
	
	id next = [data objectForKey:@"hasnext"];
	if (nil != next && ![next isKindOfClass:[NSNull class]]) {
		hasNext = [next intValue];
	}
	NSArray *info = [data objectForKey:@"info"];
	if (nil == info || ![info isKindOfClass:[NSArray class]]) {
		return nil;
	}
	
	return info;
}

// 存储获取的热门用户信息
- (void)storeNewHotUserInfo:(NSArray *)array {
	NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.entries];
	for (id dict in array) {
		if (![dict isKindOfClass:[NSDictionary class]]) {
			return;
		}
		HotUserInfo *user = [[HotUserInfo alloc] init];
		user.userNick = [dict objectForKey:@"nick"];
		user.userName = [dict objectForKey:@"name"];
		user.numberOfFans = [dict objectForKey:@"fansnum"];
		user.hasListen = [dict objectForKey:@"ismyidol"];
		user.is_auth = [dict objectForKey:@"is_auth"];
		user.headURL = [dict objectForKey:@"head"];
		user.local_id = [dict objectForKey:@"local_id"];
		
		[tempArray addObject:user];
		[user release];
	}
	
	self.entries = tempArray;
}

// 获取热门用户信息成功时的回调函数
- (void)getHotUserInfoSuccess:(NSDictionary *)dictionary {
	
	if (hud.hidden == NO) {
		[self hiddenMBProgress];
	}
	
	NSArray *info = (NSArray *)[self checkHotUserDataValidation:dictionary];
	if (nil == info) {
		return;
	}else {
		[self storeNewHotUserInfo:info];
	}
	isLoading = NO;
	if (self.tableView.hidden == YES) {
		self.tableView.hidden = NO;
	}
	[self.tableView reloadData];
}

// 获取热门用户信息失败时的回调函数
- (void)getHotUserInfoFailure:(NSError *)error {
	hud.labelText = @"网络失败，请重试！";
	isLoading = NO;
	[self performSelector:@selector(hiddenMBProgress) withObject:nil afterDelay:1.0f];
	NSLog(@"getHotUserInfoFailure:%@", [error localizedDescription]);
}


- (void)dealloc {
    [entries release];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
	NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
	[backBtn release];
	[imageDownloadsInProgress release];
	[requestApi release];
	[hud release];
	self.currentIndexPath = nil;
	
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}


#pragma mark -
#pragma mark Table view creation (UITableViewDataSource)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int count = [entries count];
	if (count == 0) {
		return 0;
	}else {
		return count + 1;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"LazyTableCell";
    static NSString *PlaceholderCellIdentifier = @"LoadMoreCell";
    
    int nodeCount = [self.entries count];
	if (nodeCount != 0 && indexPath.row == nodeCount) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
										   reuseIdentifier:PlaceholderCellIdentifier] autorelease];   
            cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.font = [UIFont systemFontOfSize:14];
        }
		return cell;
    }
	
    CustomeHotuserCell *cell = (CustomeHotuserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CustomeHotuserCell alloc] initWithStyle:UITableViewCellStyleDefault
										  reuseIdentifier:CellIdentifier] autorelease];
		UIView *aView = [[UIView alloc] initWithFrame:cell.contentView.frame];
		aView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:0.933];
		cell.selectedBackgroundView = aView; 
		[aView release];
		cell.delegate = self;
    }
	HotUserInfo *appRecord = [self.entries objectAtIndex:indexPath.row];
	[cell refreshCellWithData:appRecord atIndexPath:indexPath];
	if (!appRecord.userhead) {
		if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
			[self startIconDownload:appRecord forIndexPath:indexPath];
		}              
	}

    return cell;
}

// 选中某个Cell的时候调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	selectedIndexPath = indexPath;
	if (indexPath.row < [entries count]) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		self.currentIndexPath = indexPath;
		HotUserInfo *user = [self.entries objectAtIndex:indexPath.row];
		
		[[PushAndRequest shareInstance] pushControllerType:3 withName:user.userName];
	}
}

// 收听用户成功时的回调函数
- (void)addFriendSuccessCallback:(NSDictionary *)dict {
	id retObj = [dict objectForKey:@"errcode"];
	int ret = 0;
	if (nil == retObj || [retObj isKindOfClass:[NSNull class]]) {
		return;
	}else {
		ret = [retObj intValue];
		if (0 == ret) {
			HotUserInfo *currentUser = [self.entries objectAtIndex:currentIndexPath.row];
			currentUser.hasListen = @"1";
			[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
		}else {
			NSLog(@"addFriendFailed:%@", [dict objectForKey:@"msg"]);
								  
		}
	}
}


// 收听用户失败时的回调函数
- (void)addFriendFailureCallback:(NSError *)error {
	NSLog(@"addFriendFailureCallback:%@", [error localizedDescription]);
}


// 当收听按钮点击的时候调用
- (void)cellBtnClicked:(id)sender {
	UIButton *btn = (UIButton *)sender;
	UITableViewCell *cell = (UITableViewCell *)[[btn superview] superview];
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	self.currentIndexPath = indexPath;
	NSLog(@"cellBtnClicked indexPath:%@ row = %d, section:%d", indexPath, indexPath.row, indexPath.section);
	HotUserInfo *obj = [self.entries objectAtIndex:indexPath.row];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
	[params setValue:@"json" forKey:@"format"];
	[params setValue:obj.userName forKey:@"name"];
	[params setValue:URL_FRIENDS_ADD forKey:@"request_api"];
	
	[requestApi friendsAddWithParamters:params
							   delegate:self
							  onSuccess:@selector(addFriendSuccessCallback:) 
							  onFailure:@selector(addFriendFailureCallback:)];
	
	
}

// 视图将要出现的时候调用
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if (nil != selectedIndexPath) {
		[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
		selectedIndexPath = nil;
	}
	
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.tabBarController performSelector:@selector(hideNewTabBar)];
}

// 视图将要消失的时候调用
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	if (hud.hidden == NO) {
		[self hiddenMBProgress];
	}
	//[self.navigationController setNavigationBarHidden:YES animated:YES];
	//[self.tabBarController performSelector:@selector(showNewTabBar)];
}

#pragma mark -
#pragma mark Table cell image support
- (void)startIconDownload:(HotUserInfo *)appRecord forIndexPath:(NSIndexPath *)indexPath {
    HeadDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) {
        iconDownloader = [[HeadDownloader alloc] init];
        iconDownloader.userRecord = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];   
    }
}

- (void)loadImagesForOnscreenRows {
    if ([self.entries count] > 0) {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) {
			if (indexPath.row >= [self.entries count]) {
				break;
			}
            HotUserInfo *appRecord = [self.entries objectAtIndex:indexPath.row];
            if (!appRecord.userhead) {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
        }
    }
}

- (void)appImageDidLoad:(NSIndexPath *)indexPath {
    HeadDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
		((UIImageView *)[cell.contentView viewWithTag:tagForHead]).image = iconDownloader.userRecord.userhead;
    }
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	NSLog(@"endDragging:%@", [scrollView class]);
	
    if (!decelerate) {
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.entries count] inSection:0]];
	if (nil == cell) {
		return;
	}
	
	if (1 == hasNext) {
		cell.textLabel.text = @"已经加载完毕";
		return;
	}
	
	NSArray *array = [self.tableView visibleCells];
	if ([array containsObject:cell]) {
		if (!isLoading/* && !(self.tableView.dragging)*/) {
			[self getHotUserInfoWithFlag:UserInfoTypeMore];
			cell.textLabel.text = @"加载更多";
		}else {
			cell.textLabel.text = @"载入中....";
		}
	}

	/*
	if (1 == hasNext) {
		cell.textLabel.text = @"已经加载完毕";
	}else {
		if (!isLoading) {
			[self getHotUserInfoWithFlag:UserInfoTypeMore];
			cell.textLabel.text = @"加载更多";
		}else {
			cell.textLabel.text = @"载入中....";
		}
		
	}
	 */
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForOnscreenRows];
}

@end