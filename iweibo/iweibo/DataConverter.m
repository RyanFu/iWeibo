//
//  DataConverter.m
//  iweibo
//
//  Created by ZhaoLilong on 2/27/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "DataConverter.h"
#import "Info.h"

@implementation DataConverter

+ (NSMutableArray *) convertToArray:(NSDictionary *)dict withType:(SearchCatalogType)type{
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:30];
	switch (type) {
		case SearchBroadType:
			array =  [DataConverter convertToInfoArray:dict];
			break;
		case SearchTopicType:
			array =  [DataConverter convertToTopicArray:dict];
			break;
		case SearchUserType:
			array = [DataConverter convertToUserArray:dict];
			break;
		default:
			break;
	}
	NSLog(@"array:%@",array);
	return array;
}

+ (NSMutableArray *)convertToInfoArray:(NSDictionary *)dict{
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:30];
	if ([[dict objectForKey:@"data"]objectForKey:@"info"]!=nil) {
		if ([[[dict objectForKey:@"data"]objectForKey:@"info"] isKindOfClass:[NSArray class]]) {
			for (NSDictionary *sts in [[dict objectForKey:@"data"] objectForKey:@"info"]) {	
				if (sts && [sts isKindOfClass:[NSDictionary class]]  ) {
					Info *weiboInfo = [[Info alloc] init];
					weiboInfo.uid = [sts objectForKey:@"id"];
					weiboInfo.name = [sts objectForKey:@"name"];
					weiboInfo.nick = [sts objectForKey:@"nick"];
					weiboInfo.isvip = [NSString stringWithFormat:@"%@",[sts objectForKey:@"isvip"]];
					weiboInfo.origtext = [sts objectForKey:@"origtext"];
					weiboInfo.from = [sts objectForKey:@"from"];
					weiboInfo.timeStamp = [NSString stringWithFormat:@"%@",[sts objectForKey:@"timestamp"]];
					weiboInfo.emotionType = [sts objectForKey:@"emotionType"];
					weiboInfo.count = [NSString stringWithFormat:@"%@",[sts objectForKey:@"count"]];
					weiboInfo.mscount = [NSString stringWithFormat:@"%@",[sts objectForKey:@"mcount"]];
					weiboInfo.head = [NSString stringWithFormat:@"%@",[sts objectForKey:@"head"]];
					
					if (![[sts objectForKey:@"image"]isEqual:[NSNull null]]) {
						NSArray *imagelist = [[NSArray alloc]initWithArray:[sts objectForKey:@"image"]];
						if ([imagelist count]!=0) {
							NSString *image = [imagelist objectAtIndex:0];
							weiboInfo.image = image;
						}
						[imagelist release];
					}
					
					if (![[sts objectForKey:@"video"] isEqual:[NSNull null]]) {
						NSDictionary *video = [[NSDictionary alloc]initWithDictionary:[sts objectForKey:@"video"]];
						weiboInfo.video = video;
						[video release];
					}
					
					if (![[sts objectForKey:@"music"] isEqual:[NSNull null]]) {
						NSDictionary *musci = [[NSDictionary alloc] initWithDictionary:[sts objectForKey:@"music"]];
						weiboInfo.music = musci;	
						[musci release];
					}
					
					if (![[sts objectForKey:@"source"] isEqual:[NSNull null]]){
						NSDictionary *source = [[NSDictionary alloc] initWithDictionary:[sts objectForKey:@"source"]];
						weiboInfo.source =[NSDictionary dictionaryWithDictionary:[sts objectForKey:@"source"]];
						[source release];
					}
					
					[array addObject:weiboInfo];
					[weiboInfo release];
				}	
				else {
					CLog(@"++++++++++%s, data error result:%@", __FUNCTION__, dict);
				}
			}
		}
		else {
			CLog(@"++++++++++%s, data error result:%@", __FUNCTION__, dict);
		}
		
	}
	CLog(@"-------------%s", __FUNCTION__);
	return array;	
}

+ (NSMutableArray *)convertToTopicArray:(NSDictionary *)dict{
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:20];
	NSString *msg = [DataCheck checkDictionary:dict forKey:@"msg" withType:[NSString class]];
	if (![msg isKindOfClass:[NSNull class]] && [msg isEqualToString:@"ok"]) {
		NSDictionary *data = [dict objectForKey:@"data"];
		NSArray *info = [data objectForKey:@"info"];
		for (NSDictionary *dic in info) {
			NSString *str = [dic objectForKey:@"text"];
			[array addObject:str];
		}
	}
	return array;		
}

+ (NSMutableArray *)convertToUserArray:(NSDictionary *)dict{
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:20];
	NSString *msg = [DataCheck checkDictionary:dict forKey:@"msg" withType:[NSString class]];
	if (![msg isKindOfClass:[NSNull class]] && [msg isEqualToString:@"ok"]) {
		NSDictionary *data = [dict objectForKey:@"data"];
		NSArray *info = [data objectForKey:@"info"];
		for (NSDictionary *dic in info) {
			Info *info = [[Info alloc] init];
			info.head = [dic objectForKey:@"head"];
			info.nick = [dic objectForKey:@"nick"];
			info.name = [dic objectForKey:@"name"];
			info.isvip = [dic objectForKey:@"isvip"];
			[array addObject:info];
			[info release];
		}
	}
	return array;
}

@end
