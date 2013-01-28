//
//  SourceViewEx.m
//  iweibo
//
//  Created by Minwen Yi on 4/13/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "SourceViewEx.h"
#import "HomePage.h"
#import "iweiboAppDelegate.h"
#import "ImageLink.h"
#import "VideoLink.h"
#import "ColorUtil.h"
#import "PhotoView.h"
#import "ZoomView.h"
#import "DetailPageConst.h"
#import "PushAndRequest.h"
#import "TimelinePageConst.h"
#import "HotTopicDetailController.h"
#import "TimeTrack.h"
#import "HotBroadcastInfo.h"
#import "UIImageManager.h"
#import "IWBGifImageCache.h"

@implementation SourceViewEx
@synthesize imageViewEx, videoImageEx;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		[imageView removeFromSuperview];
		[videoImageEx removeFromSuperview];
		// 添加图片
		imageViewEx = [[IWBGifImageView alloc] init];
		self.layer.borderColor = [UIColor colorWithRed:0.827 green:0.843 blue:0.855 alpha:1].CGColor;
		self.backgroundColor = [UIColor colorWithRed:0.945 green:0.949 blue:0.953 alpha:1];
		imageViewEx.tag = ImageTag;
		imageViewEx.userInteractionEnabled = YES;
		[self addSubview:imageViewEx];
		
		// 添加视频缩略图
		videoImageEx = [[IWBGifImageView alloc] init];
		videoImageEx.contentMode = UIViewContentModeScaleToFill;
		videoImageEx.tag = videoImageTag;
		videoImageEx.userInteractionEnabled = YES;
		[self addSubview:videoImageEx];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	self.imageViewEx = nil;
	self.videoImageEx = nil;
    [super dealloc];
}

// 绘制转发图片
- (void)drawPicture {
	for (NSInteger i = 0; i < [imageViewEx.subviews count]; i++) {
		UIImageView *image = [imageViewEx.subviews objectAtIndex:i];
		[image removeFromSuperview]; 
		image = nil;
	}
	if (!self.hasImage) {
		imageViewEx.hidden = YES;
		return;
	}
	imageViewEx.hidden = NO;
	// 初始化x,y方向坐标
	position.x = 5;
	position.y += VSpaceBetweenVideoAndText;
	// 1.设置图片url
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhoto:)];
	[imageViewEx addGestureRecognizer:tapGesture];
	[tapGesture release];
	
	// 2. 区分不同显示类型进行相关设置
	switch (self.sourceStyle) {
		case HotBroadcastSourceStyle: {
			// 主timeLine
			[imageView setLink:transInfo.transImage];
			// 加载图片
			//if (nil == transInfo.sourceImageData || 0 == [transInfo.sourceImageData length]) {
			if (YES) {
				[imageView setFrame:CGRectMake(5, position.y, DefaultImageWidth, DefaultImageHeight)];
				// 只有url的情况下，从数据库或者网络异步加载
				NSData *data = nil;
				data =[HotBroadcastInfo mySourceImageDataWithUrl:transInfo.transImage];
				if ([data length]>4) {
					[imageView addImageFromData:nil viewLocation:0];
					[imageView addImageFromData:data viewLocation:0];
				}
				else {
					//	[imageView addImageFromData:nil];
					self.hasLoadedImage = NO;
					[imageView loadImageFromURL:[NSString stringWithFormat:@"%@/%d",transInfo.transImage, TLUrlImageRequestSize] 
									   withType:multiMediaTypeHotBroadcastSrcImage 
										 userId:transInfo.transId];
				}
			}
			else {
				// 参考广播处理方式
			}				
			// x座标偏移量: 图片宽度(75)+间隔(10)
			//position.y += DefaultImageHeight;
			//position.y += VSBetweenSourceImageAndText;
			position.x += DefaultImageWidth + TLHSBetweenImageAndVideo;
		}
			break;
			
		case HomeSourceSytle:		{
			// 主timeLine
			[imageViewEx setLink:transInfo.transImage];
			// 加载图片
			//if (nil == transInfo.sourceImageData || 0 == [transInfo.sourceImageData length]) {
			if (YES) {
				[imageViewEx setFrame:CGRectMake(5, position.y, DefaultImageWidth, DefaultImageHeight)];
				imageViewEx.image = [UIImageManager defaultImage:ICON_SOURCE_IMAGE];
			}
			else {
				// 参考广播处理方式
			}				
			// x座标偏移量: 图片宽度(75)+间隔(10)
			//position.y += DefaultImageHeight;
			//position.y += VSBetweenSourceImageAndText;
			position.x += DefaultImageWidth + TLHSBetweenImageAndVideo;
		}
			break;
		case BroadSourceSytle:		{
			// 单条消息页
			// 计算视频高度
			CGFloat virticalSpace = 0.0f;
			if (self.hasVideo) {
				// 有视频无数据时用默认高度
				if (nil == transInfo.sourceVideoData || 0 == [transInfo.sourceVideoData length]) {
					virticalSpace += VSBetweenImageAndVideo + DefaultImageHeight;
				}
				else {
					// 否则用视频当前高度
					UIImage *originVideo = [[UIImage alloc] initWithData:transInfo.sourceVideoData];
					virticalSpace += originVideo.size.height / 2.0f + VSBetweenImageAndVideo;
					[originVideo release];
				}					
			}
			// 加载图片
			if (nil == transInfo.sourceImageData || 0 == [transInfo.sourceImageData length]) {
				position.x = (DPOriginTextWidth - DefaultImageWidth) / 2.0f;
				NSString *urlString = [[NSString alloc] initWithFormat:@"%@/%d",transInfo.transImage,DPUrlImageRequestSize];
				NSData *gifData = [[IWBGifImageCache sharedImageCache] imageFromKey:urlString fromDisk:YES];
				[urlString release];
				if (gifData) {
					[imageViewEx setGIFData:gifData];
				}
				else{
					[imageView setFrame:CGRectMake(position.x, position.y + virticalSpace, DefaultImageWidth, DefaultImageHeight)];
					//self.labelLocation = position.y + virticalSpace;
					self.hasLoadedImage = NO;
					UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(27.0f, 27.0f, 25.0f, 25.0f)];
					[activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
					[imageViewEx addSubview:activityIndicator];
					[activityIndicator startAnimating];
					[activityIndicator release];
					[imageView setLink:transInfo.transImage];
					[imageView loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%d",transInfo.transImage, DPUrlImageRequestSize]] 
									   withType:multiMediaTypeSourceImage 
										 userId:transInfo.transId 
										refresh:YES];
				}
				
				[imageViewEx setLink:transInfo.transImage];
				[imageViewEx setFrame:CGRectMake(position.x, position.y + virticalSpace, DefaultImageWidth, DefaultImageHeight)];
				imageViewEx.image = [UIImageManager defaultImage:ICON_SOURCE_IMAGE];
				
				// 4. 计算label偏移高度
				self.labelLocation =  position.y + virticalSpace + DefaultImageHeight + VSBetweenSourceImageAndText;
			}
			else {
				// info.imageImageData非空表示已经从网络加载过数据,执行的图片刷新操作
				// 1. 求取图片规格
				UIImage *imageSrc = [[UIImage alloc] initWithData:transInfo.sourceImageData];
				//assert(imageSrc);
				if (imageSrc != nil) {
					// 2. 假如有视频，预留视频高度(视频在上边)
					CGFloat imageWidth = DefaultImageWidth;
					if (imageSrc.size.width / 2.0f > MaxImageHeight) {
						// 大于MaxImageHeight，用MaxImageHeight
						position.x = (DPOriginTextWidth - MaxImageHeight) / 2.0f;
						imageWidth = MaxImageHeight;
					}
					else{
						// 最小为DefaultImageWidth
						position.x = (DPOriginTextWidth - imageSrc.size.width / 2.0f) / 2.0f;
						imageWidth = imageSrc.size.width / 2.0f;
					}
					self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
					// ４为边框保留
					self.imageView.frame = CGRectMake(position.x - ImageFrameWidth, position.y + virticalSpace, imageWidth + 2 * ImageFrameWidth, imageSrc.size.height / 2.0f + 2 * ImageFrameWidth);
					// 3. 加载图片
					//[imageView setLink:transInfo.transImage];
//					//[imageView addImageFromData:transInfo.sourceImageData viewLocation:1];
//					[imageView addImageFromData:transInfo.sourceImageData viewLocation:1 withFrame:YES];
//					[imageSrc release];
					for (NSInteger i = 0; i < [imageViewEx.subviews count]; i++) {
						UIView *v = [imageViewEx.subviews objectAtIndex:i]; 
						[v removeFromSuperview]; 
						v = nil;
					}
					[imageViewEx setLink:transInfo.transImage];
					//[imageView addImageFromData:info.imageImageData viewLocation:1];
					[imageViewEx setGIFData:transInfo.sourceImageData];
					//边框
					UIImageView *imgBg = [[UIImageView alloc]initWithFrame:CGRectMake(position.x - ImageFrameWidth, position.y + virticalSpace, imageWidth + 2 * ImageFrameWidth, imageSrc.size.height / 2.0f + 2 * ImageFrameWidth)];
					imgBg.backgroundColor = [UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
					UIImageView* imageViewBack = [[UIImageView alloc]initWithFrame:CGRectMake(ImageFrameWidth / 2.0f, ImageFrameWidth / 2.0f, 
																							  imgBg.bounds.size.width - ImageFrameWidth, imgBg.bounds.size.height - ImageFrameWidth)];
					[imgBg addSubview:imageViewBack];
					[imageViewBack release];
					imageViewBack.backgroundColor = [UIColor whiteColor];
					[self addSubview:imgBg];
					[self sendSubviewToBack:imgBg];
					[imgBg release];
					imageViewEx.frame = CGRectMake(position.x , position.y + virticalSpace + ImageFrameWidth, imgBg.frame.size.width - 2 * ImageFrameWidth, imgBg.frame.size.height - 2 * ImageFrameWidth);
					
					[imageSrc release];
					// 4. 计算label偏移高度
					self.labelLocation = imageViewEx.frame.origin.y + imageViewEx.frame.size.height + 2*ImageFrameWidth + VSBetweenSourceImageAndText;
					
				}
				else {
					position.x = (DPOriginTextWidth - DefaultImageWidth) / 2.0f;
					[videoImage setFrame:CGRectMake(position.x - ImageFrameWidth, position.y + virticalSpace, DefaultImageWidth + 2 * ImageFrameWidth, DefaultImageHeight + 2 * ImageFrameWidth)];
					[imageView setLink:transInfo.transImage];
					[imageView addImageFromData:nil viewLocation:1 withFrame:YES];
					self.labelLocation = imageView.frame.origin.y + imageView.frame.size.height + 2*ImageFrameWidth + VSBetweenSourceImageAndText;
					
				}
				// lichntao 2012-02-21 发送通知，告诉DetailCell图片从本地加载
				[[NSNotificationCenter defaultCenter] postNotificationName:@"getPictureDownLoadingFinished" object:nil];
			}
			
		}
			break;
		case MsgSourceSytle:{
			// @提及我的
			// 加载图片
			NSLog(@"msgNick:%@\tmsgImage:%@",transInfo.transNick,transInfo.transImage);
			if (YES) {
				[imageView setFrame:CGRectMake(10, position.y, DefaultImageWidth, DefaultImageHeight)];
				// 只有url的情况下，从数据库或者网络异步加载
				NSData *data = nil;
				data =[TransInfo myMsgSourceImageDataWithUrl:transInfo.transImage];
				if ([data length]>4) {
					[imageView addImageFromData:nil viewLocation:0];
					[imageView addImageFromData:data viewLocation:0];
				}
				else {
					//	[imageView addImageFromData:nil];
					self.hasLoadedImage = NO;
					[imageView setLink:transInfo.transImage];
					[imageView loadImageFromURL:[NSString stringWithFormat:@"%@/%d",transInfo.transImage, TLUrlImageRequestSize] 
									   withType:multiMediaTypeMsgSourceImage 
										 userId:transInfo.transId];
				}
			}
			else {
				// 参考广播处理方式
			}				
			// x座标偏移量: 图片宽度(75)+间隔(10)
			//position.y += DefaultImageHeight;
			//position.y += VSBetweenSourceImageAndText;
			position.x += TLHSBetweenImageAndVideo + DefaultImageWidth;	
		}
			break;
		default:
			break;
	}
	
}

- (void)clearItems {
	// 清除子视图
	for (UIView *_view in self.subviews) {
		if ([_view isMemberOfClass:[UILabel class]]
			||[_view isMemberOfClass:[UIButton class]]
			||[_view isMemberOfClass:[UIImageView class]]
			) {
			if (_view != videoImageEx && _view != imageViewEx) {
				[_view removeFromSuperview];
				_view = nil;
			}
		}
	}
}



-(void)addVideoPlayImageWithRul:(NSString *)url {
	// 播放图片
	// 添加播放箭头
	UIImageView *playImage = [[UIImageView alloc] init];
	//CLog(@"%s, videoImage.frame.size.origin.x:%f, y:%f videoImage.frame.size.width:%f, videoImage.frame.size.height:%f", 
	//		 videoImage.frame.origin.x, videoImage.frame.origin.y, videoImage.frame.size.width, videoImage.frame.size.height);
	playImage.frame = CGRectMake((videoImageEx.frame.size.width - DefaultPlayBtnWidth) / 2.0f, 
								 (videoImageEx.frame.size.height - DefaultPlayBtnHeight) / 2.0f, 
								 DefaultPlayBtnWidth, 
								 DefaultPlayBtnHeight);
	playImage.image = [UIImage imageNamed:@"未标题-2.png"];
	[videoImageEx addSubview:playImage];
	[playImage release];
}

// 绘制视频图片
- (void)drawVideoPic {
	if (!hasVideo) {
		videoImageEx.hidden = YES;
		return;
	}
	videoImageEx.hidden = NO;
	for (NSInteger i = 0; i < [videoImageEx.subviews count]; i++) {
		UIImageView *image = [videoImageEx.subviews objectAtIndex:i]; 
		[image removeFromSuperview]; 
		image = nil;
	}
	// 初始化坐标
	if (!self.hasImage) {
		position.y += VSBetweenSourceImageAndText;
	}
	
	// 区分不同显示类型进行相关设置
	switch (self.sourceStyle) {
		case HotBroadcastSourceStyle: {
			if (YES) {
				[videoImage setFrame:CGRectMake(position.x, position.y, DefaultImageWidth, DefaultImageHeight)];
				// 只有url的情况下，从数据库或者网络异步加载
				NSData *data = nil;
				data =[HotBroadcastInfo mySourceVideoDataWithUrl:transInfo.transVideo];
				if ([data length]>4) {
					[videoImage addVideoFromData:nil];
					[videoImage addVideoFromData:data];
					[self addVideoPlayImageWithRul:transInfo.transVideoRealUrl];
				}
				else {
					self.hasLoadedVideo = NO;
					[videoImage loadImageFromURL:transInfo.transVideo withType:multiMediaTypeHotBroadcastSrcVideo userId:transInfo.transId];
				}		
			}
			else {
				// 参考广播处理方式
			}		
			position.y += DefaultImageHeight + VSBetweenSourceImageAndText;
		}
			break;
		case HomeSourceSytle:	{
			// 主timeLine
			// 加载视频缩略图
			//if (nil == info.videoImageData || 0 == [info.videoImageData length]) {
			if (YES) {
				[videoImageEx setFrame:CGRectMake(position.x, position.y, DefaultImageWidth, DefaultImageHeight)];
				videoImageEx.image = [UIImageManager defaultImage:ICON_SOURCE_VIDEO_IMAGE];
				[self addVideoPlayImageWithRul:transInfo.transVideoRealUrl];
					
			}
			else {
				// 参考广播处理方式
			}		
			position.y += DefaultImageHeight + VSBetweenSourceImageAndText;
		}
			break;
		case MsgSourceSytle:{
			// @提及我的
			// 加载视频缩略图
			//if (nil == info.videoImageData || 0 == [info.videoImageData length]) {
			if (YES) {
				[videoImage setFrame:CGRectMake(position.x, position.y, DefaultImageWidth, DefaultImageHeight)];
				// 只有url的情况下，从数据库或者网络异步加载
				NSData *data = nil;
				data =[TransInfo mySourceVideoDataWithUrl:transInfo.transVideo];
				if ([data length]>4) {
					[videoImage addVideoFromData:nil];
					[videoImage addVideoFromData:data];
					[self addVideoPlayImageWithRul:transInfo.transVideoRealUrl];
				}
				else {
					//	[videoView addVideoFromData:nil];
					self.hasLoadedVideo = NO;
					[videoImage loadImageFromURL:transInfo.transVideo withType:multiMediaTypeMsgSourceVideo userId:transInfo.transId];
				}		
			}
			else {
				// 参考广播处理方式
			}		
			position.y += DefaultImageHeight + VSBetweenSourceImageAndText;
		}
			break;
		case BroadSourceSytle: {
			// 详细页面视频缩略图
			if (nil == transInfo.sourceVideoData || 0 == [transInfo.sourceVideoData length]) {
				// 从网络加载
				// 只有url的情况下，从数据库或者网络异步加载
				//NSData *data = nil;
				//data =[TransInfo mySourceVideoDataWithUrl:transInfo.transVideo];
				//if ([data length]>4) {
				if (NO) {
					// 2012-02-21 By Yi Minwen 广播类型直接从网络加载 
					// 图片对应尺寸发生变化，不读取数据库
					//					UIImage *imageVideo = [[UIImage alloc] initWithData:data];
					//					assert(imageVideo);
					//					// 2. 假如有视频，预留视频高度(视频在上边)
					//					CGFloat imageWidth = DefaultImageWidth;
					//					if (imageVideo.size.width / 2.0f > MaxImageHeight) {
					//						// 大于MaxImageHeight，用MaxImageHeight
					//						position.x = (DPOriginTextWidth - imageVideo.size.width / 2.0f) / 2.0f;
					//						imageWidth = MaxImageHeight;
					//					}
					//					else{
					//						// 最小为DefaultImageWidth
					//						position.x = (DPOriginTextWidth - imageVideo.size.width / 2.0f) / 2.0f;
					//						imageWidth = imageVideo.size.width / 2.0f;
					//					}
					//					//	CLog(@"imageVideo.imageWidth:%f position.x:%f", imageVideo.size.width, position.x);
					//					self.videoImage.frame = CGRectMake(position.x , position.y, imageWidth, imageVideo.size.height / 2.0f);
					//					[videoImage addImageFromData:data viewLocation:1];
					//					[imageVideo release];
				}
				else {
					//	[videoView addVideoFromData:nil];
					self.hasLoadedVideo = NO;
					videoImage.frame = CGRectMake((DPOriginTextWidth - DefaultImageWidth) / 2.0f , position.y, DefaultImageWidth, DefaultImageHeight);
					
					[videoImage loadImageFromURL:[NSURL URLWithString:transInfo.transVideo]  
										withType:multiMediaTypeSourceVideo 
										  userId:transInfo.transId
										 refresh:YES];
				}
				position.y += DefaultImageHeight + VSBetweenSourceImageAndText;
			}
			else {
				// 从数据流加载
				// 1. 求取图片规格
				UIImage *imageVideo = [[UIImage alloc] initWithData:transInfo.sourceVideoData];
				if (imageVideo != nil) {
					// 2. 假如有视频，预留视频高度(视频在上边)
					CGFloat imageWidth = DefaultImageWidth;
					if (imageVideo.size.width / 2.0f > MaxImageHeight) {
						// 大于MaxImageHeight，用MaxImageHeight
						position.x = (DPOriginTextWidth - imageVideo.size.width / 2.0f) / 2.0f;
						imageWidth = MaxImageHeight;
					}
					else{
						// 最小为DefaultImageWidth
						position.x = (DPOriginTextWidth - imageVideo.size.width / 2.0f) / 2.0f;
						imageWidth = imageVideo.size.width / 2.0f;
					}
					//self.videoImage.frame = CGRectMake(position.x , position.y, imageWidth, imageVideo.size.height / 2.0f);
//					// 3. 加载图片
//					[videoImage addImageFromData:transInfo.sourceVideoData viewLocation:1];
//					[self addVideoPlayImageWithRul:transInfo.transVideoRealUrl];
					[videoImageEx setFrame:CGRectMake(position.x , position.y, imageWidth, imageVideo.size.height / 2.0f)];
					videoImageEx.image = imageVideo;
					[self addVideoPlayImageWithRul:transInfo.transVideoRealUrl];
					
					// 4. 计算label偏移高度
					//self.labelLocation = position.y + imageSrc.size.height / 2.0f;
					position.y += imageVideo.size.height / 2.0f + VSBetweenSourceImageAndText;
					[imageVideo release];
					
				}
				else {
					// 视频加载异常的情况
					position.x = (DPOriginTextWidth - DefaultImageWidth) / 2.0f;
					[videoImage setFrame:CGRectMake(position.x, position.y, DefaultImageWidth, DefaultImageHeight)];
					[videoImage addVideoFromData:nil];
					[self addVideoPlayImageWithRul:transInfo.transVideoRealUrl];
					position.y += DefaultImageHeight + VSBetweenSourceImageAndText;
				}
				
			}	
		}
			break;
		default:
			break;
	}
	// 添加点击响应
	videoImageEx.hidden = NO;
	videoImageEx.userInteractionEnabled = YES;
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapVideo:)];
	[videoImageEx setLink:transInfo.transVideoRealUrl];
	[videoImageEx addGestureRecognizer:tapGesture];
	[tapGesture release];
	if (!hasImage) {
		self.labelLocation = videoImageEx.frame.origin.y + videoImageEx.frame.size.height + VSBetweenSourceImageAndText;
	}	
}

// 点击图片
- (void) tapPhoto:(UITapGestureRecognizer *)gesture{
	NSLog(@"gesture:%@",((UIImageView *)gesture.view).link);
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
	NSString *url = [NSString stringWithFormat:@"%@",((UIImageView *)gesture.view).link];
	switch (self.sourceStyle) {
		case HotBroadcastSourceStyle: {
			PhotoView *photoView = [[PhotoView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) withUrl:url];
			photoView.imageData = [TransInfo mySourceImageDataWithUrl:transInfo.transImage];
			[delegate.window addSubview:photoView];
			[photoView release];
		}
			break;
		case HomeSourceSytle: {
			PhotoView *photoView = [[PhotoView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) withUrl:url];
			photoView.imageData = [TransInfo mySourceImageDataWithUrl:transInfo.transImage];
			[delegate.window addSubview:photoView];
			[photoView release];
		}
			break;
		case BroadSourceSytle: {		
			delegate.draws = 0;			// 2012-3-12 zhaolilong 处理导航栏
			ZoomView *zoomView = [[ZoomView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
			zoomView.imageUrl = url;
			[delegate.window addSubview:zoomView];
			[zoomView release];
		}
			break;
		case MsgSourceSytle:{
			PhotoView *photoView = [[PhotoView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) withUrl:url];
			photoView.imageData = [TransInfo myMsgSourceImageDataWithUrl:transInfo.transImage];
			[delegate.window addSubview:photoView];
			[photoView release];			
		}
			break;
		default:
			break;
	}	
}

-(void)addMainText {
	if (self.sourceStyle == BroadSourceSytle) {
		[super addMainText];
		return;
	}
	// 文本处理
	NSString *sourceOrigtext = self.transInfo.transOrigtext;
	if (sourceOrigtext != nil) {
		NSMutableArray *arrItem = (NSMutableArray *)[[SourceView srcViewUnitItemDic] objectForKey:transInfo.transId];
		for (MessageUnitItemInfo *unitItem in arrItem) {
			switch (unitItem.itemType) {
				case TypeEmotion: {
					position = unitItem.itemPos;
					position.x += 5;	// 边距
					UIImage *emotion = [UIImage imageNamed:unitItem.itemText];
					UIImageView	*emotionView = nil;
					BOOL bNeedAddToView = NO;
					if ([arrImagesFree count] > 0) {
						emotionView = [[arrImagesFree objectAtIndex:0] retain];
						[arrImagesFree removeObjectAtIndex:0];
						emotionView.hidden = NO;
					}
					else {
						bNeedAddToView = YES;
						emotionView = [[UIImageView alloc] init];
					}
					emotionView.image = emotion;
					emotionView.tag = EmotionViewTag;
					CGFloat xPos = position.x;
					CGFloat eWidth = EmotionImageWidth;
					if (EmotionImageWidth > emotion.size.width) {
						xPos += (EmotionImageWidth - emotion.size.width) / 2.0f;
						eWidth = emotion.size.width;
					}
					emotionView.frame = CGRectMake(xPos, position.y, eWidth , emotion.size.height);
					if (isLongPress) {
						emotionView.backgroundColor = [UIColor greenColor];
					}
					else {
						emotionView.backgroundColor = [UIColor colorWithRed:0.945 green:0.949 blue:0.953 alpha:1];
					}
					if (bNeedAddToView) {
						[self addSubview:emotionView];
					}
					[arrImagesInUse addObject:emotionView];
					[emotionView release];		
					// 添加表情后坐标偏移
					position.x += EmotionImageWidth;
				}
					break;
				case TypeNickName:
				case TypeHttpLink:
				case TypeTopic: {
					position = unitItem.itemPos;
					position.x += 5;	// 边距
					[self addLink:position withTmpString:unitItem.itemText withString:unitItem.itemLink withType:unitItem.itemType];
					position.x += [unitItem.itemText sizeWithFont:textFont].width;
				}
					break;
				case TypeText: {
//                    CLog(@"%s, %@", __FUNCTION__, unitItem);
					position = unitItem.itemPos;
					position.x += 5;	// 边距
					UILabel *lb = nil;
					BOOL bNeedAddToView = NO;
					if ([arrLablesFree count] > 0) {
						lb = [[arrLablesFree objectAtIndex:0] retain];
						[arrLablesFree removeObjectAtIndex:0];
						lb.hidden = NO;
					}
					else {
						bNeedAddToView = YES;
						lb = [[UILabel alloc] init];
						lb.textColor = [UIColor colorStringToRGB:[NSString stringWithFormat:@"%d",OriginTextColor]];
						lb.tag = TextLabelTag;
						lb.font = textFont;
					}
					CGSize strSize = [unitItem.itemText sizeWithFont:textFont];
					// 文本距离右边屏幕间距为DPTimeRightSpaceWidth, 距离顶部边框宽度VSBetweenOriginTextAndFrame
					lb.text = unitItem.itemText;
                    lb.lineBreakMode = UILineBreakModeCharacterWrap;
                    lb.numberOfLines = 0;
                    CGRect rc = CGRectMake(position.x, position.y, unitItem.itemRect.size.width, unitItem.itemRect.size.height);
                    lb.frame = rc;
					if (isLongPress) {
						lb.backgroundColor = [UIColor greenColor];
					}						
					else {
						lb.backgroundColor = [UIColor colorWithRed:0.945 green:0.949 blue:0.953 alpha:1];
					}

					if (bNeedAddToView) {
						[self addSubview:lb];
					}
					[arrLablesInUse addObject:lb];
					[lb release];	
					position.x += strSize.width;
				}
					break;
				default:
					break;
			}
		}
		if (position.x == self.frameWidth) {
			position.x = 5;
			CGFloat wordHeight = [@"我" sizeWithFont:textFont].height;		// 文本高度
			position.y += wordHeight;
		}
	}
}

@end
