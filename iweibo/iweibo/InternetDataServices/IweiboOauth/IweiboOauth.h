//
//  IweiboOauth.h
//  iweibo
//
//  Created by zhaoguohui on 11-12-26.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IweiboOauth : NSObject {

}

- (NSString *)generateSignatureWithUrl:(NSURL *)aUrl
						 customeSecret:(NSString *)aConsumerSecret 
						   tokenSecret:(NSString *)aTokenSecret 
							httpMethod:(NSString *)aHttpMethod 
							parameters:(NSDictionary *)aPatameters;
@end
