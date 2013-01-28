//
//  CommonMethod.m
//  iweibo
//
//  Created by lichentao on 12-2-23.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "CommonMethod.h"

@implementation CommonMethod
@synthesize proHD;
@synthesize requestApi,imageErrorView,imageSubView;
static CommonMethod *commonMethodInstance = nil;

// 常用方法类唯一实例
+ (CommonMethod *)shareInstance{
	if (nil == commonMethodInstance) {
		commonMethodInstance = [[CommonMethod alloc] init];
	}
	return commonMethodInstance;
}

// 请求接口
- (IWeiboAsyncApi *)shareRequestApi{
	if (nil == requestApi) {
		requestApi	 = [[IWeiboAsyncApi alloc] init];
	}
	return requestApi;
}

// 判断连接网络状态WiFi和3G
- (BOOL)connectionStatus{
	if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable) && ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
		return NO;
	}
	else {
		return YES;
	}
}

//	提示状态
- (MBProgressHUD *)shareMBProgressHUD:(MBProgressHUDState)hudState{
	// 多出地方用到，将此实例的alpha置为1  
	if (nil == proHD) {
		proHD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(60,170, 200, 180)];
		imageErrorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:LOGINERROR]];
		imageSubView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]];
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicator.bounds = CGRectMake(indicator.bounds.origin.x, indicator.bounds.origin.y, 30.0f, 30.0f);
        indicator.hidesWhenStopped = YES;
	}
    [indicator stopAnimating];
	switch (hudState) {
		case load:
			if (imageSubView || imageErrorView) {
				imageSubView.hidden = YES;
				imageErrorView.hidden = YES;
			}
			proHD.mode = MBProgressHUDModeIndeterminate;
			proHD.labelText = @"      载入中...       ";
			proHD.labelFont = [UIFont systemFontOfSize:14];
			break;
		case loadError:
			imageErrorView.hidden = NO;
			proHD.customView = imageErrorView;
			proHD.mode = MBProgressHUDModeCustomView;
			proHD.labelText = @"网络错误,请重试!";
			proHD.labelFont = [UIFont systemFontOfSize:14];
			break;
		case subScription:
			imageSubView.hidden = NO;
			proHD.customView = imageSubView;
			proHD.mode = MBProgressHUDModeCustomView;
			proHD.labelText = @"订阅成功!";
			proHD.labelFont = [UIFont systemFontOfSize:14];
			break;
		case subScriptionFail:
			imageErrorView.hidden = NO;
			proHD.customView = imageErrorView;
			proHD.mode = MBProgressHUDModeCustomView;
			proHD.labelText = @"订阅失败!";
			proHD.labelFont = [UIFont systemFontOfSize:14];
			break;

	    case cancelScription:
			imageSubView.hidden = NO;
			proHD.customView = imageSubView;
			proHD.mode = MBProgressHUDModeCustomView;
			proHD.labelText = @"已经取消!";
			proHD.labelFont = [UIFont systemFontOfSize:14];
			break;
		case cancelScriptionFail:
			imageErrorView.hidden = NO;
			proHD.customView = imageErrorView;
			proHD.mode = MBProgressHUDModeCustomView;
			proHD.labelText = @"取消失败,请重试!";
			proHD.labelFont = [UIFont systemFontOfSize:14];
			break;
	
		case noThisTopic:
			imageErrorView.hidden = NO;
			proHD.customView = imageErrorView;
			proHD.mode = MBProgressHUDModeCustomView;
			proHD.labelText = @"暂时还没有微博!";
			proHD.labelFont = [UIFont systemFontOfSize:14];
			break;
        case inSubScription:
			imageErrorView.hidden = NO;
//			proHD.customView = indicator;
			proHD.mode = MBProgressHUDModeIndeterminate;
			proHD.labelText = @"请稍候...";
			proHD.labelFont = [UIFont systemFontOfSize:14];
		default:
			break;
	}
	proHD.alpha = 1;
	[proHD show:YES];		
	return proHD;
}

// 内存管理释放资源
- (void)dealloc{
	if (commonMethodInstance) {
		[commonMethodInstance release];
		commonMethodInstance = nil;
	}
	if (proHD) {
		[imageErrorView release];
        imageErrorView = nil;
		[imageSubView release];
        imageSubView = nil;
        [indicator release];
        indicator = nil;
		[proHD release];
        
	}
	[super dealloc];
}
@end
