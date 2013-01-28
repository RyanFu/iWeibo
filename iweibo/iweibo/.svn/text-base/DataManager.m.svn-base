//
//  DataManager.m
//  iweibo
//
//  Created by wangying on 1/14/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "DataManager.h"
#import "MusicInfo.h"
#import "videoUrl.h"
#import "TransInfo.h"
#import "NamenickInfo.h"
#import "Info.h"
#import "HotBroadcastInfo.h"
#import "Canstants.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "Database.h"
#import "Draft.h"
#import "IWBSvrSettingsManager.h"
#import "CustomizedSiteInfo.h"

@implementation DataManager
@synthesize videoUrlList,transSource,imageSaveArray,musicList;
@synthesize arrayAll,type;

- (id)init{
	self = [super init];
	if (self!=nil) {
		transSource = [[NSMutableArray alloc] initWithCapacity:5];
		videoUrlList = [[NSMutableArray alloc] initWithCapacity:5];
		musicList = [[NSMutableArray alloc]initWithCapacity:3];
		imageSaveArray = [[NSMutableArray alloc] initWithCapacity:5];
		arrayAll  = [[NSMutableArray alloc] initWithCapacity:10];
	}
	return self;
	
}

- (void)deleteSuperfluousData
{
    
    FMDatabase *db = [Database sharedManager].db;
 //   [db executeUpdate:@"DELETE FROM weibo where id is NULL"]; //删除空数据 
    CLog(@"是否超过500条数据？？");
    FMResultSet *rs= [db executeQuery:@"SELECT count(*) FROM weibo"];
    [rs next];
    int totalNum = [rs intForColumnIndex:0];
    CLog(@"总数据num====>%d",totalNum);
    if (totalNum>LIMITNUM) {
        int deleteNum = totalNum-LIMITNUM;
        NSString *delNum = [NSString stringWithFormat:@"%d",deleteNum];
        FMResultSet *superfluousRs = [db executeQuery:@"select id from weibo order by timeStamp ASC limit 0,?",delNum];        
//        FMResultSet *superfluousRs = [db executeQuery:@"select id from weibo order by timeStamp ASC limit 0,?" withArgumentsInArray:[NSArray arrayWithObject:delNum]];
        CLog(@"要删除%d",deleteNum);
       NSMutableString *idSetString = [NSMutableString stringWithString:@"("]; 
        for (int i=0; i<deleteNum; i++) {
            [superfluousRs next];
            CLog(@"获取id====>%@",[superfluousRs stringForColumnIndex:0]);      
            if(i==0)
            {
                [idSetString appendString:@"'"];
            }else
            {
                [idSetString appendString:@",'"];
            }
            [idSetString appendString:[superfluousRs stringForColumn:@"id"]];
            [idSetString appendString:@"'"];
        }
        [idSetString appendString:@")"];
       CLog(@"获取集合idSet====>%@",idSetString);
        [db executeUpdateWithFormat:[NSString stringWithFormat:@"DELETE FROM transWeibo where IdTrans in %@",idSetString]];
        
        [db executeUpdateWithFormat:[NSString stringWithFormat:@"DELETE FROM videoData where id in %@",idSetString]];
        
        [db executeUpdateWithFormat:[NSString stringWithFormat:@"DELETE FROM weibo where id in %@", idSetString]];
        CLog(@"删除成功！");
    }
   
}

#pragma mark -
#pragma mark sava weibo Info To DB

- (void)insertDataToDatabase:(Info *)dataInfo {
	FMDatabase *db = [Database sharedManager].db;
	if (db && dataInfo) {
		NSString *picurlVideoString = @"";
		NSString *realurlVideoString = @"";
		TransInfo *sourceBackInfo;

		if (dataInfo.image ==nil) {
			dataInfo.image = @"";
		}
		if ([dataInfo.video count]!=0) {
			if ([dataInfo.video objectForKey:VIDEOPICURL]!=nil) {
				picurlVideoString = [dataInfo.video objectForKey:VIDEOPICURL];
			}
			if ([dataInfo.video objectForKey:VIDEOREALURL]!=nil) {
				realurlVideoString = [dataInfo.video objectForKey:VIDEOREALURL];
			}
		}

		NSNumber *latitude = [NSNumber numberWithFloat:dataInfo.userLatitude];
		NSNumber *userLongitude = [NSNumber numberWithFloat:dataInfo.userLongitude];
	    sourceBackInfo = [self manageSourceInfo:dataInfo.source weiboId:dataInfo.uid];
		
		NSString *sqlWeibo = @"insert into weibo(id,name,nick,isvip,localAuth,origintext,sourceFrom,timeStamp,emotionType,count,mycount,headUrlString,imageUrlString,videoUrlString,videoRealUrl,type,latitude,longitude) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		NSArray *arrayData = [[NSArray alloc]initWithObjects:
							  dataInfo.uid,
							  dataInfo.name,
							  dataInfo.nick,
							  dataInfo.isvip,
							  dataInfo.localAuth,
							  dataInfo.origtext,
							  dataInfo.from,
							  dataInfo.timeStamp,
							  dataInfo.emotionType,
							  dataInfo.count,
							  dataInfo.mscount,
							  dataInfo.head,
							  dataInfo.image,
							  picurlVideoString,
							  realurlVideoString,
							  dataInfo.type,
							  latitude,
							  userLongitude,nil] ;
		[db executeUpdate:sqlWeibo withArgumentsInArray:arrayData];
		[arrayData release];
		
		if ([dataInfo.source count]!=0) {
			NSArray *trArray = [[NSArray alloc]initWithObjects:
								dataInfo.uid,
								sourceBackInfo.transNick,
								sourceBackInfo.transName,
								sourceBackInfo.transIsvip,
								sourceBackInfo.translocalAuth,
								sourceBackInfo.transOrigtext,
								sourceBackInfo.transImage,
								sourceBackInfo.transVideo,
								sourceBackInfo.transVideoRealUrl,
								sourceBackInfo.transCount,
								sourceBackInfo.transCommitcount,
								sourceBackInfo.transTime,
								sourceBackInfo.transFrom,nil];
			[db executeUpdate:@"insert into transWeibo(IdTrans,nickTrans,nameTrans,isvipTrans,localAuthTrans,origTrans,imageUrlTrans,videoUrlTrans,videoRealurlTrans,countTrans,commitCountTrans,timestampTrans,fromTrans) values(?,?,?,?,?,?,?,?,?,?,?,?,?)"withArgumentsInArray:trArray];
			[trArray release];
			[self updateSourceWeibo:dataInfo.uid];
		}
		
/*	modified by wangying 2012-02-02 此处为音频和视频信息处理
 		musicBackInfo = [self manageMusicInfo:dataInfo.music];
 		videoBackInfo = [self manageVideoInfo:dataInfo.video];
		if ([dataInfo.music count]!=0) {
			NSString *sqlVideo = @"insert into videoData (id,musicAuthor,musicUrl,musicTitle)values(?,?,?,?)";
			NSArray *arrayVideo = [[NSArray alloc] initWithObjects:dataInfo.uid,musicBackInfo.author,musicBackInfo.musicurl,musicBackInfo.title,nil];
			[db executeUpdate:sqlVideo withArgumentsInArray:arrayVideo];
			[arrayVideo release];
		}
		
		if ([dataInfo.video count]!=0) {
			NSString *sqlVideo = @"update videoData set videoPicurl=?,videoPlayer=?,videoRealurl=?,videoShorturl=?,videoTitle=? where id=? ";
			NSArray *arrayVideo = [[NSArray alloc] initWithObjects:videoBackInfo.picurl,videoBackInfo.player,videoBackInfo.realurl,videoBackInfo.shorturl,videoBackInfo.title,dataInfo.uid,nil];
			[db executeUpdate:sqlVideo withArgumentsInArray:arrayVideo];
			[arrayVideo release];
		}
 */
//	[self requestImage:dataInfo];
	}
}

//更新timeline中source源信息
- (void)updateSourceWeibo:(NSString *)uid{
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	FMDatabase *db = [Database sharedManager].db;
	if (actSite && db) {
		NSString *sql = @"update transWeibo set userName = ?, site = ? where IdTrans = ?";
		NSArray *arrayArg = [NSArray arrayWithObjects:actSite.loginUserName,actSite.descriptionInfo.svrName,uid,nil];
		[db executeUpdate:sql withArgumentsInArray:arrayArg];
	}
}			 

- (void)insertMessageToDatabase:(Info *)dataInfo{
	FMDatabase *db = [Database sharedManager].db;
	if (db && dataInfo) {
		NSString *picurlVideoString = @"";
		NSString *realurlVideoString = @"";
		TransInfo *sourceBackInfo;

		if (dataInfo.image ==nil) {
			dataInfo.image = @"";
		}
		if ([dataInfo.video count]!=0) {
			if ([dataInfo.video objectForKey:VIDEOPICURL]!=nil) {
				picurlVideoString = [dataInfo.video objectForKey:VIDEOPICURL];
			}
			if ([dataInfo.video objectForKey:VIDEOREALURL]!=nil) {
				realurlVideoString = [dataInfo.video objectForKey:VIDEOREALURL];
			}
		}
		
		NSNumber *latitude = [NSNumber numberWithFloat:dataInfo.userLatitude];
		NSNumber *userLongitude = [NSNumber numberWithFloat:dataInfo.userLongitude];

	    sourceBackInfo = [self manageSourceInfo:dataInfo.source weiboId:dataInfo.uid];
		
		NSString *sqlWeibo = @"insert into messageWeibo(id,name,nick,isvip,localAuth,origintext,sourceFrom,timeStamp,emotionType,count,mycount,headUrlString,imageUrlString,videoUrlString,videoRealUrl,type,latitude,longitude) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		NSArray *arrayData = [[NSArray alloc]initWithObjects:
							  dataInfo.uid,
							  dataInfo.name,
							  dataInfo.nick,
							  dataInfo.isvip,
							  dataInfo.localAuth,
							  dataInfo.origtext,
							  dataInfo.from,
							  dataInfo.timeStamp,
							  dataInfo.emotionType,
							  dataInfo.count,
							  dataInfo.mscount,
							  dataInfo.head,
							  dataInfo.image,
							  picurlVideoString,
							  realurlVideoString,
							  dataInfo.type,
							  latitude,
							  userLongitude,nil] ;
		[db executeUpdate:sqlWeibo withArgumentsInArray:arrayData];
		[arrayData release];
		
		if ([dataInfo.source count]!=0) {
			NSArray *trArray = [[NSArray alloc]initWithObjects:
								dataInfo.uid,
								sourceBackInfo.transNick,
                                sourceBackInfo.transName,
								sourceBackInfo.transIsvip,
                                sourceBackInfo.translocalAuth,
								sourceBackInfo.transOrigtext,
								sourceBackInfo.transImage,
								sourceBackInfo.transVideo,
								sourceBackInfo.transVideoRealUrl,
								sourceBackInfo.transCount,
								sourceBackInfo.transCommitcount,
								sourceBackInfo.transTime,
								sourceBackInfo.transFrom,nil];
			[db executeUpdate:@"insert into messageTransWeibo(IdTrans,nickTrans,nameTrans,isvipTrans,localAuthTrans,origTrans,imageUrlTrans,videoUrlTrans,videoRealurlTrans,countTrans,commitCountTrans,timestampTrans,fromTrans) values(?,?,?,?,?,?,?,?,?,?,?,?,?)"withArgumentsInArray:trArray];
			[trArray release]; 
			[self updateSourceMessageWeibo:dataInfo.uid];
		}

/*	modified by wangying 2012-02-02 此处为音频和视频信息处理
 
		musicBackInfo = [self manageMusicInfo:dataInfo.music];
		videoBackInfo = [self manageVideoInfo:dataInfo.video];
		if ([dataInfo.music count]!=0) {
			NSString *sqlVideo = @"insert into messageVideoData (id,musicAuthor,musicUrl,musicTitle)values(?,?,?,?)";
			NSArray *arrayVideo = [[NSArray alloc] initWithObjects:dataInfo.uid,musicBackInfo.author,musicBackInfo.musicurl,musicBackInfo.title,nil];
		[db executeUpdate:sqlVideo withArgumentsInArray:arrayVideo];
			[arrayVideo release];
		}
		
		if ([dataInfo.video count]!=0) {
			NSString *sqlVideo = @"update messageVideoData set videoPicurl=?,videoPlayer=?,videoRealurl=?,videoShorturl=?,videoTitle=? where id=? ";
			NSArray *arrayVideo = [[NSArray alloc] initWithObjects:videoBackInfo.picurl,videoBackInfo.player,videoBackInfo.realurl,videoBackInfo.shorturl,videoBackInfo.title,dataInfo.uid,nil];
		[db executeUpdate:sqlVideo withArgumentsInArray:arrayVideo];
			[arrayVideo release];
		}
 */
	}
}

//更新提及我的中source源信息
- (void)updateSourceMessageWeibo:(NSString *)uid{
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	FMDatabase *db = [Database sharedManager].db;
	if (db  && actSite) {
		NSString *sql = @"update messageTransWeibo set userName = ?, site = ? where IdTrans = ?";
		NSArray *arrayArg = [NSArray arrayWithObjects:actSite.loginUserName,actSite.descriptionInfo.svrName,uid,nil];
		[db executeUpdate:sql withArgumentsInArray:arrayArg];
	}
}

#pragma mark -
#pragma mark update Weibo
//更新微博中用户名和站点信息
- (void)updateWeiboWithSite:(NSString *)userName site:(NSString *)site withWhere:(NSString *)id{
	FMDatabase *db = [Database sharedManager].db;
	if (db && userName) {
		NSString *sql = @"update weibo set userName = ?, site = ? where id = ?";
		NSArray *arrayArg = [NSArray arrayWithObjects:userName,site,id,nil];
		[db executeUpdate:sql withArgumentsInArray:arrayArg];
	}
}

//更新消息页中用户名和站点信息
- (void)updateMessageWithSite:(NSString *)userName site:(NSString *)site withWhere:(NSString *)id{
	FMDatabase *db = [Database sharedManager].db;
	if (db && userName) {
		NSString *sql = @"update messageWeibo set userName = ?, site = ? where id = ?";
		NSArray *arrayArg = [NSArray arrayWithObjects:userName,site,id,nil];
		[db executeUpdate:sql withArgumentsInArray:arrayArg];
	}
}

#pragma mark -
- (void)requestImage:(Info *)requestInfo{
	NSString *headUrlString = @"";
	NSString *videoUrlString = @"";
	NSString *imageUrlString = @"";
	NSString *sourceImageUrlString = @"";
	NSString *sourceVideoUrlString = @"";
	NSString *idString = requestInfo.uid;

	if (![requestInfo.head isEqual:[NSNull null]]) {
		headUrlString = [NSString stringWithFormat:@"%@/40",requestInfo.head];
		[self loadImage:headUrlString:idString:multiMediaTypeHead];
	}
	if (requestInfo.image != nil) {
		imageUrlString = [NSString stringWithFormat:@"%@/60",requestInfo.image];
		[self loadImage:imageUrlString:idString:multiMediaTypeImage];
	}
	if (![requestInfo.video isEqual:[NSNull null]]) {
		videoUrlString = [NSString stringWithFormat:@"%@/60",[requestInfo.video objectForKey:VIDEOPICURL]];
		[self loadImage:videoUrlString:idString:multiMediaTypeVideo];
	}
	if (![requestInfo.source isEqual:[NSNull null]]) {
		if (![[requestInfo.source objectForKey:HOMEIMAGE]isEqual:[NSNull null]]) {
			NSArray *array =[requestInfo.source objectForKey:HOMEIMAGE];
			if([array count]!=0)
				sourceImageUrlString = [NSString stringWithFormat:@"%@/60",[array objectAtIndex:0]];
			[self loadImage:sourceImageUrlString :idString :multiMediaTypeSourceImage];
		}
		if (![[requestInfo.source objectForKey:HOMEVIDEO] isEqual:[NSNull null]]) {
			if (![[requestInfo.source objectForKey:HOMEVIDEO]objectForKey:VIDEOPICURL]) {
				sourceVideoUrlString = [NSString stringWithFormat:@"%@/60",[[requestInfo.source objectForKey:HOMEVIDEO]objectForKey:VIDEOPICURL]];
				[self loadImage:sourceVideoUrlString :idString :multiMediaTypeSourceVideo];
			}
		}
	}
}
			 
- (void)loadImage:(NSString *)urlString:(NSString *)id:(MultiMediaType)typeM{
	AsyncImageView *aImageView = [[AsyncImageView alloc] init];
	[aImageView loadImageFromURL:[NSURL URLWithString:urlString] withType:typeM userId:id];
	[aImageView release];
}

#pragma mark -
#pragma mark manageSourceInfo

- (MusicInfo *)manageMusicInfo:(NSDictionary *)info{
	MusicInfo *musicIn = [[[MusicInfo alloc] init] autorelease];
	if([info count]==0){
		musicIn.author = @"";
		musicIn.title = @"";
		musicIn.musicurl = @"";
	}
	else{
		NSDictionary *music = [[NSDictionary alloc] initWithDictionary:info];
		if ([music objectForKey:MUSICAUTHOR]!=nil) {
			musicIn.author = [music objectForKey:MUSICAUTHOR];
		}
		else {
			musicIn.author = @"";
		}
		if ([music objectForKey:MUSICURL]!=nil) {
			musicIn.musicurl = [music objectForKey:MUSICURL];
		}
		else {
			musicIn.musicurl = @"";
		}
		
		if ([music objectForKey:VIDEOTITLE]!=nil) {
			musicIn.title = [music objectForKey:VIDEOTITLE];
		}
		else {
			musicIn.title = @"";
		}
		[musicList addObject:musicIn];
		[music release];
	}
	return musicIn;
}

- (videoUrl *)manageVideoInfo:(NSDictionary *)videoInfo{
	videoUrl *videoIn = [[[videoUrl alloc] init] autorelease];
	if ([videoInfo count]!=0) {
		NSDictionary *video = [[NSDictionary alloc] initWithDictionary:videoInfo];
		if ([video objectForKey:VIDEOPICURL]!=nil) {
			videoIn.picurl = [video objectForKey:VIDEOPICURL];
		}
		else {
			videoIn.picurl = @"";
		}
		if ([video objectForKey:VIDEOPLAYER]!=nil) {
			videoIn.player = [video objectForKey:VIDEOPLAYER];
		}
		else {
			videoIn.player = @"";
		}
		if ([video objectForKey:VIDEOREALURL]!=nil) {
			videoIn.realurl = [video objectForKey:VIDEOREALURL];
		}
		else {
			videoIn.realurl = @"";
		}
		if ([video objectForKey:VIDEOSHORTURL]!=nil) {
			videoIn.shorturl = [video objectForKey:VIDEOSHORTURL];
		}
		else {
			videoIn.shorturl = @"";
		}if ([video objectForKey:VIDEOTITLE]!=nil) {
			videoIn.title = [video objectForKey:VIDEOTITLE];
		}
		else {
			videoIn.title = @"";
		}
		[videoUrlList addObject:videoIn];
		[video release];
	}
	return videoIn;
}

- (TransInfo *)manageSourceInfo:(NSDictionary *)sourceInfo weiboId:(NSString *)id{
	TransInfo *infoSource = [[[TransInfo alloc] init] autorelease];
	if ([sourceInfo count]!=0) {
		NSDictionary *source = [[NSDictionary alloc] initWithDictionary:sourceInfo];
		infoSource.transId = id;
//2012-03-06 addedby wangying  transWeiId存储的是转发的微博id
		infoSource.transWeiId = [source objectForKey:@"id"];
		infoSource.transNick = [source objectForKey:HOMENICK];
		infoSource.transName = [source objectForKey:HOMENAME];
		infoSource.transIsvip = [NSString stringWithFormat:@"%@",[source objectForKey:HOMEISVIP]];
		infoSource.translocalAuth = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"is_auth"]];
		infoSource.transOrigtext = [source objectForKey:HOMEORITEXT];	
		infoSource.transFrom = [source objectForKey:HOMEFROM];
		infoSource.transTime = [NSString stringWithFormat:@"%@",[source objectForKey:HOMETIME]];
		infoSource.transCount = [NSString stringWithFormat:@"%@",[source valueForKey:HOMECOUNT]];
		infoSource.transCommitcount = [NSString stringWithFormat:@"%@",[source valueForKey:HOMEMCOUNT]];
		//source源里目前服务器没有返回经，纬度
		//infoSource.userLongitude = [source objectForKey:];
		//infoSource.userLatitude = [source objectForKey:];
		if (![[source objectForKey:HOMEIMAGE]isEqual:[NSNull null]]) 
			infoSource.transImage = [[source objectForKey:HOMEIMAGE]objectAtIndex:0];
		else {
			infoSource.transImage = @"";
		}
		if (![[source objectForKey:HOMEVIDEO]isEqual:[NSNull null]]) {
			if ([[source objectForKey:HOMEVIDEO]objectForKey:VIDEOPICURL]!=nil) {
				infoSource.transVideo = [[source objectForKey:HOMEVIDEO]objectForKey:VIDEOPICURL];
			}
			else {
				infoSource.transVideo = @"";
			}

			if ([[source objectForKey:HOMEVIDEO]objectForKey:VIDEOREALURL]!=nil) {
				infoSource.transVideoRealUrl = [[source objectForKey:HOMEVIDEO] objectForKey:VIDEOREALURL];
			}
			else {
				infoSource.transVideoRealUrl = @"";
			}

		}
		else {
			infoSource.transVideo = @"";
			infoSource.transVideoRealUrl = @"";
		}

		[transSource addObject:infoSource];
		[source release];
	}
	return infoSource;
}

#pragma mark -
#pragma mark read Weibo Info FromDB

- (NSMutableArray *)getDataFromWeibo:(NSString *)time type:(NSString *)typeType userName:(NSString *)nameInfo site:(NSString *)siteInfo{
	FMDatabase *db = [Database sharedManager].db;
	FMResultSet *s = nil;
	[arrayAll removeAllObjects];
	if ([typeType isEqualToString:@"homelineType"]) {
		s = [db executeQueryWithFormat:@"select * from weibo where timeStamp<=%@ and userName = %@ and site = %@ order by timeStamp desc limit 30",time,nameInfo,siteInfo];
	}
	if ([typeType isEqualToString:@"messageType"]){
		s = [db executeQueryWithFormat:@"select * from messageWeibo where timeStamp<=%@ and userName = %@ and site = %@ order by timeStamp desc limit 30",time,nameInfo,siteInfo];
	}
	while ([s next]) {
		Info *weibo = [[Info alloc] init];
		weibo.uid = [s stringForColumn:@"id"];
		weibo.name = [s stringForColumn:@"name"];
		weibo.nick = [s stringForColumn:@"nick"];
		weibo.isvip = [s stringForColumn:@"isvip"];
		weibo.localAuth = [s stringForColumn:@"localAuth"];
		weibo.origtext = [s stringForColumn:@"origintext"];
		weibo.from = [s stringForColumn:@"sourceFrom"];
		weibo.timeStamp = [s stringForColumn:@"timeStamp"];
		weibo.emotionType = [s stringForColumn:@"emotionType"];
		weibo.count = [s stringForColumn:@"count"];
		weibo.mscount = [s stringForColumn:@"mycount"];
		weibo.head = [s stringForColumn:@"headUrlString"];
		weibo.type = [s stringForColumn:@"type"];
		weibo.image = [s stringForColumn:@"imageUrlString"];
		weibo.userLatitude = [s doubleForColumn:@"latitude"];
		weibo.userLongitude = [s doubleForColumn:@"longitude"];
		weibo.userName = [s stringForColumn:@"userName"];
		weibo.site = [s stringForColumn:@"site"];
		if ([weibo.image length] == 0) {
			weibo.image = nil;
		}

		NSString *a = [s stringForColumn:@"videoUrlString"];
		if ([a length]!=0) {
			NSDictionary *picurl = [NSDictionary dictionaryWithObject:a forKey:VIDEOPICURL];
			weibo.video = picurl;
		}
		
		[arrayAll addObject:weibo];
		[weibo release];
	}
	[s close];
	return arrayAll;
}

- (NSMutableArray *)getDataFromTransWeibo:(NSString *)idString type:(NSString *)str{
	FMDatabase *db = [Database sharedManager].db;	
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	NSMutableArray *sourceWeiboInfo = [NSMutableArray arrayWithCapacity:8];
	FMResultSet *so = nil;
	if ([str isEqualToString:@"homelineType"] && actSite && actSite.bUserLogin) {
		 so = [db executeQueryWithFormat:@"select * from transWeibo where IdTrans = %@ and userName = %@ and site = %@",idString,actSite.loginUserName,actSite.descriptionInfo.svrName];
	}
	if ([str isEqualToString:@"messageType"] && actSite && actSite.bUserLogin) {
		 so = [db executeQueryWithFormat:@"select * from messageTransWeibo where IdTrans = %@ and userName = %@ and site = %@",idString,actSite.loginUserName,actSite.descriptionInfo.svrName];
	}

	while ([so next]) {
		TransInfo *sourceInfo = [[TransInfo alloc] init];
		sourceInfo.transId = [so stringForColumn:@"IdTrans"];
		sourceInfo.transNick = [so stringForColumn:@"nickTrans"];
		sourceInfo.transName = [so stringForColumn:@"nameTrans"];
		sourceInfo.transIsvip = [so stringForColumn:@"isvipTrans"];
		sourceInfo.translocalAuth = [so stringForColumn:@"localAuthTrans"];
		sourceInfo.transOrigtext = [so stringForColumn:@"origTrans"];
		sourceInfo.transImage = [so stringForColumn:@"imageUrlTrans"];
		sourceInfo.transVideo = [so stringForColumn:@"videoUrlTrans"];
		sourceInfo.transVideoRealUrl = [so stringForColumn:@"videoRealurlTrans"];
		sourceInfo.transCount = [so stringForColumn:@"countTrans"];
		sourceInfo.transCommitcount = [so stringForColumn:@"commitCountTrans"];
		sourceInfo.transTime = [so stringForColumn:@"timestampTrans"];
		sourceInfo.transFrom = [so stringForColumn:@"fromTrans"];
		[sourceWeiboInfo addObject:sourceInfo];
		[sourceInfo release];
	}
	[so close];
	return sourceWeiboInfo;
}

//读取主页最新一条记录的时间
+ (NSString *)readNewTimeWithUser:(NSString *)userName andSite:(NSString *)siteName{
	FMDatabase *db = [Database sharedManager].db;
	NSString  *s = [db stringForQuery:@"select timeStamp from weibo where userName = ? and site = ? order by timeStamp desc limit 1",userName,siteName];
	return s ;
}

//读取提及我的最新一条记录的时间
+ (NSString *)readMessageNewTimeWithUser:(NSString *)userName andSite:(NSString *)siteName{
	[[Database sharedManager] connectDB];
	FMDatabase *db = [Database sharedManager].db;
	NSString *s = [db stringForQuery:@"select timeStamp from messageWeibo where userName = ? and site = ? order by timeStamp desc limit 1",userName,siteName];
	return s;
}

#pragma mark -
#pragma mark hotBroadCast

//热门广播信息存入数据库
- (void) insertHotBroadCastToDatabase:(HotBroadcastInfo *)hotBroadcastInfo{
	TransInfo *sourceBackInfo;
	FMDatabase *db = [Database sharedManager].db;
	if (db && hotBroadcastInfo) {
		NSString  *picurlVideoString = @"";
		NSString  *realurlVideoString = @"";
		
		if ([hotBroadcastInfo.video isKindOfClass:[NSDictionary class]] && [hotBroadcastInfo.video count]!=0) {
			if ([hotBroadcastInfo.video objectForKey:VIDEOPICURL]!=nil) {
				picurlVideoString = [hotBroadcastInfo.video objectForKey:VIDEOPICURL];
			}
			if ([hotBroadcastInfo.video objectForKey:VIDEOREALURL]!=nil) {
				realurlVideoString = [hotBroadcastInfo.video objectForKey:VIDEOREALURL];
			}
		}
		sourceBackInfo = [self manageSourceInfo:hotBroadcastInfo.source weiboId:hotBroadcastInfo.uid];
		NSString *sqlWeibo = @"insert into hotBroadCast(weiboId,local_id,local_nick,local_name,local_lauth,local_isauth,local_origtext,local_count,local_mcount,local_from,local_weiboId,local_imageUrl,local_type,local_headUrl,local_isvip,local_timestamp,local_videoPicurl,local_videoRealurl) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		NSArray *arrayData = [[NSArray alloc]initWithObjects:
							  hotBroadcastInfo.uid,
							  hotBroadcastInfo.localID,
							  hotBroadcastInfo.nick,
							  hotBroadcastInfo.name,
							  hotBroadcastInfo.isAuth,
							  hotBroadcastInfo.localAuth,
							  hotBroadcastInfo.origtext,
							  hotBroadcastInfo.count,
							  hotBroadcastInfo.mscount,
							  hotBroadcastInfo.from,
							  hotBroadcastInfo.uid,
							  hotBroadcastInfo.image,
							  hotBroadcastInfo.type,
							  hotBroadcastInfo.head,
							  hotBroadcastInfo.isvip,
							  hotBroadcastInfo.timeStamp,
							  picurlVideoString,
							  realurlVideoString,nil];

		[db executeUpdate:sqlWeibo withArgumentsInArray:arrayData];
		[arrayData release];
		
		if ([hotBroadcastInfo.source count]!=0) {
			NSArray *trArray = [[NSArray alloc]initWithObjects:hotBroadcastInfo.uid,sourceBackInfo.transId,sourceBackInfo.transNick,sourceBackInfo.transName,sourceBackInfo.transIsvip,sourceBackInfo.transOrigtext,sourceBackInfo.transImage,sourceBackInfo.transVideo,sourceBackInfo.transVideoRealUrl,sourceBackInfo.transCount,sourceBackInfo.transCommitcount,sourceBackInfo.transTime,sourceBackInfo.transFrom,nil];
			[db executeUpdate:@"insert into hotBroadTransWeibo(IdTrans,transIdTrans,nickTrans,nameTrans,isvipTrans,origTrans,imageUrlTrans,videoUrlTrans,videoRealurlTrans,countTrans,commitCountTrans,timestampTrans,fromTrans) values(?,?,?,?,?,?,?,?,?,?,?,?,?)"withArgumentsInArray:trArray];
			[trArray release]; 			
		}
		
	}
}

// 获取数据库中最新的30条记录
+ (NSMutableArray *)getLatestBroadCast {
	return [DataManager getHotBroadCastFromDatabase:nil getType:getNew];
}

// 获取localid小于当前值的所有记录
+ (NSMutableArray *)getHotBroadCastLessThanLocalID:(NSString *)localID{
	return [DataManager getHotBroadCastFromDatabase:localID getType:getlatest];
}

//数据库读取热门广播信息
+ (NSMutableArray *)getHotBroadCastFromDatabase:(NSString *)id getType:(NSUInteger)readType{
	FMDatabase *db = [Database sharedManager].db;
	FMResultSet *s = nil;
	NSMutableArray *hotArray = [[[NSMutableArray alloc] initWithCapacity:30] autorelease];
	switch (readType) {
		case getNew:
			s = [db executeQueryWithFormat:@"select weiboId,local_id,local_nick,local_name,local_lauth,local_isauth,local_origtext,local_count,local_mcount,local_from,local_weiboId,local_imageUrl,local_type,local_headUrl,local_isvip,local_timestamp,local_videoPicurl,local_videoRealurl from hotBroadCast order by local_id desc limit 30"];
			break;
		case getlatest:
			s = [db executeQueryWithFormat:@"select weiboId,local_id,local_nick,local_name,local_lauth,local_isauth,local_origtext,local_count,local_mcount,local_from,local_weiboId,local_imageUrl,local_type,local_headUrl,local_isvip,local_timestamp,local_videoPicurl,local_videoRealurl from hotBroadCast where local_id<%@ order by local_id desc limit 30",id];
			break;
		default:
			break;
	}
	
	while ([s next]) {
		HotBroadcastInfo *hotBrInfo = [[HotBroadcastInfo alloc] init];
		hotBrInfo.uid			= [s stringForColumn:@"weiboId"];
		hotBrInfo.localID		= [s stringForColumn:@"local_id"];
		hotBrInfo.nick			= [s stringForColumn:@"local_nick"];
		hotBrInfo.name			= [s stringForColumn:@"local_name"];
		hotBrInfo.isAuth		= (NSNumber *)[s objectForColumnName:@"local_lauth"];
		hotBrInfo.localAuth		= [s stringForColumn:@"local_isauth"];
		hotBrInfo.origtext		= [s stringForColumn:@"local_origtext"];
		hotBrInfo.count			= [s stringForColumn:@"local_count"];
		hotBrInfo.mscount		= [s stringForColumn:@"local_mcount"];
		hotBrInfo.from			= [s stringForColumn:@"local_from"];
		hotBrInfo.uid			= [s stringForColumn:@"local_weiboId"];
		hotBrInfo.image			= [s stringForColumn:@"local_imageUrl"];
		hotBrInfo.type			= [s stringForColumn:@"local_type"];
		hotBrInfo.head			= [s stringForColumn:@"local_headUrl"];
		hotBrInfo.mscount		= [s stringForColumn:@"local_isvip"];
		hotBrInfo.timeStamp		= [s stringForColumn:@"local_timestamp"];
		hotBrInfo.videoPicUrl	= [s stringForColumn:@"local_videoPicurl"];
		hotBrInfo.videoRealUrl	= [s stringForColumn:@"local_videoRealurl"];
		[hotArray addObject:hotBrInfo];
		[hotBrInfo release];
	}
	[s close];
	return hotArray;
}

//获取本地最新广播的转播源
+ (NSMutableArray *)getFromHotBroadTransWeibo:(NSString *)idString {
	FMDatabase *db = [Database sharedManager].db;
	NSMutableArray *sourceWeiboInfo = [NSMutableArray arrayWithCapacity:8];
	FMResultSet *so = nil;
	so = [db executeQueryWithFormat:@"select nickTrans,nameTrans,isvipTrans,origTrans,imageUrlTrans,videoUrlTrans,videoRealurlTrans,countTrans,commitCountTrans,timestampTrans,fromTrans from hotBroadTransWeibo where IdTrans = %@",idString];  //根据转发的id来取值

	while ([so next]) {
		TransInfo *sourceInfo = [[TransInfo alloc] init];
		sourceInfo.transId = idString ;
		sourceInfo.transNick = [so stringForColumn:@"nickTrans"];
		sourceInfo.transName = [so stringForColumn:@"nameTrans"];
		sourceInfo.transIsvip = [so stringForColumn:@"isvipTrans"];
		sourceInfo.transOrigtext = [so stringForColumn:@"origTrans"];
		sourceInfo.transImage = [so stringForColumn:@"imageUrlTrans"];
		sourceInfo.transVideo = [so stringForColumn:@"videoUrlTrans"];
		sourceInfo.transVideoRealUrl = [so stringForColumn:@"videoRealurlTrans"];
		sourceInfo.transCount = [so stringForColumn:@"countTrans"];
		sourceInfo.transCommitcount = [so stringForColumn:@"commitCountTrans"];
		sourceInfo.transTime = [so stringForColumn:@"timestampTrans"];
		sourceInfo.transFrom = [so stringForColumn:@"fromTrans"];
		[sourceWeiboInfo addObject:sourceInfo];
		[sourceInfo release];
	}
	[so close];
	return sourceWeiboInfo;
}

+ (BOOL)removeHotBCFromDB{
	FMDatabase *db = [Database sharedManager].db;
	BOOL bResult = [db executeUpdateWithFormat:@"delete from hotBroadCast"];
	return bResult;
}

+ (BOOL)removeHotBCTransFromDB{
	FMDatabase *db = [Database sharedManager].db;
	BOOL bResult = [db executeUpdateWithFormat:@"delete from hotBroadTransWeibo"];
	return bResult;
}

#pragma mark -
#pragma mark hotSearchWorld

//rss订阅存储到数据库
+ (void)insertHotWordSearchToDatabase:(NSString *)userName  hotWord:(NSString *)hotWord hotType:(NSString *)hotype{
	FMDatabase *db = [Database sharedManager].db;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin && db) {	
		NSString *sqlWeibo = @"insert into HotWordSearch(userName,hotWord,hotType,site) values(?,?,?,?)";
		NSArray *arrayData = [[NSArray alloc]initWithObjects:userName,hotWord,hotype,actSite.descriptionInfo.svrName,nil];
        [db executeUpdate:sqlWeibo withArgumentsInArray:arrayData];
        [arrayData release];
//		NSString *updateHotWord = @"update HotWordSearch set site = ? where userName = ? and hotWord = ? and hotType = ?";
//		NSArray *updateWordArray = [[NSArray alloc] initWithObjects:actSite.descriptionInfo.svrName,userName,hotWord,hotype,nil];
//		[db executeUpdate:updateHotWord withArgumentsInArray:updateWordArray];				
//		[updateWordArray release];
	}
}

//rss订阅查询
+ (NSMutableArray *)getHotWordSearchFromDatabase : (NSString *) hotype {
	[[Database sharedManager] connectDB];
	FMDatabase *db = [Database sharedManager].db;
	FMResultSet *s = nil;
	NSMutableArray *hotArray = [[[NSMutableArray alloc] initWithCapacity:2] autorelease];
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {	
		if ([hotype isEqualToString:@"2"]) {//＝＝ 2 获取全部话题
			s = [db executeQueryWithFormat:@"select hotWord from HotWordSearch where site = %@ and userName = %@",actSite.descriptionInfo.svrName,actSite.loginUserName];
		}
		else {
			s = [db executeQueryWithFormat:@"select hotWord from HotWordSearch where hotType = %@ and site = %@ and userName = %@",hotype,actSite.descriptionInfo.svrName,actSite.loginUserName];
		}
		while ([s next]) {
			NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
			[dic setObject:[s stringForColumn:@"hotWord"] forKey:@"hotWord"];
			[hotArray addObject:dic];
			[dic release];
		}
		[s close];
	}
	return hotArray;
}

+ (BOOL)alterHotWordSearchColoum:(NSString *)coloum{
	FMDatabase *db = [Database sharedManager].db;
	NSString *addColoum = [NSString stringWithFormat:@"alter table HotWordSearch add %@ text(20,0)",coloum];
	BOOL rs = [db executeUpdateWithFormat:addColoum];
	return rs;
}

+ (BOOL)removeHotWordSearch:(NSString *)rssContent hotype:(NSString *) hotype{
	FMDatabase *db = [Database sharedManager].db;
	BOOL bResult = [db executeUpdateWithFormat:@"delete from HotWordSearch where hotWord = %@ and hotType = %@ ",rssContent,hotype];
	return bResult;
}

+(BOOL)removeHotWordSearch{
	FMDatabase *db = [Database sharedManager].db;
	BOOL bResult = NO;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin && db) {
		NSString *sql = @"delete from HotWordSearch where userName = ? and site = ?";
		NSArray *array = [[NSArray alloc] initWithObjects:actSite.loginUserName,actSite.descriptionInfo.svrName,nil];
		bResult = [db executeUpdate:sql withArgumentsInArray:array];
		[array release];
	}
	return bResult;
}

//热词搜索存入数据库
+ (void)insertHotSearchToDatabase:(NSString *)hotSearch{
	FMDatabase *db = [Database sharedManager].db;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin && db) {
		NSString *sqlWeibo = @"insert into HotSearch(hotSearch,userName) values(?,?)";
		NSString *updateSql = @"update HotSearch set site = ? where userName = ? and hotSearch = ?";
		NSArray *arrayData = [[NSArray alloc]initWithObjects:hotSearch,actSite.loginUserName,nil];
		NSArray *updateArray = [[NSArray alloc] initWithObjects:actSite.descriptionInfo.svrName,actSite.loginUserName,hotSearch,nil];
		[db executeUpdate:sqlWeibo withArgumentsInArray:arrayData];
		[db executeUpdate:updateSql withArgumentsInArray:updateArray];
		[arrayData release];		
		[updateArray release];
	}
}

//热词搜索查询
+ (NSMutableArray *)getHotSearchFromDatabase{
	FMDatabase *db = [Database sharedManager].db;
	FMResultSet *s = nil;
	NSMutableArray *hotArray = [[[NSMutableArray alloc] initWithCapacity:2] autorelease];
//	s = [db executeQueryWithFormat:@"select hotWord from HotSearch where hotWord like '%hotLikeWord%'"];
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin && db) {
		s = [db executeQueryWithFormat:@"select hotSearch from HotSearch where site = %@ and userName = %@",actSite.descriptionInfo.svrName,actSite.loginUserName];
		while ([s next]) {
			[hotArray addObject:[s stringForColumn:@"hotSearch"]];
		}
		[s close];
	}
	return hotArray;
}

+ (BOOL)alterHotSearchColoum:(NSString *)coloum{
	FMDatabase *db = [Database sharedManager].db;
	NSString *addColoum = [NSString stringWithFormat:@"alter table hotSearch add %@ text(20,0)",coloum];
	BOOL rs = [db executeUpdateWithFormat:addColoum];
	return rs;
}

+ (BOOL)removeHotSearch{
	FMDatabase *db = [Database sharedManager].db;
	BOOL bResult = [db executeUpdateWithFormat:@"delete from HotSearch"];
	return bResult;
}

#pragma mark -
#pragma mark more-draft

/*type是转发类,text是文本，timeStamp时间戳，isHaspic是否有图片，attachData图片资源，forwardName转发昵称,forwardText转发内容*/
+ (void)insertDraftToDatabase:(Draft *)draftComposed{
	FMDatabase *db = [Database sharedManager].db;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (db && actSite) {
		NSString *userNameStirng =  [NSString stringWithFormat:@"%@",draftComposed.realUserName];
		NSString *site			 =  [NSString stringWithFormat:@"%@",actSite.descriptionInfo.svrName];
		NSNumber *draftType	=		[NSNumber numberWithInt:draftComposed.draftType];		
		NSString *draftTypeString = [NSString stringWithFormat:@"%@",draftComposed.draftTypeContext];
		NSString *draftText	=		[NSString stringWithFormat:@"%@",draftComposed.draftText];		
		NSNumber *draftisHasPic	=	draftComposed.isHasPic;	
		NSData	 *draftAttach	=	[NSData dataWithData:draftComposed.attachedData];
		NSString *draftForName	=	[NSString stringWithFormat:@"%@",draftComposed.draftTitle];	
		NSString *draftForText	=	[NSString stringWithFormat:@"%@",draftComposed.draftForwardOrCommentText];	
		NSString *draftTimestamp =	[NSString stringWithFormat:@"%@",draftComposed.timeStamp];	
		NSString *draftUid	=		[NSString stringWithFormat:@"%@",draftComposed.uid];
		NSString *draftTalkTo =		[NSString stringWithFormat:@"%@",draftComposed.talkToUserName];
		NSNumber *attachedDataType = [NSNumber numberWithInt:draftComposed.attachedDataType];
//		added by wangying 2012-03-05  location是定位信息，后期版本需添加
//		NSString *location			= [draft objectForKey:@"location"];
		NSString *draft = @"insert into moredraft(userName,draftType,draftTypeString,draftText,draftisHasPic,draftAttach,draftForName,draftForText,draftTimestamp,draftUid,attachedDataType,draftTalkTo,site) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
		NSArray *arrayData = [[NSArray alloc]initWithObjects:userNameStirng,draftType,draftTypeString,draftText,draftisHasPic,draftAttach,draftForName,draftForText,draftTimestamp,draftUid,attachedDataType,draftTalkTo,site,nil];
		[db executeUpdate:draft withArgumentsInArray:arrayData];
		[arrayData release];		
	}
}

+ (BOOL)alterDraftColoum:(NSString *)coloum{
	FMDatabase *db = [Database sharedManager].db;
	NSString  *addColoum = [NSString stringWithFormat:@"alter table moredraft add %@ text(20,0)",coloum];
	BOOL rs = [db executeUpdateWithFormat:addColoum];
	return rs;
}

//草稿箱查询
+ (NSMutableArray *)getDraftFromDatabase:(NSString *)userName{
	FMDatabase *db = [Database sharedManager].db;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	FMResultSet *s = nil;
	
	NSMutableArray *draftArray = [[[NSMutableArray alloc] initWithCapacity:7] autorelease];
	//s = [db executeQueryWithFormat:@"select draftType,draftTypeString,draftText,draftisHasPic,draftAttach,draftForName,draftForText,draftTimestamp,draftUid,attachedDataType,draftTalkTo from moredraft where userName = %@ order by draftTimestamp desc",userName];
	s = [db executeQueryWithFormat:@"select draftType,draftTypeString,draftText,draftisHasPic,draftForName,draftForText,draftTimestamp,draftUid,attachedDataType,draftTalkTo from moredraft where userName = %@ and site = %@ order by draftTimestamp desc",userName,actSite.descriptionInfo.svrName];
	while ([s next]) {
		Draft *draftComposed = [[Draft alloc] init];
		draftComposed.draftType = [s intForColumn:@"draftType"];
		draftComposed.draftTypeContext = [s stringForColumn:@"draftTypeString"];
		draftComposed.draftText = [s stringForColumn:@"draftText"];
		draftComposed.isHasPic = [NSNumber numberWithInt:[s intForColumn:@"draftisHasPic"]];
		draftComposed.attachedDataType = [s intForColumn:@"attachedDataType"];
		draftComposed.talkToUserName = [s stringForColumn:@"draftTalkTo"];
		//NSData *data = [s dataForColumn:@"draftAttach" ];
//		//if (!data) {
////			data = [NSData data];
////		}
//		draftComposed.attachedData = data;
		draftComposed.draftTitle = [s stringForColumn:@"draftForName"];
		draftComposed.draftForwardOrCommentText = [s stringForColumn:@"draftForText"];
		draftComposed.timeStamp = [s stringForColumn:@"draftTimestamp"];
		draftComposed.uid = [s stringForColumn:@"draftUid"];
		[draftArray addObject:draftComposed];
		[draftComposed release];
	}
	[s close];
	return draftArray;
}
// 草稿图片获取
+ (NSData *)getDraftAttachedData:(NSString *)time userName:(NSString *)name {
	FMDatabase *db = [Database sharedManager].db;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	FMResultSet *s = nil;
	NSData *attachedPicData = nil;
	s = [db executeQueryWithFormat:@"select draftAttach from moredraft where draftTimestamp = %@ and userName = %@ and site =%@ order by draftTimestamp desc", time, name,actSite.descriptionInfo.svrName];
	if ([s next]) {
		attachedPicData= [s dataForColumn:@"draftAttach" ];
	}
	[s close];
	return attachedPicData;
}
// 草稿箱草稿个数查询
+ (NSInteger )getDraftCountFromDatabase:(NSString *)userName {
	FMDatabase *db = [Database sharedManager].db;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	FMResultSet *s = nil;
	s = [db executeQueryWithFormat:@"select count(draftTimestamp) from moredraft where userName = %@ and site = %@", userName,actSite.descriptionInfo.svrName];
	[s next];
    NSInteger num = [s intForColumnIndex:0];
	[s close];
	return num;
}

+ (BOOL)removeDraft:(NSString *)time userName:(NSString *)name{
	FMDatabase *db = [Database sharedManager].db;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	BOOL bResult = [db executeUpdateWithFormat:@"delete from moredraft where draftTimestamp = %@ and userName = %@ and site = %@",time,name,actSite.descriptionInfo.svrName];
	return bResult;
}
#pragma mark -
#pragma mark userInfo

//userInfo存储到数据库
+ (void)insertUserInfoToDB:(NamenickInfo *)info{
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {
		FMDatabase *db = [Database sharedManager].db;
		if (db) {
			NSString *sqlWeibo = @"insert into nameNickInfo(userName,userNick, site) values(?, ?, ?)";
			NSArray *arrayData = [[NSArray alloc]initWithObjects:info.userName, info.userNick, actSite.descriptionInfo.svrName, nil];
			[db executeUpdate:sqlWeibo withArgumentsInArray:arrayData];
			[arrayData release];		
		}
	}
}

+ (void)insertUserInfoToDBWithDic:(NSDictionary *)nameNickInfoDic {
	if (![nameNickInfoDic isKindOfClass:[NSDictionary class]]) {
		return;
	}	
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {
		FMDatabase *db = [Database sharedManager].db;
		if (db) {
			NSString *sqlWeibo = @"insert into nameNickInfo(userName,userNick, site) values(?, ?, ?)";
			NSString *sqlUpdate = @"update nameNickInfo set userNick=? where userName=?  and site=?";
			NSArray *nameArray = [nameNickInfoDic allKeys];
			for (NSString *userName in nameArray) {
				NSString *userNick = [nameNickInfoDic objectForKey:userName];
				if ([userName isKindOfClass:[NSString class]] && [userNick isKindOfClass:[NSString class]]) {
					FMResultSet *s = [db executeQueryWithFormat:@"select 1 from nameNickInfo where userName=%@ and site=%@", userName, actSite.descriptionInfo.svrName];
					if ([s next]) {
						[s close];
						// 有数据执行更新操作
						NSArray *arrayData = [[NSArray alloc]initWithObjects:userNick, userName, actSite.descriptionInfo.svrName, nil];
						[db executeUpdate:sqlUpdate withArgumentsInArray:arrayData];
						[arrayData release];
					}
					else {
						[s close];
						NSArray *arrayData = [[NSArray alloc]initWithObjects:userName, userNick, actSite.descriptionInfo.svrName, nil];
						[db executeUpdate:sqlWeibo withArgumentsInArray:arrayData];
						[arrayData release];	
					}

				}	
			}
		}
	}
}

//userInfo查询
+ (NSMutableArray *)getUserInfoFromDB{
	NSMutableArray *userArray = [NSMutableArray arrayWithCapacity:2];
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {
		FMDatabase *db = [Database sharedManager].db;
		FMResultSet *s = nil;
		s = [db executeQueryWithFormat:@"select userName,userNick from nameNickInfo where site=%@", actSite.descriptionInfo.svrName];
		while ([s next]) {
			NamenickInfo *user = [[NamenickInfo alloc] init];
			user.userName = [s stringForColumn:@"userName"];
			user.userNick = [s stringForColumn:@"userNick"];
			[userArray addObject:user];
			[user release];
		}
		[s close];
	}
	return userArray;
}
// 删除
+ (BOOL)removeAllUserNameNickInfo {
	BOOL bResult = NO;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil && actSite.bUserLogin) {
		FMDatabase *db = [Database sharedManager].db;
		bResult = [db executeUpdateWithFormat:@"delete from nameNickInfo where site=%@", actSite.descriptionInfo.svrName];
	}
	return bResult;
}

#pragma mark -
#pragma mark alter table 

//添加数据库脚本
+ (BOOL)alterWeiboColoum:(NSString *)coloum andType:(NSUInteger)typeWhere{
	NSString *addColoum = nil;
	FMDatabase *db = [Database sharedManager].db;
	switch (typeWhere) {
		case weibo:
			addColoum = [NSString stringWithFormat:@"alter table weibo add %@ text(20,0)",coloum];
			break;
		case messageWeibo:
			addColoum = [NSString stringWithFormat:@"alter table messageWeibo add %@ text(20,0)",coloum];
			break;
	    case sourceWeibo:
			addColoum = [NSString stringWithFormat:@"alter table transWeibo add %@ text(20,0)",coloum];
			break;
		case sourceMessageWeibo:
			addColoum = [NSString stringWithFormat:@"alter table messageTransWeibo add %@ text(20,0)",coloum];
			break;
		default:
			break;
	}
	BOOL rs = [db executeUpdateWithFormat:addColoum];
	return rs;
}

#pragma mark -
#pragma mark delete
	
+ (BOOL)removeWeiboInfoFromDB {
	BOOL bResult = NO;
	FMDatabase *db = [Database sharedManager].db;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil) {
		NSString *sql = @"delete from weibo where userName = ? and site = ?";
		NSArray *array = [[NSArray alloc] initWithObjects:actSite.loginUserName,actSite.descriptionInfo.svrName,nil];
		bResult = [db executeUpdate:sql withArgumentsInArray:array];
		[array release];
	}
	return bResult;
}

+ (BOOL)removeMessageWeiboInfoFromDB {
	BOOL bResult = NO;
	FMDatabase *db = [Database sharedManager].db;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil) {
		NSString *sql = @"delete from messageWeibo where userName = ? and site = ?";
		NSArray *array = [[NSArray alloc] initWithObjects:actSite.loginUserName,actSite.descriptionInfo.svrName,nil];
		bResult = [db executeUpdate:sql withArgumentsInArray:array];
		[array release];
	}
	return bResult;
}

+ (BOOL)removeSourceInfoFromDB {
	BOOL bResult = NO;
	FMDatabase *db = [Database sharedManager].db;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil) {
		NSString *sql = @"delete from transWeibo where userName = ? and site = ?";
		NSArray *array = [[NSArray alloc] initWithObjects:actSite.loginUserName,actSite.descriptionInfo.svrName,nil];
		bResult = [db executeUpdate:sql withArgumentsInArray:array];
		[array release];
	}
	return bResult;
}

+ (BOOL)removeMessageSourceInfoFromDB {
	BOOL bResult = NO;
	FMDatabase *db = [Database sharedManager].db;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil) {
		NSString *sql = @"delete from messageTransWeibo where userName = ? and site = ?";
		NSArray *array = [[NSArray alloc] initWithObjects:actSite.loginUserName,actSite.descriptionInfo.svrName,nil];
		bResult = [db executeUpdate:sql withArgumentsInArray:array];
		[array release];
	}
	return bResult;
}

+ (BOOL)removeVideoInfoFromDB {
	FMDatabase *db = [Database sharedManager].db;
	BOOL bResult = [db executeUpdateWithFormat:@"delete from videoData"];
	[db executeUpdateWithFormat:@"delete from messageVideoData"];
	return bResult;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
	
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	[imageSaveArray release];
	[videoUrlList release];
	[transSource release];
	[musicList release];
	[arrayAll release];
    [super dealloc];
}

// 2012-05-28 By Yi Minwen
// 执行数据库表结构升级脚本
+ (BOOL)executeSQLDBUpdate {
	BOOL bResult = YES;
	FMDatabase *db = [Database sharedManager].db;
	FMResultSet *s = nil;
	NSInteger versionIndex = SQL_LITE_DB_VIER_BASE;
	s = [db executeQueryWithFormat:@"select version from versionConfig"];
	if ([s next]) {
		versionIndex = [s intForColumnIndex:0];
	}
	[s close];
	// 5-28号脚本更新
	// 昵称表增加site字段，用来区分是哪个服务器下的用户昵称
	if (versionIndex < SQL_LITE_DB_VER_05_28) {
		// 由于为第一版，可不考虑兼容问题，直接修改db
		//[db beginTransaction];
//		[db executeUpdate:@"ALTER TABLE \"main\".\"nameNickInfo\" RENAME TO \"_nameNickInfo_old_20120528\""];
//		[db executeUpdate:@"CREATE TABLE \"main\".\"nameNickInfo\" ( \
//		 \"userName\" text(20,0) NOT NULL, \
//		 \"userNick\" text(20,0), \"site\" text(20,0) NOT NULL, PRIMARY KEY(\"userName\",\"site\") \
//		 )"];
//		[db executeUpdate:@"INSERT INTO \"main\".\"nameNickInfo\" (\"userName\", \"userNick\") SELECT \"userName\", \"userNick\" FROM \"main\".\"_nameNickInfo_old_20120528\""];
//		if (![db commit]) {
//			[db rollback];
//			bResult = NO;
//		}
		// 更新版本信息
//		NSString *strVer = [[NSString alloc] initWithFormat:@"%d", SQL_LITE_DB_VER_05_28];
//		bResult = [db executeUpdateWithFormat:@"update versionConfig set version=%@", strVer];
	}
	// 其他更新
	return bResult;
}

// 查找缓存图像
+ (NSData *)getCachedImageFromDB:(NSString *)strUrl withType:(IMAGE_TYPE)typeImage {
    if (strUrl == nil || [strUrl length] == 0) {
        return nil;
    }
	FMDatabase *db = [Database sharedManager].db;
	FMResultSet *s = nil;
	NSData *attachedPicData = nil;
    NSString *strSQL = nil;
    switch (typeImage) {
        case ICON_HEAD: {
            strSQL = [NSString stringWithFormat:@"select headData from cachedImages where imageUrl='%@'", strUrl];
        }
            break;
        case IMAGE_ORIGIN: {
            strSQL = [NSString stringWithFormat:@"select midData from cachedImages where imageUrl='%@'", strUrl];
        }
            break;
        case IMAGE_LARGE:
            break;
        default:
            break;
    }
    if (nil != strSQL) {
        s = [db executeQueryWithFormat:strSQL];
        if ([s next]) {
            attachedPicData= [s dataForColumnIndex:0];
        }
    }
	[s close];
	return attachedPicData;
}

+ (BOOL)insertCachedImageToDB:(NSString *)strUrl withData:(NSData *)dataImage andType:(IMAGE_TYPE)typeImage {
    FMDatabase *db = [Database sharedManager].db;
	// 删除，然后添加
	BOOL bResult = NO;
    NSString *strSQL =[NSString stringWithFormat:@"select 1 from cachedImages where imageUrl=%@", strUrl];
    NSString *strUpdate = nil;
    FMResultSet *s = [db executeQueryWithFormat:strSQL];
    if ([s next]) {
        switch (typeImage) {
            case IMAGE_SMALL: {
                strUpdate = @"update cachedImages set headData=? where imageUrl=?";
            }
                break;
            case IMAGE_ORIGIN: {
                strUpdate = @"update cachedImages set midData=? where imageUrl=?";
            }
                break;
            case IMAGE_LARGE:
                break;
            default:
                break;
        }
        if (nil != strUpdate) {
            NSArray *array = [[NSArray alloc] initWithObjects:dataImage, strUrl, nil];
            bResult = [db executeUpdate:strUpdate withArgumentsInArray:array];
            [array release];
        }
    }
    else {
        // 插入新数据
        switch (typeImage) {
            case ICON_HEAD: {
                strUpdate = @"insert into cachedImages(imageUrl, headData) values(?, ?)";
            }
                break;
            case IMAGE_ORIGIN: {
                strUpdate = @"insert into cachedImages(imageUrl, midData) values(?, ?)";
            }
                break;
            case IMAGE_LARGE:
                break;
            default:
                break;
        }
        if (nil != strUpdate) {
            NSArray *array = [[NSArray alloc] initWithObjects:strUrl, dataImage, nil];
            bResult = [db executeUpdate:strUpdate withArgumentsInArray:array];
            [array release];
        }
    }
	return bResult;
}

+ (BOOL)removeCachedImagesFromDB {
	BOOL bResult = NO;
	FMDatabase *db = [Database sharedManager].db;
	CustomizedSiteInfo *actSite = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite;
	if (actSite != nil) {
		bResult = [db executeUpdateWithFormat:@"delete from cachedImages"];
	}
	return bResult;
}
@end
