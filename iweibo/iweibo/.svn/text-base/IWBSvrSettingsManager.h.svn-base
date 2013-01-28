//
//  IWBSvrSettingsManager.h
//  iweibo
//
//  Created by wangying on 5/4/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomizedSiteInfo.h"

// 站点名称
#define		KEY_SITE_NAME				@"ServerName"
// 是否为当前应用站点
#define		KEY_SITE_IS_ACTIVE			@"IsActive"
// 站点状态: 0 表示未登陆过, 1表示曾经登陆过，2表示上次登陆
#define		KEY_SITE_LAST_ACTIVE_STATUS	@"IsLastActiveSite"
// 主题版本
#define		KEY_SITE_THEME_VER			@"themeVer"
// 是否为推荐微博站点
#define		KEY_SITE_IS_DEFAULT			@"IsDefaultWBServer"
// 站点描述
#define		KEY_SITE_DESCRIPTION		@"Description"
// 站点图标所在子路径
#define		KEY_SITE_ICONS_PATH			@"iconsPath"
// 站点URL
#define		KEY_SITE_URL				@"URL"
// 是否有用户登陆
#define		KEY_SITE_USER_LOGIN			@"UserLogin"
// 是否第一次登陆
#define		KEY_SITE_USER_FIRST_LOGIN	@"UserFirstLogin"
// 登陆用户名称
#define		KEY_SITE_LOGIN_USER_NAME	@"LoginUserName"
// 官方微博
#define		KEY_SITE_OFFICIAL			@"Official"
// token(只在OAuth模式下有效)
#define		KEY_SITE_ACCESS_TOKEN		@"FirstTempValue"
// secrect(只在OAuth模式下有效)
#define		KEY_SITE_ACCESS_SECRECT		@"SecondTempValue"
// logo名称
#define		SITE_LOGO_NAME				@"logo"
// 后缀
#define		SITE_LOGO_TYPE				@"png"
// loading图片名称
#define		SITE_LOADING_NAME			@"loading.png"
// 被删除的默认站点
#define     KEY_SITE_ISDELETEDWB        @"isdelatedwb"
// 是否为当前删除的加载站点
#define     KEY_SITE_SHOUDEREMOVED      @"shouldRemode"
// 网址相关图标相对位置
#define		SITE_ICONS_FOLDER_NAME		@"siteIcons"

// 保存服务器配置信息文件名称
#define		SERVER_SETTINGS_FILE_NAME	@"ServerSettings.plist"

#define     MAX_TRY_COUNT               (50 * 60 * 2)

@interface IWBSvrSettingsManager : NSObject {
	NSArray				*themeArray;
	NSMutableArray		*dicSiteInfo;		// 保存从文件读取出来的原始数据信息
	NSMutableArray		*arrSiteInfo;		// 保存CustomizedSiteInfo数组信息
	CustomizedSiteInfo	*activeSite;		// 当前激活site
	NSMutableArray		*downloadArray;		// 下载多线程
	NSCondition			*numCondition;		//	锁
	NSInteger			curDownloadedIconsNumber;	// 需要下载的图片总个数
	NSOperationQueue	*operQueue;
	id					delegate;
	SEL					onSuccessCallback;
	BOOL				bCancelledThemeDownload;
	NSString			*iconFolderName;			// 正在下载的图片文件夹名称，用来保证切换后台后重新再下载仍旧用之前的文件夹
}

@property (nonatomic,retain) NSArray						*themeArray;
@property (nonatomic, retain) NSMutableArray				*dicSiteInfo;
@property (nonatomic, retain, readonly) NSMutableArray		*arrSiteInfo;
@property (nonatomic, retain, readonly) CustomizedSiteInfo	*activeSite;
@property (nonatomic, retain, readonly) NSOperationQueue	*operQueue;
@property (nonatomic, copy) NSString						*iconFolderName;
+(IWBSvrSettingsManager*)sharedSvrSettingManager;

// 是否当前应用为默认微博
+(BOOL)isDefaultWBServer;
// 是否为已存在url
-(CustomizedSiteInfo *)getSiteInfoByUrl:(NSString *)siteUrl;
// 异步下载图片到本地目录, 返回(先下载图片，然后再根据返回的图片文件夹名称更新站点)
// ret: 回调用返回图片所在文件夹名称以及下载结果
// { 
//	"ret":"1"
//	"PATH":"aa"
// }
-(void)downloadTheme:(NSString *)siteUrl wiThemeDic:(NSDictionary *)dicDeltaTheme delegate:(id)dele Callback:(SEL)sel;
// 取消下载
-(void)CancelThemeDownLoading;
// 设置当前site的theme信息(假如不存在当前site则需要手动添加)
-(BOOL)updateSite:(NSString *)siteUrl withVer:(NSString *)ver themeDic:(NSDictionary *)dicDeltaTheme andIconFolder:(NSString *)fName;
// 设置当前site为激活site，并更新相关信息
-(BOOL)updateAndSetSiteActive:(NSString *)siteUrl;
// 设置所有site为非激活site
-(BOOL)inactiveAllSite;
// 设置当前site描述信息
-(BOOL)updateSite:(NSString *)siteUrl withDescription:(SiteDescriptionInfo *)desInfo;
// 设置账户登陆状态
-(BOOL)updateSite:(NSString *)siteUrl withUser:(NSString *)uName loginState:(BOOL)bLogin firstLogin:(BOOL)bFirstLogin;
// 设置登陆token跟secrect信息
-(BOOL)updateSite:(NSString *)siteUrl withUser:(NSString *)uName accessToken:(NSString *)token accessKey:(NSString *)key;
// 拷贝文件到cach目录
-(BOOL)copyDefaultIconsToCachedDir;
// 拷贝plist到cach目录
-(BOOL)copyDefaultSvrSettingsFileToCachedDir;
// 标记被删除微博信息,如果是网络加载的站点，连数据一起删除
-(BOOL)SigndelateSite:(NSString*)Siturl;
@end
