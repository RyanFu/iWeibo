//
//  MyFavTopicInfo.m
//  iweibo
//
//  Created by Minwen Yi on 1/10/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "MyFavTopicInfo.h"
#import "Database.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "IWBSvrSettingsManager.h"
#import "CustomizedSiteInfo.h"


@implementation MyFavTopicInfo
@synthesize topicID, favNum, tweetNum, textString, timeStamp, hasAddedBefore;

- (void)dealloc {
	self.topicID = nil;
	self.favNum = nil;
	self.tweetNum = nil;
	self.textString = nil;
	self.timeStamp = nil;
	self.hasAddedBefore = nil;
	[super dealloc];
}

+(NSMutableArray *)myFavTopicsFromDB {
	FMDatabase *db = [Database sharedManager].db;
	NSMutableArray *arrayAll = [NSMutableArray arrayWithCapacity:10];
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {						
		FMResultSet *s = [db executeQueryWithFormat:@"select ID, favNum, text, timeStamp, tweetNum, topicAddedBefore from myFavTopics \
						  where site=%@ and loginUserName=%@ order by topicAddedBefore desc", actSite.descriptionInfo.svrName, actSite.loginUserName];
		while ([s next]) {
			MyFavTopicInfo *info = [[MyFavTopicInfo alloc] init];
			info.topicID = [s stringForColumnIndex:0];
			info.favNum = [NSNumber numberWithInt:[s intForColumnIndex:1]];
			info.textString = [s stringForColumnIndex:2];
			info.timeStamp = [NSNumber numberWithInt:[s intForColumnIndex:3]];
			info.tweetNum = [NSNumber numberWithInt:[s intForColumnIndex:4]];
			info.hasAddedBefore = [NSNumber numberWithInt:[s  intForColumnIndex:5]];
			[arrayAll addObject:info];
			[info release];
		}
		[s close];
	}
	return arrayAll;
}

// 从数据库中获取数据
+ (NSMutableArray *)mySimpleFavTopicsFromDB {
	FMDatabase *db = [Database sharedManager].db;
	NSMutableArray *arrayAll = [NSMutableArray arrayWithCapacity:10];
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {						
		FMResultSet *s = [db executeQueryWithFormat:@"select ID, text, topicAddedBefore from myFavTopics \
						  where site=%@ and loginUserName=%@ order by topicAddedBefore desc", actSite.descriptionInfo.svrName, actSite.loginUserName];
		while ([s next]) {
			MyFavTopicInfo *info = [[MyFavTopicInfo alloc] init];
			info.topicID = [s stringForColumnIndex:0];
			info.textString = [s stringForColumnIndex:1];
			info.hasAddedBefore = [NSNumber numberWithInt:[s  intForColumnIndex:2]];
			[arrayAll addObject:info];
			[info release];
		}
		[s close];
	}
	return arrayAll;
}

+ (BOOL)updateTopicByID:(NSString *)tID WithStatus:(BOOL)status{
	BOOL bResult = NO;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {				
		FMDatabase *db = [Database sharedManager].db;
		int n = status ? 1 : 0;
		NSString *st = [NSString stringWithFormat:@"%d", n];
		bResult = [db executeUpdateWithFormat:@"update myFavTopics set topicAddedBefore=%@ where id=%@ and site=%@ and loginUserName=%@", 
				   st, tID, actSite.descriptionInfo.svrName, actSite.loginUserName];
	}
	return bResult;
}

// 更新话题是否写入过状态
+ (BOOL)updateTopicByText:(NSString *)topicText WithStatus:(BOOL)status {
	if (topicText == nil || [topicText length] == 0) {
		return YES;
	}
	BOOL bResult = NO;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {				
		FMDatabase *db = [Database sharedManager].db;
		FMResultSet *s = [db executeQueryWithFormat:@"select 1 from myFavTopics where text=%@ and site=%@ and loginUserName=%@", topicText, actSite.descriptionInfo.svrName, actSite.loginUserName];
		if ([s next]) {
			// 更新原有话题
			int n = status ? 1 : 0;
			NSString *st = [NSString stringWithFormat:@"%d", n];
			bResult = [db executeUpdateWithFormat:@"update myFavTopics set topicAddedBefore=%@ where text=%@ and site=%@ and loginUserName=%@", st, topicText, actSite.descriptionInfo.svrName, actSite.loginUserName];		
		}
		else {
			// 插入本地话题
			bResult = [db executeUpdateWithFormat:@"insert into myFavTopics(loginUserName, site, ID, favNum, text, timeStamp, tweetNum, topicAddedBefore) values(%@, %@, '0', 0, %@, '0', 0, 1)", actSite.loginUserName, actSite.descriptionInfo.svrName, topicText];
		}
		[s close];
	}
	return bResult;
	
}

// 更新话题信息
+ (BOOL)updateMyFavTopic:(NSString *)tID WithInfo:(MyFavTopicInfo *) topicInfo {
	BOOL bResult = NO;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {		
		FMDatabase *db = [Database sharedManager].db;
		FMResultSet *sQueryCnt = [db executeQueryWithFormat:@"select 1 from myFavTopics where ID=%@ and site=%@ and loginUserName=%@", tID, actSite.descriptionInfo.svrName, actSite.loginUserName];
		NSString *favNumString = [[NSString alloc] initWithFormat:@"%@", topicInfo.favNum];
		NSString *timeStampString = [[NSString alloc] initWithFormat:@"%@", topicInfo.timeStamp];
		NSString *tweetnumString = [[NSString alloc] initWithFormat:@"%@", topicInfo.tweetNum];
		NSString *bAdded = [[NSString alloc] initWithFormat:@"%@", topicInfo.hasAddedBefore];
		if ([sQueryCnt next]) {
			// 有数据则更新数据
			bResult = [db executeUpdateWithFormat:@"update myFavTopics set favNum=%@, text=%@, timeStamp=%@, tweetNum=%@ where ID=%@ and site=%@ and loginUserName=%@", 
					   favNumString, topicInfo.textString, timeStampString, tweetnumString, topicInfo.topicID, actSite.descriptionInfo.svrName, actSite.loginUserName];
		}
		else {
			// 没有数据则插入数据
			NSString *sql = @"insert into myFavTopics(loginUserName, site, ID, favNum, text, timeStamp, tweetNum, topicAddedBefore) "
							"values(?, ?, ?, ?, ?, ?, ?, ?)";
			NSArray *arrayArg = [NSArray arrayWithObjects:actSite.loginUserName,actSite.descriptionInfo.svrName, topicInfo.topicID,topicInfo.favNum , 
								 topicInfo.textString, topicInfo.timeStamp, topicInfo.tweetNum, topicInfo.hasAddedBefore, nil];
			bResult = [db executeUpdate:sql withArgumentsInArray:arrayArg];
	//		bResult = [db executeUpdateWithFormat:@"insert into myFavTopics values(%@, %@, %@, %@,%@,%@)", 
	//				   topicInfo.topicID,favNumString , topicInfo.textString, timeStampString, tweetnumString, bAdded];
		}
		[favNumString release];
		[tweetnumString release];
		[timeStampString release];
		[bAdded release];
		[sQueryCnt close];
	}
	return bResult;
}

+ (BOOL)updateMyFavTopicInfoToDB:(NSArray *)favTopicInfoArray {
	BOOL bResult = NO;
	for (NSDictionary *dic in favTopicInfoArray) {
		MyFavTopicInfo *infoItem = [[MyFavTopicInfo alloc] init];
		infoItem.topicID = [dic objectForKey:@"id"];
		infoItem.favNum = [dic objectForKey:@"favnum"];
		infoItem.textString = [dic objectForKey:@"text"];
		infoItem.timeStamp = [dic objectForKey:@"timestamp"];
		infoItem.tweetNum = [dic objectForKey:@"tweetnum"];
		NSNumber *numAdded = [[NSNumber alloc] initWithInt:0];
		infoItem.hasAddedBefore = numAdded;
		[numAdded release];
		bResult = [MyFavTopicInfo updateMyFavTopic:infoItem.topicID WithInfo:infoItem];
		[infoItem release];
		if (!bResult) { 
			//assert(NO);
			break;
		}
	}
	if (bResult) {
		[MyFavTopicInfo updateMyFavTopicsLastUpdatedTimeToCurrent];
	}
	return bResult;
}

// 数据更新状态
+ (int)IsUpdateMyFavTopicListFromServerNeeded {
	int nResult = 0;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {		
		NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
		NSTimeInterval now=[dat timeIntervalSince1970]*1;
		FMDatabase *db = [Database sharedManager].db;
		FMResultSet *s = [db executeQueryWithFormat:@"select myFavTopicLastUpdatedTime from config where site=%@ and name=%@", actSite.descriptionInfo.svrName, actSite.loginUserName];
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
+ (BOOL)updateMyFavTopicsLastUpdatedTimeToCurrent {
	BOOL bResult = NO;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {
		NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
		NSTimeInterval now=[dat timeIntervalSince1970]*1;
		NSString *timeString=[NSString stringWithFormat:@"%.0f", now];
		FMDatabase *db = [Database sharedManager].db;
		bResult = [db executeUpdateWithFormat:@"update config set myFavTopicLastUpdatedTime=%@ where site=%@ and name=%@", timeString, actSite.descriptionInfo.svrName, actSite.loginUserName];
	}
	return bResult;
}
// 重置上次更新时间为0，使下次插入话题时，强制去网络更新
+ (BOOL)resetMyFavTopicsLastUpdatedTime {
	BOOL bResult = NO;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {
		FMDatabase *db = [Database sharedManager].db;
		bResult = [db executeUpdateWithFormat:@"update config set myFavTopicLastUpdatedTime=0 where site=%@ and name=%@", actSite.descriptionInfo.svrName, actSite.loginUserName];
	}
	return bResult;
}

// 清除一条记录
+ (BOOL)removeTopicFromDB: (NSString *)topicName {
	BOOL bResult = NO;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {		
		FMDatabase *db = [Database sharedManager].db;
		bResult = [db executeUpdateWithFormat:@"delete from myFavTopics where text=%@ and site=%@ and loginUserName=%@", topicName, actSite.descriptionInfo.svrName, actSite.loginUserName];
	}
	return bResult;
}

// 清除数据
+ (BOOL)removeTopicsFromDB {
	BOOL bResult = NO;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {
		FMDatabase *db = [Database sharedManager].db;
		bResult = [db executeUpdateWithFormat:@"delete from myFavTopics where site=%@ and loginUserName=%@", actSite.descriptionInfo.svrName, actSite.loginUserName];
		if (bResult) {
			bResult = [db executeUpdateWithFormat:@"update config set myFavTopicLastUpdatedTime='0' where  site=%@ and name=%@", actSite.descriptionInfo.svrName, actSite.loginUserName];
		}
	}
	return bResult;
}
@end
