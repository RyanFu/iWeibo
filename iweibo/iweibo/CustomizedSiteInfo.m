//
//  CustomizedSiteInfo.m
//  iweibo
//
//  Created by Minwen Yi on 5/16/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "CustomizedSiteInfo.h"
#import "IWBSvrSettingsManager.h"

@implementation SiteDescriptionInfo
@synthesize svrName, svrUrl, svrDescription, official;

- (id)copyWithZone:(NSZone *)zone
{
	SiteDescriptionInfo *copy = [[[self class] allocWithZone:zone] init];
	copy->svrName = [svrName copy];
	copy->svrDescription = [svrDescription copy];
	copy->svrUrl = [svrUrl copy];
	copy->official = [official copy];
	return copy;
}

-(id)init {
	if (self = [super init]) {
		self.svrName = @"";
		self.svrDescription = @"";
		self.svrUrl = @"";
		self.official = @"";
	}
	return self;
}

-(void)dealloc {
	self.svrName = nil;
	self.svrDescription = nil;
	self.svrUrl = nil;
	self.official = nil;
	[super dealloc];
}

-(NSString *)description {
	NSString *str = [NSString stringWithFormat:@"[SiteDescriptionInfo name:%@, des:%@, url:%@ official:%@]", svrName, svrDescription, svrUrl, official];
	return str;
}

// 转换字典为CustomizedSiteInfo对象
-(id) initWithDic:(NSDictionary *)dicData {
	if (self = [super init]) {
		self.svrName = [dicData objectForKey:@"name"];
		if ([svrName isKindOfClass:[NSNull class]]) {
			self.svrName = @"";
		}
		self.svrUrl = [dicData objectForKey:@"url"];
		if ([svrUrl isKindOfClass:[NSNull class]]) {
			self.svrUrl = @"";
		}
		else {
			self.svrUrl = [NSString stringWithFormat:@"%@index.php/mobile/", svrUrl];	// 加上后缀
		}

		self.official = [dicData objectForKey:@"official"];
		if ([official isKindOfClass:[NSNull class]]) {
			self.official = @"";
		}
		self.svrDescription = [dicData objectForKey:@"description"];
		if ([svrDescription isKindOfClass:[NSNull class]]) {
			self.svrDescription = @"";
		}
	}
	return self;
}
@end


@implementation CustomizedSiteInfo
@synthesize bActive, nLastActiveStatus, bIsDefaultSvr, bUserLogin, bUserFirstLogin, loginUserName;
@synthesize logoIconPath, descriptionInfo;
@synthesize siteMainPath;
@synthesize loadingIconPath;
@synthesize themeVer;
@synthesize userAccessToken;
@synthesize userAccessSecrect;
@synthesize bIsdeledated;

-(id)init {
	if (self = [super init]) {
		self.logoIconPath = @"";
		self.descriptionInfo = nil;
		self.siteMainPath = @"";
		self.themeVer = @"";
		self.loadingIconPath = @"";
		self.loginUserName = @"";
		self.userAccessSecrect = @"";
		self.userAccessToken = @"";
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	CustomizedSiteInfo *copy = [[[self class] allocWithZone:zone] init];
	copy->bActive = bActive;
	copy->nLastActiveStatus = nLastActiveStatus;
	copy->bIsDefaultSvr = bIsDefaultSvr;
	copy->bUserLogin = bUserLogin;
	copy->bUserFirstLogin = bUserFirstLogin;
	copy->loginUserName = [loginUserName copy];
	copy->userAccessToken = [userAccessToken copy];
	copy->userAccessSecrect = [userAccessSecrect copy];
	copy->siteMainPath = [siteMainPath copy];
	copy->logoIconPath = [logoIconPath copy];
	copy->themeVer = [themeVer copy];
	copy->loadingIconPath = [loadingIconPath copy];
	copy->descriptionInfo = [descriptionInfo copy];
    copy->bIsdeledated  = bIsdeledated;
	return copy;
}

-(NSString *)description {
	NSString *str = [NSString stringWithFormat:@"bActive:%d, nLastActiveStatus:%d, bIsDefaultSvr:%d, logoIconPath:%@ descriptionInfo:%@, isdelated:%@", bActive, nLastActiveStatus, bIsDefaultSvr, logoIconPath, descriptionInfo,bIsdeledated];
	return str;
}

-(void)dealloc {
	self.logoIconPath = nil;
	self.descriptionInfo = nil;
	self.siteMainPath = nil;
	self.themeVer = nil;
	self.loadingIconPath = nil;
	self.loginUserName = nil;
	self.userAccessSecrect = nil;
	self.userAccessToken = nil;
	[super dealloc];
}

+(NSString *)randFileName  {  
    // 获取系统时间  
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];  
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];  
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];  
    [dateFormatter setDateFormat:@"yyMMddHHmmssSSSSSS"];  
	
    // 时间字符串  
    NSString *datestr = [dateFormatter stringFromDate:[NSDate date]];  
    [dateFormatter release];  
	return datestr;
}
@end

@implementation CustomizedSiteInfo(PlistParse) 
-(id)initWithDic:(NSDictionary *)dicSite {
	self = [super init];
	if (self && [dicSite isKindOfClass:[NSDictionary class]]) {
		descriptionInfo = [[SiteDescriptionInfo alloc] init];
		self.descriptionInfo.svrName = [dicSite objectForKey:KEY_SITE_NAME];
		self.descriptionInfo.svrDescription = [dicSite objectForKey:KEY_SITE_DESCRIPTION];
		self.descriptionInfo.official = [dicSite objectForKey:KEY_SITE_OFFICIAL];
		self.themeVer = [dicSite objectForKey:KEY_SITE_THEME_VER];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		NSString *destIconsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent: SITE_ICONS_FOLDER_NAME];
		self.siteMainPath = [destIconsPath stringByAppendingPathComponent:[dicSite objectForKey:KEY_SITE_ICONS_PATH]];
		self.logoIconPath =[NSString stringWithFormat:@"%@/%@.%@", self.siteMainPath, SITE_LOGO_NAME, SITE_LOGO_TYPE];
		self.loadingIconPath = [NSString stringWithFormat:@"%@/%@", self.siteMainPath, SITE_LOADING_NAME];
		self.descriptionInfo.svrUrl = [dicSite objectForKey:KEY_SITE_URL];
		self.bActive = [[dicSite objectForKey:KEY_SITE_IS_ACTIVE] boolValue];
		self.bIsDefaultSvr = [[dicSite objectForKey:KEY_SITE_IS_DEFAULT] boolValue];
		self.bUserLogin = [[dicSite objectForKey:KEY_SITE_USER_LOGIN] boolValue];
		self.bUserFirstLogin = [[dicSite objectForKey:KEY_SITE_USER_FIRST_LOGIN] boolValue];
		self.nLastActiveStatus = [[dicSite objectForKey:KEY_SITE_LAST_ACTIVE_STATUS] intValue];
		self.loginUserName = [dicSite objectForKey:KEY_SITE_LOGIN_USER_NAME];
		self.userAccessSecrect = [dicSite objectForKey:KEY_SITE_ACCESS_SECRECT];
		self.userAccessToken = [dicSite objectForKey:KEY_SITE_ACCESS_TOKEN];
        self.bIsdeledated = [[dicSite objectForKey:KEY_SITE_ISDELETEDWB] boolValue];
	}
	return self;
}


+(NSMutableDictionary *)dicWithSiteUrl:(NSString *)siteUrl version:(NSString *)ver andIconFolder:(NSString *)fName {
	NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithCapacity:5];
	[dicResult setObject:@"" forKey:KEY_SITE_NAME];
	[dicResult setObject:[siteUrl lowercaseString] forKey:KEY_SITE_URL];
	[dicResult setObject:@"" forKey:KEY_SITE_DESCRIPTION];
	[dicResult setObject:@"" forKey:KEY_SITE_OFFICIAL];
	[dicResult setObject:@"0" forKey:KEY_SITE_IS_ACTIVE];
	[dicResult setObject:@"0" forKey:KEY_SITE_LAST_ACTIVE_STATUS];
	[dicResult setObject:@"0" forKey:KEY_SITE_IS_DEFAULT];
	[dicResult setObject:ver forKey:KEY_SITE_THEME_VER];
	[dicResult setObject:@"0" forKey:KEY_SITE_USER_LOGIN];
	[dicResult setObject:@"0" forKey:KEY_SITE_USER_FIRST_LOGIN];
	[dicResult setObject:@"" forKey:KEY_SITE_LOGIN_USER_NAME];
	[dicResult setObject:@"" forKey:KEY_SITE_ACCESS_SECRECT];
	[dicResult setObject:@"" forKey:KEY_SITE_ACCESS_TOKEN];
	[dicResult setObject:fName forKey:KEY_SITE_ICONS_PATH];
//    [dicResult setObject:@"0" forKey:KEY_SITE_ISDELETEDWB];
	//NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//	// 随即生成一个图片路径
//	NSString *destIconsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent: SITE_ICONS_FOLDER_NAME];
//	NSString *strIconsPath = [self randFileName];
//	destIconsPath = [destIconsPath stringByAppendingPathComponent:strIconsPath];
//	self.logoIconPath =[NSString stringWithFormat:@"%@/%@.%@", destIconsPath, SITE_LOGO_NAME, SITE_LOGO_TYPE];
	return dicResult;
}


@end