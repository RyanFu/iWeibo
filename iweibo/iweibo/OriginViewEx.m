//
//  OriginViewEx.m
//  iweibo
//
//  Created by Minwen Yi on 4/13/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "OriginViewEx.h"
#import "VideoLink.h"
#import "iweiboAppDelegate.h"
#import "PhotoView.h"
#import "ImageLink.h"
#import "DetailPageConst.h"
#import "TimelinePageConst.h"
#import "HotBroadcastInfo.h"
#import "PushAndRequest.h"
#import "HotTopicDetailController.h"
#import "HomePage.h"
#import "HotBroadcastInfo.h"
#import "TimeTrack.h"
#import "UIImageManager.h"
#import "IWBGifImageCache.h"

@implementation OriginViewEx
@synthesize imageViewEx, videoViewEx;
@synthesize myOriginViewMapDelegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		[imageView removeFromSuperview];
		[videoView removeFromSuperview];
		// 添加图片
		imageViewEx = [[IWBGifImageView alloc] init];
		imageViewEx.contentMode = UIViewContentModeScaleToFill;
		imageViewEx.tag = ImageTag;
		imageViewEx.userInteractionEnabled = YES;
		[self addSubview:imageViewEx];
		// 添加视频图片
		videoViewEx = [[IWBGifImageView alloc] init];
		videoViewEx.contentMode = UIViewContentModeScaleToFill;
		videoViewEx.tag = videoImageTag;
		videoViewEx.userInteractionEnabled = YES;
		[self addSubview:videoViewEx];
		
    }
    return self;
}

- (void)dealloc {
	self.imageViewEx = nil;
	self.videoViewEx = nil;
    [super dealloc];
}


// 绘制图片
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
	position.x = TLHSBetweenOriginFrameAndImage;
	position.y += VSpaceBetweenVideoAndText;
	// 1.设置图片url
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhoto:)];
	[imageViewEx addGestureRecognizer:tapGesture];
	[tapGesture release];
	// 2. 区分不同显示类型进行相关设置
	switch (self.showStyle) {
		case HotBroadcastShowStyle:		{
			// 主timeLine
			// 加载图片
			//if (nil == transInfo.sourceImageData || 0 == [transInfo.sourceImageData length]) {
			if (YES) {
				[imageView setFrame:CGRectMake(position.x, position.y, DefaultImageWidth, DefaultImageHeight)];
				// 只有url的情况下，从数据库或者网络异步加载
				NSData *data = [HotBroadcastInfo myHotBroadCastImageDataWithUrl:info.image];
				[imageView setLink:info.image];
				if ([data length]>4) {
					[imageView addImageFromData:nil viewLocation:0];
					[imageView addImageFromData:data viewLocation:0];
				}
				else {
					self.hasLoadedImage = NO;
					[imageView loadImageFromURL:[NSString stringWithFormat:@"%@/%d",info.image,TLUrlImageRequestSize] 
									   withType:multiMediaTypeHotBroadcastImage 
										 userId:info.uid];
				}
			}
			else {
				// 参考广播处理方式
			}
			// x座标偏移量: 图片宽度(75)+间隔(10)
			position.x += TLHSBetweenImageAndVideo + DefaultImageWidth;
		}
			break;
		case HomeShowSytle:		{
			// 主timeLine
			// 加载图片
			//if (nil == transInfo.sourceImageData || 0 == [transInfo.sourceImageData length]) {
			if (YES) {
				[imageViewEx setLink:info.image];
				[imageViewEx setFrame:CGRectMake(position.x, position.y, DefaultImageWidth, DefaultImageHeight)];
				imageViewEx.image = [UIImageManager defaultImage:ICON_ORIGIN_IMAGE];
			}
			else {
				// 参考广播处理方式
			}
			// x座标偏移量: 图片宽度(75)+间隔(10)
			position.x += TLHSBetweenImageAndVideo + DefaultImageWidth;
		}
			break;
		case BroadSourceSytle:		{
			// 单条消息页
			// 计算视频高度
			CGFloat virticalSpace = 0.0f;
			if (self.hasVideo) {
				// 有视频无数据时用默认高度
				if (nil == info.videoImageData || 0 == [info.videoImageData length]) {
					virticalSpace += VSBetweenImageAndVideo + DefaultImageHeight;
				}
				else {
					// 否则用视频当前高度
					UIImage *originVideo = [[UIImage alloc] initWithData:info.videoImageData];
					virticalSpace += originVideo.size.height / 2.0f + VSBetweenImageAndVideo;
					[originVideo release];
				}					
			}
			// 加载图片
			if (nil == info.imageImageData || 0 == [info.imageImageData length]) {
				position.x = (DPOriginTextWidth - DefaultImageWidth) / 2.0f;
				
				[imageViewEx setLink:info.image];
				[imageViewEx setFrame:CGRectMake(position.x, position.y + virticalSpace, DefaultImageWidth, DefaultImageHeight)];
				imageViewEx.image = [UIImageManager defaultImage:ICON_ORIGIN_IMAGE];
				
				NSString *urlString = [[NSString alloc] initWithFormat:@"%@/%d",info.image,DPUrlImageRequestSize];
				NSData *gifData = [[IWBGifImageCache sharedImageCache] imageFromKey:urlString fromDisk:YES];
				[urlString release];
				if (gifData) {
					[imageViewEx setGIFData:gifData];
				}
				else {
					UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(27.0f, 27.0f, 25.0f, 25.0f)];
					[activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
					[imageViewEx addSubview:activityIndicator];
					[activityIndicator startAnimating];
					[activityIndicator release];
					[imageView setFrame:CGRectMake(position.x, position.y + virticalSpace, DefaultImageWidth, DefaultImageHeight)];
					//self.labelLocation = position.y + virticalSpace;
					self.hasLoadedImage = NO;
					[imageView setLink:info.image];
					[imageView loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%d",info.image,DPUrlImageRequestSize]] 
									   withType:multiMediaTypeImage 
										 userId:info.uid 
										refresh:YES];
				}
			}
			else {
				// info.imageImageData非空表示已经从网络加载过数据,执行的图片刷新操作
				// 1. 求取图片规格
				UIImage *imageSrc = [[UIImage alloc] initWithData:info.imageImageData];
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
					// 4.0f为边框宽度
					self.imageView.frame = CGRectMake(position.x - ImageFrameWidth, position.y + virticalSpace, imageWidth + 2 * ImageFrameWidth, imageSrc.size.height / 2.0f + 2 * ImageFrameWidth);
					// 3. 加载图片
					for (NSInteger i = 0; i < [imageViewEx.subviews count]; i++) {
						UIView *v = [imageViewEx.subviews objectAtIndex:i]; 
						[v removeFromSuperview]; 
						v = nil;
					}
					[imageViewEx setLink:info.image];
					//[imageView addImageFromData:info.imageImageData viewLocation:1];
					[imageViewEx setGIFData:info.imageImageData];
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
					
					
					// 4. 计算label偏移高度
					//self.labelLocation = position.y + imageSrc.size.height / 2.0f;
					[imageSrc release];
				}
				else {
					position.x = (DPOriginTextWidth - DefaultImageWidth) / 2.0f;
					[imageView setFrame:CGRectMake(position.x - ImageFrameWidth, position.y + virticalSpace, DefaultImageWidth + 2 * ImageFrameWidth, DefaultImageHeight + 2 * ImageFrameWidth)];
					[imageView setLink:info.image];
					//[imageView addImageFromData:info.imageImageData viewLocation:1];
					[imageView addImageFromData:nil viewLocation:1 withFrame:YES];
				}
				//lichentao 2012-02-21 发送通知，告诉DetailCell图片从本地加载
				[[NSNotificationCenter defaultCenter] postNotificationName:@"getPictureDownLoadingFinished" object:nil];
			}
			// x座标偏移量:(视频总是居中显示，修改x无实际意义)
			//position.x += TLHSBetweenImageAndVideo + DefaultImageWidth;
		}
			break;
		case MsgShowSytle:{
			
			// 消息页面加载图片
			//if (nil == transInfo.sourceImageData || 0 == [transInfo.sourceImageData length]) {
			if (YES) {
				[imageView setFrame:CGRectMake(position.x, position.y, DefaultImageWidth, DefaultImageHeight)];
				// 只有url的情况下，从数据库或者网络异步加载
				NSData *data = [Info myMsgImageDataWithUrl:info.image];
				[imageView setLink:info.image];
				if ([data length]>4) {
					[imageView addImageFromData:nil viewLocation:0];
					[imageView addImageFromData:data viewLocation:0];
				}
				else {
					self.hasLoadedImage = NO;
					[imageView loadImageFromURL:[NSString stringWithFormat:@"%@/%d",info.image,TLUrlImageRequestSize] 
									   withType:multiMediaTypeMsgImage 
										 userId:info.uid];
				}
			}
			else {
				// 参考广播处理方式
			}
			// x座标偏移量: 图片宽度(75)+间隔(10)
			position.x += TLHSBetweenImageAndVideo + DefaultImageWidth;
		}
			break;
		default:
			break;
	}
	imageViewEx.hidden = NO;
}


-(void)addVideoPlayImageWithRul:(NSString *)url {
	// 播放图片
	UIImageView *playImage = [[UIImageView alloc] init];
	[playImage setLink:url];
	playImage.userInteractionEnabled = YES;
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapVideo:)];
	[playImage addGestureRecognizer:tapGesture];
	[tapGesture release];
	
	playImage.frame = CGRectMake((videoViewEx.frame.size.width - DefaultPlayBtnWidth) / 2.0f, 
								 (videoViewEx.frame.size.height - DefaultPlayBtnHeight) / 2.0f, 
								 DefaultPlayBtnWidth, 
								 DefaultPlayBtnHeight);
	playImage.image = [UIImage imageNamed:@"未标题-2.png"];
	[videoViewEx addSubview:playImage];
	[playImage release];
}

- (void)drawVideoPic {//添加视频图片及点击事件
	
	for (NSInteger i = 0; i < [videoViewEx.subviews count]; i++) {
		UIImageView *image = [videoViewEx.subviews objectAtIndex:i];
		[image removeFromSuperview]; 
		image = nil;
	}
	if (!hasVideo) {
		videoViewEx.hidden = YES;
		return;
	}
	videoViewEx.hidden = NO;
	
	// 初始化坐标
	if (!self.hasImage) {
		position.y += VSpaceBetweenVideoAndText;
	}
	DataManager *dataManager = [[DataManager alloc] init];
	videoUrl *vUrl = [dataManager manageVideoInfo:info.video];
	// 区分不同显示类型进行相关设置
	switch (self.showStyle) {
		case HotBroadcastShowStyle: {
			// 热门广播
			// 加载图片
			//if (nil == info.videoImageData || 0 == [info.videoImageData length]) {
			if (YES) {
				[videoView setFrame:CGRectMake(position.x, position.y, DefaultImageWidth, DefaultImageHeight)];
				// 只有url的情况下，从数据库或者网络异步加载
				NSData *data = nil;
				data =[HotBroadcastInfo myHotBroadCastVideoDataWithUrl:vUrl.picurl];
				if ([data length]>4) {
					[videoView addVideoFromData:nil];
					[videoView addVideoFromData:data];
					[self addVideoPlayImageWithRul:vUrl.realurl];
				}
				else {
					//	[videoView addVideoFromData:nil];
					self.hasLoadedVideo = NO;
					[videoView loadImageFromURL:[NSString stringWithFormat:@"%@", vUrl.picurl] withType:multiMediaTypeHotBroadcastVideo userId:info.uid];
				}			
			}
			else {
				// 参考广播处理方式
			}	
		}
			break;
		case HomeShowSytle:	{
			// 主timeLine
			// 加载图片
			//if (nil == info.videoImageData || 0 == [info.videoImageData length]) {
			if (YES) {
				[videoViewEx setFrame:CGRectMake(position.x, position.y, DefaultImageWidth, DefaultImageHeight)];
				videoViewEx.image = [UIImageManager defaultImage:ICON_ORIGIN_VIDEO_IMAGE];
				[self addVideoPlayImageWithRul:vUrl.realurl];
			}
			else {
				// 参考广播处理方式
			}			
		}
			break;
		case BroadShowSytle: {
			if (nil == info.videoImageData || 0 == [info.videoImageData length]) {
				// 从网络加载
				// 只有url的情况下，从数据库或者网络异步加载
				//NSData *data = nil;
				//				data =[Info myVideoDataWithUrl:vUrl.picurl];
				//if ([data length]>4) {
				if (NO) {
					// 图片对应尺寸发生变化，不读取数据库
					//UIImage *imageVideo = [[UIImage alloc] initWithData:data];
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
					//				//	CLog(@"imageVideo.imageWidth:%f position.x:%f", imageVideo.size.width, position.x);
					//					self.videoView.frame = CGRectMake(position.x , position.y, imageWidth, imageVideo.size.height / 2.0f);
					//					[videoView addImageFromData:data viewLocation:1];
					//					[imageVideo release];
				}
				else {
					//	[videoView addVideoFromData:nil];
					self.hasLoadedVideo = NO;
					videoView.frame = CGRectMake((DPOriginTextWidth - DefaultImageWidth) / 2.0f , position.y, DefaultImageWidth, DefaultImageHeight);
					[videoView loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", vUrl.picurl]]  
									   withType:multiMediaTypeVideo 
										 userId:info.uid 
										refresh:YES];
				}
			}
			else {
				// 从数据流加载
				// 1. 求取图片规格
				UIImage *imageVideo = [[UIImage alloc] initWithData:info.videoImageData];
				//assert(imageVideo);
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
					//CLog(@"imageVideo.size.width:%f position.x:%f position.y", imageVideo.size.width, position.x);
					self.videoView.frame = CGRectMake(position.x , position.y, imageWidth, imageVideo.size.height / 2.0f);
					// 3. 加载图片
					[videoView addImageFromData:info.videoImageData viewLocation:1];
					[self addVideoPlayImageWithRul:vUrl.realurl];
					// 4. 计算label偏移高度
					//self.labelLocation = position.y + imageSrc.size.height / 2.0f;
					[imageVideo release];
				}
				else {
					// 视频加载异常的情况
					position.x = (DPOriginTextWidth - DefaultImageWidth) / 2.0f;
					[videoView setFrame:CGRectMake(position.x, position.y, DefaultImageWidth, DefaultImageHeight)];
					[videoView addImageFromData:nil viewLocation:1];
					[self addVideoPlayImageWithRul:vUrl.realurl];
				}
				
			}	
		}
			break;
		case MsgShowSytle:
			// 消息页面加载图片
			//if (nil == info.videoImageData || 0 == [info.videoImageData length]) {
			if (YES) {
				[videoView setFrame:CGRectMake(position.x, position.y, DefaultImageWidth, DefaultImageHeight)];
				// 只有url的情况下，从数据库或者网络异步加载
				NSData *data = nil;
				data =[Info myMsgVideoDataWithUrl:vUrl.picurl];
				if ([data length]>4) {
					[videoView addVideoFromData:nil];
					[videoView addVideoFromData:data];
					[self addVideoPlayImageWithRul:vUrl.realurl];
				}
				else {
					//	[videoView addVideoFromData:nil];
					self.hasLoadedVideo = NO;
					[videoView loadImageFromURL:[NSString stringWithFormat:@"%@", vUrl.picurl] withType:multiMediaTypeMsgVideo userId:info.uid];
				}			
			}
			else {
				// 参考广播处理方式
			}	
			break;
		default:
			break;
	}
	[dataManager release];	
	videoViewEx.hidden = NO;
	[videoViewEx setLink:vUrl.realurl];
}

//-(void)clearItems {
//	for (UIView *_view in self.subviews) {
//		if (
//			//[_view isMemberOfClass:[UILabel class]]
//			//||[_view isMemberOfClass:[UIButton class]]
//			[_view isMemberOfClass:[UIImageView class]]
//			) {
//			if (_view != videoViewEx && _view != imageViewEx) {
//				[_view removeFromSuperview];
//				_view = nil;
//			}
//		}
//	}
//}

//点击图片
- (void) tapPhoto:(UITapGestureRecognizer *)gesture{
	//NSLog(@"gesture:%@",((AsyncImageView *)gesture.view).link);
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
	NSString *url = [NSString stringWithFormat:@"%@",((UIImageView *)gesture.view).link];
	switch (self.showStyle) {
		case HotBroadcastShowStyle: {
			PhotoView *photoView = [[PhotoView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) withUrl:url]; 
			photoView.imageData = [HotBroadcastInfo myImageDataWithUrl:info.image];
			[delegate.window addSubview:photoView];
			[photoView release];
		}
			break;
		case HomeShowSytle: {
			PhotoView *photoView = [[PhotoView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) withUrl:url]; 
			photoView.imageData = [Info myImageDataWithUrl:info.image];
//			[UIView beginAnimations:nil context:nil];
//			[UIView setAnimationDelay:0.5];
			[delegate.window addSubview:photoView];
//			[UIView commitAnimations];
			[photoView release];
		}
			break;
		case BroadShowSytle: {		
			delegate.draws = 0;	// 2012-3-12 zhaolilong 处理导航栏
			ZoomView *zoomView = [[ZoomView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
			zoomView.imageUrl = url;
			[delegate.window addSubview:zoomView];
			[zoomView release];
		}
			break;
		case MsgShowSytle:{
			PhotoView *photoView = [[PhotoView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) withUrl:url]; 
			photoView.imageData = [Info myMsgImageDataWithUrl:info.image];
			[delegate.window addSubview:photoView];
			[photoView release];
		}
			break;
		default:
			break;
	}	
}

-(void)addMainText {
	if (BroadShowSytle == self.showStyle) {
		[super addMainText];
		return;
	}
	if (info.origtext!=nil) {
		NSMutableArray *arrItem = (NSMutableArray *)[[OriginView originViewUnitItemDic] objectForKey:info.uid];
		for (MessageUnitItemInfo *unitItem in arrItem) {
				switch (unitItem.itemType) {
					case TypeEmotion: {
						position = unitItem.itemPos;
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
						emotionView.tag = EmotionViewTag ;
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
							emotionView.backgroundColor = [UIColor whiteColor];
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
						[self addLink:position withTmpString:unitItem.itemText withString:unitItem.itemLink withType:unitItem.itemType];
						position.x += [unitItem.itemText sizeWithFont:textFont].width;
					}
						break;
					case TypeText: {
//                        CLog(@"%s, %@", __FUNCTION__, unitItem);
						position = unitItem.itemPos;
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
						//lb.font = textFont;
						CGSize strSize = [unitItem.itemText sizeWithFont:textFont];
						// 文本距离右边屏幕间距为DPTimeRightSpaceWidth, 距离顶部边框宽度VSBetweenOriginTextAndFrame
						lb.text = unitItem.itemText;
                        lb.lineBreakMode = UILineBreakModeCharacterWrap;
                        lb.numberOfLines = 0;
						lb.frame = unitItem.itemRect;
						if (isLongPress) {
							lb.backgroundColor = [UIColor greenColor];
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
		if (position.x == frameWidth) {
			position.x = 0;
			//position.y += 25;
			CGFloat wordHeight = [@"我" sizeWithFont:textFont].height;		// 文本高度
			position.y += wordHeight;
		}
	}
}
-(void)showCutDownMap       //地图缩略图，等待调用
{
    
    
    MKMapView * cutDownMap = [[MKMapView alloc] initWithFrame:CGRectMake(10, 10, 300, 150)];
    cutDownMap.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    cutDownMap.delegate = self;
    [cutDownMap setMapType:MKMapTypeStandard];
    CLLocationCoordinate2D userCenter;
    userCenter.latitude = 40.052913;
    userCenter.longitude = 116.298437;
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.1;
    span.longitudeDelta = 0.1;
    
    cutDownMap.zoomEnabled = NO;
    cutDownMap.scrollEnabled = NO;
    
    MKCoordinateRegion theRegion = {userCenter, span};
    [cutDownMap setRegion:theRegion animated:YES];
    
    MKPointAnnotation	* pinAnnotation = [[MKPointAnnotation alloc] init];
    pinAnnotation.coordinate = userCenter;
    [cutDownMap addAnnotation:pinAnnotation];
    [pinAnnotation release];

    
    
    UIImageView * bgImageView = [[UIImageView alloc] init]; //frame等待添加
    bgImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showaMplifyingMap:)];
    [bgImageView addGestureRecognizer:click];
    [bgImageView setBackgroundColor:[UIColor whiteColor]];
    [bgImageView addSubview:cutDownMap];
    [self addSubview:bgImageView];
    [cutDownMap release];
    [bgImageView release];
    [click release];
    
    
}

-(void)showaMplifyingMap:(CLLocationCoordinate2D)theCenter
{
    if ([self.myOriginViewMapDelegate respondsToSelector:@selector(OrignViewMapClicked:)]) {
        [self.myOriginViewMapDelegate OrignViewMapClicked:theCenter];
    }
    
}

-(void)showAddress      //小地图下方地址信息，等待调用
{
    
    UIView * bgView = [[UIView alloc] init];    //frame等待添加
    UIImageView * leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
    leftImage.image = nil;//图片等待添加
    UILabel * addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 15)];
    [addrLabel sizeToFit];
    addrLabel.text = @"北京市海淀区 软件园六号路";
    
    [bgView addSubview:leftImage];
    [bgView addSubview:addrLabel];
    [self addSubview:bgView];
    
    [leftImage release];
    [addrLabel release];
    [bgView release];
    
    
}





@end
