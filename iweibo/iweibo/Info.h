//
//  Info.h
//  iweibo
//
//  Created by ZhaoLilong on 12/29/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Info : NSObject {
	NSString	 *city_code;			// 城市码
	NSString	 *count;				// 微博被转次数
	NSString	 *country_code;			// 国家码
	NSString	 *emotionType;			// 心情类型
	NSString	 *emotionUrl;			// 心情图片url
	NSString	 *from;					// 来源
	NSString	 *fromUrl;				// 来源url
	NSString	 *geo;					// 发表者地理信息
	NSString	 *head;					// 发表者头像url
	NSString	 *uid;					// 微博唯一id
	NSString	 *image;				// 图片url列表
	BOOL		 isrealname;			//
	NSString	 *isvip;				// 是否微博认证用户 0-不是 1-是
	NSString	 *localAuth;			// 本地认证
	NSString	 *location;				// 发表者所在地
	NSString	 *mscount;				// 点评次数
	NSString	 *name;					// 发表人帐户名
	NSString	 *nick;					// 昵称
	NSString	 *openid;				// 用户唯一id
	NSString	 *origtext;				// 原始内容
	NSString	 *provinceCode;			// 省份码
	NSString	 *text;					// 微博内容
	NSString	 *timeStamp;			// 发表时间
	NSString	 *type;					// 微博类型，1-原创发表，2-转载，3-私信，4-回复，5-空回，6-提及，7-评论
	NSUInteger	 visiblecode;
	NSUInteger	 status;				// 微博状态，0-正常，1-系统删除，2-审核中，3-用户删除，4-根删除
	NSUInteger	 selfType;				// 是否自已发的的微博，0-不是，1-是
	NSDictionary *music;				// 音频信息
	NSDictionary *video;				// 视频信息
	NSDictionary *source;			    // 源
	NSData		 *headImageData;	    // 头像数据
	NSData	   	 *imageImageData;		// 图像数据
	NSData		 *videoImageData;		// 视频缩略图数据
	NSString	 *videoPicUrl;			// 视频缩略图url
	NSString	 *videoRealUrl;			// 视频真正url
	NSString	 *userName;				// 用户名
	NSString	 *site;					// 站点信息
	BOOL		 bUserLocationEnabled;	// 是否开启坐标
    CGFloat      userLatitude;			// 用户坐在经度
    CGFloat      userLongitude;			// 用户所在维度
	
} 

@property(nonatomic, copy) NSString *city_code;
@property(nonatomic, copy) NSString *count;
@property(nonatomic, copy) NSString *country_code;
@property(nonatomic, copy) NSString *emotionType;
@property(nonatomic, copy) NSString *emotionUrl;
@property(nonatomic, copy) NSString *from;
@property(nonatomic, copy) NSString *fromUrl;
@property(nonatomic, copy) NSString *geo;
@property(nonatomic, copy) NSString *head;
@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *localAuth;
@property(nonatomic, copy) NSString *location;
@property(nonatomic, copy) NSString *mscount;
@property(nonatomic, retain) NSDictionary *music;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *nick;
@property(nonatomic, copy) NSString *isvip;
@property(nonatomic, copy) NSString *openid;
@property(nonatomic, copy) NSString *origtext;
@property(nonatomic, copy) NSString *provinceCode;
@property(nonatomic, copy) NSString *text;
@property(nonatomic, copy) NSString *timeStamp;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString	*videoPicUrl;		
@property(nonatomic, copy) NSString	*videoRealUrl;		
@property(nonatomic, copy) NSString *userName;
@property(nonatomic ,copy) NSString *site;
@property(assign) NSUInteger selfType;
@property(assign) NSUInteger status;
@property(assign) NSUInteger visiblecode;
@property(assign) BOOL isrealname;
@property(nonatomic, retain) NSDictionary *video;
@property(nonatomic, retain) NSDictionary *source;
@property(nonatomic, retain) NSData   *headImageData;
@property(nonatomic, retain) NSData   *imageImageData;
@property(nonatomic, retain) NSData   *videoImageData;
@property(nonatomic, assign) BOOL		bUserLocationEnabled;
@property(nonatomic, assign) CGFloat   userLatitude;
@property(nonatomic, assign) CGFloat   userLongitude;

+ (NSData *)myImageDataWithUrl:(NSString *)url;
+ (NSData *)myVideoDataWithUrl:(NSString *)url;
+ (NSData *)myHeadImageDataWithUrl:(NSString *)url;
+ (NSData *)myMsgImageDataWithUrl:(NSString *)url;
+ (NSData *)myMsgVideoDataWithUrl:(NSString *)url;
+ (NSData *)myMsgHeadImageDataWithUrl:(NSString *)url;

+ (void) updateVideoData:(NSData *)data withUrl:(NSString *)idString;
+ (void) updateImageData:(NSData *)data withUrl:(NSString *)idString;
+ (void) updateHeadData:(NSData *)data withUrl:(NSString *)idString;
+ (void) updateMsgVideoData:(NSData *)data withUrl:(NSString *)idString;
+ (void) updateMsgImageData:(NSData *)data withUrl:(NSString *)idString;
+ (void) updateMsgHeadData:(NSData *)data withUrl:(NSString *)idString;
// 计算时间间隔
+ (NSString *)intervalSinceNow: (double) theDate ;
+ (NSString *)showTime:(double)theDate;			// 只显示时间或日期

@end
