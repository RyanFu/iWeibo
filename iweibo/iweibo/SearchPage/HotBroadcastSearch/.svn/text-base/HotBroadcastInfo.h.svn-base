//
//  HotBroadcastInfo.h
//  iweibo
//
//  Created by Minwen Yi on 2/25/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Info.h"
#import <objc/runtime.h>
#import "Canstants.h"

@interface HotBroadcastInfo : Info {
	NSString			*localID;			// 微博的本地id号
	NSNumber			*isLocalAuth;			// 是否是本地认证，1是，0不是(Info包含该字段)
	NSNumber			*isAuth;			// 是否是认证帐号，1是，0不是；
}

@property (nonatomic, retain) NSString			*localID;
@property (nonatomic, retain) NSNumber			*isLocalAuth;
@property (nonatomic, retain) NSNumber			*isAuth;

// 解析单个网络数据成对象
-(void)updateWithDic:(NSDictionary *)infoDic;
// 源消息解析
+(id)sourceInfoItemFromDic:(NSDictionary *)srcDic infoID:(NSString *)idSrc;

//从数据库获取热门广播的image图片
+ (NSData *)myHotBroadCastImageDataWithUrl:(NSString *)url;

//从数据库获取热门广播的video图片
+ (NSData *)myHotBroadCastVideoDataWithUrl:(NSString *)url;

//从数据库获取头像图片
+ (NSData *)myHotBroadCastHeadImageDataWithUrl:(NSString *)url; 

//更新热门广播的video图片
+ (void) updateHotBroadCastVideoData:(NSData *)data withUrl:(NSString *)idString;

//更新热门广播的image图片
+ (void) updateHotBroadCastImageData:(NSData *)data withUrl:(NSString *)idString;

//更新热门广播的头像图片
+ (void) updateHotBroadCastHeadData:(NSData *)data withUrl:(NSString *)idString;

//根据图片url查询图片数据
+ (NSData *)mySourceImageDataWithUrl:(NSString *)url;
//根据视频url查询视频数据
+ (NSData *)mySourceVideoDataWithUrl:(NSString *)url;
//根据转播id更新图片数据
+ (void)updateSourceImageData:(NSData *)data withUrl:(NSString *)idString;
//根据转播id更新视频数据
+ (void)updateSourceVideoData:(NSData *)data withUrl:(NSString *)idString;
@end

// 扩充属性
@interface Info(addiViewInfo) 

@property (nonatomic, retain)NSMutableArray		*infoNodeArr;		// 添加解析文本内容
@end
