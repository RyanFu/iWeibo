//
//  ComposeViewControllerBuilder.h
//  iweibo
//
//	撰写界面生成器
//
//  Created by Minwen Yi on 12/28/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComposeBaseViewController.h"
#import "ComposeConsts.h"
#import "Draft.h"


@interface ComposeViewControllerBuilder : NSObject {
}

// 通过撰写类型生成写消息界面, 
// 注: 调用者需负责手动释放相应资源(可调用desposeViewController:进行释放)
+ (ComposeBaseViewController *)createWithComposeMsgType:(ComposeMsgType) enumType;
// 通过草稿箱生成对象撰写界面
// 注: 调用者需负责手动释放相应资源(可调用desposeViewController:进行释放)
+ (ComposeBaseViewController *)createWithDraft:(Draft *)draft;
//+ (void)desposeViewController:(ComposeBaseViewController *)viewController;
@end
