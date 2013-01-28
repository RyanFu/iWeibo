//
//  ThemeSkin.h
//  iweibo
//
//  Created by wangying on 6/8/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;

@interface ThemeSkin : UITableViewController {
	NSArray			*skinArray; 
	NSArray			*plistArray;
    UIButton        *leftButton;
    NSNumber        *currentIndex;
    MBProgressHUD   *proHD;
}

@property (nonatomic, retain) NSArray	*skinArray;
@property (nonatomic, retain) NSArray   *plistArray;

@end
