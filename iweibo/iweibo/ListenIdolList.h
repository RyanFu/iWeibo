//
//  ListenIdolList.h
//  iweibo
//
//  Created by wangying on 2/1/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ListenIdolList : NSObject {
	NSString    *name;
	NSString	*nick;
	NSString	*head;
	NSString    *fansnum;
	NSString	*isvip;
	NSString    *sex;
	NSString    *location;
	NSString    *timeStamp;
	NSString    *uid;
	NSString	*text;  //tweet中的text内容
	NSString    *localAuth;//本地认证
}

@property (nonatomic, retain) NSString	  *name;
@property (nonatomic, retain) NSString	  *nick;
@property (nonatomic, retain) NSString	  *head;
@property (nonatomic, retain) NSString	  *fansnum;
@property (nonatomic, retain) NSString    *isvip;
@property (nonatomic, retain) NSString    *sex;
@property (nonatomic, retain) NSString	  *location;
@property (nonatomic, retain) NSString	  *timeStamp;
@property (nonatomic, retain) NSString	  *uid;
@property (nonatomic, retain) NSString	  *text;
@property (nonatomic, copy) NSString *localAuth;

@end
