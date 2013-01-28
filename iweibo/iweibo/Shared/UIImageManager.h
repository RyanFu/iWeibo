//
//  UIImageManager.h
//  iweibo
//
//	UIImage对象生成器，用户维护时间线中图片，头像，视频等资源
//
//  Created by Minwen Yi on 4/13/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IconDownloader.h"

#define KEYURL						@"URL"
#define KEYTYPE						@"TYPE"
#define KEYREQID					@"REQID"

@protocol UIImageManagerDelegate<NSObject>
@optional
// 加载图片完毕: 根据需要可实现两者中任意一种方法即可
// 返回UIImage类型
-(void)UIImageManagerDoneLoading:(UIImage *)img WithType:(IconType)iType;
// 返回NSData类型
-(void)UIImageManagerDoneLoadingWithData:(NSData *)imgData andType:(IconType)iType;
// 加载
@end

@interface UIImageManager : NSObject<IconDownloaderDelegate> {
	id<UIImageManagerDelegate>	myUIIMageManagerDelegate;
	BOOL				searchFromLocal;
	IconDownloader		*headImageDownloader;
	IconDownloader		*imageDownloader;
	IconDownloader		*videoImageDownloader;
	IconDownloader		*sourceImageDownloader;
	IconDownloader		*sourceVideoImageDownloader;
	//IconDownloader		*sourceHeadImageDownloader;
}

@property (nonatomic, assign) BOOL		searchFromLocal;

+(NSDictionary *)cachedHeadImages;
// 获取默认图片
+ (UIImage *)defaultImage:(IconType)iType;
// 获取缓存图片
+ (UIImage *)cachedImage:(IconType)iType forUrl:(NSString *)strUrl;
// 获取默认图片(缓存中有图片则从缓存中取)
+ (UIImage *)defaultImage:(IconType)iType forUrl:(NSString *)strUrl;

- (id)initWithDelegate:(id)delegate;
// 取消当前所有请求
- (void)cancelAllIconDownloading;
// 根据url获取图像
// 由于图片绑定到了消息中，需要一并传消息id，以便存储
- (void)startGettingImageWithParam:(NSDictionary *)param;
- (void)startGettingImageWithUrl:(NSString *)strUrl requestID:(NSString *)rID andType:(IconType)iType;
// 转换成基本图片类型: 头像，图片，视频
// 注: 由于派生类类型跟基本类型不一样，需要进行转换
//- (IconType)convertToBaseImageType:(IconType)iType;
// 从网络加载图片数据
- (void)getImageWithParam:(NSDictionary *)param;
// 从本地加载图片数据
-(UIImage *)getImageFromDB:(NSString *)strUrl WithType:(IconType)iType;
// 缓存图片到数据库
-(void)saveImageToDB:(NSData *)imgData WithBaseInfo:(NSDictionary *)param;
@end
