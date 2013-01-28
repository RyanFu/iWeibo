//
//  CommonMethod.h
//  iweibo
//
//  Created by lichentao on 12-2-23.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "IWeiboAsyncApi.h"
typedef enum{
	load = 0,				// 载入中
	loadError = 1,			// 网络错误
	subScription,			// 订阅话题成功
	subScriptionFail,		// 订阅话题失败
	cancelScription,		// 取消订阅成功
	cancelScriptionFail,	// 取消订阅失败
	noThisTopic,				// 没有此类话题
    inSubScription,             // 正在订阅/取消订阅
}MBProgressHUDState;

@interface CommonMethod : NSObject {

	MBProgressHUD *proHD;
	IWeiboAsyncApi *requestApi;
	UIImageView   *imageErrorView;	// 网络错误图片
	UIImageView   *imageSubView;	// 订阅成功或者取消的图片（对号图标）
    UIActivityIndicatorView *indicator;
}

@property (nonatomic, retain) MBProgressHUD *proHD;
@property (nonatomic, retain) IWeiboAsyncApi *requestApi;
@property (nonatomic, retain) UIImageView   *imageErrorView;
@property (nonatomic, retain) UIImageView   *imageSubView;
// 单例
+ (CommonMethod *)shareInstance;
// 显示网络错误状态
- (MBProgressHUD *)shareMBProgressHUD:(MBProgressHUDState)hudState;
// 判断网络状态
- (BOOL)connectionStatus;
@end
