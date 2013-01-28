//
//  PushAndRequest.h
//  iweibo
//
//  Created by LiQiang on 12-2-10.
//  Copyright 2012年 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IWeiboAsyncApi;
@class PersonalMsgViewController;

@interface PushAndRequest : NSObject {
    IWeiboAsyncApi *personMsg;
    PersonalMsgViewController *personMsgController;
}
@property (nonatomic, retain) IWeiboAsyncApi *personMsg;
+ (PushAndRequest *)shareInstance;
- (void)pushControllerType:(int)controllerType withName:(NSString *)userName;
@end
