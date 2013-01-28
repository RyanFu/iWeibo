//
//  NSString+Encoding.h
//  iweibo
//
//  Created by zhaoguohui on 11-12-26.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (QOAEncoding)

- (NSString *)URLEncodedString;

- (NSString *)URLDecodedString;

@end
