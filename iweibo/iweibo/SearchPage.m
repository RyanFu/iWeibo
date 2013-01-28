//
//  SearchPage.m
//  iweibo
//
//  Created by LiQiang on 11-12-27.
//  Copyright 2011年 Beyondsoft. All rights reserved.
//

#import "SearchPage.h"
#import "SearchCatalogViewController.h"
#import "HotTopicController.h"
#import "UITableViewControllerEx.h"
#import "HotBroadcastTableViewController.h"
#import "HpThemeManager.h"
#import "SCAppUtils.h"

@implementation SearchPage
@synthesize searchPageMainView;
@synthesize btnTitleArray,searchImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
	searchPageMainView.mySearchPageMainViewDelegate = nil;
	[searchPageMainView release];
	searchPageMainView = nil;
    [searchImageView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)updateTheme:(NSNotification *)not{
    NSDictionary  *plistDic = [[HpThemeManager sharedThemeManager]themeDictionary];
    NSString *themePathTmp = [plistDic objectForKey:@"SearchPageFirstImage"];
    NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    searchImageView.image = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchInput.png"]];;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	// 1. 隐藏导航栏
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	// 2. 加载搜索框(先用图片替换)
    
    NSDictionary *plistDic = nil;
    NSDictionary *pathDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"ThemePath"];
    if ([pathDic count] == 0){
        plistDic = [[HpThemeManager sharedThemeManager] themeDictionary];
        if ([plistDic count] == 0) {
            NSString *skinPath = [[NSBundle mainBundle] pathForResource:@"ThemeManager" ofType:@"plist"];
            plistDic = [[NSArray arrayWithContentsOfFile:skinPath] objectAtIndex:0];
        }
    }
    else{
        plistDic = pathDic;
    }
    
    NSString *themePathTmp = [plistDic objectForKey:@"SearchPageFirstImage"];
    NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    
	searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40)];	// 图片尺寸
	searchImageView.userInteractionEnabled = YES;
	searchImageView.image = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"SearchInput.png"]];;
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhoto:)];
	[searchImageView addGestureRecognizer:tapGesture];
	[tapGesture release];
	[self.view addSubview:searchImageView];
	
	// 3. 加载主视图
	searchPageMainView = [[SearchPageMainView alloc] initWithFrame:CGRectMake(0.0f, 40.0f, 320.0f, 373-2.0f)];	// 480-20-40-48
	searchPageMainView.mySearchPageMainViewDelegate = self;
	[self.view addSubview:searchPageMainView];
	// 4. 加载关键词数据(未完成)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (btnTitleArray == nil) {
		btnTitleArray = [[NSMutableArray alloc] initWithCapacity:10];
	}
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	[self.btnTitleArray removeAllObjects];
	// 从数据库中读取订阅的话题
	 NSMutableArray *topicArray = [NSMutableArray arrayWithCapacity:10];
	NSMutableArray *subscibedArray = [DataManager getHotWordSearchFromDatabase:@"0"];
	NSMutableArray *hottopicArray = [DataManager getHotWordSearchFromDatabase:@"1"];
	// 将已订阅的话题和热门话题两个数组进行拼接
	if ([subscibedArray count] > 0) {
		int subscibedNum = [subscibedArray count];
		for (int i = 0; i < subscibedNum; i++) {
			[topicArray addObject:[[subscibedArray objectAtIndex:subscibedNum-i-1] objectForKey:@"hotWord"]];
		}
	}
	if ([hottopicArray count] > 0) {
		int hottopicNum = [hottopicArray count];
		for (int j = 0; j < hottopicNum; j++) {
			NSString *hotWord = [[hottopicArray objectAtIndex:hottopicNum-j-1] objectForKey:@"hotWord"];
			if ([subscibedArray count] == 0) {
				[topicArray addObject:hotWord];
			}else if (![topicArray containsObject:hotWord]) {			// 去除重复话题
				[topicArray addObject:hotWord];
			}
		}
	}
	if ([topicArray count] >= 6) {
		topicArray = [NSMutableArray arrayWithArray:[topicArray subarrayWithRange:NSMakeRange(0, 6)]];
		for (int i = 0; i <  [topicArray count]; i++) {
			[self.btnTitleArray addObject:[topicArray objectAtIndex:i]];
		}
	}else {
		for (int i = 0; i < [topicArray count]; i++) {
			[self.btnTitleArray addObject:[topicArray objectAtIndex:i]];
		}
	}
	[self.searchPageMainView.firstView setBtnTitleArray:self.btnTitleArray];
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

// 点击图片
- (void) tapPhoto:(UITapGestureRecognizer *)gesture{
	// 打开搜索关键字界面
	SearchCatalogViewController *searchCatalogViewController = [[SearchCatalogViewController alloc] init];
	 //searchCatalogViewController.preText = @"xxx";
	[self.navigationController pushViewController:searchCatalogViewController animated:YES];
	[searchCatalogViewController release];	
}
#pragma mark -
#pragma protocol SearchPageMainViewDelegate<NSObject>
// 按钮点击事件
// infoBtn:相应参数信息
-(void)SearchPageMainViewBtnClicked:(UIButton *)btnClicked withInfo:(id)infoBtn {
	switch (btnClicked.tag) {
		case SPVFirstTopicBtnTag: 
			[self touchBtn:btnClicked.titleLabel.text];
			break;
		case SPVSecondTopicBtnTag:
			[self touchBtn:btnClicked.titleLabel.text];
			break;
		case SPVThirdTopicBtnTag:
			[self touchBtn:btnClicked.titleLabel.text];
			break;
		case SPVFourthTopicBtnTag:
			[self touchBtn:btnClicked.titleLabel.text];
			break;
		case SPVFifthTopicBtnTag: {
			// 话题按钮点击
			// 获取对应信息
			// 生成对应窗体
			[self touchBtn:btnClicked.titleLabel.text];
			break;
		}
			break;
		case SPVMoreTopicBtnTag: {
			// 更多按钮点击
			// 获取对应信息
			// 生成对应窗体
			[self touchBtn:btnClicked.titleLabel.text];
			break;
		}
        case SPVHotBroadcastMsgBtnTag:{ 
            HotBroadcastTableViewController *hotBroadcastViewCtrl = [[HotBroadcastTableViewController alloc] init];
			[self.tabBarController performSelector:@selector(hideNewTabBar)];//隐藏tabbar
			[self.navigationController.navigationBar setHidden:NO];
			[self.navigationController pushViewController:hotBroadcastViewCtrl animated:YES];
			[hotBroadcastViewCtrl release];
        }
			break;
        case SPVHotTopicBtnTag:{
            HotTopicController *hotTopic = [[HotTopicController alloc] init];
			[self.navigationController pushViewController:hotTopic animated:YES];
			[hotTopic release];
        }
            break;
        case SPVHotUserBtnTag:{
            HotUserViewController *controller = [[HotUserViewController alloc] init];
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
        }
            break;
		default:
			break;
	}
}

- (void)SearchPageMainTableViewClicked:(NSUInteger)indexRow{
    switch (indexRow) {
        case 0:
        {
            HotTopicController *hotTopic = [[HotTopicController alloc] init];
			[self.navigationController pushViewController:hotTopic animated:YES];
			[hotTopic release];
            break;
        }
        case 1:
        {
            HotBroadcastTableViewController *hotBroadcastViewCtrl = [[HotBroadcastTableViewController alloc] init];
			[self.tabBarController performSelector:@selector(hideNewTabBar)];//隐藏tabbar
			[self.navigationController.navigationBar setHidden:NO];
			[self.navigationController pushViewController:hotBroadcastViewCtrl animated:YES];
			[hotBroadcastViewCtrl release];
        }
            break;
        case 2:
        {
            HotUserViewController *controller = [[HotUserViewController alloc] init];
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark 点击按钮响应
- (void)touchBtn:(NSString *)string{
	fromFront = YES;
	SearchCatalogViewController *searchCatalogViewController = [[SearchCatalogViewController alloc] init];
	string = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
	searchCatalogViewController.preText = string;
	[self.navigationController pushViewController:searchCatalogViewController animated:YES];
	[searchCatalogViewController release];	
}


@end
