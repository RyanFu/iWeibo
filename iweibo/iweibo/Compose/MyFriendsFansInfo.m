//
//  MyFriendsFansInfo.m
//  iweibo
//
//  Created by Minwen Yi on 1/11/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "MyFriendsFansInfo.h"
#import "Database.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "IWBSvrSettingsManager.h"
#import "CustomizedSiteInfo.h"

@implementation MyFriendsFansInfo
@synthesize fansname, openid, nick, head, sex, fanslocation, country_code, province_code, city_code, isvip, isCommonContact;

- (void)dealloc {
	self.fansname = nil;
	self.openid = nil;
	self.nick = nil;
	self.head = nil;
	self.sex = nil;
	self.fanslocation = nil;
	self.country_code = nil;
	self.province_code = nil;
	self.city_code = nil;
	self.isCommonContact = nil;
	self.isvip = nil;
	[super dealloc];
}

// 从数据库中获取所有数据
+ (NSMutableArray *)myFriendsFansListFromDB {
	FMDatabase *db = [Database sharedManager].db;
	NSMutableArray *arrayAll = [NSMutableArray arrayWithCapacity:10];
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {
		FMResultSet *s = [db executeQueryWithFormat:@"select name, openid, nick, head, sex, location, country_code, province_code, city_code, isvip, isCommonContact \
						  from myFriendsFans where site=%@ and loginUserName=%@ order by isCommonContact desc", actSite.descriptionInfo.svrName, actSite.loginUserName];
		while ([s next]) {
			MyFriendsFansInfo *info = [[MyFriendsFansInfo alloc] init];
			info.fansname = [s stringForColumnIndex:0];
			info.openid = [s stringForColumnIndex:1];
			info.nick = [s stringForColumnIndex:2];
			info.head = [s stringForColumnIndex:3];
			info.sex = [NSNumber numberWithInt:[s intForColumnIndex:4]];
			info.fanslocation = [s stringForColumnIndex:5];
			info.country_code = [s stringForColumnIndex:6];
			info.province_code = [s stringForColumnIndex:7];
			info.city_code = [s stringForColumnIndex:8];
			info.isvip = [NSNumber numberWithInt:[s intForColumnIndex:9]];
			info.isCommonContact = [NSNumber numberWithInt:[s intForColumnIndex:10]];
			[arrayAll addObject:info];
			[info release];
		}
	}
	return arrayAll;
}
// 从数据库中获取所有数据
+ (NSMutableArray *)mySimpleFriendsFansListFromDB {
	FMDatabase *db = [Database sharedManager].db;
	NSMutableArray *arrayAll = [NSMutableArray arrayWithCapacity:30];
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {
		FMResultSet *s = [db executeQueryWithFormat:@"select name, nick, head, isvip, isCommonContact from myFriendsFans \
						  where site=%@ and loginUserName=%@ order by isCommonContact desc", actSite.descriptionInfo.svrName, actSite.loginUserName];
		while ([s next]) {
			MyFriendsFansInfo *info = [[MyFriendsFansInfo alloc] init];
			info.fansname = [s stringForColumnIndex:0];
			info.nick = [s stringForColumnIndex:1];
			info.head = [s stringForColumnIndex:2];
			info.isvip = [NSNumber numberWithInt:[s intForColumnIndex:3]];
			info.isCommonContact = [NSNumber numberWithInt:[s intForColumnIndex:4]];
			[arrayAll addObject:info];
			[info release];
		}
	}
	return arrayAll;
}

+ (NSMutableArray *)mySimpleCommonFriendsFansListFromDB {
	FMDatabase *db = [Database sharedManager].db;
	NSMutableArray *arrayAll = [NSMutableArray arrayWithCapacity:30];
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {
		FMResultSet *s = [db executeQueryWithFormat:@"select name, nick, head, isvip, isCommonContact from myFriendsFans \
						  where isCommonContact=1 and site=%@ and loginUserName=%@ order by isCommonContact desc", actSite.descriptionInfo.svrName, actSite.loginUserName];
		while ([s next]) {
			MyFriendsFansInfo *info = [[MyFriendsFansInfo alloc] init];
			info.fansname = [s stringForColumnIndex:0];
			info.nick = [s stringForColumnIndex:1];
			info.head = [s stringForColumnIndex:2];
			info.isvip = [NSNumber numberWithInt:[s intForColumnIndex:3]];
			info.isCommonContact = [NSNumber numberWithInt:[s intForColumnIndex:4]];
			[arrayAll addObject:info];
			[info release];
		}
	}
	return arrayAll;
}

// 更新是否为常用联系人
+ (BOOL)updateFans:(NSString *)fName WithStatus:(BOOL)status {
	BOOL bResult = NO;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {
		FMDatabase *db = [Database sharedManager].db;
		int n = status ? 1 : 0;
		NSString *st = [[NSString alloc] initWithFormat:@"%d", n];
		bResult = [db executeUpdateWithFormat:@"update myFriendsFans set isCommonContact=%@ \
				   where name=%@ and site=%@ and loginUserName=%@ ", st, fName, actSite.descriptionInfo.svrName, actSite.loginUserName];	
		[st release];
	}
	return bResult;
}

// 更新听众信息
+ (BOOL)updateFans:(NSString *)fName WithInfo:(MyFriendsFansInfo *) fansInfo {
	FMDatabase *db = [Database sharedManager].db;
	// 删除，然后添加
	BOOL bResult = NO;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {
		FMResultSet *s = [db executeQueryWithFormat:@"select isCommonContact from myFriendsFans \
						  where name=%@ and site=%@ and loginUserName=%@", fansInfo.fansname, actSite.descriptionInfo.svrName, actSite.loginUserName];
		NSString *sexStr = [[NSString alloc] initWithFormat:@"%@", fansInfo.sex];
		NSString *isvipStr = [[NSString alloc] initWithFormat:@"%@", fansInfo.isvip];
		NSString *isCommonContactStr = [[NSString alloc] initWithFormat:@"%@", fansInfo.isCommonContact];
		if ([s next]) {
			NSString *isCommonContactString = [[NSString alloc] initWithFormat:@"%d", [s intForColumnIndex:0]];
			// 更新各个字段
			bResult = [db executeUpdateWithFormat:@"update myFriendsFans set nick=%@, head=%@, sex=%@, location=%@, "
					   " country_code=%@, province_code=%@, city_code=%@, isvip=%@, @isCommonContact=%@ where name=%@ "
					   " and site=%@ and loginUserName=%@",
					   fansInfo.nick, fansInfo.head, sexStr, fansInfo.fanslocation, 
					   fansInfo.country_code, fansInfo.province_code, fansInfo.city_code, isvipStr, isCommonContactString, fansInfo.fansname,
					  actSite.descriptionInfo.svrName, actSite.loginUserName];
			[isCommonContactString release];
		}
		else {
			// 插入新数据
			// 注意字段顺序
			bResult = [db executeUpdateWithFormat:@"insert into myFriendsFans(site, loginUserName, name, openid, nick, head, sex, location, "
					   " country_code, province_code, city_code, isvip, isCommonContact, headImageData) "
					   " values(%@, %@, %@, %@, %@, %@,%@, %@,%@, %@,%@, %@, %@, %@ )", 
					   actSite.descriptionInfo.svrName, actSite.loginUserName, fansInfo.fansname, fansInfo.openid, fansInfo.nick, fansInfo.head, sexStr, 
					   fansInfo.fanslocation, fansInfo.country_code, fansInfo.province_code, fansInfo.city_code, isvipStr, isCommonContactStr, @""];	
			
		}
		[sexStr release];
		[isvipStr release];
		[isCommonContactStr release];
	}
	return bResult;
}	 

+ (BOOL)updateMyFriendsFansInfoToDB:(NSMutableArray *)fansInfoArray {
	// 删除，然后添加
	BOOL bResult = NO;
	for (NSDictionary *infoItem in fansInfoArray) {
		MyFriendsFansInfo *fansInfo = [[MyFriendsFansInfo alloc] init];
		fansInfo.fansname = [infoItem objectForKey:@"name"];
		fansInfo.openid = [infoItem objectForKey:@"openid"];
		fansInfo.nick = [infoItem objectForKey:@"nick"];
		fansInfo.head = [infoItem objectForKey:@"head"];
		fansInfo.sex = [infoItem objectForKey:@"sex"];
		fansInfo.fanslocation = [infoItem objectForKey:@"location"];
		fansInfo.country_code = [infoItem objectForKey:@"country_code"];
		fansInfo.province_code = [infoItem objectForKey:@"province_code"];
		fansInfo.city_code = [infoItem objectForKey:@"city_code"];
		fansInfo.isvip = [infoItem objectForKey:@"isvip"];
		NSNumber *CommonContact = [[NSNumber alloc] initWithInt:0];
		fansInfo.isCommonContact = CommonContact;
		[CommonContact release];
		
		bResult = [MyFriendsFansInfo updateFans:fansInfo.fansname  WithInfo:fansInfo];
		[fansInfo release];
		if (!bResult) {
			break;
		}
	}
	// 更新到最新时间
	if (bResult) {
		[MyFriendsFansInfo updateFansLastUpdatedTimeToCurrent];
	}
	return bResult;
}

// 将联系人添加到常用联系人中
+ (BOOL)addFanToCommonContact:(NSString *)fName WithDicInfo:(NSDictionary *)dic {
	BOOL bResult = NO;
	MyFriendsFansInfo *fansInfo = [[MyFriendsFansInfo alloc] init];
	fansInfo.fansname = [dic objectForKey:@"name"];
	fansInfo.openid = [dic objectForKey:@"openid"];
	fansInfo.nick = [dic objectForKey:@"nick"];
	fansInfo.head = [dic objectForKey:@"head"];
	fansInfo.sex = [dic objectForKey:@"sex"];
	fansInfo.fanslocation = [dic objectForKey:@"location"];
	fansInfo.country_code = [dic objectForKey:@"country_code"];
	fansInfo.province_code = [dic objectForKey:@"province_code"];
	fansInfo.city_code = [dic objectForKey:@"city_code"];
	fansInfo.isvip = [dic objectForKey:@"isvip"];
	NSNumber *CommonContact = [[NSNumber alloc] initWithInt:1];
	fansInfo.isCommonContact = CommonContact;
	[CommonContact release];
	bResult = [MyFriendsFansInfo updateFans:fansInfo.fansname  WithInfo:fansInfo];
	[fansInfo release];
	return bResult;
}

// 是否需要从服务器更新数据
							 
+ (int)isUpdateFansFromServerNeeded {
	int nResult = 0;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {
		NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
		NSTimeInterval now=[dat timeIntervalSince1970]*1;
		FMDatabase *db = [Database sharedManager].db;
		FMResultSet *s = [db executeQueryWithFormat:@"select myFriendsLastUpdatedTime from config where site=%@ and name=%@", actSite.descriptionInfo.svrName, actSite.loginUserName];
		if ([s next]) {
			NSString  *lastUpdatedTime= [s stringForColumnIndex:0];
			NSTimeInterval last = [lastUpdatedTime doubleValue];
			if ((now - (24.0 * 3600.0)) > last) {
				// 说明超过24小时没更新
				nResult = 1;
			}
			else {
				nResult = 0;
			}
		}
		else {
			nResult = -1;
			// 从未更新过，插入一条初始语句
			[db executeUpdateWithFormat:@"insert into config(site, id, myFavTopicLastUpdatedTime, myFriendsLastUpdatedTime, name) values(%@, %@, 0, 0, %@)", actSite.descriptionInfo.svrName, @"1", actSite.loginUserName];
		}
		[s close];
	}
	return nResult;
}

// 更新最后更新时间到当前时间
+ (BOOL)updateFansLastUpdatedTimeToCurrent {
	BOOL bResult = NO;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {
		NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
		NSTimeInterval now=[dat timeIntervalSince1970]*1;
		NSString *timeString=[NSString stringWithFormat:@"%.0f", now];
		FMDatabase *db = [Database sharedManager].db;
		bResult = [db executeUpdateWithFormat:@"update config set myFriendsLastUpdatedTime=%@ where site=%@ and name=%@", timeString , actSite.descriptionInfo.svrName, actSite.loginUserName];
	}
	return bResult;
}

// 清除数据
+ (BOOL)removeFriendsFansFromDB {
	BOOL bResult = NO;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {
		FMDatabase *db = [Database sharedManager].db;
		bResult = [db executeUpdateWithFormat:@"delete from myFriendsFans where site=%@ and loginUserName=%@", actSite.descriptionInfo.svrName, actSite.loginUserName];
		if (bResult) {
			bResult = [db executeUpdateWithFormat:@"update config set myFriendsLastUpdatedTime='0' where site=%@ and name=%@", actSite.descriptionInfo.svrName, actSite.loginUserName];
		}
	}
	return bResult;
}

// 获取对应好友用户头像数据
+ (NSData *)myFanHeadImageDataWithName:(NSString *)fName {
	NSData *data = nil;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {
		FMDatabase *db = [Database sharedManager].db;
		FMResultSet *resultSet = [db executeQueryWithFormat:@"select headImageData from myFriendsFans where name=%@ "
								  " and site=%@ and loginUserName=%@", fName, actSite.descriptionInfo.svrName, actSite.loginUserName];
		if ([resultSet next]) {
			data = [resultSet dataForColumnIndex:0];
		}
		[resultSet close];
	}
	return data;
}

// 获取对应好友用户头像数据
+ (NSData *)myFanHeadImageDataWithUrl:(NSString *)url {
	NSData *data = nil;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {
		FMDatabase *db = [Database sharedManager].db;
		FMResultSet *resultSet = [db executeQueryWithFormat:@"select headImageData from myFriendsFans where head=%@ "
								  " and site=%@ and loginUserName=%@", url, actSite.descriptionInfo.svrName, actSite.loginUserName];
		if ([resultSet next]) {
			data = [resultSet dataForColumnIndex:0];
		}
		[resultSet close];
	}
	return data;
}

+ (BOOL)updateImageData:(NSData *)imageData ForHead:(NSString *)headStr {
	if (imageData == nil || [imageData length] == 0 || headStr == nil || [headStr length] == 0) {
		return YES;
	}
	BOOL bResult = NO;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {
		FMDatabase *db = [Database sharedManager].db;
		//NSString *strData = [[NSString alloc] initWithFormat:@"%@", imageData];
	//	BOOL bResult = [db executeQueryWithFormat:@"update myFriendsFans set headImageData=%@ where head=%@",strData, headStr];
	//	[strData release];
		// 与用户无关，因此不用加用户限制
		NSString *sql = @"update myFriendsFans set headImageData=? where head=? and site=?";
		NSArray *arrayArg = [NSArray arrayWithObjects:imageData, headStr, actSite.descriptionInfo.svrName, nil];
		bResult = [db executeUpdate:sql withArgumentsInArray:arrayArg];
	}
	return bResult;
}

@end
