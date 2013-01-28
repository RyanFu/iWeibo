    //
//  About.m
//  iweibo
//
//  Created by wangying on 3/6/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "AboutView.h"
#import "HpThemeManager.h"

@implementation AboutView

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// 返回上一级控制器
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateTheme:(NSNotificationCenter *)noti{
    NSDictionary *plistDict = [[HpThemeManager sharedThemeManager]themeDictionary];
    NSString *themePathTmp = [plistDict objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    [editBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"composebtn-bg.png"]] forState:UIControlStateNormal];
}

// 添加返回按钮
- (void)addBarBtn {
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
	
	editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	editBtn.frame = CGRectMake(0, 0, 50, 30);
	editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
	[editBtn setTitle:@"设置" forState:UIControlStateNormal];
	[editBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
	[editBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"composebtn-bg.png"]] forState:UIControlStateNormal];
	
	UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
	self.navigationItem.leftBarButtonItem = editItem;
	[editItem release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
	[customLab setTextColor:[UIColor whiteColor]];
	[customLab setText:@"关于"];
	[customLab setTextAlignment:UITextAlignmentCenter];
	customLab.backgroundColor = [UIColor clearColor];
	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	self.navigationItem.titleView = customLab;
	[customLab release];
	//self.title = @"关于";
	
	[self addBarBtn];
	UIImage *image = [UIImage imageNamed:@"about.png"];
	aboutImage = [[UIImageView alloc] initWithImage:image];
	[self.view addSubview:aboutImage];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification object:nil];
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.tabBarController performSelector:@selector(hideNewTabBar)];//隐藏tabbar
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
    [super dealloc];
}


@end
