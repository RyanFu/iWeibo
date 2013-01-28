//
//  Info.m
//  iweibo
//
//  Created by ZhaoLilong on 12/29/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import "Info.h"
#import "FMDatabase.h"
#import "Database.h"
#import "FMDatabaseAdditions.h"

@implementation Info
@synthesize city_code,count,country_code,emotionType,emotionUrl,from,fromUrl,geo,head,uid,image,isrealname,isvip,localAuth,location,mscount,music,name,nick,openid,origtext,provinceCode,selfType,status,text,timeStamp,type,video,visiblecode,source;
@synthesize headImageData,videoImageData,imageImageData;
@synthesize videoPicUrl,videoRealUrl;
@synthesize bUserLocationEnabled, userLatitude,userLongitude;
@synthesize userName,site;

-(void) dealloc{
	[city_code release];
	[country_code release];
	[emotionType release];
	[emotionUrl release];
	[from release];
	[fromUrl release];
	[geo release];
	[head release];
	[uid release];
	[image release];
	[localAuth release];
	[location release];
	[music release];
	[name release];
	[nick release];
	[openid release];
	[origtext release];
	[provinceCode release];
	[text release];
	[timeStamp release];
	[count release];
	[mscount release];
	[isvip release];
	[type release];
	[video release];
	[videoPicUrl release];
	[videoRealUrl release];
	[userName release];
	[site release];
	[source release];
	[headImageData release];
	[videoImageData release];
	[imageImageData release];
	[super dealloc];
}


+ (NSData *)myImageDataWithUrl:(NSString *)url {
	NSData *data = nil;
	FMDatabase *db = [Database sharedManager].db;
	data = [db dataForQuery:@"select imageImageData from weibo where imageUrlString=?", url];
	return data;
}

+ (NSData *)myVideoDataWithUrl:(NSString *)url {
	NSData *data = nil;
	FMDatabase *db = [Database sharedManager].db;
	data = [db dataForQuery:@"select videoImageData from weibo where videoUrlString=?",url];
	return data;
}

+ (NSData *)myHeadImageDataWithUrl:(NSString *)url {
	NSData *data = nil;
	FMDatabase *db = [Database sharedManager].db;
	data = [db dataForQuery:@"select headImageData from weibo where headUrlString=?", url];
	return data;	 
}

+ (NSData *)myMsgImageDataWithUrl:(NSString *)url {
	NSData *data = nil;
	FMDatabase *db = [Database sharedManager].db;
	data = [db dataForQuery:@"select imageImageData from messageWeibo where imageUrlString=?", url];
	return data;
}

+ (NSData *)myMsgVideoDataWithUrl:(NSString *)url {
	NSData *data = nil;
	FMDatabase *db = [Database sharedManager].db;
	data = [db dataForQuery:@"select videoImageData from messageWeibo where videoUrlString=?",url];
	return data;
}

+ (NSData *)myMsgHeadImageDataWithUrl:(NSString *)url {
	NSData *data = nil;
	FMDatabase *db = [Database sharedManager].db;
	data = [db dataForQuery:@"select headImageData from messageWeibo where headUrlString=?", url];
	return data;	 
}

+ (void) updateVideoData:(NSData *)data withUrl:(NSString *)idString{
	FMDatabase *database = [Database sharedManager].db;
	NSString *sql = @"update weibo set videoImageData=? where id=?";
	NSArray *arrayArg = [NSArray arrayWithObjects:data, idString, nil];
//	BOOL bResult = [database executeUpdate:sql withArgumentsInArray:arrayArg];
//	[database executeUpdateWithFormat:@"update weibo set videoImageData=%@ where id=%@",data,idString];
	[database executeUpdate:sql withArgumentsInArray:arrayArg];
}

+ (void) updateImageData:(NSData *)data withUrl:(NSString *)idString{
	FMDatabase *database = [Database sharedManager].db;
	NSString *sql = @"update weibo set imageImageData=? where id=?";
	NSArray *arrayArg = [NSArray arrayWithObjects:data, idString, nil];
//	BOOL bResult = [database executeUpdate:sql withArgumentsInArray:arrayArg];
//	[database executeUpdateWithFormat:@"update weibo set imageImageData=%@ where id=%@",data,idString];
	[database executeUpdate:sql withArgumentsInArray:arrayArg];
}

+ (void) updateHeadData:(NSData *)data withUrl:(NSString *)idString{
	FMDatabase *database = [Database sharedManager].db;	
	NSString *sql = @"update weibo set headImageData=? where id=?";
	NSArray *arrayArg = [NSArray arrayWithObjects:data, idString, nil];
//	BOOL bResult = [database executeUpdate:sql withArgumentsInArray:arrayArg];
	[database executeUpdate:sql withArgumentsInArray:arrayArg];
}

+ (void) updateMsgVideoData:(NSData *)data withUrl:(NSString *)idString{
	FMDatabase *database = [Database sharedManager].db;
	NSString *sql = @"update messageWeibo set videoImageData=? where id=?";
	NSArray *arrayArg = [NSArray arrayWithObjects:data, idString, nil];
	[database executeUpdate:sql withArgumentsInArray:arrayArg];
	//	[database executeUpdateWithFormat:@"update weibo set videoImageData=%@ where id=%@",data,idString];
}

+ (void) updateMsgImageData:(NSData *)data withUrl:(NSString *)idString{
	FMDatabase *database = [Database sharedManager].db;
	NSString *sql = @"update messageWeibo set imageImageData=? where id=?";
	NSArray *arrayArg = [NSArray arrayWithObjects:data, idString, nil];
	[database executeUpdate:sql withArgumentsInArray:arrayArg];
	//	[database executeUpdateWithFormat:@"update weibo set imageImageData=%@ where id=%@",data,idString];
}

+ (void) updateMsgHeadData:(NSData *)data withUrl:(NSString *)idString{
	FMDatabase *database = [Database sharedManager].db;	
	NSString *sql = @"update messageWeibo set headImageData=? where id=?";
	NSArray *arrayArg = [NSArray arrayWithObjects:data, idString, nil];
	[database executeUpdate:sql withArgumentsInArray:arrayArg];
}

+ (NSString *)intervalSinceNow: (double) theDate 
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-theDate;
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
		if ([timeString compare:@"0.1"]==NSOrderedAscending) {
			timeString = [NSString stringWithFormat:@"刚刚"];
		}
		else {
			timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
		}
    }
	if (cha/3600>1&&cha/86400<1) {
		timeString = [NSString stringWithFormat:@"%f", cha/3600];
		timeString = [timeString substringToIndex:timeString.length-7];
		timeString=[NSString stringWithFormat:@"%@小时前", timeString];
	}
	if (cha/86400>1&&cha/172800<1) {
        timeString= @"昨天";
	}
	if (cha/172800>1&&cha/259200<1) {
		timeString = @"前天";
	}
	if (cha/259200>1) {
		NSDate *currentStamp = [NSDate dateWithTimeIntervalSinceNow:-cha];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"M月d日"];
		timeString = [dateFormatter stringFromDate:currentStamp];
		[dateFormatter release];		
	}
	
    return timeString;
}

+ (NSString *)showTime:(double)theDate{
	NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-theDate;
	if (cha/86400<1) {
		NSDate *currentStamp = [NSDate dateWithTimeIntervalSinceNow:-cha];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"hh:mm"];
		timeString = [dateFormatter stringFromDate:currentStamp];
		[dateFormatter release];	
	}else{
		NSDate *currentStamp = [NSDate dateWithTimeIntervalSinceNow:-cha];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"M月d日"];
		timeString = [dateFormatter stringFromDate:currentStamp];
		[dateFormatter release];		
	}
    return timeString;
}

@end
