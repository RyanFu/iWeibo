    //
//  SettingView.m
//  iweibo
//
//  Created by wangying on 2/28/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "SettingView.h"
#import "iweiboAppDelegate.h"
#import "ColorUtil.h"
#import "HpThemeManager.h"
#import "DetailPageConst.h"
#import "DataManager.h"
#import "AboutView.h"
#import "ThemeSkin.h"
#import "SCAppUtils.h"

#define ALERTYES  10
@implementation SettingView

@synthesize settingTable,contentArray,mbProgress;
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

- (void)updateTheme:(NSNotificationCenter *)noti{
    NSDictionary *plistDict = [[HpThemeManager sharedThemeManager]themeDictionary];
    NSString *themePathTmp = [plistDict objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    [editBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"composebtn-bg.png"]] forState:UIControlStateNormal];
    UIImage *imageNav = [UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"navigationbar_bg.png"]];
    [SCAppUtils navigationController:self.navigationController setImage:imageNav];
}

#pragma mark -
#pragma mark viewDidLoad
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
	UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
	[customLab setTextColor:[UIColor whiteColor]];
	[customLab setText:@"设置"];
	[customLab setTextAlignment:UITextAlignmentCenter];
	customLab.backgroundColor = [UIColor clearColor];
	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	self.navigationItem.titleView = customLab;
	[customLab release];
	//self.title = @"设置";

	self.navigationItem.hidesBackButton = YES;
//	UIBarButtonItem	 *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(finishedOK)];
//	self.navigationItem.rightBarButtonItem = item;
//	[item release];
	editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
	editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
	[editBtn setTitle:@"完成" forState:UIControlStateNormal];
	[editBtn addTarget:self action:@selector(finishedOK) forControlEvents:UIControlEventTouchUpInside];
	[editBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"composebtn-bg.png"]] forState:UIControlStateNormal];
	
	UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
	self.navigationItem.rightBarButtonItem = editItem;
	[editItem release];
	
	settingTable = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]style:UITableViewStyleGrouped];
	settingTable.backgroundColor = [UIColor colorStringToRGB:MoreSettingBackgroundColor];
	settingTable.delegate = self;
	settingTable.dataSource = self;
	[self.view addSubview:settingTable];
	
	contentArray = [[NSArray alloc] initWithObjects:@"去给微博打个分，支持一下",
																@"提示声音",
																@"清理缓存",
																@"关于",
																@"主题",nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification object:nil];
}


- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.tabBarController performSelector:@selector(hideNewTabBar)];//隐藏tabbar
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[self.tabBarController performSelector:@selector(showNewTabBar)];//显示tabbar
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)animationDidStop {
	iweiboAppDelegate *dele = (iweiboAppDelegate *)[[UIApplication sharedApplication] delegate];
	dele.window.backgroundColor = [UIColor whiteColor]; 
}

- (void)finishedOK{
	iweiboAppDelegate *dele = (iweiboAppDelegate *)[[UIApplication sharedApplication] delegate];
	dele.window.backgroundColor = [UIColor blackColor];
	[UIView beginAnimations:@"View Flip" context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationTransition:  UIViewAnimationTransitionFlipFromLeft forView:dele.mainContent.view cache: NO];	
	[UIView setAnimationDelegate:self];
//	[UIView setAnimationDidStopSelector:@selector(animationDidStop)]; 注释掉此行，解决界面翻转太快时候，背景出现白色的现象
	
	[self.navigationController popViewControllerAnimated:NO];
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
	return 5;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	NSInteger count = 1;
	return count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	UISwitch *soundSwitch = nil;
	
	NSUInteger section = indexPath.section;
	static NSString *cellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	switch (section) {
		case 0:
			cell.textLabel.text = [contentArray objectAtIndex:section];
			break;
		case 1:
			soundSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(120, 10, 80, 40)];
			NSNumber *state = [[NSUserDefaults standardUserDefaults] objectForKey:KEYPLAYSOURND];
			if (state != nil) {
				[soundSwitch setOn:[state boolValue] animated:YES];
			}
			else {
				[soundSwitch setOn:NO animated:YES];
			}
			
			[soundSwitch addTarget:self action:@selector(setPlaySound:) forControlEvents:UIControlEventValueChanged];
			cell.textLabel.text = [contentArray objectAtIndex:section];
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.accessoryView = soundSwitch;
			[soundSwitch release];
			break;
		case 2:
			cell.textLabel.text = [contentArray objectAtIndex:section];
			cell.accessoryType = UITableViewCellAccessoryNone;
			break;
		case 3:
			cell.textLabel.text = [contentArray objectAtIndex:section];
			break;
		case 4:
			cell.textLabel.text = [contentArray objectAtIndex:section];
			break;
		default:
			break;
	}
	
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	switch (indexPath.section) {
		case 0:
			[self performSelector:@selector(linkAppstore) withObject:nil afterDelay:0.2f];
			break;
		case 1:
			break;
		case 2:
			[self ClickdarftListButton];
			break;
		case 3:
			[self loadAboutView];
			break;
		case 4:
		{
			ThemeSkin *ehSkin = [[ThemeSkin alloc] initWithStyle:UITableViewStyleGrouped];
			[self.navigationController pushViewController:ehSkin animated:YES];
			[ehSkin release];
		}
			break;
		default:
			break;
	}
	 
}

- (void)linkAppstore {
	//&id=%d,m_appleID
	NSString *str =  @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=513868785";//%d,m_appleID";  
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat height = 45.0f;
	return height;
}

#pragma mark -
#pragma mark otherFunctions

- (void) hiddenMBProgress{
    [mbProgress hide:YES];
}

- (void)showMBProgress{

    if (mbProgress == nil) {
        mbProgress = [[MBProgressHUD alloc] initWithFrame:CGRectMake(30, 80, 260, 260)];
		
		mbProgress.labelText = @"缓存清理完毕"; 
		UIImageView  *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ISOK]];
		mbProgress.customView = imageView;
		[imageView release];
		mbProgress.mode = MBProgressHUDModeCustomView;
    }
	
    [self.view addSubview:mbProgress];  
    [self.view bringSubviewToFront:mbProgress];  
    mbProgress.removeFromSuperViewOnHide = YES;
    [mbProgress show:YES];  
	[self performSelector:@selector(hiddenMBProgress) withObject:nil afterDelay:1];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 1) {
		[DataManager removeWeiboInfoFromDB];
		[DataManager removeMessageWeiboInfoFromDB];
		[DataManager removeSourceInfoFromDB];
		[DataManager removeMessageSourceInfoFromDB];
		[self showMBProgress];
	}
}

//清除主timeline和消息页数据
- (void)ClickdarftListButton{
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil
													message:@"确定要清除缓存吗?"
												   delegate:self
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:@"确定",nil]autorelease];
	[alert show];

}

//加载关于页面
- (void)loadAboutView{
	AboutView *about = [[AboutView alloc] init];
	[self.navigationController pushViewController:about animated:YES];
	[about release];
}

#pragma mark -

- (void)setPlaySound:(id)sender{
	playsound = ((UISwitch*)sender).on;
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithBool:playsound] forKey: KEYPLAYSOURND];
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
    [editBtn release];
	[settingTable release];
	[contentArray release];
    [super dealloc];
}


@end
