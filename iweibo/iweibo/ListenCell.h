//
//  ListenCell.h
//  iweibo
//
//  Created by ZhaoLilong on 2/1/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Asyncimageview.h"
#import "ListenIdolList.h"
#import "ColorUtil.h"
#import "CommentView.h"
#import "IconDownloader.h"

#define SINGLELINEVERTICALPOS 18		// 单行时起始坐标
#define DOUBLELINEVERTICALPOS 10	// 两行时起始坐标

@interface ListenCell : UITableViewCell<IconDownloaderDelegate> {
	UIImageView		*vipView;		// vip视图
	ListenIdolList			*listenIdolList;	// 用户信息数据
	UIImageView                     *headView;		// 头像视图
	IconDownloader                  *headImageDownloader;   // 头像下载对象
	IconStatus                      enumHeadStatus;         // 头像加载状态
}

@property (nonatomic, retain) UIImageView		*vipView;
@property (nonatomic, retain) ListenIdolList		*listenIdolList;
@property (nonatomic, retain) UIImageView                       *headView;
@property (nonatomic, retain) IconDownloader                    *headImageDownloader;

// 添加视图
- (void)addSubviews;

// 获取最大宽度
- (CGFloat)getMaxWidth:(CGSize)nameSize andLocationSize:(CGSize)locationSize;
// 开始下载图片资源
- (void)startIconDownload;
@end
