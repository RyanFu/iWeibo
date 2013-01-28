//
//  ColorUtil.h
//  iweibo
//
//  Created by ZhaoLilong on 2/3/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
 
@interface UIColor(ColorUtil)

// 将16进制颜色字符串转换成UIColor对象
+ (UIColor *)colorStringToRGB:(NSString *)hexColor;

@end
