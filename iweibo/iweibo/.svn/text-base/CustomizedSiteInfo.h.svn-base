//
//  CustomizedSiteInfo.h
//  iweibo
//
//	微博服务器信息
//
//  Created by Minwen Yi on 5/16/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

// 站点描述信息
@interface SiteDescriptionInfo : NSObject
{
	NSString			*svrName;					// 名称
	NSString			*svrUrl;					// 服务器地址
	NSString			*official;
	NSString			*svrDescription;			// 站点描述
}

@property (nonatomic, copy) NSString			*svrName;
@property (nonatomic, copy) NSString			*svrUrl;
@property (nonatomic, copy) NSString			*official;
@property (nonatomic, copy) NSString			*svrDescription;	

// 转换字典为SiteDescriptionInfo对象
-(id) initWithDic:(NSDictionary *)dicData;
@end


@interface CustomizedSiteInfo : NSObject {
	BOOL				bActive;					// 是否为当前激活站点
	NSInteger			nLastActiveStatus;			// 0 表示未登陆过, 1表示曾经登陆过，2表示上次登陆
	BOOL				bIsDefaultSvr;				// 是否为默认站点
	BOOL				bUserLogin;					// 是否已登陆
	BOOL				bUserFirstLogin;			// 是否首次登陆
	NSString			*loginUserName;				// 登陆用户名
	NSString			*userAccessToken;			// token:只有OAuth模式的默认站点(bIsDefault为YES)才是有效值
	NSString			*userAccessSecrect;			// secrect:只有OAuth模式的默认站点(bIsDefault为YES)才是有效值
	NSString			*themeVer;					// theme版本信息
	NSString			*siteMainPath;				// site下图片子路径
	NSString			*logoIconPath;				// 资源图片路径
	NSString			*loadingIconPath;			// loading页图片
	SiteDescriptionInfo	*descriptionInfo;			// 描述信息
    BOOL                bIsdeledated;               // 是否是被删除站点
}

@property (nonatomic, assign) BOOL				bActive;
@property (nonatomic, assign) NSInteger			nLastActiveStatus;
@property (nonatomic, assign) BOOL				bIsDefaultSvr;	
@property (nonatomic, assign) BOOL				bUserLogin;
@property (nonatomic, assign) BOOL				bUserFirstLogin;
@property (nonatomic, assign) NSString			*loginUserName;
@property (nonatomic, copy) NSString			*userAccessToken;
@property (nonatomic, copy) NSString			*userAccessSecrect;
@property (nonatomic, copy) NSString			*themeVer;
@property (nonatomic, copy) NSString			*siteMainPath;
@property (nonatomic, copy) NSString			*logoIconPath;
@property (nonatomic, copy) NSString			*loadingIconPath;
@property (nonatomic, retain) SiteDescriptionInfo	*descriptionInfo;
@property (nonatomic, assign)BOOL               bIsdeledated;
@end

@interface CustomizedSiteInfo(PlistParse) 
// 转换字典为CustomizedSiteInfo对象
-(id) initWithDic:(NSDictionary *)dicSite;
// 生成CustomizedSiteInfo对象为字典数据
+(NSMutableDictionary *)dicWithSiteUrl:(NSString *)siteUrl version:(NSString *)ver andIconFolder:(NSString *)fName;
@end