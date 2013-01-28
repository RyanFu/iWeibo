//
//  SelectWeiboPage.m
//  iweibo
//
//  Created by Cui Zhibo on 12-5-14.
//  Copyright (c) 2012年 Beyondsoft. All rights reserved.
//

#import "SelectWeiboPage.h"
#import "WeiboDetailsPage.h"
#import "IWBSvrSettingsManager.h"
#import "CustomizedSiteInfo.h"
#import "SubScribeWeiboViewController.h"
#import "iweiboAppDelegate.h"
#import "MyWBIconView.h"
#import "SubScribeWeiboSearchViewController.h"
#import "ModelAlertDelegate.h"
#import "MySubView.h"
#import "SubViewForThreeItems.h"
#import "LoginPage.h"
#import "AboutIWeiboViewController.h"

@interface SelectWeiboPage (privite)
- (void)achieveInfoFromServer;
@end

@implementation SelectWeiboPage
@synthesize dicThemeResult;



- (id)init{
    self = [super init];
    if (self) {
        allDelateBtn = [[NSMutableArray alloc]init];
        allDelateImg = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)loadView{
    [super loadView];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"homeBig_bg.png"]];
    [self.view addSubview:bgView];
    [bgView release];
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 320, 21)];
    tempView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:tempView];
    [tempView release];
    
    UIImageView *navImageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homeNav_bg.png"]];
    navImageView.frame = CGRectMake(0, 0, 320, NavbgHight);
    navImageView.userInteractionEnabled = YES;
    [self.view addSubview:navImageView];
    [navImageView release];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame =CGRectMake(282, 7, 32, 32);
    [leftBtn addTarget:self action:@selector(showThreeMenuItem:) forControlEvents:UIControlEventTouchUpInside];
    [navImageView addSubview:leftBtn];
    UIImageView *leftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homeParticular.png"]];
    leftImg.frame = CGRectMake(290, 14.5, 17, 17);
    [navImageView addSubview:leftImg];
    [leftImg release];
    
    iWeiboAsyncApi = [[IWeiboAsyncApi alloc] init];
    // 加载本地数据
    [self achieveInfoFromLocal];
    
    navCoverView = [[UIView alloc] initWithFrame:navImageView.bounds];
    navCoverView.backgroundColor = [UIColor clearColor];
    navCoverView.hidden = YES;
    [navImageView addSubview:navCoverView];

    // 如果为第一次进入程序，就加载介绍页面
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [self theAppFirstStartView];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didEnterBackground)
												 name:UIApplicationDidEnterBackgroundNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(willEnterForeground)
												 name:UIApplicationWillEnterForegroundNotification
											   object:nil];

}
// 添加程序第一次启动时介绍页面视图
- (void)theAppFirstStartView{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    UIView *firstShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    firstShowView.backgroundColor = [UIColor blackColor];
    firstShowView.tag = 88;
    [self.view addSubview:firstShowView];
    [firstShowView release];
    
    UIScrollView *scrollViewInFirstView = [[UIScrollView alloc] initWithFrame:firstShowView.bounds];
    scrollViewInFirstView.backgroundColor = [UIColor clearColor];
    scrollViewInFirstView.contentSize = CGSizeMake(320 * 2, 460);
    scrollViewInFirstView.showsVerticalScrollIndicator = NO;
    scrollViewInFirstView.showsHorizontalScrollIndicator = NO;
    scrollViewInFirstView.pagingEnabled = YES;
    scrollViewInFirstView.bounces = YES;
    scrollViewInFirstView.delegate = self;
    scrollViewInFirstView.tag = 10000;
    [firstShowView addSubview:scrollViewInFirstView];
    [scrollViewInFirstView release];
    
    
    for (int i = 1; i < 3; i++) {
        NSString *string = [NSString stringWithFormat:@"homeIntroduce%i",i];
        NSString *introduceFile = [[NSBundle mainBundle] pathForResource:string ofType:@"png"];
        UIImage *introdeceImage = [UIImage imageWithContentsOfFile:introduceFile];
        UIImageView *introdeceImageView = [[UIImageView alloc] initWithImage:introdeceImage];
        introdeceImageView.frame = CGRectMake(320 * (i - 1), 0, 320, 460);
        [scrollViewInFirstView addSubview:introdeceImageView];
        [introdeceImageView release];
    }
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake(68.5 + 320, 300, 183, 38);
    [startBtn setImage:[UIImage imageNamed:@"homeGo_btn.png"] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startTheApp) forControlEvents:UIControlEventTouchUpInside];
    [scrollViewInFirstView addSubview:startBtn];

    
    pageForFirstView = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 440, 320, 10)];
    pageForFirstView.numberOfPages = 2;
    [firstShowView addSubview:pageForFirstView];

}

// 启动程序就是删除介绍页面
- (void)startTheApp{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0];
    [[self.view viewWithTag:88] removeFromSuperview];
    [UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
	[UIView commitAnimations];

}

-(void)didEnterBackground {
	CLog(@"%s", __FUNCTION__);
	// 下载线程暂停
	[[IWBSvrSettingsManager sharedSvrSettingManager] CancelThemeDownLoading];
	if (isDownloadingTheme) {
		isCancelledFromBackground = YES;
	}
}

-(void)willEnterForeground {
	CLog(@"%s", __FUNCTION__);
	// 下载线程重新启动
	if (isCancelledFromBackground) {
		isCancelledFromBackground = NO;
		[self getThemeInfo];
	}
}


- (void)achieveInfoFromLocal{
    int page = ([[IWBSvrSettingsManager sharedSvrSettingManager].arrSiteInfo count] + 1)/ 9;
    if (([[IWBSvrSettingsManager sharedSvrSettingManager].arrSiteInfo count] + 1) % 9 != 0) {
        page ++;
    }
    scrollview = [[MyScrollView alloc]init];
    scrollview.contentSize = CGSizeMake(320 * page, 380);
    scrollview.frame = CGRectMake(0, NavbgHight, 320, 460);
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.pagingEnabled = YES;
    scrollview.bounces = YES;
    scrollview.userInteractionEnabled = YES;
    scrollview.delegate = self;
    scrollview.tag = 20000;
    scrollview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollview];
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 420, 320, 30)];
    pageControl.tag = 1111;
    pageControl.numberOfPages = page;
    [self.view addSubview:pageControl];
    UIView *tempview = [[UIView alloc] initWithFrame:scrollview.bounds];
    [scrollview addSubview:tempview];
    [tempview release];
    
    int i = 0;
    for(CustomizedSiteInfo *customizedSiteInfo in [IWBSvrSettingsManager sharedSvrSettingManager].arrSiteInfo){
        UIImage *img = [UIImage imageWithContentsOfFile:customizedSiteInfo.logoIconPath];
        if (nil == img) {
            img = [UIImage imageNamed:@"icon.png"];
        }
        MyWBIconView *mywbiconview = [[MyWBIconView alloc] initWithFrame:CGRectMake((i% 3) * (40.5 + 67) + 19 + (i / 9) * 320 , 
                                                                                    ((i%9) / 3)  * ( 27 + 96) + 25  , 67, 96 )];
        mywbiconview.userInteractionEnabled = YES;
        mywbiconview.myLabel.userInteractionEnabled = YES;
        [mywbiconview.myButton setBackgroundImage:img forState:UIControlStateNormal];
        mywbiconview.myButton.tag = i + 100;
        [mywbiconview.myButton addTarget:self action:@selector(turnToDetailsPage:) forControlEvents:UIControlEventTouchUpInside];
        mywbiconview.myLabel.text = customizedSiteInfo.descriptionInfo.svrName;
        // 增加是否上次登陆过标记
        if (customizedSiteInfo.nLastActiveStatus == 2) {
            UIImageView	*imgSelected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homeSelected.png"]];
            imgSelected.frame = CGRectMake(0.0f, 0.0f, 27.0f, 27.0f);
            [mywbiconview addSubview:imgSelected];
            [imgSelected release];
        }
        [ scrollview addSubview:mywbiconview];
        [mywbiconview release];
        
        UILongPressGestureRecognizer *longClicked = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMenuControl:)];
        longClicked.minimumPressDuration = 0.7;
        [mywbiconview addGestureRecognizer:longClicked];
        longClicked.view.tag = i + 200;
        [longClicked release];
        i++;
    }
    int j = [IWBSvrSettingsManager sharedSvrSettingManager].arrSiteInfo.count;
    MyWBIconView *addIconView = [[MyWBIconView alloc] initWithFrame:CGRectMake((j% 3) * (40.5 + 67) + 19 + (j / 9) * 320 , 
                                                                               ((i%9) / 3)  * ( 27 + 96) + 25  , 67, 96 )];
    [addIconView.myButton setBackgroundImage:[UIImage imageNamed:@"HomeAdd_app.png"] forState:UIControlStateNormal];
    [addIconView.myButton addTarget:self action:@selector(subscriptionWeibo) forControlEvents:UIControlEventTouchUpInside];
    addIconView.myLabel.text = @"添加更多";
    [scrollview addSubview:addIconView];
    [addIconView release];
    // 点击icon时的蒙版
    bigViewForIcon = [[UIView alloc] initWithFrame:self.view.bounds];
    bigViewForIcon.backgroundColor = [UIColor clearColor];
    // 生成遮挡蒙层，,先隐藏，提示框出现时，蒙层也出现，位于提示框的下一层
    bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320 * page, 460)];
    bigView.backgroundColor = [UIColor clearColor];
    bigView.hidden = YES;
    [scrollview addSubview:bigView];
    for (i = 0; i < [[IWBSvrSettingsManager sharedSvrSettingManager].arrSiteInfo count]; i++) {
        // 删除图片
        UIImageView *delateImg = [[UIImageView alloc] initWithFrame:CGRectMake((i% 3) * (40.5 + 67) + 20 + (i / 9) * 320 - 10.5 , 
                                                                               ((i%9) / 3)  * ( 27 + 96) + 25 - 9  , 25, 25)];
        delateImg.image = [UIImage imageNamed:@"homeDelete.png"];
        delateImg.hidden = YES;
        [allDelateImg addObject:delateImg];
        [scrollview addSubview:delateImg];
        [delateImg release];
        // 删除按钮
        UIButton *delateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delateBtn addTarget:self action:@selector(isDeletaCurrentWB:) forControlEvents:UIControlEventTouchUpInside];
        delateBtn.frame = CGRectMake((i% 3) * (40.5 + 67) + 20 + (i / 9) * 320 - 16 , 
                                     ((i%9) / 3)  * ( 27 + 94) + 26.5   - 15  , 35, 35);
        delateBtn.tag = i;
        delateBtn.hidden = YES;
        [scrollview addSubview:delateBtn];
        [allDelateBtn addObject:delateBtn];
    }
    // ”删除，详情“，提示框
    for (int i = 0; i < [IWBSvrSettingsManager sharedSvrSettingManager].arrSiteInfo.count; i++) {
        // icon在图片最左边时，为防止视图溢出屏幕，要更改x坐标
        if ((i + 1) % 3 == 0) {
            MySubView *subView = [[MySubView alloc] initWithFrame:CGRectMake((i / 9) * 320 + 140, ((i%9) / 3)  * ( 27 + 96) + 25 + 50 , 170, 55 ) WithImageName:@"homeBgright.png" ];
            subView.tag = i + 300;
            subView.hidden = YES;
            [subView.delateBtn addTarget:self action:@selector(deleteCurrentWB) forControlEvents:UIControlEventTouchUpInside];
            [subView.editBtn addTarget:self action:@selector(turnToDetailsPageLong:) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:subView];
            [subView release];

        }else{
            MySubView *subView = [[MySubView alloc] initWithFrame:CGRectMake((i% 3) * (40.5 + 67) + 20 + (i / 9) * 320 - 10, 
                                                                             ((i%9) / 3)  * ( 27 + 96) + 25 + 50 , 170, 55 ) WithImageName:@"homeBgleft.png" ];
            subView.tag = i + 300;
            subView.hidden = YES;
            [subView.delateBtn addTarget:self action:@selector(deleteCurrentWB) forControlEvents:UIControlEventTouchUpInside];
            [subView.editBtn addTarget:self action:@selector(turnToDetailsPageLong:) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:subView];
            [subView release];
        }
    }
    SubViewForThreeItems *threeItemView = [[SubViewForThreeItems alloc] initWithFrame:CGRectMake(60, 27 , 249, 55)];
    threeItemView.tag = 500;
    threeItemView.hidden = YES;
    [threeItemView.editBtn addTarget:self action:@selector(editingWB) forControlEvents:UIControlEventTouchUpInside];
    [threeItemView.aboutBtn addTarget:self action:@selector(aboutWBDetails) forControlEvents:UIControlEventTouchUpInside];
    [threeItemView.addBtn addTarget:self action:@selector(subscriptionWeibo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:threeItemView];
    [threeItemView release];
}

// 用于存储上一次scrollView.contentOffset的值
int xContentOffsetLastTime = 0;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView viewWithTag:10000]) {
        int curPage = scrollView.contentOffset.x / scrollView.frame.size.width;
        pageForFirstView.currentPage = curPage;
        if (scrollView.contentOffset.x > xContentOffsetLastTime) {
            // 向右滑动
            NSLog(@"向右滑动");
            xContentOffsetLastTime = scrollView.contentOffset.x ;
        }
        else if (scrollView.contentOffset.x < xContentOffsetLastTime ){
            // 向左滑动
            NSLog(@"向左滑动");
            xContentOffsetLastTime = scrollView.contentOffset.x ;
        }
        else {
            if (scrollView.contentOffset.x == 320.0f) {
                [self performSelector:@selector(startTheApp) withObject:nil afterDelay:0.2];
                xContentOffsetLastTime = 0;
            }
            return;
        }
    }else{
        int curPage = scrollView.contentOffset.x / scrollView.frame.size.width;
        pageControl.currentPage = curPage;
    }
}

- (void)subscriptionWeibo{
    bigView.hidden = YES;
    [self.view viewWithTag:500].hidden = YES;
	SubScribeWeiboSearchViewController *searchViewController = [[SubScribeWeiboSearchViewController alloc] init];
	searchViewController.idParentController = self;
	[self.navigationController pushViewController:searchViewController animated:YES];
	[searchViewController release];
//    SubScribeWeiboViewController *subscribeViewController = [[SubScribeWeiboViewController alloc] init];
//	subscribeViewController.idParentController = self;
//	[self.navigationController pushViewController:subscribeViewController animated:YES];
//	[subscribeViewController release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL) canPerformAction:(SEL)selector withSender:(id) sender {
    if (selector == @selector(turnToDetailsPageLong:) || selector == @selector(deleteCurrentWB)) {
        return YES;
    }
    if (selector == @selector(editingWB) || selector == @selector(aboutWBDetails) || selector == @selector(subscriptionWeibo)) {
        return YES;
    }
    return NO;
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

// 显示三个选项 
- (void)showThreeMenuItem:(id)sender{
    bigView.hidden = NO;
    scrollview.scrollEnabled = NO;
    [self.view viewWithTag:500].hidden = NO;
}
// 显示“删除，详情”提示框
- (void)showMenuControl:(id)sender{
    UILongPressGestureRecognizer *lonGes = (UILongPressGestureRecognizer *)sender;
    selectTag = lonGes.view.tag;
    if (lonGes.state == UIGestureRecognizerStateBegan) {
        bigView.hidden = NO;
        navCoverView.hidden = NO;
        scrollview.scrollEnabled = NO;
        for (int i = 0; i < [[IWBSvrSettingsManager sharedSvrSettingManager].arrSiteInfo count]; i++) {
            if ([self.view viewWithTag:i + 300]) {
                [self.view viewWithTag:i + 300].hidden = YES;
            }
        }
        [self.view viewWithTag:selectTag + 100].hidden = NO;
    }
}

// 删除当前选中站点
- (void)deleteCurrentWB{
    bigView.hidden = YES;
    navCoverView.hidden = YES;
    [self.view viewWithTag:selectTag + 100].hidden = YES;
    CFRunLoopRef currentRunLoop = CFRunLoopGetCurrent();
	ModalAlertDelegate *modalDelegate = [[ModalAlertDelegate alloc] initWithRunLoop:currentRunLoop];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                    message:@"确定要删除此微博？" 
                                                   delegate:modalDelegate 
                                          cancelButtonTitle:@"确定" 
                                          otherButtonTitles:@"取消", nil];
    [alert show];
    [alert release];
    CFRunLoopRun();
    NSUInteger answer = modalDelegate.index;
    if (answer != 1) {
        [[self.view viewWithTag:selectTag + 100] removeFromSuperview];
        CustomizedSiteInfo *cusInfo = [[IWBSvrSettingsManager sharedSvrSettingManager].arrSiteInfo objectAtIndex:selectTag - 200];
        NSString *Siteurl = [NSString stringWithFormat:@"%@",cusInfo.descriptionInfo.svrUrl];
        [[IWBSvrSettingsManager sharedSvrSettingManager] SigndelateSite:Siteurl];
        [self showViewAgain];
    }    
    [modalDelegate release];
}

// 重新展示视图
- (void)showViewAgain{
    [scrollview removeFromSuperview];
    [scrollview release];
    [pageControl removeFromSuperview];
    [pageControl release];
    [[self.view viewWithTag:500] removeFromSuperview];
    [self achieveInfoFromLocal];

}
// 编辑当前微博，是否删除
- (void)isDeletaCurrentWB:(id)sender{
    bigView.hidden = YES;
    UIButton *btn = (UIButton *)sender;
    CFRunLoopRef currentRunLoop = CFRunLoopGetCurrent();
	ModalAlertDelegate *modalDelegate = [[ModalAlertDelegate alloc] initWithRunLoop:currentRunLoop];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
                                                    message:@"确定要删除此微博？" 
                                                   delegate:modalDelegate 
                                          cancelButtonTitle:@"确定" 
                                          otherButtonTitles:@"取消", nil];
    [alertView show];
    [alertView release];
    CFRunLoopRun();
    NSUInteger answer = modalDelegate.index;
    if (answer != 1) {
        CustomizedSiteInfo *cusInfo = [[IWBSvrSettingsManager sharedSvrSettingManager].arrSiteInfo objectAtIndex:btn.tag];
        NSString *Siteurl = [NSString stringWithFormat:@"%@",cusInfo.descriptionInfo.svrUrl];
        [[IWBSvrSettingsManager sharedSvrSettingManager] SigndelateSite:Siteurl];
        [self showViewAgain];
    }else{
        for (UIButton *theBtn in allDelateBtn) {
            theBtn.hidden = YES;
        }
        for (UIImageView *theImg in allDelateImg) {
            theImg.hidden = YES;
        }
    }
    [modalDelegate release];
}

// 编辑爱微博
- (void)editingWB{
    [self.view viewWithTag:500].hidden = YES;
    for (UIButton *btn in allDelateBtn) {
        btn.hidden = NO;
    }
    for (UIImageView *theImg in allDelateImg) {
        theImg.hidden = NO;
    }

}

// 关于爱微博
- (void)aboutWBDetails{
    bigView.hidden = YES;
    [self.view viewWithTag:500].hidden = YES;
    AboutIWeiboViewController *aboutIWeiboViewController = [[AboutIWeiboViewController alloc] init];
    [self.navigationController pushViewController:aboutIWeiboViewController animated:YES];
    [aboutIWeiboViewController release];
}

// 点击空白地方隐藏提示框
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (int i = 0; i < [[IWBSvrSettingsManager sharedSvrSettingManager].arrSiteInfo count]; i++) {
        if ([self.view viewWithTag:i + 300]) {
            [self.view viewWithTag:i + 300].hidden = YES;
        }
    }
    [self.view viewWithTag:500].hidden = YES;
    for (UIButton *theBtn in allDelateBtn) {
        theBtn.hidden = YES;
    }
    for (UIImageView *theImg in allDelateImg) {
        theImg.hidden = YES;
    }
    bigView.hidden = YES;
    navCoverView.hidden = YES;
    scrollview.scrollEnabled = YES;
}

// 长按图标，详情显示
-(void)turnToDetailsPageLong:(id)sender{
    bigView.hidden = YES;
    navCoverView.hidden = YES;
    [self.view viewWithTag:selectTag + 100].hidden = YES;
    WeiboDetailsPage *weiboDetailsPage = [[WeiboDetailsPage alloc] init];
    weiboDetailsPage.idParentController = self;
    weiboDetailsPage.customizedSiteInfo = [[IWBSvrSettingsManager sharedSvrSettingManager].arrSiteInfo objectAtIndex:selectTag - 200];
	[self.navigationController pushViewController:weiboDetailsPage animated:YES];
    [weiboDetailsPage release];
}

// 单点击图标 
-(void)turnToDetailsPage:(id)sender{
    UIButton *mybutton=(UIButton *)sender;
    btnTag = mybutton.tag - 100;
    for (int i = 0; i < [[IWBSvrSettingsManager sharedSvrSettingManager].arrSiteInfo count]; i++) {
        if ([self.view viewWithTag:i + 300]) {
            [self.view viewWithTag:i + 300].hidden = YES;
        }
    }
    cusinfo = [[IWBSvrSettingsManager sharedSvrSettingManager].arrSiteInfo objectAtIndex:btnTag];
    if (cusinfo.nLastActiveStatus == 0) {
        // 如果曾经未登陆过，则直接进入详情页面，不更新信息
        WeiboDetailsPage *weiboDetailsPage = [[WeiboDetailsPage alloc] init];
        weiboDetailsPage.idParentController = self;
        weiboDetailsPage.isGetInfoFailure = YES;
            weiboDetailsPage.customizedSiteInfo = [[IWBSvrSettingsManager sharedSvrSettingManager].arrSiteInfo objectAtIndex:btnTag];
        [self.navigationController pushViewController:weiboDetailsPage animated:YES];
        [weiboDetailsPage release];
    }else{
        // 如果曾经登陆过，单击此图标后，更新信息，并且跳过详情页面
        [self.view addSubview:bigViewForIcon];
        [[IWBSvrSettingsManager sharedSvrSettingManager] updateAndSetSiteActive:cusinfo.descriptionInfo.svrUrl];
        [self performSelector:@selector(doneServerPreparation) withObject:nil afterDelay:0];
    }
}


-(void)dealloc{
	CLog(@"%s", __FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
	[[IWBSvrSettingsManager sharedSvrSettingManager] CancelThemeDownLoading];
    [scrollview release];
    [pageControl release];
    [allDelateBtn  release];
    [allDelateImg release];
    [iWeiboAsyncApi cancelCurrentRequest];
    [iWeiboAsyncApi release];
    [bigViewForIcon release];
    [bigView release];
    [navCoverView release];
    [pageForFirstView release];
    [super dealloc];
}
#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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

-(void)viewWillAppear:(BOOL)animated {
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
	delegate.draws = 2;
	[self.navigationController setNavigationBarHidden:YES animated:YES];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"come"]) {
        [self theAppFirstStartView];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"come"];
    }
	[super viewWillAppear:animated];
}

-(void)nextStep {
	iweiboAppDelegate *iweboDelegate = (iweiboAppDelegate*)[UIApplication sharedApplication].delegate;
	
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (!(actSite != nil && actSite.bUserLogin)) {
        
        LoginPage *loginController = [[LoginPage alloc] init];
        loginController.view.tag = LOGIN_PAGE_TAG;
        [self.navigationController pushViewController:loginController animated:NO];
        [loginController release];
        [iweboDelegate performSelector:@selector(playAnimation)];
//		[iweboDelegate performSelector:@selector(addLoginPage)];
	}
	else {
		// 准备工作
        [iweboDelegate performSelector:@selector(playAnimation)];
		[iweboDelegate prepareDataForLoginUser];
        iweboDelegate.window.rootViewController = nil;
		iweboDelegate.mainContent = nil;
		[iweboDelegate performSelector:@selector(constructMainFrame)];
		[iweboDelegate performSelector:@selector(addMainFrame)];
	}
    
    // 移除遮挡icon的蒙版
    if(bigViewForIcon){
        [bigViewForIcon removeFromSuperview];
    }
}

//- (void)animationDidStop {
//	iweiboAppDelegate *dele = (iweiboAppDelegate *)[[UIApplication sharedApplication] delegate];
////	dele.window.backgroundColor = [UIColor whiteColor];
//}
// 完成
-(void)doneServerPreparation {
	iweiboAppDelegate *delegate = (iweiboAppDelegate*)[UIApplication sharedApplication].delegate;
	delegate.draws = 1;
	delegate.window.backgroundColor = [UIColor blackColor];
	[delegate performSelector:@selector(addLoadingImg)];
	//delegate.window.rootViewController.wantsFullScreenLayout = YES;
//	BOOL statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
	[UIView beginAnimations:@"flip Server" context:nil];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationTransition:  UIViewAnimationTransitionFlipFromRight forView:delegate.window cache:NO];
	[UIView setAnimationDelegate:self];
//	[UIView setAnimationDidStopSelector:@selector(animationDidStop)];
	[self.navigationController popViewControllerAnimated:NO];
//	//[[UIApplication sharedApplication] setStatusBarHidden:YES];
//	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:delegate.window cache:YES];
	[UIView commitAnimations];	
	//[[UIApplication sharedApplication] setStatusBarHidden:statusBarHidden];
	[self performSelector:@selector(nextStep) withObject:nil afterDelay:2.0f];
	

}

#pragma mark getInfo

-(void)iconsDidFinishedDownloadingWithPar:(NSDictionary *)result {
	isDownloadingTheme = NO;
	CLog(@"%s", __FUNCTION__);// 更新信息theme信息
	NSString *ret = [result objectForKey:@"ret"];
	if ([ret intValue] != 0) {
		NSString *strFolder = [result objectForKey:@"PATH"];
		NSNumber *ver = [self.dicThemeResult objectForKey:@"version"];
		NSString *strVer = [NSString stringWithFormat:@"%@", ver];
		NSDictionary *dicTheme = [self.dicThemeResult objectForKey:@"list"];
		// 保存信息到本地文件themeDic:(NSDictionary *)dicDeltaTheme andIconFolder
		BOOL bResult = [[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:cusinfo.descriptionInfo.svrUrl
																		   withVer:strVer 
																		  themeDic:dicTheme
																	 andIconFolder:strFolder];
		if (!bResult) {
//			[self getResultFailedWithDes:@"保存数据异常"];	// 异常情况下，可继续执行
		}
	}
	else {
//		[self getResultFailedWithDes:@"下载文件超时"];	// 异常情况下，可继续执行
	}
	[self performSelectorOnMainThread:@selector(achieveInfoFromServer) withObject:nil waitUntilDone:NO];
}

-(void)getThemeInfo {
	NSMutableDictionary *par = [NSMutableDictionary dictionaryWithCapacity:3];
	[par setObject:@"json" forKey:@"format"];
	[par setObject:@"customized/theme" forKey:@"request_api"];
	[par setObject:cusinfo.themeVer forKey:@"ver"];
	[iWeiboAsyncApi getCustomizedThemeWithUrl:cusinfo.descriptionInfo.svrUrl Parameters:par delegate:self
                                    onSuccess:@selector(onGetThemeSuccess:) onFailure:@selector(onGetThemeFailure:)];
}

- (void)onGetThemeSuccess:(NSDictionary *)reciveData{
    NSLog(@"reciveData is %@",reciveData);
    NSDictionary *dicData = [DataCheck checkDictionary:reciveData forKey:@"data" withType:[NSDictionary class]];
    NSLog(@"dicData is %@",dicData);
	if ([dicData isKindOfClass:[NSDictionary class]] && [dicData count] > 0) {
		self.dicThemeResult = dicData;
		NSDictionary *dicTheme = [dicData objectForKey:@"list"];
        NSLog(@"dicTheme is %@",dicTheme);
		if ([dicTheme isEqual:[NSNull null]] || [dicTheme count] == 0) {
			// 最新版本，或者获取异常
			// 获取主题失败不影响登陆
			[self performSelector:@selector(achieveInfoFromServer) withObject:nil afterDelay:0];
		}
		else {
            isDownloadingTheme = YES;
			[[IWBSvrSettingsManager sharedSvrSettingManager] downloadTheme:cusinfo.descriptionInfo.svrUrl
																wiThemeDic:dicTheme 
																  delegate:self 
																  Callback:@selector(iconsDidFinishedDownloadingWithPar:)];
        }
	}
	else {
		// 获取主题失败不影响登陆
		[self performSelector:@selector(achieveInfoFromServer) withObject:nil afterDelay:0];
	}
}

- (void)onGetThemeFailure:(NSError *)error{
    NSLog(@"error for updata theme!");
    // 获取主题失败，也要激活并出现loading页面
        [[IWBSvrSettingsManager sharedSvrSettingManager] updateAndSetSiteActive:cusinfo.descriptionInfo.svrUrl];
        [self doneServerPreparation];
}

- (void) achieveInfoFromServer{
    NSLog(@"come in fromServer!");
    NSMutableDictionary *par = [NSMutableDictionary dictionaryWithCapacity:2];
	[par setObject:@"json" forKey:@"format"];
	[par setObject:@"customized/siteinfo" forKey:@"request_api"];
    [iWeiboAsyncApi getCustomizedSiteInfoWithUrl:cusinfo.descriptionInfo.svrUrl 
                                      Parameters:par 
                                        delegate:self 
                                       onSuccess:@selector(onCheckSuccess:) 
                                       onFailure:@selector(onCheckFailure:)];
    NSLog(@"cc = %@",cusinfo.descriptionInfo.svrUrl);
}

-(void)donePreparation {
	if ([idParentController respondsToSelector:@selector(doneServerPreparation)]) {
		[idParentController performSelectorOnMainThread:@selector(doneServerPreparation) withObject:nil waitUntilDone:YES];
		[self.navigationController popViewControllerAnimated:NO];
	}

}

- (void)onCheckSuccess:(NSDictionary *)recivedData{
    NSLog(@"recive = %@",recivedData);
	NSDictionary *dicData = [recivedData objectForKey:@"data"];
	if ([dicData isKindOfClass:[NSDictionary class]] ) {
		SiteDescriptionInfo *siteDescriptionInfo = [[SiteDescriptionInfo alloc] initWithDic:dicData];
		NSString *strUrl = [cusinfo.descriptionInfo.svrUrl copy];
		cusinfo.descriptionInfo = siteDescriptionInfo;
		[[IWBSvrSettingsManager sharedSvrSettingManager] updateSite:strUrl withDescription:cusinfo.descriptionInfo];
		[siteDescriptionInfo release];
		[strUrl release];
        NSMutableArray *newInfoArray = [IWBSvrSettingsManager sharedSvrSettingManager].arrSiteInfo;
        CustomizedSiteInfo *newInfo = [newInfoArray objectAtIndex:btnTag];
                // 获取数据成功，用新的数据来更新
                [[IWBSvrSettingsManager sharedSvrSettingManager] updateAndSetSiteActive:newInfo.descriptionInfo.svrUrl];
                [self doneServerPreparation];
	}
	else {
                [[IWBSvrSettingsManager sharedSvrSettingManager] updateAndSetSiteActive:cusinfo.descriptionInfo.svrUrl];
                [self doneServerPreparation];
	}
	[self performSelectorOnMainThread:@selector(donePreparation) withObject:nil waitUntilDone:YES];
}

- (void)onCheckFailure:(NSError *)failData{
    NSLog(@"error to get reciveData from server!");
            [[IWBSvrSettingsManager sharedSvrSettingManager] updateAndSetSiteActive:cusinfo.descriptionInfo.svrUrl];
            [self doneServerPreparation];

}

@end
