//
//  DisaplayMapViewController.h
//  iweibo
//
//  Created by Cui Zhibo on 12-4-24.
//  Copyright (c) 2012年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

extern NSString *const kThemeDidChangeNotification;

@interface DisaplayMapViewController : UIViewController<MKMapViewDelegate,MKAnnotation>
{
    UIButton        *leftButton;
    CLLocationCoordinate2D theUesrCenter;
}

@property (nonatomic, retain) UIButton      *leftButton;
@property (nonatomic, assign) CLLocationCoordinate2D theUserCenter;

@end
