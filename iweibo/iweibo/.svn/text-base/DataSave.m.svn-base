//
//  DataSave.m
//  iweibo
//
//  Created by wangying on 1/14/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "DataSave.h"
#import "Info.h"
#import "Canstants.h"
#import "ListenIdolList.h"

@implementation DataSave
@synthesize n,nL;
@synthesize listenArray,infoArray;

- (id)init{
	self = [super init];
	if (self !=nil) {
		listenArray = [[NSMutableArray alloc] initWithCapacity:30];
		infoArray = [[NSMutableArray alloc] initWithCapacity:30];
	}
	return self;
}

- (void)dealloc{
	[listenArray release];
	[infoArray release];
	[super dealloc];
}

//微博信息存储
- (NSArray *)storeInfoToClass:(NSDictionary *)result{
//	n=0;
	NSMutableArray *syncInfoQueue = [[NSMutableArray alloc] initWithCapacity:30];
	NSDictionary *data =[DataCheck checkDictionary:result forKey:HOMEDATA withType:[NSDictionary class]];
	NSArray *info = [DataCheck checkDictionary:data forKey:HOMEINFO withType:[NSArray class]];
	if (![info isKindOfClass:[NSNull class]]) {
		for (NSDictionary *sts in info) {	
			if ([sts isKindOfClass:[NSDictionary class]] && sts) {				
				Info *weiboInfo = [[Info alloc] init];
				weiboInfo.uid = [sts objectForKey:HOMEID];
				weiboInfo.name = [sts objectForKey:HOMENAME];
				weiboInfo.nick = [sts objectForKey:HOMENICK];
				weiboInfo.origtext = [sts objectForKey:HOMEORITEXT];
				weiboInfo.from = [sts objectForKey:HOMEFROM];
				weiboInfo.head = [sts objectForKey:HOMEHEAD];
				weiboInfo.userLatitude = [[sts objectForKey:LATITUDE] doubleValue];
				weiboInfo.userLongitude = [[sts objectForKey:LONGITUDE] doubleValue];
				NSString *vip = [[NSString alloc] initWithFormat:@"%@",[sts objectForKey:HOMEISVIP]];  //NSNumber类型
				weiboInfo.isvip = vip;
				[vip release];
				NSString *auth = [[NSString alloc] initWithFormat:@"%@",[sts objectForKey:@"is_auth"]];
				weiboInfo.localAuth = auth;
				[auth release];
				NSString *time = [[NSString alloc] initWithFormat:@"%@",[sts objectForKey:HOMETIME]];
				weiboInfo.timeStamp = time;
				[time release];
				NSString *emotion = [[NSString alloc] initWithFormat:@"%@",[sts objectForKey:HOMEEMOTION]];
				weiboInfo.emotionType = emotion;
				[emotion release];
				NSString *count = [[NSString alloc] initWithFormat:@"%@",[sts objectForKey:HOMECOUNT]];
				weiboInfo.count = count;
				[count release];
				NSString *mscount = [[NSString alloc] initWithFormat:@"%@",[sts objectForKey:HOMEMCOUNT]];
				weiboInfo.mscount = mscount;
				[mscount release];
				NSString *type = [[NSString alloc] initWithFormat:@"%@",[sts objectForKey:HOMETYPE]];
				weiboInfo.type = type;
				[type release];
				
				if (![[sts objectForKey:HOMEIMAGE]isEqual:[NSNull null]]) {
					NSArray *imagelist = [[NSArray alloc]initWithArray:[sts objectForKey:HOMEIMAGE]];
					if ([imagelist count]!=0) {
						NSString *image = [imagelist objectAtIndex:0];
						weiboInfo.image = image;
					}
					[imagelist release];
				}
				
				if (![[sts objectForKey:HOMEVIDEO] isEqual:[NSNull null]]) {
					NSDictionary *video = [[NSDictionary alloc]initWithDictionary:[sts objectForKey:HOMEVIDEO]];
					weiboInfo.video = video;
					[video release];
				}
				
				if (![[sts objectForKey:HOMEMUSIC] isEqual:[NSNull null]]) {
					NSDictionary *musci = [[NSDictionary alloc] initWithDictionary:[sts objectForKey:HOMEMUSIC]];
					weiboInfo.music = musci;	
					[musci release];
				}
				
				if (![[sts objectForKey:HOMESOURCE] isEqual:[NSNull null]]){
					NSDictionary *source = [[NSDictionary alloc] initWithDictionary:[sts objectForKey:HOMESOURCE]];
					weiboInfo.source =[NSDictionary dictionaryWithDictionary:[sts objectForKey:HOMESOURCE]];
					[source release];
				}
				[syncInfoQueue addObject:weiboInfo];
//				if (timeStamp != @"0") {
//					if ([weiboInfo.timeStamp compare: timeStamp]== NSOrderedDescending) {
//						n++;
//					}
//				}
				[weiboInfo release];
			}	
		}// end for
	}
	self.infoArray = syncInfoQueue;
	[syncInfoQueue release];
	return infoArray;
}

//听众和收听列表存储
-(NSArray *)storeIntoClass:(NSDictionary *)dic:(NSString *)time{
	nL = 0;
	NSMutableArray *lisAndAudiArray = [[NSMutableArray alloc]initWithCapacity:30];
	NSDictionary *data =[DataCheck checkDictionary:dic forKey:HOMEDATA withType:[NSDictionary class]];
	NSArray *listen = [DataCheck checkDictionary:data forKey:HOMEINFO withType:[NSArray class]];
	if (![listen isKindOfClass:[NSNull class]]) {
		for (NSDictionary *l in listen) {
			ListenIdolList *lis = [[ListenIdolList alloc] init];
			if ([l isKindOfClass:[NSDictionary class]] && l) {
				lis.uid = [l objectForKey:HOMEID];
				lis.name = [l objectForKey:HOMENAME];
				lis.nick = [l objectForKey:HOMENICK];
				lis.location = [l objectForKey:HOMELOCATI];
				lis.head = [l objectForKey:HOMEHEAD];
				NSString *vip = [[NSString alloc] initWithFormat:@"%@",[l valueForKey:HOMEISVIP]];
				lis.isvip = vip;
				[vip release];
				NSString *fansnum = [[NSString alloc] initWithFormat:@"%@",[l valueForKey:HOMEFANSNUM]];
				lis.fansnum = fansnum;
				[fansnum release];
				NSString *sex = [[NSString alloc] initWithFormat:@"%@",[l objectForKey:HOMESEX]];
				lis.sex = sex;
				[sex release];
				NSString *time = [[NSString alloc] initWithFormat:@"%@",[l objectForKey:HOMETIME]];
				lis.timeStamp = time;
				[time release];
				NSString *auth = [[NSString alloc] initWithFormat:@"%@",[l objectForKey:HOTISAUTH]];
				lis.localAuth = auth;
				[auth release];
				if ([[l objectForKey:HOMETWEET]isKindOfClass:[NSArray class]]) {
					NSArray *arr = [l objectForKey:HOMETWEET];
					if ([arr count]!=0) {
						lis.text = [[arr objectAtIndex:0]objectForKey:HOMETEXT]; //这里tweet返回的是个数组
					}
				}
				[lisAndAudiArray addObject:lis];
				if (time != @"0") {
					if ([lis.timeStamp compare: time]== NSOrderedDescending) {
						nL++;
					}
				}
			}  
			[lis release];
		}
	}
	self.listenArray = lisAndAudiArray;
	[lisAndAudiArray release];
	return listenArray;
}

@end
