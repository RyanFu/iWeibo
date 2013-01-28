//
//  IWeiboSyncApi.m
//  iweibo
//
//  Created by zhaoguohui on 11-12-27.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import "IWeiboSyncApi.h"


@implementation IWeiboSyncApi

// 实现登录功能
- (NSDictionary *)iweiboLoginWithUserName:(NSString *)name password:(NSString *)pwd error:(NSError **)error {
	
	ASIHTTPRequest *httpRequest = nil;
	NSDictionary *retValue = [NSDictionary dictionary];
	NSString *url = [IWeiboSyncHttpRequest getIWeiboLoginURLWithName:name password:pwd];
	NSLog(@"url = %@", url);
	if (nil == url) {
		// 说明传入的参数有误
		NSLog(@"error:用户名或密码为空");
		return nil;
	}else {
		httpRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
	}

	[httpRequest startSynchronous];
	NSString *result = nil;
	if (nil != httpRequest.error) {
		// 有错误
		if (nil != error) {
			// 如果出现错误，需要返回错误结果
			*error = httpRequest.error;
		}
	}else {
		result = [httpRequest responseString];
		retValue = [result JSONValue];
	}

	[httpRequest release];
	
	return retValue;
}

@end
