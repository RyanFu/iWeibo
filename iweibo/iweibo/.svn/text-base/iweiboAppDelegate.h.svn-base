//
//  iweiboAppDelegate.h
//  iweibo
//
//  Created by LiQiang on 11-12-22.
//  Copyright 2011年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RXCustomTabBar.h"
#import "LoginPage.h"
#import "HomePage.h"
#import "MessagePage.h"
#import "SearchPage.h"
#import "MorePage.h"
#import "DraftController.h"

#import "IWeiboAsyncApi.h"
#import "SelectWeiboPage.h"

#define	LOADING_IMG_TAG				999
#define	SELECT_WB_PAGE_TAG			(LOADING_IMG_TAG + 1)
#define LOGIN_PAGE_TAG				(LOADING_IMG_TAG + 2)
#define MAIN_CONTENT_VIEW_TAG		(LOGIN_PAGE_TAG + 1)

@interface iweiboAppDelegate : NSObject <UIApplicationDelegate, DraftControllerDelegate> {
    RXCustomTabBar *mainContent;
    LoginPage * loginController;
    HomePage *homeTab;
    UINavigationController *homeNav;
    MessagePage *msgTab;
    UINavigationController *msgNav;
    SearchPage *searchTab;
    UINavigationController *searchNav;		// 搜索导航器
    MorePage *moreTab;
    UINavigationController *moreNav;
	
	NSTimer *nNewMsgTimer;
	IWeiboAsyncApi *nNewMsgApi;
	
	BOOL firstLaunch;
	CustomStatusBar				*cStatusBar;	// 2012-02-21 滚动状态条
	
	BOOL draws;
    SelectWeiboPage *selectPage;
    BOOL shouldComeIn;
    
    // 用户theme下载相关
    NSString                *strSiteUrl;
    NSString                *themeVer;                  // 下载前version信息
    NSString                *latestThemeVer;               // 下载成功后version信息
	BOOL                    isDownloadingTheme;			// 是否正在下载图片
	BOOL                    isCancelledFromBackground;	// 是否切换到后台并且取消图片下载
}

@property (assign) BOOL draws;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) RXCustomTabBar *mainContent;
@property (nonatomic, retain) HomePage *homeTab;
@property (nonatomic, retain) UINavigationController *homeNav;
@property (nonatomic, retain) MessagePage *msgTab;
@property (nonatomic, retain) UINavigationController *msgNav;
@property (nonatomic, retain) SearchPage *searchTab;
@property (nonatomic, retain) UINavigationController *searchNav;
@property (nonatomic, retain) MorePage *moreTab;
@property (nonatomic, retain) UINavigationController *moreNav;

@property (nonatomic, retain) NSTimer *nNewMsgTimer;
@property (nonatomic, retain) IWeiboAsyncApi *nNewMsgApi;
@property (nonatomic, assign) BOOL firstLaunch;
@property (nonatomic, retain)CustomStatusBar				*cStatusBar;
@property (nonatomic, assign)BOOL shouldComeIn;     // 第一次启动程序中，切换到其他微博是否应该加载介绍页面
@property (nonatomic, retain)SelectWeiboPage        *selectPage;

@property (nonatomic, copy) NSString                *strSiteUrl;
@property (nonatomic, copy) NSString                *themeVer;
@property (nonatomic, copy) NSString                *latestThemeVer;

- (void)constructContent;
- (void)constructMainFrame;
- (void)playAnimation;
//- (void)checkLogin;
- (void)loginOut;
- (void)addMainFrame;
//- (void)startNanfangWeiboWithloadImage;
- (void)checkForNewMessage;
// 生成loading页面
-(void)addLoadingImg;
// 生成登陆页面
-(void)addLoginPage;

-(void)addSelectWeiboPageWithLogoutStatus:(BOOL)bLogout;

// 用户登陆失效
-(void)onLoginUserExpired;
// 用户每次登陆或者自动登陆前，需要初始化的数据
-(void)prepareDataForLoginUser;

-(void)backToSelectPage;


// 启动theme下载
-(void)getThemeInfo;
// 异步下载图片到本地目录
-(void)downloadTheme:(NSString *)siteUrl withVer:(NSString *)strVer;
//// 下载图片
//-(void)startDownloadingThemeWithDelegate:(id)delegate waitUntilDone:(BOOL)bWait;
// 取消下载
-(void)cancelDownloadingTheme;
@end
