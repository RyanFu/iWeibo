//
//  IWBSvrSettingsManager.m
//  iweibo
//
//  Created by wangying on 5/4/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "IWBSvrSettingsManager.h"
#import "CustomizedSiteInfo.h"
#import "Canstants_Data.h"
#import "TimeTrack.h"

@interface IWBSvrSettingsManager(private)
// 读取信息
-(void)readSiteInfosFromFile;

@end

@implementation IWBSvrSettingsManager(private)

// 读取信息
-(void)readSiteInfosFromFile {
	[arrSiteInfo removeAllObjects];
	if (activeSite) {
		[activeSite release];
		activeSite = nil;
	}
	for (NSDictionary *dicSite in dicSiteInfo) {
		CustomizedSiteInfo *info = [[CustomizedSiteInfo alloc] initWithDic:dicSite];
        if(info.bIsdeledated != 1 ){
            [arrSiteInfo addObject:info];
        }
		if (YES == info.bActive) {
			activeSite = [info copy];
		}
		[info release];
	}
}

@end

@implementation IWBSvrSettingsManager

@synthesize themeArray;
@synthesize dicSiteInfo;
@synthesize arrSiteInfo;
@synthesize activeSite;
@synthesize operQueue;
@synthesize iconFolderName;

/*
- (NSString *)filePath:(NSString *)file_{
    NSString *path = [[NSBundle mainBundle] pathForResource:file_ ofType:@"plist"];
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documents_path=[[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@.plist",file_]];
    
    NSFileManager *fileMnanger = [NSFileManager defaultManager];
    
    
    if (![fileMnanger fileExistsAtPath:documents_path]) {
        [fileMnanger copyItemAtPath:path toPath:documents_path error:nil];
    }
    
    return documents_path;
}
 */
-(id)init
{
	self = [super init];
	if(self)
	{
		[self copyDefaultSvrSettingsFileToCachedDir];	// 先拷贝到对应目录下
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:SERVER_SETTINGS_FILE_NAME];
		themeArray = [[NSArray alloc] initWithContentsOfFile:path];
		dicSiteInfo = [[NSMutableArray alloc] initWithContentsOfFile:path];
		arrSiteInfo = [[NSMutableArray alloc] initWithCapacity:4];
		[self readSiteInfosFromFile];
		downloadArray = [[NSMutableArray alloc] initWithCapacity:3];
		numCondition = [[NSCondition alloc] init];
		operQueue = [[NSOperationQueue alloc] init];
		[operQueue setMaxConcurrentOperationCount:4];	// 最大同时线程运行数
	}
	return self;
}

+(IWBSvrSettingsManager*)sharedSvrSettingManager
{   
	static IWBSvrSettingsManager *instance = nil;
	if (!instance) 
	{
		instance = [[IWBSvrSettingsManager alloc] init];
	}
	return instance;
}

// 是否当前应用为默认微博
+(BOOL)isDefaultWBServer {
	BOOL bResult = NO;
	CustomizedSiteInfo *aSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (nil == aSite) {
		bResult = NO;
	}
	else {
		bResult = aSite.bIsDefaultSvr;
	}

	return bResult;
}

-(void)dealloc
{   
	[themeArray release];
	[dicSiteInfo release];
	[arrSiteInfo release];
	[activeSite release];
//	for (NSThread *th in downloadArray) {
//		[th cancel];
//	}
//	[downloadArray release];
//	downloadArray = nil;
	[numCondition release];
	[operQueue cancelAllOperations];
	[operQueue release];
	self.iconFolderName = nil;
	[super dealloc];
}

// 是否为已存在url
-(CustomizedSiteInfo *)getSiteInfoByUrl:(NSString *)siteUrl {
	if (![siteUrl isKindOfClass:[NSString class]] || [siteUrl length] == 0) {
		return nil;
	}
	CustomizedSiteInfo *siteInfo = nil;
	NSString *strSiteUrl = [siteUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	for (CustomizedSiteInfo *itemInfo in arrSiteInfo) {
		// 查找url
		if (NSOrderedSame == [strSiteUrl caseInsensitiveCompare:itemInfo.descriptionInfo.svrUrl]) {
			siteInfo = [itemInfo copy];
			break;
		}
	}
	return [siteInfo autorelease];
}

// 拷贝文件到cach目录
-(BOOL)copyDefaultIconsToCachedDir {
	NSFileManager *manager = [NSFileManager defaultManager]; 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *srcIconsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:SITE_ICONS_FOLDER_NAME];
	NSString *destIconsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent: SITE_ICONS_FOLDER_NAME];
	[manager createDirectoryAtPath:destIconsPath withIntermediateDirectories:YES attributes:nil error:nil];
	// 创建路径
	for(NSString *subPath in [manager subpathsAtPath:srcIconsPath]) {
		if ([[subPath pathExtension] isEqualToString:@""])
		{
			NSString *fullPath = [NSString stringWithFormat:@"%@/%@", destIconsPath, subPath];
			[manager createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:nil];
		}
		else {
			//CLog(@"file:%@", subPath);
		}
	}
	NSError *error;
	for (NSString *filename in [manager enumeratorAtPath: srcIconsPath]) {
		if (![[filename pathExtension] isEqualToString:@""]) {
			NSString *desFile = [NSString stringWithFormat:@"%@/%@", destIconsPath, filename];
			BOOL find = [manager fileExistsAtPath:desFile];
			if (!find) { 
				NSString *srcFile = [NSString stringWithFormat:@"%@/%@",srcIconsPath,filename];
				BOOL success = [manager copyItemAtPath:srcFile toPath:desFile error:&error];
				if (!success) {
					CLog(@"Failed to copy files '%@'.", [error localizedDescription]);
				}
			}
		}
	} 
	return YES;
}

// 拷贝plist到cach目录
-(BOOL)copyDefaultSvrSettingsFileToCachedDir {
	BOOL bResult = NO;
	NSString *srcPath = [[NSBundle mainBundle] pathForResource:@"ServerSettings" ofType:@"plist"];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *destPlistPath = [[paths objectAtIndex:0] stringByAppendingPathComponent: SERVER_SETTINGS_FILE_NAME];
	NSFileManager *manager = [NSFileManager defaultManager];
	BOOL find = [manager fileExistsAtPath:destPlistPath];
	if (!find) { 
		NSError *error;
		bResult = [manager copyItemAtPath:srcPath toPath:destPlistPath error:&error];
		if (!bResult) {
			CLog(@"Failed to copy files '%@'.", [error localizedDescription]);
		}
	}
	return bResult;
}

// 设置当前site为激活site，并更新相关信息
-(BOOL)updateAndSetSiteActive:(NSString *)siteUrl {
	BOOL bResult = NO;
	if (nil == [self getSiteInfoByUrl:siteUrl]) {
		return NO;
	}
	// 更新激活信息
	for (NSMutableDictionary *dicSite in dicSiteInfo) {
		// 查找对应服务器
		if (NSOrderedSame == [[dicSite objectForKey:KEY_SITE_URL] caseInsensitiveCompare:siteUrl]) {
			[dicSite setObject:@"1" forKey:KEY_SITE_IS_ACTIVE];
			[dicSite setObject:@"2" forKey:KEY_SITE_LAST_ACTIVE_STATUS];
		}
		else {
			[dicSite setObject:@"0" forKey:KEY_SITE_IS_ACTIVE];
			// 假如曾经登陆过，则将状态置为一
			if ([[dicSite objectForKey:KEY_SITE_LAST_ACTIVE_STATUS] intValue] != 0) {
				[dicSite setObject:@"1" forKey:KEY_SITE_LAST_ACTIVE_STATUS];
			}
		}
	}
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent: SERVER_SETTINGS_FILE_NAME];
	bResult = [dicSiteInfo writeToFile:path atomically:NO];
	// 更新对象数组信息
	[self readSiteInfosFromFile];
	return bResult;
}
// 设置所有site为非激活site
-(BOOL)inactiveAllSite {
	// 更新激活信息
	for (NSMutableDictionary *dicSite in dicSiteInfo) {
		[dicSite setObject:@"0" forKey:KEY_SITE_IS_ACTIVE];
	}
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent: SERVER_SETTINGS_FILE_NAME];
	BOOL bResult = [dicSiteInfo writeToFile:path atomically:NO];
	[self readSiteInfosFromFile];
	return bResult;
}

// 设置当前site描述信息
-(BOOL)updateSite:(NSString *)siteUrl withDescription:(SiteDescriptionInfo *)desInfo {
	BOOL bResult = NO;
	for (NSDictionary *dicSite in dicSiteInfo) {
		// 查找对应服务器
		if (NSOrderedSame == [[dicSite objectForKey:KEY_SITE_URL] caseInsensitiveCompare:siteUrl]) {
			bResult = YES;
			break;
		}
		
	}
	if (!bResult) {
		return NO;
	}
	// 更新激活信息
	for (NSMutableDictionary *dicSite in dicSiteInfo) {
		// 查找对应服务器
		if (NSOrderedSame == [[dicSite objectForKey:KEY_SITE_URL] caseInsensitiveCompare:siteUrl]) {
			NSString *str = desInfo.official;
			if (str != nil && [str length] > 0) {
				[dicSite setObject:str forKey:KEY_SITE_OFFICIAL];
			}
			str = desInfo.svrName;
			if (str != nil && [str length] > 0) {
				[dicSite setObject:str forKey:KEY_SITE_NAME];
			}
			str = desInfo.svrDescription;
			if (str != nil && [str length] > 0) {
				[dicSite setObject:str forKey:KEY_SITE_DESCRIPTION];
			}
			break;
		}
	}
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent: SERVER_SETTINGS_FILE_NAME];
	bResult = [dicSiteInfo writeToFile:path atomically:NO];
	// 重新生成arrSiteInfo信息
	[self readSiteInfosFromFile];
	return bResult;
}
// 设置账户登陆状态
-(BOOL)updateSite:(NSString *)siteUrl withUser:(NSString *)uName loginState:(BOOL)bLogin firstLogin:(BOOL)bFirstLogin {
	BOOL bResult = NO;
	//for (NSDictionary *dicSite in dicSiteInfo) {
//		// 查找对应服务器
//		if (NSOrderedSame == [[dicSite objectForKey:KEY_SITE_URL] caseInsensitiveCompare:siteUrl]) {
//			bResult = YES;
//			break;
//		}
//	}
//	if (!bResult) {
//		return NO;
//	}
	if (![self getSiteInfoByUrl:siteUrl]) {
		return NO;
	}
	// 更新激活信息
	NSString *strFirstLogin = @"1";
	if (!bFirstLogin) {
		strFirstLogin = @"0";
	}
	for (NSMutableDictionary *dicSite in dicSiteInfo) {
		// 查找对应服务器
		if (NSOrderedSame == [[dicSite objectForKey:KEY_SITE_URL] caseInsensitiveCompare:siteUrl]) {
			if (!bLogin) {
				[dicSite setObject:@"0" forKey:KEY_SITE_USER_LOGIN];
				[dicSite setObject:@"0" forKey:KEY_SITE_USER_FIRST_LOGIN];
				[dicSite setObject:@"" forKey:KEY_SITE_LOGIN_USER_NAME];
			}
			else {
				[dicSite setObject:@"1" forKey:KEY_SITE_USER_LOGIN];
				[dicSite setObject:strFirstLogin forKey:KEY_SITE_USER_FIRST_LOGIN];
				[dicSite setObject:uName forKey:KEY_SITE_LOGIN_USER_NAME];			
			}
			break;
		}
	}
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent: SERVER_SETTINGS_FILE_NAME];
	bResult = [dicSiteInfo writeToFile:path atomically:NO];
	// 重新生成arrSiteInfo信息
	[self readSiteInfosFromFile];
	return bResult;
}


// 设置登陆token跟secrect信息
-(BOOL)updateSite:(NSString *)siteUrl withUser:(NSString *)uName accessToken:(NSString *)token accessKey:(NSString *)key {
	if (![self getSiteInfoByUrl:siteUrl]) {
		return NO;
	}
	// 更新激活信息
	for (NSMutableDictionary *dicSite in dicSiteInfo) {
		// 查找对应服务器
		if (NSOrderedSame == [[dicSite objectForKey:KEY_SITE_URL] caseInsensitiveCompare:siteUrl]) {
			[dicSite setObject:token forKey:KEY_SITE_ACCESS_TOKEN];
			[dicSite setObject:key forKey:KEY_SITE_ACCESS_SECRECT];
			break;
		}
	}
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent: SERVER_SETTINGS_FILE_NAME];
	BOOL bResult = [dicSiteInfo writeToFile:path atomically:NO];
	// 重新生成arrSiteInfo信息
	[self readSiteInfosFromFile];
	return bResult;
}

- (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size    
{    
    UIGraphicsBeginImageContext(size);										// 创建一个bitmap的context，并把它设置成为当前正在使用的context
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];				// 绘制改变大小的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();	// 从当前context中创建一个改变大小后的图片    
    UIGraphicsEndImageContext();											// 使当前的context出堆栈    
    return scaledImage;													// 返回新的改变大小后的图片
} 

-(BOOL)downloadIcon:(NSString *)srcUrl toLocal:(NSString *)localPath {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSFileManager *manager = [NSFileManager defaultManager];
	NSString *iconName = [srcUrl lastPathComponent];
	NSString *iconPath = [localPath stringByAppendingPathComponent:iconName];
	// 创建目录
	[manager createDirectoryAtPath:localPath withIntermediateDirectories:YES attributes:nil error:nil];
	// 创建文件
	NSData *dt = [NSData dataWithContentsOfURL:[NSURL URLWithString:srcUrl]];
	BOOL bResult = [manager createFileAtPath:iconPath contents:dt attributes:nil];
	// 创建1x图
	CGFloat scale = 1.0;
	if (iconPath.length >= 8)
	{
		// Search @2x. at the end of the string, before a 3 to 4 extension length (only if key len is 8 or more @2x. + 4 len ext)
		NSRange range = [iconPath rangeOfString:@"@2x." options:0 range:NSMakeRange(iconPath.length - 8, 5)];
		if (range.location != NSNotFound)
		{
			scale = 2.0;
		}
	}
	if (bResult) {
		UIImage *image = [[UIImage alloc] initWithData:dt];
		CGSize szImage = image.size;
		szImage.width = szImage.width / scale;
		szImage.height = szImage.height / scale;
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
		{
			UIImage *scaledImage = [self originImage:image scaleToSize:szImage];
			NSData *dtScale = UIImagePNGRepresentation(scaledImage);
			NSString *iconScale = [iconName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
			NSString *iconPathScale = [localPath stringByAppendingPathComponent:iconScale];
			bResult = [manager createFileAtPath:iconPathScale contents:dtScale attributes:nil];
		}
		[image release];
	}
	[pool drain];
	return bResult;
}

-(void)downloadIconWithPar:(NSMutableDictionary *)dic {
	[NSThread sleepForTimeInterval:5.0f];
	NSString *srcUrl = [dic objectForKey:@"URL"];
	NSString *localPath = [dic objectForKey:@"PATH"];
	[self downloadIcon:srcUrl toLocal:localPath];
	[numCondition lock];
	curDownloadedIconsNumber--;
	[numCondition unlock];
}

-(NSString *)randFileName  {  
	if (self.iconFolderName == nil) {
		// 获取系统时间  
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];  
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];  
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];  
		[dateFormatter setDateFormat:@"yyMMddHHmmssSSSSSS"];  
		
		// 时间字符串  
		NSString *datestr = [dateFormatter stringFromDate:[NSDate date]];  
		[dateFormatter release];  
		self.iconFolderName = datestr;
	}
	CLog(@"%s, iconFolderName=%@", __FUNCTION__, iconFolderName);
	return self.iconFolderName;
}

-(void)downloadThemeWithParameter:(NSMutableDictionary *)dicData {
	NSMutableDictionary *dicCopy = [dicData copy];
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	bCancelledThemeDownload = NO;
	NSString *siteIconSubPath = [dicCopy objectForKey:@"PATH"];
	NSDictionary *dicDeltaTheme = [dicCopy objectForKey:@"DeltaTheme"];
	NSString *siteUrl = [dicCopy objectForKey:@"URL"];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *destIconsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent: SITE_ICONS_FOLDER_NAME];
	siteIconSubPath = [destIconsPath stringByAppendingPathComponent:siteIconSubPath];
	NSString *strShortUrl = [siteUrl stringByReplacingOccurrencesOfString:HOST_SUB_PATH_COMPONENT withString:@""];	// 短路径
	NSArray *arrAllKeys = [dicDeltaTheme allKeys];
	curDownloadedIconsNumber = [arrAllKeys count];
	// 多线程
	for (NSString *key in arrAllKeys) {
		NSString *value = [dicDeltaTheme valueForKey:key];
		NSString *srcIconUrl = [strShortUrl stringByAppendingPathComponent:value];
		if (srcIconUrl.length >= 8)
		{
			// Search @2x. at the end of the string, before a 3 to 4 extension length (only if key len is 8 or more @2x. + 4 len ext)
			NSRange range = [srcIconUrl rangeOfString:@"@2x." options:0 range:NSMakeRange(srcIconUrl.length - 8, 5)];
			if (range.location != NSNotFound)
			{
				NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:srcIconUrl, @"URL", siteIconSubPath, @"PATH", nil];
				NSInvocationOperation *invOperation = [[NSInvocationOperation alloc] initWithTarget:self 
																						   selector:@selector(downloadIconWithPar:)
																							 object:dic];
				[operQueue addOperation:invOperation];
				[invOperation release];
				[dic release];
			}
			else {
				[numCondition lock];
				curDownloadedIconsNumber--;
				[numCondition unlock];
			}
		}
		else {
			[numCondition lock];
			curDownloadedIconsNumber--;
			[numCondition unlock];
		}
	}
	BOOL bResult = NO;
	NSInteger tryCount =  MAX_TRY_COUNT;	
	while (tryCount > 0 && !bCancelledThemeDownload) {
		CLog(@"tryCount:%d", tryCount);
		[NSThread sleepForTimeInterval:0.02];
		tryCount--;
		[numCondition lock];
		if (curDownloadedIconsNumber == 0) {
			bResult = YES;
			[numCondition unlock];
			break;
		}
		[numCondition unlock];
	}
	if (bResult) {
		NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1", @"ret", [dicData objectForKey:@"PATH"], @"PATH",@"存储成功", @"msg", nil];
		if ([delegate respondsToSelector:onSuccessCallback]) {
			[delegate performSelector:onSuccessCallback withObject:dic];
		}
		[dic release];
		self.iconFolderName = nil;
	}
	else {
		if (tryCount == 0) {
			// 超时
			NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0", @"ret", [dicData objectForKey:@"PATH"], @"PATH",@"下载超时", @"msg", nil];
			if ([delegate respondsToSelector:onSuccessCallback]) {
				[delegate performSelector:onSuccessCallback withObject:dic];
			}
			[dic release];
			self.iconFolderName = nil;
		}
	}

	[dicCopy release];
	CLog(@"%s, finished", __FUNCTION__);
	[pool drain];
}

// 异步下载图片到本地目录, 返回(先下载图片，然后再根据返回的图片文件夹名称更新站点)
// ret: 回调用返回图片所在文件夹名称以及下载结果
-(void)downloadTheme:(NSString *)siteUrl wiThemeDic:(NSDictionary *)dicDeltaTheme delegate:(id)dele Callback:(SEL)sel {
	if (delegate != nil) {
		CLog(@"%s", __FUNCTION__);
	}
	CustomizedSiteInfo *site = [self getSiteInfoByUrl:siteUrl];
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//	NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent: SERVER_SETTINGS_FILE_NAME];
	NSString *siteIconSubPath = nil;
	if (site != nil) {
		siteIconSubPath = [site.siteMainPath lastPathComponent];
	}
	else {
		siteIconSubPath = [self randFileName];
	}
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:siteUrl, @"URL", dicDeltaTheme, @"DeltaTheme", siteIconSubPath, @"PATH", nil];
	CLog(@"dic=%@", dic);
	delegate = dele;
	onSuccessCallback = sel;
	// 启动下载
	[self performSelectorInBackground:@selector(downloadThemeWithParameter:) 
			   withObject:dic];
	[dic release];
}

// 取消下载
-(void)CancelThemeDownLoading {
	CLog(@"%s", __FUNCTION__);
	[self.operQueue cancelAllOperations];
	delegate = nil;
	onSuccessCallback = nil;
	bCancelledThemeDownload = YES;
}

// 设置当前site的theme信息(假如不存在当前site则需要手动添加)
// 1.更新ver信息
// 2.更新theme文件
-(BOOL)updateSite:(NSString *)siteUrl withVer:(NSString *)ver themeDic:(NSDictionary *)dicDeltaTheme andIconFolder:(NSString *)fName {
	BOOL bResult = YES;
	NSMutableArray *arrSiteInfoFromFile = [dicSiteInfo copy];
	CustomizedSiteInfo *site = [self getSiteInfoByUrl:siteUrl];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent: SERVER_SETTINGS_FILE_NAME];
	if (site != nil) {
		// 存在当前site
		// 更新激活信息
		for (NSMutableDictionary *dicSite in dicSiteInfo) {
			// 查找对应服务器
			if (NSOrderedSame == [[dicSite objectForKey:KEY_SITE_URL] caseInsensitiveCompare:siteUrl]) {
				[dicSite setObject:ver forKey:KEY_SITE_THEME_VER];
				break;
			}
		}
	}
	else {
		// 不存在当前site
		NSMutableDictionary *dicNewItem = [CustomizedSiteInfo dicWithSiteUrl:siteUrl version:ver andIconFolder:fName];
		[dicSiteInfo addObject:dicNewItem];
	}
//		// 下载图片资源到本地
//	// 先获取路径
//	TimeTrack* timeTrackDownload = [[TimeTrack alloc] initWithName:[NSString stringWithFormat:@"%s iconDownload",__FUNCTION__]];
////	[timeTrackDownload printCurrentTime];
//	NSString *strShortUrl = [siteUrl stringByReplacingOccurrencesOfString:HOST_SUB_PATH_COMPONENT withString:@""];	// 短路径
//	NSArray *arrAllKeys = [dicDeltaTheme allKeys];
//	curDownloadedIconsNumber = [arrAllKeys count];
//	// 多线程
//	for (NSString *key in arrAllKeys) {
//		NSString *value = [dicDeltaTheme valueForKey:key];
//		NSString *srcIconUrl = [strShortUrl stringByAppendingPathComponent:value];
//		if (srcIconUrl.length >= 8)
//		{
//			// Search @2x. at the end of the string, before a 3 to 4 extension length (only if key len is 8 or more @2x. + 4 len ext)
//			NSRange range = [srcIconUrl rangeOfString:@"@2x." options:0 range:NSMakeRange(srcIconUrl.length - 8, 5)];
//			if (range.location != NSNotFound)
//			{
//				NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:srcIconUrl, @"URL", siteIconSubPath, @"PATH", nil];
//				NSInvocationOperation *invOperation = [[NSInvocationOperation alloc] initWithTarget:self 
//																						   selector:@selector(downloadIconWithPar:)
//																							 object:dic];
//				[operQueue addOperation:invOperation];
//				[invOperation release];
//				//NSThread *threadIconDownload = [[NSThread alloc] initWithTarget:self selector:@selector(downloadIconWithPar:) object:dic];
//				//[downloadArray addObject:threadIconDownload];
////				[threadIconDownload start];
////				[threadIconDownload release];
//				[dic release];
//			}
//			else {
//				[numCondition lock];
//				curDownloadedIconsNumber--;
//				[numCondition unlock];
//			}
//                                                                                       
//		}
//	}
//	bResult = NO;
//	NSInteger tryCount = 50 * 60 * 2;	// 2分钟
//	while (tryCount > 0) {
//		CLog(@"%d", tryCount);
//		[NSThread sleepForTimeInterval:0.02];
//		tryCount--;
//		[numCondition lock];
//		if (curDownloadedIconsNumber == 0) {
//			bResult = YES;
//			[numCondition unlock];
//			break;
//		}
//		[numCondition unlock];
//	}
//	// 清除数据	
////	for (NSThread *th in downloadArray) {
////		[th cancel];
////	}
////	[downloadArray removeAllObjects];
//	[operQueue cancelAllOperations];
//	
//	[timeTrackDownload release];
	
	if (bResult) {
		bResult = [dicSiteInfo writeToFile:path atomically:NO];
		// 重新生成arrSiteInfo信息
		[self readSiteInfosFromFile];
	}
	else {
		dicSiteInfo = arrSiteInfoFromFile;	// 还原
		bResult = [dicSiteInfo writeToFile:path atomically:NO];
		// 重新生成arrSiteInfo信息
		[self readSiteInfosFromFile];
	}
	[arrSiteInfoFromFile release];
	return bResult;
}

// 标记被删除微博信息,如果是网络加载的站点，连数据一起删除
-(BOOL)SigndelateSite:(NSString*)Siturl {
    NSDictionary *shouldRemovedDic = nil;
	for (NSMutableDictionary *dicSite in dicSiteInfo) {
        
        if (NSOrderedSame == [[dicSite objectForKey:KEY_SITE_URL] caseInsensitiveCompare:Siturl])
        {
            if ([[dicSite objectForKey:KEY_SITE_IS_DEFAULT] intValue] == 0) {
                [dicSite setObject:@"1" forKey:KEY_SITE_SHOUDEREMOVED];
                shouldRemovedDic = dicSite;
            }else{
                [dicSite setObject:@"1" forKey:KEY_SITE_ISDELETEDWB];
            }
        }
        
	}
    
    if ([[shouldRemovedDic objectForKey:KEY_SITE_SHOUDEREMOVED] intValue] == 1 ) {
        [dicSiteInfo removeObject:shouldRemovedDic];
    }
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent: SERVER_SETTINGS_FILE_NAME];
	BOOL bResult = [dicSiteInfo writeToFile:path atomically:NO];
	[self readSiteInfosFromFile];
	return bResult;
}


@end
