//
//  ZoomView.h
//  iweibo
//
//	原图查看
//
//  Created by ZhaoLilong on 1/31/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "IWBGifImageView.h"

@interface ZoomView : UIView<UIScrollViewDelegate> {
	int					_received;				// 接收到的数据长度
	long long			_total;					// 请求总共的数据长度
	BOOL				isHidden;				// 隐藏标识
	BOOL				isFirst;					// 第一次点击标识
	BOOL				isScaled;				// 放大标识
	BOOL				hasLoaded;				// 加载标识
	BOOL				hasSaved;				// 保存标识
	BOOL				enableSave;				// 保存可点击标识
	UILabel				*percentLabel;			// 百分比标签
	NSString			*imageUrl;				// 图片url
	UIImage				*mImage;				// 图片视图的图片
	CGFloat				m_imageWidth;			// 图片宽度
	CGFloat				m_imageHeight;			// 图片高度
	UIScrollView			*mScrollView;			// 滚动视图
	UIImageView		*picView;				// 图片视图
	IWBGifImageView		*mImageView;			// 图片视图
	UIProgressView		*progressView;			// 进度条视图
	NSMutableData		*receivedData;			// 接收到的数据
	UINavigationBar		*navigationBar;			// 导航条
	UINavigationItem	*navigationItem;
	MBProgressHUD		*progressHUD;			// 加载动画视图
	NSURLConnection	*conn;					// 请求的连接
}

@property (nonatomic, retain) UIProgressView *progressView;

@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, retain) UIImage *mImage;

@property (nonatomic, retain) IWBGifImageView *mImageView;

@property (nonatomic, assign) BOOL hasLoaded;
 
// 加载图片
- (void)loadImage;	

// 存储gif图片
- (void)storeGifToCache:(NSData *)gifImageData;

// 隐藏延迟
- (void)hideDelayed;	

// 保存按钮响应
- (void)save:(id)sender;	

// 返回按钮响应
- (void)back:(id)sender;

// 单击响应
- (void)singleTap:(UITapGestureRecognizer *)gesture;

// 双击响应
- (void)doubleTap:(UITapGestureRecognizer *)gesture;
 
@end
