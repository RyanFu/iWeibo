//
//  UserInfo.m
//  iweibo
//
//  Created by zhaoguohui on 12-1-13.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "UserInfo.h"
#import "Database.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "IWBSvrSettingsManager.h"

@implementation UserInfo
@synthesize birth_day;	
@synthesize birth_month;
@synthesize birth_year;	
@synthesize city_code;	
@synthesize country_code;
@synthesize edu;		
@synthesize email;		
@synthesize fansnum;	
@synthesize head;		
@synthesize idolnum;	
@synthesize introduction;
@synthesize isent;		
@synthesize isrealname;	
@synthesize isvip;		
@synthesize location;	
@synthesize name;		
@synthesize nick;		
@synthesize openid;		
@synthesize province_code;
@synthesize sex;		
@synthesize tag;		
@synthesize tweetnum;	
@synthesize verifyinfo;	

static UserInfo *userInfo = nil;
// 创建单例用户信息对象
+ (UserInfo *)sharedUserInfo {
	if (userInfo == nil) {
		userInfo = [[UserInfo alloc] init];
		[userInfo loadDataFromDB];
	}
	return userInfo;
}

// 从数据库加载初始数据
-(void)loadDataFromDB {
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {
		FMDatabase *db = [Database sharedManager].db;
		FMResultSet *s = [db executeQueryWithFormat:@"select name, nick, fansnum, idolnum, head, introduction, tweetnum from UserInfo where name=%@ and site=%@", actSite.loginUserName, actSite.descriptionInfo.svrName];
		if ([s next]) {
			self.name = [s stringForColumnIndex:0];
			self.nick = [s stringForColumnIndex:1];
			self.fansnum = [NSNumber numberWithInt:[s intForColumnIndex:2]];
			self.idolnum = [NSNumber numberWithInt:[s intForColumnIndex:3]];
			self.head = [s stringForColumnIndex:4];
			self.introduction = [s stringForColumnIndex:5];
			if (self.introduction == nil) {
				self.introduction = @"";
			}
			self.tweetnum = [NSNumber numberWithInt:[s intForColumnIndex:6]];
		}
		[s close];
	}
}

- (BOOL)saveUserDataToUserInfo:(NSDictionary *)info {
	BOOL bResult = NO;
	self.nick = [info objectForKey:@"nick"];
	self.name = [info objectForKey:@"name"];
	self.fansnum = [info objectForKey:@"fansnum"];
	self.idolnum = [info objectForKey:@"idolnum"];
	self.head = [info objectForKey:@"head"];
	if (self.head == nil) {
		self.head = @"";
	}
	self.introduction = [info objectForKey:@"introduction"];
	if (self.introduction == nil) {
		self.introduction = @"";
	}
	self.tweetnum = [info objectForKey:@"tweetnum"];
	
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {
		FMDatabase *db = [Database sharedManager].db;
		FMResultSet *s = [db executeQueryWithFormat:@"select 1 from UserInfo where name=%@ and site=%@", self.name, actSite.descriptionInfo.svrName];
		if ([s next]) {
			// 更新原有用户信息
			bResult = [db executeUpdateWithFormat:@"update UserInfo set nick=%@ fansnum=%@, idolnum=%@, head=%@, introduction=%@, tweetnum=%@ where name=%@ and site=%@",self.nick, self.fansnum, self.idolnum, self.head, self.introduction, self.tweetnum, self.name, actSite.descriptionInfo.svrName];		
		}
		else {
			// 插入新用户信息
			bResult = [db executeUpdateWithFormat:@"insert into UserInfo(name,site, nick, fansnum, idolnum, head, introduction, tweetnum) values(%@,%@,%@,%@,%@,%@,%@,%@)",self.name, actSite.descriptionInfo.svrName, self.nick, self.fansnum, self.idolnum, self.head, self.introduction, self.tweetnum];
		}
		[s close];
	}
	return bResult;
}

- (void)clearUserInfo {
	self.birth_day = nil;
	self.birth_month = nil;
	self.birth_year = nil;
	self.city_code = nil;
	self.country_code = nil;
	self.edu = nil;
	self.email = nil;
	self.fansnum = nil;
	self.head = nil;
	self.idolnum = nil;
	self.introduction = nil;
	self.isent = nil;
	self.isrealname = nil;
	self.isvip = nil;
	self.location = nil;
	self.name = nil;
	self.nick = nil;
	self.openid = nil;
	self.province_code = nil;
	self.sex = nil;
	self.tag = nil;
	self.tweetnum = nil;
	self.verifyinfo = nil;
}

- (void)dealloc {
	
	[birth_day release];	
	[birth_month release];
	[birth_year release];	
	[city_code release];
	[country_code release];
	[edu release];
	[email release];		
	[fansnum release];
	[head release];
	[idolnum release];
	[introduction release];
	[isent release];		
	[isrealname release];
	[isvip release];
	[location release];
	[name release];
	[nick release];
	[openid release];
	[province_code release];
	[sex release];
	[tag release];
	[tweetnum release];
	[verifyinfo release];
	
	[super dealloc];
}
@end
