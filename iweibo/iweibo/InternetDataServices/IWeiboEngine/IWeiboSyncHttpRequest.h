//
//  IWeiboSyncHttpRequest.h
//  iweibo
//
//  Created by zhaoguohui on 11-12-27.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+MD5.h"


@interface IWeiboSyncHttpRequest : NSObject {

}

/*
	@function: 生成登录使用的请求URL
 
	@param: name 用户名
	@param: password 密码
 
	@return: 生成的登录请求URL
 */
+ (NSString*)getIWeiboLoginURLWithName:(NSString *)name password:(NSString *)pwd;
@end
