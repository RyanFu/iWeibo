//
//  CustomStatusBar.h
//  iweibo
//
//  Created by ZhaoLilong on 12-1-15.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum StatusType {
	statusTypeLoading = 0,
	statusTypeSuccess = 1
}StatusType;

@interface CustomStatusBar : UIWindow {
	UILabel				  *lblStatus;		// 状态label
	UIActivityIndicatorView *indicator;		// 显示加载
	UIImageView		  *imageView;	// 图片
	StatusType			  type;			// 状态类型
}

@property (nonatomic, retain)	UILabel				  *lblStatus;
@property (nonatomic, assign)StatusType			  type;
@property (nonatomic, retain)	UIImageView		 *imageView;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;

- (void)showWithStatusMessage:(NSString *)msg;// 显示状态信息							

@end
