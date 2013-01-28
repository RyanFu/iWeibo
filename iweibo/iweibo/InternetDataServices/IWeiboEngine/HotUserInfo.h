//
//  HotUserInfo.h
//  iweibo
//
//  Created by zhaoguohui on 12-2-23.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HotUserInfo : NSObject {

	NSString *userName;
	NSString *userNick;
	UIImage *userhead;
	NSString *numberOfFans;
	NSString *hasListen;
	NSString *headURL;
	NSString *is_auth;
	NSString *local_id;
	
}

@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *userNick;
@property (nonatomic, retain) UIImage *userhead;
@property (nonatomic, retain) NSString *numberOfFans;
@property (nonatomic, retain) NSString *hasListen;
@property (nonatomic, retain) NSString *headURL;
@property (nonatomic, retain) NSString *is_auth;
@property (nonatomic, retain) NSString *local_id;

@end
