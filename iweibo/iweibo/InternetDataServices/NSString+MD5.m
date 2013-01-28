//
//  NSString+MD5.m
//  iweibo
//
//  Created by zhaoguohui on 11-12-27.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (md5)

- (NSString *) MD5 
{
	const char *cStr = [self cStringUsingEncoding:NSUTF8StringEncoding];//[self UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result );
	return [[NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			] lowercaseString];  
}
- (NSString *) MD5Unicode 
{
	const char *cStr = [self cStringUsingEncoding:NSUnicodeStringEncoding];
	unsigned char result[16];
	CC_MD5( cStr, [self length]*2, result );
	return [[NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			] lowercaseString];  
}
@end
