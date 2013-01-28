//
//  IweiboOauth.m
//  iweibo
//
//  Created by zhaoguohui on 11-12-26.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import "IweiboOauth.h"
#import <CommonCrypto/CommonHMAC.h>
#import "NSData+QBase64.h"
#import "NSString+QEncoding.h"

@implementation IweiboOauth

// 对参数进行排序
static NSInteger SortParameter(NSString *key1, NSString *key2, void *context) {
	NSComparisonResult r = [key1 compare:key2];
	if(r == NSOrderedSame) { // compare by value in this case
		NSDictionary *dict = (NSDictionary *)context;
		NSString *value1 = [dict objectForKey:key1];
		NSString *value2 = [dict objectForKey:key2];
		return [value1 compare:value2];
	}
	return r;
}


// 用HMAC_SHA1签名算法进行签名
static NSData *HMAC_SHA1(NSString *data, NSString *key) {
	unsigned char buf[CC_SHA1_DIGEST_LENGTH];
	CCHmac(kCCHmacAlgSHA1, [key UTF8String], [key length], [data UTF8String], [data length], buf);
	return [NSData dataWithBytes:buf length:CC_SHA1_DIGEST_LENGTH];
}


// 生成签名的一部分
- (NSString *)generateSignatureBaseWithUrl:(NSURL *)aUrl 
								httpMethod:(NSString *)aHttpMethod 
								parameters:(NSDictionary *)aParameters {
	
	NSString *aNormalizedUrl = nil;
	NSString *aNormalizedRequestParameters = nil;
	if ([aUrl port]) {
		aNormalizedUrl = [NSString stringWithFormat:@"%@:%@//%@%@", [aUrl scheme], [aUrl port], [aUrl host], [aUrl path]];
	} else {
		aNormalizedUrl = [NSString stringWithFormat:@"%@://%@%@", [aUrl scheme], [aUrl host], [aUrl path]];
	}
	
	NSMutableArray *parametersArray = [NSMutableArray array];
	NSArray *sortedKeys = [[aParameters allKeys] sortedArrayUsingFunction:SortParameter context:aParameters];
	for (NSString *key in sortedKeys) {
		NSString *value = [aParameters valueForKey:key];
		[parametersArray addObject:[NSString stringWithFormat:@"%@=%@", key, [value URLEncodedString]]];
	}
	aNormalizedRequestParameters = [parametersArray componentsJoinedByString:@"&"];
	
	NSString *signatureBaseString = [NSString stringWithFormat:@"%@&%@&%@",
									 aHttpMethod, [aNormalizedUrl URLEncodedString], [aNormalizedRequestParameters URLEncodedString]];
	return signatureBaseString;
}

// 根据指定的参数生成签名
- (NSString *)generateSignatureWithUrl:(NSURL *)aUrl
						 customeSecret:(NSString *)aConsumerSecret 
						   tokenSecret:(NSString *)aTokenSecret 
							httpMethod:(NSString *)aHttpMethod 
							parameters:(NSDictionary *)aPatameters {
	
	NSString *signatureBase = [self generateSignatureBaseWithUrl:aUrl 
													  httpMethod:aHttpMethod 
													  parameters:aPatameters];
	
	//NSString *signatureKey = [NSString stringWithFormat:@"%@&%@", [aConsumerSecret URLEncodedString], aTokenSecret ? [aTokenSecret URLEncodedString] : @""];
	NSString *signatureKey = [NSString stringWithFormat:@"%@&%@", aConsumerSecret, aTokenSecret];
	NSData *signature = HMAC_SHA1(signatureBase, signatureKey);
	
	NSString *base64Signature = [signature base64EncodedString];
	return base64Signature;
}

@end
