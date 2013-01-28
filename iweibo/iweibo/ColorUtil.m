//
//  ColorUtil.m
//  iweibo
//
//  Created by ZhaoLilong on 2/3/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "ColorUtil.h"
 
@implementation UIColor(ColorUtil)

+ (UIColor *)colorStringToRGB:(NSString *)hexColor{
	//声明红、绿、蓝变量
	unsigned int red, green, blue;
	
	//声明取值长度为2
	NSRange range;
	range.length =2;
	
	//取值位置为0
	range.location =0;
	
	//获取红色分量
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
	
	//取值位置为2
	range.location =2;
	
	//获取绿色分量
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
	
	//取值位置为4
	range.location =4;
	
	//获取红色分量    
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
	return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

@end
