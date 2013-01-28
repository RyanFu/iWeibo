//
//  NSString+Encoding.m
//  iweibo
//
//  Created by zhaoguohui on 11-12-26.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import "NSString+QEncoding.h"


@implementation NSString (QOAEncoding)
// 将url中的一些特殊字符进行转义
- (NSString *)URLEncodedString {
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
    [result autorelease];
	return result;
}

// 将转义之后的字符还原出来
- (NSString*)URLDecodedString {
	NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																						   (CFStringRef)self,
																						   CFSTR(""),
																						   kCFStringEncodingUTF8);
    [result autorelease];
	return result;	
}

@end
