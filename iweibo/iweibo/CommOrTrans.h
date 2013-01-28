//
//  commOrTrans.h
//  iweibo
//
//  Created by wangying on 1/30/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentView.h"

@interface CommOrTrans : UITableViewCell {
	NSString	*uid;
	NSString	*nick;
	NSString	*time;
	NSString	*text;
	NSString	*isvip;
	NSString	*type;
	NSString	*localAuth;
	
}

@property (nonatomic, copy) NSString	*uid;
@property (nonatomic, copy) NSString	*nick;
@property (nonatomic, copy) NSString	*time;
@property (nonatomic, copy) NSString	*text;
@property (nonatomic, copy) NSString	*isvip;
@property (nonatomic, copy) NSString	*type;
@property (nonatomic, copy) NSString *localAuth;

- (void)setMsg;

@end
