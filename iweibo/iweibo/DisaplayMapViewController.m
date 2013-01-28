//
//  DisaplayMapViewController.m
//  iweibo
//
//  Created by Cui Zhibo on 12-4-24.
//  Copyright (c) 2012年 Beyondsoft. All rights reserved.
//

#import "DisaplayMapViewController.h"
#import "HpThemeManager.h"

@implementation DisaplayMapViewController
@synthesize theUserCenter;
@synthesize leftButton;

- (void)updateTheme:(NSNotificationCenter *)noti{
    NSDictionary *plistDict = [[HpThemeManager sharedThemeManager]themeDictionary];
    NSString *themePathTmp = [plistDict objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    if (themePath) {
        [leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
    }
}

- (void)loadView{

    [super loadView];
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
	
    leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
	[leftButton setTitle:@"返回" forState:UIControlStateNormal];
	leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
	[leftButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 5)];
    if (themePath) {
        [leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
    }
    
	[leftButton addTarget:self action:@selector(goForBack:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
	self.navigationItem.leftBarButtonItem = leftBar;
	[leftBar release];
    
    self.title = @"地图";
    
    MKMapView * userMapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    userMapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    userMapView.delegate = self;
    [userMapView setMapType:MKMapTypeStandard];
    
    userMapView.zoomEnabled = YES;
    userMapView.scrollEnabled = YES;
    
    MKCoordinateSpan theUserSpan;
    theUserSpan.latitudeDelta = 0.1;
    theUserSpan.longitudeDelta = 0.1;
    
    
    MKCoordinateRegion theUserRegion = {theUesrCenter, theUserSpan};
    [userMapView setRegion:theUserRegion animated:YES];
    
    MKPointAnnotation	* pinAnnotation = [[MKPointAnnotation alloc] init];
    pinAnnotation.coordinate = theUesrCenter;
    [userMapView addAnnotation:pinAnnotation];
    [pinAnnotation release];
    
    [self.view addSubview:userMapView];
    [userMapView release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification object:nil];
}

-(void)goForBack:(id)sender
{
 
    [self.navigationController popToRootViewControllerAnimated:YES];
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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    [leftButton release];
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

@end
