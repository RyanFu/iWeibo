//
//  DataCheck.m
//  iweibo
//
//  Created by zhaoguohui on 12-2-16.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "DataCheck.h"


@implementation DataCheck

/*
 定义公共方法，用于对数据进行类型和合法性进行判断
 dictionary: 所取数据所在的字典
 key: 所取值对应的键值
 type: 所取值应该有的类型
 */
+ (id)checkDictionary:(NSDictionary *)dictionary forKey:(NSString *)key withType:(Class)type {
	if (dictionary == nil) {
		return [NSNull null];
	}
	if ([dictionary isKindOfClass:[NSNull class]]) {
		return [NSNull null];
	}
	NSArray *keys = [dictionary allKeys];
	if (![keys containsObject:key]) {
		if(VERSION_DEBUG) {
			// 在DEBUG模式下
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
															message:[NSString stringWithFormat:@"键值%@不存在",key]
														   delegate:nil
												  cancelButtonTitle:@"确定"
												  otherButtonTitles:nil];
			
			[alert show];
			[alert release];
		}
		return [NSNull null];
	}
	
	// 取键对应的值
	id obj = [dictionary objectForKey:key];
	if ([obj isKindOfClass:type]) {
		// 如果是想要的数据，则直接返回
		return obj;
	}else {
		// 类型不正确
		if(VERSION_DEBUG) {
			// 在DEBUG模式下
			/*
			NSLog(@"obj=%@", obj);
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
															message:[NSString stringWithFormat:@"键值%@的数据类型错误",key]
														   delegate:nil
												  cancelButtonTitle:@"确定"
												  otherButtonTitles:nil];
			
			[alert show];
			[alert release];
			 */
		}
		return [NSNull null];
	}
	
	return [NSNull null];	  
}

@end
