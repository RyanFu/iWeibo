//
//  IWeiboSyncHttpRequest.m
//  iweibo
//
//  Created by zhaoguohui on 11-12-27.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import "IWeiboSyncHttpRequest.h"
#import "Canstants_Data.h"
#import "SelectServer.h"

@implementation IWeiboSyncHttpRequest


// 生成登录使用的请求URL
+ (NSString*)getIWeiboLoginURLWithName:(NSString *)name password:(NSString *)pwd {
	NSString *tempName = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *tempPwd = [pwd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if (0 == [tempName length] || 0 == [tempPwd length]) {
		return nil;
	}
	// 对密码进行MD5加密一次
	NSString *password = [NSString stringWithString:[pwd MD5]];
	NSString *url = [NSString stringWithFormat:@"%@?user=%@&pwd=%@", [NSString stringWithFormat:@"%@%@", [SelectServer getServerInfoFromPlist], @"private/login"], tempName, password];
	
	return url;
}
@end
