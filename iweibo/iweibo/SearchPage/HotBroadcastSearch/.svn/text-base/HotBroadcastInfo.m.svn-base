//
//  HotBroadcastInfo.m
//  iweibo
//
//  Created by Minwen Yi on 2/25/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "HotBroadcastInfo.h"
#import "TextExtract.h"
#import "MessageViewUtility.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "Database.h"
#import "Canstants_Data.h"
#import "DataCheck.h"

static const char *infoNodeArrayKey = "infoNodeArray";	// 解析文本生成的数组关键字
//static const char *infoViewHeightKey = "infoViewHeight";	// 文本高度关键字

@implementation HotBroadcastInfo
@synthesize isAuth, isLocalAuth, localID;

- (void)dealloc {
	self.localID = nil;
	self.isAuth = nil;
	self.isLocalAuth = nil;
    [super dealloc];
	
}

// 解析单个网络数据成对象
-(void)updateWithDic:(NSDictionary *)sts {
	if (nil != sts && [sts isKindOfClass:[NSDictionary class]]) {
		// 
		self.localID = [sts objectForKey:HOTLOCALID];
		self.localAuth = [sts objectForKey:@"localauth"];
		self.isAuth = [sts objectForKey:HOTISAUTH];
		self.uid = [sts objectForKey:HOMEID];
		self.name = [sts objectForKey:HOMENAME];
		self.nick = [sts objectForKey:HOMENICK];
		self.isvip = [NSString stringWithFormat:@"%@",[sts objectForKey:HOMEISVIP]];
		self.origtext = [sts objectForKey:HOMEORITEXT];
		self.from = [sts objectForKey:HOMEFROM];
		self.timeStamp = [NSString stringWithFormat:@"%@",[sts objectForKey:HOMETIME]];
		self.emotionType = [sts objectForKey:@"emotiontype"];
		self.count = [NSString stringWithFormat:@"%@",[sts objectForKey:HOMECOUNT]];
		self.mscount = [NSString stringWithFormat:@"%@",[sts objectForKey:HOMEMCOUNT]];
		self.head = [NSString stringWithFormat:@"%@",[sts objectForKey:HOMEHEAD]];
		self.type = [NSString stringWithFormat:@"%@",[sts objectForKey:HOMETYPE]];
		
		if (![[sts objectForKey:HOMEIMAGE]isEqual:[NSNull null]]) {
			NSArray *imagelist = [[NSArray alloc]initWithArray:[sts objectForKey:HOMEIMAGE]];
			if ([imagelist count]!=0) {
				NSString *imageTemp = [imagelist objectAtIndex:0];
				self.image = imageTemp;
			}
			[imagelist release];
		}
		else {
			self.image = @"";
		}

		if (![[sts objectForKey:HOMEVIDEO] isEqual:[NSNull null]]) {
			NSDictionary *videoTemp = [[NSDictionary alloc]initWithDictionary:[sts objectForKey:HOMEVIDEO]];
			self.video = videoTemp;
			[videoTemp release];
		}
		else {
			self.video = [NSDictionary dictionary];
		}

		if (![[sts objectForKey:HOMEMUSIC] isEqual:[NSNull null]]) {
			NSDictionary *musci = [[NSDictionary alloc] initWithDictionary:[sts objectForKey:HOMEMUSIC]];
			self.music = musci;	
			[musci release];
		}
		else {
			self.music = [NSDictionary dictionary];
		}
		if (![[sts objectForKey:HOMESOURCE] isEqual:[NSNull null]]){
			NSDictionary *sourceTemp = [[NSDictionary alloc] initWithDictionary:[sts objectForKey:HOMESOURCE]];
			self.source =[NSDictionary dictionaryWithDictionary:[sts objectForKey:HOMESOURCE]];
			[sourceTemp release];
		}
		else {
			self.source = [NSDictionary dictionary];
		}
	}	
}
// 源消息解析
+(id)sourceInfoItemFromDic:(NSDictionary *)sourceInfo infoID:(NSString *)idSrc{
	TransInfo *infoSource = nil;
	if (nil != sourceInfo && [sourceInfo isKindOfClass:[NSDictionary class]] && [sourceInfo count] !=0) {
		infoSource = [[[TransInfo alloc] init] autorelease];
		NSDictionary *source = [[NSDictionary alloc] initWithDictionary:sourceInfo];
		infoSource.transId = idSrc;
		infoSource.transNick = [source objectForKey:HOMENICK],
		infoSource.transName = [source objectForKey:HOMENAME];
		infoSource.transIsvip = [NSString stringWithFormat:@"%@",[source objectForKey:HOMEISVIP]],
		infoSource.transOrigtext = [source objectForKey:HOMEORITEXT];	
		infoSource.transFrom = [source objectForKey:HOMEFROM];
		infoSource.transTime = [NSString stringWithFormat:@"%@",[source objectForKey:HOMETIME]];
		infoSource.transCount = [NSString stringWithFormat:@"%@",[source valueForKey:HOMECOUNT]];
		infoSource.transCommitcount = [NSString stringWithFormat:@"%@",[source valueForKey:HOMEMCOUNT]];
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
		[source release];
	}
	return infoSource;
}

//从数据库获取热门广播的image图片
+ (NSData *)myHotBroadCastImageDataWithUrl:(NSString *)url {
	NSData *data = nil;
	FMDatabase *db = [Database sharedManager].db;
	data = [db dataForQuery:@"select local_imageData from hotBroadCast where local_imageUrl=?", url];
	return data;
}

//从数据库获取热门广播的video图片
+ (NSData *)myHotBroadCastVideoDataWithUrl:(NSString *)url {
	NSData *data = nil;
	FMDatabase *db = [Database sharedManager].db;
	data = [db dataForQuery:@"select local_videoPicData from hotBroadCast where local_videoPicurl=?",url];
	return data;
}

//从数据库获取头像图片
+ (NSData *)myHotBroadCastHeadImageDataWithUrl:(NSString *)url {
	NSData *data = nil;
	FMDatabase *db = [Database sharedManager].db;
	data = [db dataForQuery:@"select local_headData from hotBroadCast where local_headUrl=?", url];
	return data;	 
}

//更新热门广播的video图片
+ (void) updateHotBroadCastVideoData:(NSData *)data withUrl:(NSString *)idString{
	FMDatabase *database = [Database sharedManager].db;
	NSString *sql = @"update hotBroadCast set local_videoPicData=? where weiboId=?";
	NSArray *arrayArg = [NSArray arrayWithObjects:data, idString, nil];
	[database executeUpdate:sql withArgumentsInArray:arrayArg];
}

//更新热门广播的image图片
+ (void) updateHotBroadCastImageData:(NSData *)data withUrl:(NSString *)idString{
	FMDatabase *database = [Database sharedManager].db;
	NSString *sql = @"update hotBroadCast set local_imageData=? where weiboId=?";
	NSArray *arrayArg = [NSArray arrayWithObjects:data, idString, nil];
	[database executeUpdate:sql withArgumentsInArray:arrayArg];
}

//更新热门广播的头像图片
+ (void) updateHotBroadCastHeadData:(NSData *)data withUrl:(NSString *)idString{
	FMDatabase *database = [Database sharedManager].db;	
	NSString *sql = @"update hotBroadCast set local_headData=? where weiboId=?";
	NSArray *arrayArg = [NSArray arrayWithObjects:data, idString, nil];
	[database executeUpdate:sql withArgumentsInArray:arrayArg];
}

//根据图片url查询图片数据
+ (NSData *)mySourceImageDataWithUrl:(NSString *)url {
	FMDatabase *db = [Database sharedManager].db;
	NSData *data = [db dataForQuery:@"select imageDataTrans from hotBroadTransWeibo where imageUrlTrans=?", url];
	return data;
}

//根据视频url查询视频数据
+ (NSData *)mySourceVideoDataWithUrl:(NSString *)url {
	FMDatabase *db = [Database sharedManager].db;
	NSData *data = [db dataForQuery:@"select videoDataTrans from hotBroadTransWeibo where videoUrlTrans=?", url];
	return data;
}

//根据转播id更新图片数据
+ (void)updateSourceImageData:(NSData *)data withUrl:(NSString *)idString{
	FMDatabase *database = [Database sharedManager].db; 
	NSString *sql = @"update hotBroadTransWeibo set imageDataTrans=? where transIdTrans=?";
	NSArray *arrayArg = [NSArray arrayWithObjects:data, idString, nil];
	[database executeUpdate:sql withArgumentsInArray:arrayArg];
}

//根据转播id更新视频数据
+ (void)updateSourceVideoData:(NSData *)data withUrl:(NSString *)idString{
	FMDatabase *database = [Database sharedManager].db; 
	NSString *sql = @"update hotBroadTransWeibo set videoDataTrans=? where transIdTrans=?";
	NSArray *arrayArg = [NSArray arrayWithObjects:data, idString, nil];
	[database executeUpdate:sql withArgumentsInArray:arrayArg];
}

@end


@implementation Info(addiViewInfo)

// get方法
- (NSMutableArray *)infoNodeArr {
	NSMutableArray *arr = (NSMutableArray *)objc_getAssociatedObject(self, infoNodeArrayKey);
	if (![arr isKindOfClass:[NSMutableArray class]]) {
		TextExtract *textExtract = [[TextExtract alloc] init];
		if ([self origtext] != nil) {
			NSMutableArray *infoArray = [textExtract getInfoNodeArray:[self origtext]];
			objc_setAssociatedObject(self, infoNodeArrayKey, infoArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		}
		[textExtract release];
	}
	else {
		arr = nil;
	}
	return arr;
}

//set方法
- (void)setInfoNodeArr:(NSMutableArray *)arr {
    objc_setAssociatedObject(self, infoNodeArrayKey, arr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
