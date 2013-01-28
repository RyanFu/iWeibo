//
//  ThemeSkin.m
//  iweibo
//
//  Created by wangying on 6/8/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "ThemeSkin.h"
#import "MBProgressHUD.h"
#import "HpThemeManager.h"
#import "SCAppUtils.h"

@implementation ThemeSkin
@synthesize skinArray,plistArray;

#pragma mark -
#pragma mark Initialization

NSString *const kThemeDidChangeNotification = @"kThemeDidChangeNotification";

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

// 返回上一级控制器
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateTheme:(NSNotification *)noti{
    NSDictionary  *plistDict = [[HpThemeManager sharedThemeManager]themeDictionary];
    NSString *themePathTmp = [plistDict objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    [leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
    [SCAppUtils navigationController:self.navigationController 
                            setImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"navigationbar_bg.png"]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"主题样式";
	skinArray = [[NSArray alloc] initWithObjects:@"黑色主题",@"蓝色主题",nil];
	
    proHD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(60,170, 200, 180)];
    UIImageView *imageSubView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]];
    proHD.customView = imageSubView;
    proHD.mode = MBProgressHUDModeCustomView;
    proHD.labelText = @"切换成功!";
    proHD.labelFont = [UIFont systemFontOfSize:14];
    proHD.hidden = YES;
	proHD.alpha = 1;
	[proHD show:YES];
    proHD.hidden = YES;
    [self.view addSubview:proHD];
    [imageSubView release];
    
    NSDictionary *plistDict = nil;
    NSString *skinPath = [[NSBundle mainBundle] pathForResource:@"ThemeManager" ofType:@"plist"];
    NSDictionary *pathDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThemePath"];
    if ([pathDict count] == 0) {
        plistDict = [[NSArray arrayWithContentsOfFile:skinPath] objectAtIndex:0];
    }
    else{
        plistDict = pathDict;
    }

    plistArray = [[NSArray alloc]initWithContentsOfFile:skinPath];
	NSString *themePathTmp = [plistDict objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    [SCAppUtils navigationController:self.navigationController setImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"navigationbar_bg.png"]]];
	leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
	[leftButton setTitle:@"返回" forState:UIControlStateNormal];
	leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
	[leftButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 5)];
    [leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
	[leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
	self.navigationItem.leftBarButtonItem = leftBar;
	[leftBar release];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification object:nil];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.tabBarController performSelector:@selector(hideNewTabBar)];//隐藏tabbar
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    currentIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentIndex"];
    if ([currentIndex integerValue] == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
        
	cell.textLabel.text = [skinArray objectAtIndex:indexPath.row];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)hideHUD{
    proHD.hidden = YES;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    currentIndex = [NSNumber numberWithInteger:indexPath.row];
    proHD.hidden = NO;
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:1.0];
    
	NSDictionary *skinDic = [plistArray objectAtIndex:indexPath.row];
	[[HpThemeManager sharedThemeManager] setThemeDictionary:skinDic];
    [[NSUserDefaults standardUserDefaults] setObject:skinDic forKey:@"ThemePath"];
    [[NSUserDefaults standardUserDefaults] setObject:currentIndex forKey:@"CurrentIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
	[[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification 
														object:nil 
													  userInfo:nil];
    [tableView reloadData];
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    [leftButton release];
	[plistArray release];
	[skinArray release];
    [super dealloc];
}


@end

