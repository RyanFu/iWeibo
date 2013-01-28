//
//  CommOrTransInfo.h
//  iweibo
//
//  Created by wangying on 2/4/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommOrTransInfo : NSObject {
	NSString	*uid;
	NSString	*nick;
	NSString	*name;
	NSString	*time;
	NSString	*text;
	NSString	*isvip;
	NSString	*localAuth;
	NSString	*type;
}

@property (nonatomic, retain) NSString	  *uid;
@property (nonatomic, retain) NSString    *nick;
@property (nonatomic, retain) NSString	  *name;
@property (nonatomic, retain) NSString    *time;
@property (nonatomic, retain) NSString	  *text;
@property (nonatomic, retain) NSString	  *isvip;
@property (nonatomic, retain) NSString    *localAuth;
@property (nonatomic, retain) NSString    *type;

@end
