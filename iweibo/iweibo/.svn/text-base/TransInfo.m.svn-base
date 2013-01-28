//
//  TransInfo.m
//  iweibo
//
//  Created by wangying on 1/10/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "TransInfo.h"
#import "Database.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@implementation TransInfo

@synthesize  transNick,transIsvip,transId,transWeiId,transOrigtext,transImage,transVideo;
@synthesize  sourceImageData,sourceVideoData,transName,transCount,transCommitcount,translocalAuth;
@synthesize  transFrom,transTime,transVideoRealUrl;
@synthesize bUserLocationEnabled, userLatitude,userLongitude;

+ (NSData *)mySourceImageDataWithUrl:(NSString *)url {
	NSData *data = nil;
	FMDatabase *db = [Database sharedManager].db;
	data = [db dataForQuery:@"select imageDataTrans from transWeibo where imageUrlTrans=?", url];
	return data;
}

+ (NSData *)mySourceVideoDataWithUrl:(NSString *)url {
	NSData *data = nil;
	FMDatabase *db = [Database sharedManager].db;
	data = [db dataForQuery:@"select videoDataTrans from transWeibo where videoUrlTrans=?", url];
	return data;
}

+ (NSData *)myMsgSourceImageDataWithUrl:(NSString *)url {
	NSData *data = nil;
	FMDatabase *db = [Database sharedManager].db;
	data = [db dataForQuery:@"select imageDataTrans from messageTransWeibo where imageUrlTrans=?", url];
	return data;
}

+ (NSData *)myMsgSourceVideoDataWithUrl:(NSString *)url {
	NSData *data = nil;
	FMDatabase *db = [Database sharedManager].db;
	data = [db dataForQuery:@"select videoDataTrans from messageTransWeibo where videoUrlTrans=?", url];
	return data;
}

+ (void)updateSourceImageData:(NSData *)data withUrl:(NSString *)idString{
	FMDatabase *database = [Database sharedManager].db; 
	NSString *sql = @"update transWeibo set imageDataTrans=? where idTrans=?";
	NSArray *arrayArg = [NSArray arrayWithObjects:data, idString, nil];
//	BOOL bResult = [database executeUpdate:sql withArgumentsInArray:arrayArg];
	[database executeUpdate:sql withArgumentsInArray:arrayArg];
}

+ (void)updateSourceVideoData:(NSData *)data withUrl:(NSString *)idString{
	FMDatabase *database = [Database sharedManager].db; 
	NSString *sql = @"update transWeibo set videoDataTrans=? where idTrans=?";
	NSArray *arrayArg = [NSArray arrayWithObjects:data, idString, nil];
//	BOOL bResult = [database executeUpdate:sql withArgumentsInArray:arrayArg];
	[database executeUpdate:sql withArgumentsInArray:arrayArg];
}

+ (void)updateMsgSourceImageData:(NSData *)data withUrl:(NSString *)idString{
	FMDatabase *database = [Database sharedManager].db; 
	NSString *sql = @"update messageTransWeibo set imageDataTrans=? where idTrans=?";
	NSArray *arrayArg = [NSArray arrayWithObjects:data, idString, nil];
	[database executeUpdate:sql withArgumentsInArray:arrayArg];
	//[database executeUpdate:sql withArgumentsInArray:arrayArg];
}

+ (void)updateMsgSourceVideoData:(NSData *)data withUrl:(NSString *)idString{
	FMDatabase *database = [Database sharedManager].db; 
	NSString *sql = @"update messageTransWeibo set videoDataTrans=? where idTrans=?";
	NSArray *arrayArg = [NSArray arrayWithObjects:data, idString, nil];
	//	BOOL bResult = [database executeUpdate:sql withArgumentsInArray:arrayArg];
	[database executeUpdate:sql withArgumentsInArray:arrayArg];
}

-(void) dealloc{
	
	[transCommitcount release];
	[transOrigtext release];
	[transImage release];
	[transIsvip release];
	[translocalAuth release];
	[transCount release];
	[transNick release];
	[transId  release];
	[transFrom release];
	[transTime release];
	[transVideo release];
	[sourceVideoData release];
	[sourceImageData release];
	[super dealloc];
}

@end
