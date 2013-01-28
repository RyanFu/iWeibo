//
//  UserAuthBindingWebViewController.h
//  iweibo
//
//  Created by Minwen Yi on 6/15/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebUrlViewController.h"


@interface UserAuthBindingWebViewController : WebUrlViewController {
    ENUMAUTHSTATUS              enumAuthStatus;
    id                          parentViewControllerId;         // 父节点id
    id                          graParentViewControllerId;      // 父父级别视图控制题id
}

@property (nonatomic, assign) id    parentViewControllerId;
@property (nonatomic, assign) id    graParentViewControllerId;
@end
