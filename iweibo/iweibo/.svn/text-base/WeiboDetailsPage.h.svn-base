//
//  WeiboDetailsPage.h
//  iweibo
//
//  Created by Cui Zhibo on 12-5-15.
//  Copyright (c) 2012年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "IWeiboAsyncApi.h"
#import "IWBSvrSettingsManager.h"
#import "CustomizedSiteInfo.h"
#import "FXLabel.h"

#define     topImageHeight  46
#define		HOST_SUB_PATH_COMPONENT			@"/index.php/mobile/"
@interface WeiboDetailsPage : UIViewController{
   
    IWeiboAsyncApi          *iWeiboAsyncApi;
    CustomizedSiteInfo      *customizedSiteInfo;
    UIView                  *checkView;
    BOOL                    isTouch;
	id                      idParentController;
	NSDictionary            *dicThemeResult;            // 保存主题缓存信息
	BOOL                    isDownloadingTheme;			// 是否正在下载图片
	BOOL                    isCancelledFromBackground;	// 是否切换到后台并且取消图片下载
	UIImage                 *imgLogo;
    BOOL                    isGetInfoFailure;           // 获取信息是否失败

}
@property (nonatomic, retain)CustomizedSiteInfo *customizedSiteInfo;
@property (nonatomic, assign) id				idParentController;
@property (nonatomic, retain) NSDictionary		*dicThemeResult;
@property (nonatomic, retain) UIImage			*imgLogo;
@property (nonatomic, assign) BOOL              isGetInfoFailure;
- (void) achieveInfoFromServer;

// 获取主题信息
-(void)getThemeInfo;
@end
