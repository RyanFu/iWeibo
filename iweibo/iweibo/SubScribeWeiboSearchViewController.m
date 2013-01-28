    //
//  SubScribeWeiboSearchViewController.m
//  iweibo
//
//  Created by Minwen Yi on 6/11/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "SubScribeWeiboSearchViewController.h"
#import "pinyin.h"
#import "IWBSvrSettingsManager.h"
#import <QuartzCore/QuartzCore.h>
#import "Canstants_Data.h"
#import "WeiboDetailsPage.h"
#import "AppXMLParser.h"

@implementation SubScribeWeiboSearchViewController
@synthesize mainTableView, itemSearchBar, blackCoverView, arrItems, arrSectionItems;
@synthesize arrItemsCopy;
@synthesize siteUrl;
@synthesize imgLogo;
@synthesize idParentController;

#pragma mark checkSite
// 设置异常文本
-(void)setErrorText:(NSString *)errText {
    bIsGettingInfo = NO;
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" 
                                                        message:errText 
                                                       delegate:self 
                                              cancelButtonTitle:@"确定" 
                                              otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

-(void)turnToDetailPageWithDes:(CustomizedSiteInfo *)siteInfo {
    bIsGettingInfo = NO;
	//[self.itemSearchBar resignFirstResponder];
	[tfSiteName resignFirstResponder];
    WeiboDetailsPage *weiboDetailsPage = [[WeiboDetailsPage alloc] init];
    weiboDetailsPage.idParentController = self;
    weiboDetailsPage.customizedSiteInfo = siteInfo;
	weiboDetailsPage.imgLogo = self.imgLogo;
	[self.navigationController pushViewController:weiboDetailsPage animated:YES];
    [weiboDetailsPage release];
	
}

//-(void)turnToDetailPageWithDes:(SiteDescriptionInfo *)des {
//	[self.itemSearchBar resignFirstResponder];
//    WeiboDetailsPage *weiboDetailsPage = [[WeiboDetailsPage alloc] init];
//    weiboDetailsPage.idParentController = self;
//	// 构建CustomizedSiteInfo对象
//	CustomizedSiteInfo *siteInfo = [[CustomizedSiteInfo alloc] init];
//	des.svrUrl = self.siteUrl;
//	siteInfo.themeVer = @"-1";
//	siteInfo.descriptionInfo = des;
//    weiboDetailsPage.customizedSiteInfo = siteInfo;
//	[siteInfo release];
//	weiboDetailsPage.imgLogo = self.imgLogo;
//	[self.navigationController pushViewController:weiboDetailsPage animated:YES];
//    [weiboDetailsPage release];
//}

-(void)getThemeInfo {
	NSMutableDictionary *par = [NSMutableDictionary dictionaryWithCapacity:3];
	[par setObject:@"json" forKey:@"format"];
	[par setObject:@"customized/theme" forKey:@"request_api"];
	[par setObject:@"-1" forKey:@"ver"];
	[request getCustomizedThemeWithUrl:self.siteUrl Parameters:par delegate:self
						 onSuccess:@selector(onGetThemeSuccess:) onFailure:@selector(onGetThemeFailure:)];
}

-(void)getSiteInfo {
	NSMutableDictionary *par = [NSMutableDictionary dictionaryWithCapacity:2];
	[par setObject:@"json" forKey:@"format"];
	[par setObject:@"customized/siteinfo" forKey:@"request_api"];
	[request getCustomizedSiteInfoWithUrl:self.siteUrl Parameters:par delegate:self
							onSuccess:@selector(onGetSiteInfoSuccess:) onFailure:@selector(onGetSiteFailure:)];
}


-(void)onGetSiteInfoSuccess:(NSDictionary *)result {
	CLog(@"%s, result:%@", __FUNCTION__, result);
	// 检测返回值
	NSNumber *ret = [DataCheck checkDictionary:result forKey:@"ret" withType:[NSNumber class]];
	
	// 数据获取异常
	if ([ret isEqual:[NSNull null]] || [ret intValue] != 0) {
		if ([ret isEqual:[NSNull null]]) {
			[self setErrorText:@"数据获取异常"];
		}
		else {
			NSString *msg = [DataCheck checkDictionary:result forKey:@"ret" withType:[NSString class]];
			if ([msg isEqual:[NSNull null]])
				[self setErrorText:@"数据获取异常"];
			else
				[self setErrorText:[msg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		}
	}
	else {
		NSDictionary *dicData = [DataCheck checkDictionary:result forKey:@"data" withType:[NSDictionary class]];
		if ([dicData isEqual:[NSNull null]]) {
			[self setErrorText:@"数据获取异常"];
		}
		else {
			SiteDescriptionInfo *des = [[SiteDescriptionInfo alloc] initWithDic:dicData];
			// 构建CustomizedSiteInfo对象
			CustomizedSiteInfo *siteInfo = [[CustomizedSiteInfo alloc] init];
			des.svrUrl = self.siteUrl;
			siteInfo.themeVer = @"-1";
			siteInfo.descriptionInfo = des;
			[des release];
			// 1. 检测本地是否已经有对应site存在
			[self performSelectorOnMainThread:@selector(turnToDetailPageWithDes:) withObject:siteInfo waitUntilDone:NO];
			//[self turnToDetailPageWithDes:des];
			[siteInfo release];
		}
	}
}

- (void)onGetSiteFailure:(NSError *)error {
    CLog(@"error = %@",error);
	[self setErrorText:[error localizedDescription]];
}

-(void)onGetThemeSuccess:(NSDictionary *)result {
	CLog(@"%s, result:%@", __FUNCTION__, result);
	NSNumber *ret = [DataCheck checkDictionary:result forKey:@"ret" withType:[NSNumber class]];
	// 数据获取异常
	if ([ret isEqual:[NSNull null]] || [ret intValue] != 0) {
        // 2012-08-03 By Yi Minwen 接口异常直接走下一个接口
//		if ([ret isEqual:[NSNull null]]) {
//			[self setErrorText:@"数据获取异常"];
//		}
//		else {
//			NSString *msg = [DataCheck checkDictionary:result forKey:@"msg" withType:[NSString class]];
//			if ([msg isEqual:[NSNull null]])
//				[self setErrorText:@"数据获取异常"];
//			else
//				[self setErrorText:[msg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//		}
        self.imgLogo = [UIImage imageNamed:@"icon.png"];
        // 获取站点信息
        [self performSelector:@selector(getSiteInfo) withObject:nil afterDelay:0.0f];
	}
	else {
		// ret=0, errcode=1时表示主题版本已经是最新
		NSNumber *errorcode = [DataCheck checkDictionary:result forKey:@"errcode" withType:[NSNumber class]];
		if ([ret isEqual:[NSNull null]]) {
//			[self setErrorText:@"数据获取异常"];
            // 2012-08-03 By Yi Minwen 接口异常直接走下一个接口
            self.imgLogo = [UIImage imageNamed:@"icon.png"];
            // 获取站点信息
            [self performSelector:@selector(getSiteInfo) withObject:nil afterDelay:0.0f];
		}
		else if ([errorcode intValue] == 1) {
			// 已是最新版本
			// 3. 站点信息拉取(siteInfo)
			[self performSelector:@selector(getSiteInfo) withObject:nil afterDelay:0.0f];
		}
		else {
			NSDictionary *dicData = [DataCheck checkDictionary:result forKey:@"data" withType:[NSDictionary class]];
			// 自定义微博页面必须要有所有图片，因此要判定[dicData count]值
			if ([dicData isEqual:[NSNull null]] || [dicData count] == 0) {
                //				[self setErrorText:@"数据获取异常"];
                // 2012-08-03 By Yi Minwen 接口异常直接走下一个接口
                self.imgLogo = [UIImage imageNamed:@"icon.png"];
                // 获取站点信息
                [self performSelector:@selector(getSiteInfo) withObject:nil afterDelay:0.0f];
			}
			else {
				// 下载logo
				// 创建文件
				NSDictionary *listData = [dicData objectForKey:@"list"];
				NSString *strShortUrl = [self.siteUrl stringByReplacingOccurrencesOfString:HOST_SUB_PATH_COMPONENT withString:@""];	// 短路径
				NSArray *arrAllKeys = [listData allKeys];
				NSData *dt = nil;
				for (NSString *key in arrAllKeys) {
					NSString *value = [listData valueForKey:key];
					if ([key hasPrefix:@"logo"]) {
						NSString *srcIconUrl = [strShortUrl stringByAppendingPathComponent:value];
						dt = [NSData dataWithContentsOfURL:[NSURL URLWithString:srcIconUrl]];
						break;
					}
				}
				if (nil != dt) {
					// 
					self.imgLogo = [UIImage imageWithData:dt];
					// 获取站点信息
					[self getSiteInfo];
				}
				else {
//					[self setErrorText:@"数据获取异常"];
                    // 2012-08-03 By Yi Minwen 接口异常直接走下一个接口
                    self.imgLogo = [UIImage imageNamed:@"icon.png"];
                    // 获取站点信息
                    [self performSelector:@selector(getSiteInfo) withObject:nil afterDelay:0.0f];
				}

			}
		}
	}
}

- (void)onGetThemeFailure:(NSError *)error {
    CLog(@"error = %@",error);
    // 2012-08-03 By Yi Minwen 接口异常直接走下一个接口
//	[self setErrorText:[error localizedDescription]];
    self.imgLogo = [UIImage imageNamed:@"icon.png"];
    // 获取站点信息
    [self performSelector:@selector(getSiteInfo) withObject:nil afterDelay:0.0f];
}

- (void)onCheckSuccess:(NSDictionary *)result {
	CLog(@"%s, result:%@", __FUNCTION__, result);
	//NSString *ret = [result objectForKey:@"ret"];
	if (nil != result) {
		// 返回成功，先获取icon图片
		[self getThemeInfo];
	}
	else {
		// 主站未准备好
		[self setErrorText:@"该iWeibo站点未安装客户端模块."];
	}
}

- (void)onCheckFailure:(NSError *)error {
    CLog(@"error = %@",error);
    [self setErrorText:@"该iWeibo站点未安装客户端模块."];
//	[self setErrorText:[error localizedDescription]];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	// 显示导航栏
	//[self.navigationController setNavigationBarHidden:NO animated:YES];
	// 添加返回按钮
	UIImage *viewSearchImg = [UIImage imageNamed:@"subScribeTitleBg.png"];
	UIImageView	*viewSearchBG = [[UIImageView alloc] initWithImage:viewSearchImg];
	[self.view addSubview:viewSearchBG];
	viewSearchBG.userInteractionEnabled = YES;
	[viewSearchBG release];
	UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
	leftButton.frame = CGRectMake(5, 4, 50, 30);
	[leftButton setTitle:@"返回" forState:UIControlStateNormal];
	leftButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    leftButton.titleLabel.shadowOffset = CGSizeMake(-1.0f, 2.0f);
	[leftButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 12, 5, 5)];
	[leftButton setBackgroundImage:[UIImage imageNamed:@"subScribeNav.png"] forState:UIControlStateNormal];
	[leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	[viewSearchBG addSubview:leftButton];
    
	UIImage *imgTextBg = [UIImage imageNamed:@"subScribeInput.png"];
	UIImageView	*viewTextBG = [[UIImageView alloc] initWithImage:imgTextBg];
    viewTextBG.frame = CGRectMake(61, 5, 256, 31);
    viewTextBG.userInteractionEnabled = YES;
    viewTextBG.backgroundColor = [UIColor clearColor];
	[self.view addSubview:viewTextBG];
    [viewTextBG release];
	tfSiteName= [[UITextField alloc] initWithFrame:CGRectMake(9, 5, 240, 20)];
    tfSiteName.backgroundColor = [UIColor clearColor];
    tfSiteName.borderStyle = UITextBorderStyleNone;
    tfSiteName.textColor = [UIColor blackColor];
    tfSiteName.font = [UIFont systemFontOfSize:16.0f];
    tfSiteName.placeholder = @"请输入iWeibo站点URL";
    tfSiteName.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
    tfSiteName.keyboardType = UIKeyboardTypeURL;	// use the default type input method (entire keyboard)
    tfSiteName.returnKeyType = UIReturnKeySearch;
    tfSiteName.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
    tfSiteName.delegate = self;
	[viewTextBG addSubview:tfSiteName];
    [tfSiteName becomeFirstResponder];
	//UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	leftButton.frame = CGRectMake(0, 0, 50, 30);
//	[leftButton setTitle:@"返回" forState:UIControlStateNormal];
//	leftButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
//	[leftButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 5)];
//	[leftButton setBackgroundImage:[UIImage imageNamed:@"subScribeNav.png"] forState:UIControlStateNormal];
//	[leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//	UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//	self.navigationItem.leftBarButtonItem = leftBar;
//	[leftBar release];
//	
//	UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
//	self.itemSearchBar = searchBar;
//	[self.view addSubview:self.itemSearchBar];
//	searchBar.delegate = self;
	UITableView *tbView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, 416.0f)];
	tbView.dataSource = self;
	tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tbView.delegate = self;
	self.mainTableView = tbView;
	[self.view addSubview:tbView];
	blackCoverView = [[UIView alloc] initWithFrame:self.mainTableView.frame];
	blackCoverView.backgroundColor = [UIColor blackColor];
	blackCoverView.alpha = 0.7;
	blackCoverView.userInteractionEnabled = YES;
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBackCover:)];
	[blackCoverView addGestureRecognizer:tapGesture];
	[tapGesture release];
    NSMutableArray *arrCopy = [[NSMutableArray alloc] initWithArray:[[IWBSvrSettingsManager sharedSvrSettingManager] arrSiteInfo]];
    AppXMLParser *parser = [[AppXMLParser alloc] init];
    NSMutableArray	*arrAllItems = [parser doParser];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:MAX_ITEM_COUNT];
    for (int i = 0; i < MAX_ITEM_COUNT && i < [arrAllItems count]; i++) {
        [arr addObject:[arrAllItems objectAtIndex:i]];
    }
    self.arrItems = arr;
    [arr release];
    [parser release];
	[arrCopy release];
	// 初始化表格数据
	[self initData];
	request = [[IWeiboAsyncApi alloc] init];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(tfTextDidChange)
												 name:UITextFieldTextDidChangeNotification
											   object:nil];
}

-(void)back {
	//[self.navigationController setNavigationBarHidden:YES animated:NO];
	[self.navigationController popViewControllerAnimated:YES];
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
	self.mainTableView = nil;
	self.itemSearchBar = nil;
	[blackCoverView release];
	blackCoverView = nil;
	[tfSiteName release];
	tfSiteName = nil;
}
-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
   // [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
	printf("SubScribeWeiboSearchViewController dealloc");
	[request cancelSpecifiedRequest];
	[request release];
	request = nil;
	[blackCoverView release];
	blackCoverView = nil;
	mainTableView.delegate = nil;
	self.mainTableView = nil;
	itemSearchBar.delegate = nil;
	self.itemSearchBar = nil;
	self.arrItems = nil;
	self.arrItemsCopy = nil;
	self.arrSectionItems = nil;
	self.siteUrl = nil;
	self.imgLogo = nil;
	[tfSiteName release];
	tfSiteName = nil;
    [super dealloc];
}
// 初始化数据
-(void)initData {
	NSMutableArray *arrCopy = [[NSMutableArray alloc] initWithArray:self.arrItems];
	self.arrItemsCopy = arrCopy;
	[arrCopy release];
	self.arrSectionItems = [[NSMutableArray alloc] init];
	//self.copySectionArray = [[NSMutableArray alloc] init];
	// sectionArray数据数组(常~z)
	for(int i = 0; i < 29; i ++) {
		[self.arrSectionItems addObject:[NSMutableArray array]];
		//[self.copySectionArray addObject:[NSMutableArray array]];
	}
	// 字母_a~z姓名排序
	for (int i = 0; i < [arrItemsCopy count]; i ++) {
		CustomizedSiteInfo *item = (CustomizedSiteInfo *)[self.arrItemsCopy objectAtIndex:i];
		NSString *sectionName = [NSString stringWithFormat:@"%c",pinyinFirstLetter([item.descriptionInfo.svrName characterAtIndex:0])];
		NSUInteger firstLetter = [ALPHA rangeOfString:[[sectionName substringToIndex:1] lowercaseString]].location;
		if (firstLetter != NSNotFound){
			[[self.arrSectionItems objectAtIndex:firstLetter] addObject:[self.arrItemsCopy objectAtIndex:i]];
		}
	}
}

#pragma mark - TableViewDateSource
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (bIsGettingInfo) {
        // 正在加载则不响应
        return;
    }
	//[self.itemSearchBar resignFirstResponder];
    NSArray *arrVisibleCell = [tableView visibleCells];
    for (UITableViewCell *cellVisible in arrVisibleCell) {
        UIImageView *imageView = (UIImageView *)[cellVisible.contentView viewWithTag:100];
        if (imageView != nil && NO == imageView.hidden) {
            imageView.image = [UIImage imageNamed:@"subScribeEarth.png"];
        }
        UIImageView *bgView = (UIImageView *)[cellVisible.contentView viewWithTag:103];
        if (nil != bgView) {
            bgView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
        }
        UILabel *itemDes = (UILabel *)[cellVisible.contentView viewWithTag:102];
        if (itemDes != nil && NO == itemDes.hidden) {
            itemDes.textColor = [UIColor colorWithRed:132.0f/255.0f green:134.0f/255.0f blue:134.0f/255.0f alpha:1.0f];
        }
        [cellVisible setNeedsLayout];
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  	UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:100];
    if (imageView != nil && NO == imageView.hidden) {
        imageView.image = [UIImage imageNamed:@"subScribeEarthHover.png"];
    }
    UIImageView *bgView = (UIImageView *)[cell.contentView viewWithTag:103];
    if (nil != bgView) {
        bgView.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:232.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
    }
    UILabel *itemDes = (UILabel *)[cell.contentView viewWithTag:102];
    if (itemDes != nil && NO == itemDes.hidden) {
        itemDes.textColor = [UIColor colorWithRed:83.0f/255.0f green:121.0f/255.0f blue:126.0f/255.0f alpha:1.0f];
    }
    [cell setNeedsLayout];
	[tfSiteName resignFirstResponder];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSString *strUrl = nil;
	// 判断选择的是哪行
	//if ([self.itemSearchBar.text length] > 0) {
	if ([tfSiteName.text length] > 0) {
		if ([arrItems count] > 0 ) {
			if (indexPath.row == 0) {
				//strUrl = self.itemSearchBar.text;
				strUrl = tfSiteName.text;
			}
			else {
				CustomizedSiteInfo *item = (CustomizedSiteInfo *)[self.arrItems objectAtIndex:indexPath.row];
				strUrl = item.descriptionInfo.svrUrl;
			}
		}
	}
	else {
//		if ([arrSectionItems count] > indexPath.section 
//			&& [[arrSectionItems objectAtIndex:indexPath.section] count] > indexPath.row) {
//			CustomizedSiteInfo *item = (CustomizedSiteInfo *)[[self.arrSectionItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//			strUrl = item.descriptionInfo.svrUrl;
//		}
        if (indexPath.row < [self.arrItems count]) {
            CustomizedSiteInfo *item = (CustomizedSiteInfo *)[self.arrItemsCopy objectAtIndex:indexPath.row];
            strUrl = item.descriptionInfo.svrUrl;
        }
	}
	NSAssert(strUrl != nil, @"Should never get here");
	self.siteUrl = strUrl;
	if (![strUrl hasPrefix:@"http://"]) {
		if (![strUrl hasSuffix:HOST_SUB_PATH_COMPONENT]) {
			self.siteUrl = [NSString stringWithFormat:@"http://%@%@", strUrl, HOST_SUB_PATH_COMPONENT];
		}
		else {
			self.siteUrl = [NSString stringWithFormat:@"http://%@", strUrl];
		}
	}
	else {
		if (![strUrl hasSuffix:HOST_SUB_PATH_COMPONENT]) {
			self.siteUrl = [strUrl stringByAppendingString:HOST_SUB_PATH_COMPONENT];
		}
		else {
			self.siteUrl =strUrl;
		}
	}
	CustomizedSiteInfo *siteInfo = [[IWBSvrSettingsManager sharedSvrSettingManager] getSiteInfoByUrl:self.siteUrl];
	if (siteInfo != nil) {
		[self turnToDetailPageWithDes:siteInfo];
	}
	else {
        bIsGettingInfo = YES;
		[request iweiboCheckHostWithUrl:self.siteUrl delegate:self onSuccess:@selector(onCheckSuccess:) onFailure:@selector(onCheckFailure:)];
	}
	CLog(@"%s, %@", __FUNCTION__, self.siteUrl);
}

// 右侧字母索引
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//	return [ALPHA rangeOfString:title].location;
//}
//
//// 右侧导航数组
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//	if ([self.itemSearchBar.text length] > 0) {
//		return nil;
//	}else {
//		NSMutableArray *indices = [NSMutableArray array];
//		for (int i = 0; i < [self.arrSectionItems count]; i++){ 
//			if ([[self.arrSectionItems objectAtIndex:i] count]){
//				[indices addObject:[[ALPHA substringFromIndex:i] substringToIndex:1]];
//			}
//		}
//		return indices;
//	}
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
//	if ([tfSiteName.text length] > 0) {
//	//if ([self.itemSearchBar.text length] > 0) {
//		return 1;
//	}else {
//		return 28;
//	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ([tfSiteName.text length] > 0) {
	//if ([self.itemSearchBar.text length] > 0) {
		return [self.arrItems count];
	}else {
//		return [[self.arrSectionItems objectAtIndex:section] count];
        return [self.arrItemsCopy count];
	}
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//	
//	if ([self.itemSearchBar.text length] > 0) {
//		return nil;
//	}else {
//		if ([[self.arrSectionItems objectAtIndex:section] count] == 0)
//			return nil;
//		NSString *string = [NSString stringWithFormat:@"%@", [[ALPHA substringFromIndex:section] substringToIndex:1]];
//		return string;
//	}
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	NSString *CellIdentifier = @"CellIdentifier";
//    if ([tfSiteName.text length] > 0) {
//        CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];
//    }
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (nil == cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
		UIImageView *bgView1 = [[UIImageView alloc] init];
        bgView1.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
		bgView1.frame = CGRectMake(0, 0, 320, 54);
        bgView1.tag = 103;
		bgView1.alpha = 0.2;
		[cell.contentView addSubview:bgView1];
		[cell.contentView sendSubviewToBack:bgView1];
		[bgView1 release];
		
		UIImageView *lineBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separatorLine.png"]];
        lineBg.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
		lineBg.frame = CGRectMake(0, 54, 320, 1);
		lineBg.alpha = 0.6;
		[cell.contentView addSubview:lineBg];
		[lineBg release];
		
//		UIImageView *bgView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"outline.png"]];
//		bgView.tag = 112;
//		CALayer *bgLayer = [bgView layer];
//		bgLayer.masksToBounds = YES;
//		bgLayer.cornerRadius = 8;
//		bgView.frame = CGRectMake(5, 6, 42, 42);
//		[cell.contentView addSubview:bgView];
//		[bgView release];
		
		// 头像图片
		UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 18, 19, 19)];
		headImage.tag = 100;
		[cell.contentView addSubview:headImage];
		[headImage release];
		
		//	item名称标签
		UILabel *itemName = [[UILabel alloc] initWithFrame:CGRectMake(40, 4, 260, 30)];
		itemName.tag = 101;
		itemName.backgroundColor = [UIColor clearColor];
		itemName.font = [UIFont systemFontOfSize:16];
		itemName.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
		[cell.contentView addSubview:itemName];
		[itemName release];
		
		// 搜索输入第一行
		UILabel *indexrow1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 320, 50)];
		indexrow1.tag = 110;
		indexrow1.backgroundColor = [UIColor clearColor];
		indexrow1.font = [UIFont systemFontOfSize:22];
		indexrow1.textColor = [UIColor blueColor];
		[cell.contentView addSubview:indexrow1];
		[indexrow1 release];
		
		// 描述标签
		UILabel *itemDes = [[UILabel alloc] initWithFrame:CGRectMake(40, 31, 260, 20)];
		itemDes.tag = 102;
		itemDes.backgroundColor = [UIColor clearColor];
		itemDes.font = [UIFont systemFontOfSize:12];
		itemDes.textColor = [UIColor colorWithRed:132.0f/255.0f green:134.0f/255.0f blue:134.0f/255.0f alpha:1.0f];
		[cell.contentView addSubview:itemDes];
		[itemDes release];
	}
	UILabel *itemName = (UILabel *)[cell.contentView viewWithTag:101];
	UILabel *itemDes = (UILabel *)[cell.contentView viewWithTag:102];
	UILabel *indexRow1 = (UILabel *)[cell.contentView viewWithTag:110];
	UILabel *indexLast = (UILabel *)[cell.contentView viewWithTag:111];
	UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:100];
	UIImageView *bgView = (UIImageView *)[cell.contentView viewWithTag:103];
	bgView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
    itemDes.textColor = [UIColor colorWithRed:132.0f/255.0f green:134.0f/255.0f blue:134.0f/255.0f alpha:1.0f];
    imageView.image = [UIImage imageNamed:@"subScribeEarth.png"];
	if ([tfSiteName.text length] > 0) {
		//if ([self.itemSearchBar.text length] > 0) {
		imageView.hidden = NO;
//		bgView.hidden = NO;
		indexRow1.text = nil;
		indexLast.text = nil;
		if (indexPath.row < [self.arrItems count]) {
			CustomizedSiteInfo *item = (CustomizedSiteInfo *)[self.arrItems objectAtIndex:indexPath.row];
			itemName.text = item.descriptionInfo.svrName;
			NSString *strUrl = [item.descriptionInfo.svrUrl stringByReplacingOccurrencesOfString:@"/index.php/mobile/" withString:@""];
			itemDes.text = strUrl;
		}
	}else {
		indexRow1.text = nil;
		indexLast.text = nil;
		imageView.hidden = NO;
//		bgView.hidden = NO;
//		if (indexPath.section < [arrSectionItems count] && indexPath.row < [[arrSectionItems objectAtIndex:indexPath.section] count]) {
//			CustomizedSiteInfo *item = (CustomizedSiteInfo *)[[self.arrSectionItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//			itemName.text = item.descriptionInfo.svrName;
//			NSString *strUrl = [item.descriptionInfo.svrUrl stringByReplacingOccurrencesOfString:@"/index.php/mobile/" withString:@""];
//			itemDes.text = strUrl;
//		}
        if (indexPath.row < [arrItemsCopy count]) {
			CustomizedSiteInfo *item = (CustomizedSiteInfo *)[self.arrItemsCopy objectAtIndex:indexPath.row];
			itemName.text = item.descriptionInfo.svrName;
			NSString *strUrl = [item.descriptionInfo.svrUrl stringByReplacingOccurrencesOfString:@"/index.php/mobile/" withString:@""];
			itemDes.text = strUrl;
		}
	}
	if (indexPath.row == 0 && [tfSiteName.text length] > 0) {
	//if (indexPath.row == 0 &&  [self.itemSearchBar.text length] > 0) {
		imageView.hidden = YES;
//		bgView.hidden = YES;
		itemName.text = nil;
		itemDes.text = nil;
		//indexRow1.text = self.itemSearchBar.text;
		indexRow1.text = tfSiteName.text;
	}
	return cell;
}

#pragma mark searchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
	self.itemSearchBar.placeholder = @"";
	[self.itemSearchBar setShowsCancelButton:YES animated:YES];
	if ([self.itemSearchBar.text length] == 0) {
		[self.view addSubview:blackCoverView];
	}
}
// 隐藏蒙版
- (void)removeBackCover:(id)sender{
	//[self.itemSearchBar setShowsCancelButton:NO animated:YES];
	if (blackCoverView) {
		[blackCoverView removeFromSuperview];
	}
	//[self.itemSearchBar resignFirstResponder];
	[tfSiteName resignFirstResponder];
}
// 有输入滑动消失键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	//if ([self.itemSearchBar.text length] > 0) {
	//		[self.itemSearchBar resignFirstResponder];
	[tfSiteName resignFirstResponder];
	if ([tfSiteName.text length] > 0) {
		// 找到searchBar上的按钮,将其属性置为enabled = YES
		for(id cc in [self.itemSearchBar subviews])
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
	[self.itemSearchBar setShowsCancelButton:NO animated:YES];
	self.itemSearchBar.placeholder = @"搜索";
	self.itemSearchBar.text = nil;
	if (blackCoverView) {
		[blackCoverView removeFromSuperview];
	}
	[self.itemSearchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self.itemSearchBar resignFirstResponder];
	//[self searchBar:self.itemSearchBar textDidChange:self.itemSearchBar.text];
}

// 按nick与name中出现与搜索关键字相同的进行搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	[arrItems removeAllObjects];
	if ([searchText length] > 0) {
		if (blackCoverView) {
			[blackCoverView removeFromSuperview];
		}
		for (int i = 0; i < [arrItemsCopy count]; i ++) {
			CustomizedSiteInfo *item = (CustomizedSiteInfo *)[self.arrItemsCopy objectAtIndex:i];
			NSRange nickRange = [item.descriptionInfo.svrName rangeOfString:searchText options:NSCaseInsensitiveSearch];
			NSRange nameRange = [item.descriptionInfo.svrUrl rangeOfString:searchText options:NSCaseInsensitiveSearch];
			NSString *sectionName = [NSString stringWithFormat:@"%c",pinyinFirstLetter([item.descriptionInfo.svrName characterAtIndex:0])];
			if (nickRange.length > 0 || nameRange.length > 0 || [sectionName caseInsensitiveCompare:searchText] == NSOrderedSame) {
				[self.arrItems addObject:[arrItemsCopy objectAtIndex:i]];
			}
		}
		// 添加首行
		CustomizedSiteInfo *itemFirst = [[CustomizedSiteInfo alloc] init];
		SiteDescriptionInfo *desInfo = [[SiteDescriptionInfo alloc] init];
		desInfo.svrName = @"server -1";
		desInfo.svrUrl = @"url of server -1";
		itemFirst.descriptionInfo = desInfo; 
		[desInfo release];
		[self.arrItems insertObject:itemFirst atIndex:0];
		[itemFirst release];
	}
	else {
		[self.view addSubview:blackCoverView];
	}
	[self.mainTableView reloadData];
}

// 完成
-(void)doneServerPreparation {
	if ([idParentController respondsToSelector:@selector(doneServerPreparation)]) {
		[idParentController performSelectorOnMainThread:@selector(doneServerPreparation) withObject:nil waitUntilDone:YES];
		[self.navigationController popViewControllerAnimated:NO];
	}
}

- (void)tfTextDidChange {
	NSString *searchText = tfSiteName.text;
	[arrItems removeAllObjects];
	if ([searchText length] > 0) {
		if (blackCoverView) {
			[blackCoverView removeFromSuperview];
		}
		for (int i = 0; i < [arrItemsCopy count]; i ++) {
			CustomizedSiteInfo *item = (CustomizedSiteInfo *)[self.arrItemsCopy objectAtIndex:i];
			NSRange nickRange = [item.descriptionInfo.svrName rangeOfString:searchText options:NSCaseInsensitiveSearch];
			NSRange nameRange = [item.descriptionInfo.svrUrl rangeOfString:searchText options:NSCaseInsensitiveSearch];
			NSString *sectionName = [NSString stringWithFormat:@"%c",pinyinFirstLetter([item.descriptionInfo.svrName characterAtIndex:0])];
			if (nickRange.length > 0 || nameRange.length > 0 || [sectionName caseInsensitiveCompare:searchText] == NSOrderedSame) {
				[self.arrItems addObject:[arrItemsCopy objectAtIndex:i]];
			}
		}
		// 添加首行
		CustomizedSiteInfo *itemFirst = [[CustomizedSiteInfo alloc] init];
		SiteDescriptionInfo *desInfo = [[SiteDescriptionInfo alloc] init];
		desInfo.svrName = @"server -1";
		desInfo.svrUrl = @"url of server -1";
		itemFirst.descriptionInfo = desInfo; 
		[desInfo release];
		[self.arrItems insertObject:itemFirst atIndex:0];
		[itemFirst release];
	}
	else {
		[self.view addSubview:blackCoverView];
	}
	[self.mainTableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	return YES;
}
@end
