//
//  NSURL+QAdditions.m
//  iweibo
//
//  Created by zhaoguohui on 11-12-27.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import "NSURL+Additions.h"


@implementation NSURL (Additions)

#pragma mark -
#pragma mark Class methods
// 将请求串中的参数字符串转换为字典，并将该字典返回给用户
+ (NSDictionary *)parseURLQueryString:(NSString *)queryString {
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	NSArray *pairs = [queryString componentsSeparatedByString:@"&"];
	for(NSString *pair in pairs) {
		NSArray *keyValue = [pair componentsSeparatedByString:@"="];
		if([keyValue count] == 2) {
			NSString *key = [keyValue objectAtIndex:0];
			NSString *value = [keyValue objectAtIndex:1];
			value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			if(key && value)
				[dict setObject:value forKey:key];
		}
	}
	return [NSDictionary dictionaryWithDictionary:dict];
}

// 
+ (NSURL *)smartURLForString:(NSString *)str {
	NSURL		*result; // 存放结果
	NSString	*trimmedStr; // 去掉不需要的字符之后的字符串
	NSRange     schemeMarkerRange; // 
	NSString	*scheme; // 所使用的协议字符串
	
	assert(str != nil);
	
	result = nil;
	
	// 将串中的所有空格都去掉
	trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if ( (trimmedStr != nil) && (trimmedStr.length != 0) ) {
		// 获取字符串"://"在字符串trimmedStr中的范围是多少
		schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
		
		// 如果找不到所指定的字符串，则执行下面的代码，则直接在前面添加一个"http://"字符串
		if (schemeMarkerRange.location == NSNotFound) {
			result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
		} else {
			// 如果有指定的字符串，说明在url中已经指定了协议的类型，则要判断所指定的协议是否为http和https中的一种
			scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
			assert(scheme != nil);
			
			if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
				|| ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
				result = [NSURL URLWithString:trimmedStr];
			} else {
				// 对不是http协议或https协议的时候进行特殊的处理代码要写在这里
			}
		}
	}
	
	return result;
}

@end
