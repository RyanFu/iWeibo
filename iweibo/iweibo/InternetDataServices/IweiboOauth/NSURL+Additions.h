//
//  NSURL+QAdditions.h
//  iweibo
//
//  Created by zhaoguohui on 11-12-27.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSURL (Additions)

+ (NSDictionary *)parseURLQueryString:(NSString *)queryString;

+ (NSURL *)smartURLForString:(NSString *)str;

@end
