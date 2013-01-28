//
//  CustomAdditions.h
//  iweibo
//
//	对某些常用的公共控件的扩展和自定义
//
//  Created by LiQiang on 11-8-3.
//  Copyright 2010. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIBarButtonItem(CustomAdditions)

+ (UIBarButtonItem *)leftBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
+ (UIBarButtonItem *)rightBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
+ (UIBarButtonItem *)editBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end