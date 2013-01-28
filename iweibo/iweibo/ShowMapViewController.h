//
//  ShowMapViewController.h
//  iweibo
//
//  Created by Cui Zhibo on 12-4-23.
//  Copyright (c) 2012年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AddressForMapModel.h"

extern NSString *const kThemeDidChangeNotification;

@interface ShowMapViewController : UIViewController
<MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,MKAnnotation>
{
    UIButton                *leftButton;
    
    MKMapView               * myMapView;            // 地图
	MKPointAnnotation		* pinAnnotation;        // 图钉定位
    CLLocationManager       * gpsManger;            // 位置管理器
    CLLocationCoordinate2D    currentLocation;      // 当前位置
    
    UITableView             * addrTableView;        // 地址表格
    NSMutableArray          * addrArray;            // 存放地址数组
    AddressForMapModel      * _myModel;             // 地址模型
    CGFloat                 currentLatitude;        // 当前经度
    CGFloat                 currentLongitude;       // 当前纬度    
    
    SEL                      cancel_;               
    
    id                      delegate_;              
    
}
@property (nonatomic, retain) id delegate;
@property (nonatomic, assign) SEL cancel;
@property (nonatomic, assign) CGFloat currentLatitude;
@property (nonatomic, assign) CGFloat currentLongitude;
@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;

@property (retain,nonatomic) NSMutableArray *addrArray;
-(void)initMap;
-(void)StartGPS;

@end

