//
//  HomelineCellEx.m
//  iweibo
//
//  Created by Minwen Yi on 4/13/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "HomelineCellEx.h"
#import "OriginViewEx.h"
#import "SourceViewEx.h"
#import "TimelinePageConst.h"
#import "DetailPageConst.h"
#import <QuartzCore/QuartzCore.h>

@implementation HomelineCellEx
@synthesize imgManager;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier showStyle:(OriginShowSytle)style1 sourceStyle:(SourceShowSytle)style2 containHead:(BOOL)contain{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier showStyle:style1 sourceStyle:style2 containHead:contain];
	if (self) {
		[originView removeFromSuperview];
		[originView release];
		originView = [[OriginViewEx alloc] init];		// 原创视图初始化
		if (!self.hasHead) {
			originView.hasPortrait = NO;			// 原创头像标识
		}
		originView.showStyle = style1;				// 原创类型
		originView.myOriginVideoDelegate = self;    // 原创视频代理
		[self.contentView addSubview:originView];   // 添加原创视图
		[sourceView removeFromSuperview];
		[sourceView release];
		sourceView = [[SourceViewEx alloc] init];		// 转发视图初始化
		if (!self.hasHead) {
			sourceView.hasPortrait = NO;			// 转发头像标识
		}
		sourceView.sourceStyle = style2;			// 转发类型
		sourceView.mySrcVideoDelegate = self;       // 转发视频代理
		[self.contentView addSubview:sourceView];  // 添加转发视图
		// 
		[iconView removeFromSuperview];
		[iconView release];
		iconView = [[UIImageView alloc] init];
		if (self.hasHead) {// 如果有头像
			// 添加点击手势及圆角处理
			UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHead:)];
			iconView.layer.masksToBounds = YES;
			iconView.layer.cornerRadius = 3.0f;
			iconView.tag = 001;
			iconView.frame = CGRectMake(5, 7.5, ICON_WIDTH, ICON_HEIGHT);
			iconView.userInteractionEnabled = YES;
			[iconView addGestureRecognizer:tapGesture];
			[tapGesture release];
			[self.contentView addSubview:iconView];	
		}
		
		imgManager = [[UIImageManager alloc] initWithDelegate:self];
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	[imgManager cancelAllIconDownloading];
	[imgManager release];
	imgManager = nil;
    [super dealloc];
}


-(void)setHomeInfo:(Info *)info{
	[imgManager cancelAllIconDownloading];
	enumHeadStatus = IconDefault;
	enumOriginImageStatus = IconDefault;
	enumOriginVideoImgStatus = IconDefault;
	enumSrcImageStatus = IconDefault;
	enumSrcVideoStatus = IconDefault;
	//if (homeInfo) {
	//		[homeInfo release];
	//	}
	//		homeInfo = [info retain];
	homeInfo = info;
	// 读取视图高度
	NSMutableDictionary *dic = [heightDic objectForKey:remRow];
	originHeight = [[dic objectForKey:@"origHeight"] floatValue];
	sourceHeight = [[dic objectForKey:@"sourceHeight"] floatValue];
	
	if (self.hasHead) {
		leftMargin = ICON_LEFT_MARGIN + ICON_RIGHT_MARGIN + ICON_WIDTH;
		originView.frame = CGRectMake(leftMargin, 0, TLOriginTextWidth,originHeight);
	}else {
		leftMargin = 10.0f;
		originView.frame = CGRectMake(leftMargin, 0, DPOriginTextWidth,originHeight);
	}
	
	//如果数据库没有，从网络请求
	((UIImageView *)iconView).image = [UIImageManager defaultImage:ICON_HEAD forUrl:homeInfo.head];	
	originView.info = info;
	originView.controllerType = self.rootContrlType;
	userName = info.name;
	[commentView removeFromSuperview];
	[commentNumLabel removeFromSuperview];
}

// 开始下载图片资源
- (void)startIconDownload {
	[imgManager cancelAllIconDownloading];
	if (IconDoneDownloading != enumHeadStatus) {
		enumHeadStatus = IconInDownloading;
		[imgManager startGettingImageWithUrl:homeInfo.head requestID:homeInfo.uid andType:ICON_HEAD];
	}
	// 图片加载
	if (originView.hasImage && IconDoneDownloading != enumOriginImageStatus) {
		enumOriginImageStatus = IconInDownloading;
		[imgManager startGettingImageWithUrl:homeInfo.image requestID:homeInfo.uid andType:ICON_ORIGIN_IMAGE];
	}
	if (originView.hasVideo && IconDoneDownloading != enumOriginVideoImgStatus) {
		DataManager *dataManager = [[DataManager alloc] init];
		videoUrl *vUrl = [dataManager manageVideoInfo:homeInfo.video];
		enumOriginVideoImgStatus = IconInDownloading;
		[imgManager startGettingImageWithUrl:vUrl.picurl requestID:homeInfo.uid andType:ICON_ORIGIN_VIDEO_IMAGE];
		[dataManager release];
	}
	if (NO == sourceView.hidden && sourceView.hasImage && IconDoneDownloading != enumSrcImageStatus) {
		enumSrcImageStatus = IconInDownloading;
		[imgManager startGettingImageWithUrl:sourceInfo.transImage requestID:sourceInfo.transId andType:ICON_SOURCE_IMAGE];
	}
	if (NO == sourceView.hidden && sourceView.hasVideo && IconDoneDownloading != enumSrcVideoStatus) {
		enumSrcVideoStatus = IconInDownloading;
		[imgManager startGettingImageWithUrl:sourceInfo.transVideo requestID:sourceInfo.transId andType:ICON_SOURCE_VIDEO_IMAGE];
		
	}
}

#pragma mark protocol UIImageManagerDelegate<NSObject>
// 加载图片完毕
-(void)UIImageManagerDoneLoading:(UIImage *)imgSrc WithType:(IconType)iType {
	UIImage *img = imgSrc;
	// 处理长图
	if (iType != ICON_HEAD) {
		if (imgSrc != nil) {
			CGImageRef myImage;
			if (YES) {
				if (imgSrc.size.height > imgSrc.size.width) {
					myImage = CGImageCreateWithImageInRect([imgSrc CGImage],CGRectMake(0, 0, imgSrc.size.width, imgSrc.size.width));
					img = [UIImage imageWithCGImage:myImage];
				}else{
					myImage = CGImageCreateWithImageInRect([imgSrc CGImage],CGRectMake(0, 0, imgSrc.size.height, imgSrc.size.height));
					img = [UIImage imageWithCGImage:myImage];
				}
			}else {
				myImage = CGImageCreateWithImageInRect([imgSrc CGImage],CGRectMake(0, 0, imgSrc.size.width, imgSrc.size.height));
				img = [UIImage imageWithCGImage:myImage];
			}
			CGImageRelease(myImage);
		}
		else {
			img = [UIImageManager defaultImage:iType];
		}
	}
	if (nil == imgSrc) {
		img = [UIImageManager defaultImage:iType];	 // 如果没图显示默认图片
	}
	switch (iType) {
		case ICON_HEAD: {
			if (img) {
				CGFloat iwidth = ICON_WIDTH;
				CGFloat iheight = ICON_HEIGHT;
				// 2012-05-13 By Yiminwen img缓存后，经过下边变形，显示图片会变模糊
				//if (img.size.width != iwidth && img.size.height != iheight)
				if (NO){
					CGSize itemSize = CGSizeMake(iwidth, iheight);
					UIGraphicsBeginImageContext(itemSize);
					CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
					[img drawInRect:imageRect];
					((UIImageView *)iconView).image = UIGraphicsGetImageFromCurrentImageContext();
					
					UIGraphicsEndImageContext();
				}
				else
				{
					((UIImageView *)iconView).image = img;
				}	
			}
			enumHeadStatus = IconDoneDownloading;
		}
			break;
			
		case ICON_ORIGIN_IMAGE: {
			OriginViewEx *originViewEx = (OriginViewEx *)originView;
			originViewEx.imageViewEx.image = img;
			enumOriginImageStatus = IconDoneDownloading;
		}
			break;
		case ICON_ORIGIN_VIDEO_IMAGE: {
			OriginViewEx *originViewEx = (OriginViewEx *)originView;
			originViewEx.videoViewEx.image = img;
			enumOriginVideoImgStatus = IconDoneDownloading;
			
		}
			break;
		case ICON_SOURCE_IMAGE: {
			SourceViewEx *srcEx = (SourceViewEx *)sourceView;
			srcEx.imageViewEx.image = img;
			enumSrcImageStatus = IconDoneDownloading;
		}
			break;
		case ICON_SOURCE_VIDEO_IMAGE: {
			SourceViewEx *srcEx = (SourceViewEx *)sourceView;
			srcEx.videoImageEx.image = img;
			enumSrcVideoStatus = IconDoneDownloading;
		}
			break;
		default:
			break;
	}
	
}

@end
