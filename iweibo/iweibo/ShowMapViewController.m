//
//  ShowMapViewController.m
//  iweibo
//
//  Created by Cui Zhibo on 12-4-23.
//  Copyright (c) 2012年 Beyondsoft. All rights reserved.
//

#import "ShowMapViewController.h"
#import "AddressForMapCell.h"
#import "HpThemeManager.h"
#import "IWeiboAsyncApi.h"
#import "Canstants_Data.h"

@implementation ShowMapViewController
@synthesize addrArray;
@synthesize delegate = delegate_;
@synthesize cancel = cancel_;
@synthesize currentLatitude;
@synthesize currentLongitude;
@synthesize currentLocation;

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    [leftButton release];
    [delegate_ release];
    [pinAnnotation release];
    [gpsManger release];
    [addrArray release];
    [super dealloc];
}

- (void)updateTheme:(NSNotification *)noti{
    NSDictionary  *plistDict = [[HpThemeManager sharedThemeManager]themeDictionary];
    NSString *themePathTmp = [plistDict objectForKey:@"Common"];
	NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    [leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];
}

-(void)loadView
{
    
    [super loadView];
    
    //    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self            action:@selector(goBack:)];
    //     self.navigationItem.leftBarButtonItem = leftButton;
    //     [leftButton release];
    
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithTitle:@"取消定位" style:UIBarButtonItemStylePlain target:self action:@selector(quxiao:)] ;
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
    
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
    
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
	leftButton.frame = CGRectMake(0, 0, 50, 30);
	[leftButton setTitle:@"返回" forState:UIControlStateNormal];
	leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
	[leftButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 5)];
    [leftButton setBackgroundImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"hotUserBack.png"]] forState:UIControlStateNormal];	
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
	self.navigationItem.leftBarButtonItem = leftBar;
	[leftBar release];
    
    
    self.title = @"当前位置";
    
    
    
    [self initMap];
  //  [self StartGPS];
    
    
    addrTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 106, 320, 354) style:UITableViewStylePlain];
    addrTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    addrTableView.delegate = self;
    addrTableView.dataSource = self;
    
    
    [self.view addSubview:addrTableView];
    
    
    [addrTableView release];
    
    addrArray = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification object:nil];
    
}


-(void)goBack:(id)sender
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)quxiao:(id)sender
{
    if ([delegate_ respondsToSelector:cancel_]) {
        [delegate_ performSelector:cancel_];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showMapSuccess:(id)sender{
    NSLog(@" Success dict = %@",sender);
}

- (void)showMapFailure:(id)sender{
    NSLog(@"error dict = %@",sender);
}

-(void)initMap
{
    IWeiboAsyncApi *iWeiboAsyncApi = [[IWeiboAsyncApi alloc]init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:@"json" forKey:@"format"];
    [dict setValue:[NSString stringWithFormat:@"%d",30] forKey:@"reqnum"];
    
    [dict setObject:@"113.94830703735352,22.54046422124227" forKey:@"lnglat"];
    [dict setObject:URL_GET_POI forKey:@"request_api"];
    [dict setObject:@"wb" forKey:@"reqsrc"];    
    
    //    SEL showMapSuccess = @selector(:);
    
    [iWeiboAsyncApi getGeocodingWithParamters:dict delegate:self onSuccess:@selector(showMapSuccess) onFailure:@selector(showMapFailure:)];
    
	[self StartGPS];
    myMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    
    myMapView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [myMapView setMapType:MKMapTypeStandard];
    
    
	// 当下面这句存在时，会有蓝色的聚焦点
    // myMapView.showsUserLocation = YES;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    
    span.latitudeDelta=0.1f; 
    span.longitudeDelta=0.1f;
    
    region.span=span;
    region.center=currentLocation;
    [myMapView setRegion:region animated:YES];
    [myMapView regionThatFits:region];
    pinAnnotation.coordinate = currentLocation;

    
	pinAnnotation = [[MKPointAnnotation alloc] init];

	[myMapView addAnnotation:pinAnnotation];

    
    [self.view addSubview:myMapView];
    [myMapView release];
    
    
}

-(void)StartGPS{
    
    if(gpsManger == nil){
        gpsManger = [[CLLocationManager alloc] init];
    }
    if(![CLLocationManager locationServicesEnabled]){
        NSLog(@"no GPS");
    }else{
        gpsManger.delegate = self;
        gpsManger.desiredAccuracy =  kCLLocationAccuracyBest;
        gpsManger.distanceFilter = 100.0f; 
        [gpsManger startUpdatingLocation];

    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    NSLog(@"come in");
    MKPinAnnotationView *pinView = nil;
    
    static NSString *defaultPinID = @"com.invasivecode.pin";
    pinView = (MKPinAnnotationView *)[myMapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if ( pinView == nil ){
        pinView = [[[MKPinAnnotationView alloc]
                    initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
    }else{
        
        pinView.annotation = annotation;
    }
    pinView.pinColor = MKPinAnnotationColorRed;
    pinView.canShowCallout = YES;
    pinView.animatesDrop = YES;
    return pinView;
    NSLog(@"end!");
}

 -(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
 {

	 MKCoordinateSpan span;
	 
	 currentLocation = [newLocation coordinate];

	 span.latitudeDelta=0.1f; 
	 span.longitudeDelta=0.1f;

     MKCoordinateRegion region = {currentLocation, span};
	 [myMapView setRegion:region animated:YES];
	 [myMapView regionThatFits:region];
     pinAnnotation.coordinate = currentLocation;

	 
 }
 
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"error is %@",[error localizedDescription]);
}

#pragma mark - tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * cellID = @"CEllID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID ];
    if (!cell) {
        cell = [[[AddressForMapCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
        
        if (addrArray.count) {
            //         AddressForMapModel * model = [addrArray objectAtIndex:indexPath.row];
            
            
        }
    }
    return cell;
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
