//
//  Asyncimageview.h
//  iweibo
//
//  Created by ZhaoLilong on 12/30/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol AsyncImageViewDelegate<NSObject>
//
//- (void)requestDataDidFinished:(NSData *)data withId:(NSString *) idString withUrl:(NSString *)urlString withKey:(NSString *)key;
//
//@end
#define headTag			100
#define imageTag		101
#define videoTag		102

typedef enum MultiMediaType {
	multimediatypeNone = 0,		
	multiMediaTypeHead = 4,			// 头像
	multiMediaTypeVideo = 5,			// 原创视频
	multiMediaTypeImage = 6,		// 原创图片
	multiMediaTypeSourceImage = 7,	// 转发图片
	multiMediaTypeSourceVideo = 8,	// 转发视频
	
	multiMediaTypeMsgHead,			// 消息页头像
	multiMediaTypeMsgImage,		// 消息页图片
	multiMediaTypeMsgVideo,		// 消息页视频
	multiMediaTypeMsgSourceImage,	// 消息页转发图片
	multiMediaTypeMsgSourceVideo,	// 消息页转发视频
	multiMediaTypeHotBroadcastHead,		// 热门广播头像缩略图
	multiMediaTypeHotBroadcastImage,	// 热门广播图像
	multiMediaTypeHotBroadcastVideo,	// 热门广播视频缩略图
	multiMediaTypeHotBroadcastSrcImage,	// 热门广播图像
	multiMediaTypeHotBroadcastSrcVideo,	// 热门广播视频缩略图
	
}MultiMediaType;

// 代理方法声明
@protocol AsyncImageViewDelegate;
@protocol TapHeadDelegate;

@interface AsyncImageView : UIView {
	NSURLConnection	  *connection;	// URL链接
	NSMutableData		  *data;			// 返回数据
	NSString			  *keyUrl;		
	MultiMediaType		  requestType;	// 请求类型
	NSString			  *requestId;		// 请求id
	UIImage				  *mImage;		// 图片
//	UIImageView			  *imageViewBack;
	BOOL				  refresh;		// 刷新标识
	NSString			  *videoLink;		// 视频链接
	UIActivityIndicatorView *activityIndicator;// 加载显示标识
	
	id<TapHeadDelegate>			myTapHeadDelegate;	
	id<AsyncImageViewDelegate>		myAsyncImageViewDelegate;	// 2012-02-09 By Yi Minwen
}

@property (nonatomic, retain) NSURLConnection			*connection;
@property (nonatomic, assign) BOOL						  refresh;
@property (nonatomic, retain)	 UIImage					  *mImage;
@property (nonatomic, copy)	 NSString				         *keyUrl;
@property (nonatomic, copy)    NSString					  *requestId;
@property (nonatomic, copy)	 NSString					  *videoLink;
@property (nonatomic, assign) MultiMediaType			         requestType;
@property (nonatomic, retain)  UIActivityIndicatorView		  *activityIndicator;
@property (nonatomic, assign) id<TapHeadDelegate>		  myTapHeadDelegate;
@property (nonatomic, assign) id<AsyncImageViewDelegate>  myAsyncImageViewDelegate;

// 生成image
- (UIImage*) image;
// 生成小图
- (UIImage *)smallImage:(UIImage*)bigImg;
// 从数据添加视频
- (void)addVideoFromData:(NSData *)mediaData;
// 从数据添加图片
//- (void)addImageFromData:(NSData *)mediaData;
// 从数据添加头像
- (void)addHeadImageFromData:(NSData *)imageData;
// 根据不同页面位置添加图片
- (void)addImageFromData:(NSData *)imageData viewLocation:(NSUInteger)location;
// 根据不同页面位置添加图片
// bFrame:是否加边框
- (void)addImageFromData:(NSData *)imageData viewLocation:(NSUInteger)location withFrame:(BOOL)bFrame;
// 将图片处理成指定大小
- (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size;
//处理多媒体音频，视频，头像信息
- (void)handleMediaData:(NSString *)url;
// 根据类型和url加载图片
- (void)loadImageFromURL:(NSURL*)url withType:(MultiMediaType)type;
// 根据类型、url和用户id加载图片
- (void)loadImageFromURL:(NSString*)url withType:(MultiMediaType)type userId:(NSString *)userId;
- (void)loadVideoImageFromURL:(NSString*)url withType:(MultiMediaType)type userId:(NSString *)userId;
// 根据类型、url、用户id和刷新条件加载图片
- (void)loadImageFromURL:(NSURL*)url withType:(MultiMediaType)type userId:(NSString *)userId refresh:(BOOL)refresh;

@end

@protocol AsyncImageViewDelegate<NSObject>
@optional
// 图片加载完毕委托方法
-(void)AsyncImageViewHasLoadedImage:(NSData *)dataRef;
// 视频对应图片加载完毕委托方法
-(void)AsyncImageViewHasLoadedVideo:(NSData *)dataRef;
@end

@protocol TapHeadDelegate<NSObject>
@optional
// 点击头像代理
- (void)tapHead:(UITapGestureRecognizer *)gesture;
@end


