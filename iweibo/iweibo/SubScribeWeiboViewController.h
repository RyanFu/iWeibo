//
//  SubScribeWeiboViewController.h
//  iweibo
//
//  Created by Minwen Yi on 5/17/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWeiboAsyncApi.h"
#import "CustomizedSiteInfo.h"
#import "SelectWeiboPage.h"

@interface SubScribeWeiboViewController : UIViewController<UITextFieldDelegate> {
	UITextField			*tfSiteAddr;		// 文本输入框
	UIButton			*btnCommit;			// 提交框
	UIImageView			*imgErrorBackground; // 错误描述背景图
	UILabel				*lbErrorDes;		// 错误描述标签
    UIView				*checkView;
	UIActivityIndicatorView *indicatorView;
	IWeiboAsyncApi		*api;				// 网络请求api
	CustomizedSiteInfo	*siteInfo;			// 站点信息
	NSDictionary		*dicThemeResult;	// 保存主题缓存信息
	SiteDescriptionInfo *desInfo;			// 保存返回的站点描述信息
	NSString			*siteUrl;			// 站点完整路径
	NSInteger			curStep;			// 标记当前运行步骤(保留)
	id idParentController;
	BOOL				isDownloadingTheme;
	BOOL				isCancelledFromBackground;
}

@property (nonatomic, retain) UITextField		*tfSiteAddr;
@property (nonatomic, retain) UIButton			*btnCommit;
@property (nonatomic, retain) UIView			*checkView;
@property (nonatomic, retain) UIImageView		*imgErrorBackground;
@property (nonatomic, retain) UILabel			*lbErrorDes;
@property (nonatomic, retain) CustomizedSiteInfo	*siteInfo;
@property (nonatomic, copy) NSString			*siteUrl;
@property (nonatomic, copy) NSDictionary		*dicThemeResult;
@property (nonatomic, assign) id				idParentController;
@property (nonatomic, retain) SiteDescriptionInfo *desInfo;

// 设置异常文本
-(void)setErrorText:(NSString *)errText;
// 开始图片下载
-(void)startDownloadThemeIcons;
@end
