//
//  PhotoView.h
//  iweibo
//
//  Created by ZhaoLilong on 1/31/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoomView.h"
#import "iweiboAppDelegate.h"
#import "IWBGifImageView.h"

@interface PhotoView : UIView <UIScrollViewDelegate>{
	int						_received;						// 接收到的长度
	BOOL					hasLoaded;						// 已经加载
	NSData					*imageData;						// 图片数据
	UILabel					*percentLabel;					// 百分比标签
	CGSize					originSize;						// 原来的大小
	CGPoint					originCenter;						// 原来的中心
	UIButton					*zoomBtn;						// 查看原图按钮
	UIImage					*mImage;						// 图片视图的图片
	NSString				*url;								// url地址
	long long				_total;							// 接收到的总长度
	ZoomView				*zoomView;						// 查看原图视图
	UIScrollView				*mScrollView;					// 滚动视图
	IWBGifImageView			*mImageView;					// 要显示的图片视图
	NSMutableData			*receivedData;					// 接收的数据
	NSURLConnection		*conn;							// 请求连接
	iweiboAppDelegate		*delegate;						// 代理
	UIActivityIndicatorView	*indicatorView;					// 加载动画
}

@property(nonatomic, retain) NSString	*url;

@property(nonatomic, retain) NSData	*imageData;

@property(nonatomic, assign) BOOL	hasLoaded;

// 加载图片
- (void)loadImage;

// 查看原图
- (void)zoomPhoto:(id)sender;

// 点击图片响应
- (void)tap:(UITapGestureRecognizer *)gesture;

// 捏合手势响应
- (void)pinch:(UIPinchGestureRecognizer *)gesture;

// 初始化方法
- (id)initWithFrame:(CGRect)frame withUrl:(NSString *)url;	

// 存储gif图片
- (void)storeGifToCache:(NSData *)gifImageData;
 
//按规格要求显示图片
- (void)showImageView:(UIImage *)mImage;

@end
