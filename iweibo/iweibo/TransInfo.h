//
//  TransInfo.h
//  iweibo
//
//  Created by wangying on 1/10/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TransInfo : NSObject {
	NSString *transNick;				// 转发昵称
	NSString *transName;				// 转发用户名
	NSString *transIsvip;				// 转发vip标识
	NSString *translocalAuth;
	NSString *transId;					// 原微博id
	NSString *transWeiId;				// 转发微博id
	NSString *transOrigtext;			// 转发文本
	NSString *transImage;				// 转发图像
	NSString *transVideo;				// 转发视频
	NSString *transFrom;				// 转发来源
	NSString *transTime;				// 转发时间
	NSString *transCount;				// 转播数
	NSString *transCommitcount;			// 评论数
	NSString *transVideoRealUrl;		// 转发视频真实地址
	NSData   *sourceImageData;			// 转发图片数据
	NSData   *sourceVideoData;			// 转发视频缩略图数据
	BOOL		bUserLocationEnabled;	// 是否开启坐标
    CGFloat      userLatitude;      // 用户坐在经度
    CGFloat      userLongitude;     // 用户所在维度	
}
@property (nonatomic, retain)  NSString *transNick;
@property (nonatomic, retain)  NSString *transName;
@property (nonatomic, retain)  NSString *transIsvip;
@property (nonatomic, retain)  NSString *translocalAuth;
@property (nonatomic, retain)  NSString *transId;
@property (nonatomic, retain)  NSString *transWeiId;
@property (nonatomic, retain)  NSString *transOrigtext;
@property (nonatomic, retain)  NSString *transImage;
@property (nonatomic, retain)  NSString *transVideo;
@property (nonatomic, retain)  NSString *transFrom;
@property (nonatomic, retain)  NSString *transTime;
@property (nonatomic, retain)  NSString *transCount;
@property (nonatomic, retain)  NSString *transCommitcount;
@property (nonatomic, retain)  NSString *transVideoRealUrl;
@property (nonatomic, retain)  NSData   *sourceImageData;
@property (nonatomic, retain)  NSData   *sourceVideoData;
@property(nonatomic, assign) BOOL		bUserLocationEnabled;
@property(nonatomic, assign) CGFloat   userLatitude;
@property(nonatomic, assign) CGFloat   userLongitude;

+ (NSData *)mySourceImageDataWithUrl:(NSString *)url;
+ (NSData *)mySourceVideoDataWithUrl:(NSString *)url;
+ (NSData *)myMsgSourceImageDataWithUrl:(NSString *)url;
+ (NSData *)myMsgSourceVideoDataWithUrl:(NSString *)url;

+ (void)updateSourceImageData:(NSData *)data withUrl:(NSString *)idString;
+ (void)updateSourceVideoData:(NSData *)data withUrl:(NSString *)idString;
+ (void)updateMsgSourceImageData:(NSData *)data withUrl:(NSString *)idString;
+ (void)updateMsgSourceVideoData:(NSData *)data withUrl:(NSString *)idString;

@end
