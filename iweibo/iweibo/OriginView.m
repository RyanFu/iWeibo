//
//  OriginView.m
//  iweibo
//
//  Created by ZhaoLilong on 1/9/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "OriginView.h"
#import "VideoLink.h"
#import "iweiboAppDelegate.h"
#import "PhotoView.h"
#import "ImageLink.h"
#import "DetailPageConst.h"
#import "TimelinePageConst.h"
#import "HotBroadcastInfo.h"
#import "PushAndRequest.h"
#import "HotTopicDetailController.h"
#import "IWBGifImageCache.h"
#import "IWBGifImageView.h"
#import "HomePage.h"
#import "HotBroadcastInfo.h"
#import "TimeTrack.h"
#import "MessageFrameConsts.h"

static NSMutableDictionary			*orgingHeightStatic = nil;
static NSMutableDictionary			*g_mArrUnitItems = nil;
@implementation OriginView
@synthesize controllerType;
@synthesize info;
@synthesize imageView,videoView;
@synthesize showStyle;
@synthesize myOriginUrlDelegate, myOriginVideoDelegate;
@synthesize myOriginViewDelegate;
@synthesize isLongPress;


+(NSMutableDictionary *)originViewUnitItemDic {
	if (nil == g_mArrUnitItems) {
		g_mArrUnitItems = [[NSMutableDictionary alloc] initWithCapacity:30];
	}
	return g_mArrUnitItems;
}

+(NSMutableDictionary *) orgingHeight{
	if (orgingHeightStatic == nil) {
		orgingHeightStatic = [[NSMutableDictionary alloc] init];
	}
	return orgingHeightStatic;
}

- (void)draw:(NSString *)strText withType:(NSUInteger)type{
	//CLog(@"++++++++++%s string:%@ position.x:%f, position.y:%f", __FUNCTION__, string, position.x, position.y);
	int lineWidth = 0;//长度初始化
	CGSize wordSize;
	CGFloat wordHeight = [@"我" sizeWithFont:textFont].height;		// 文本高度
	NSString *string = strText;
	if (type == 0) {
		NSMutableDictionary *dic = [HomePage nickNameDictionary];
		//for (NSString *key in dic) {
//			NSLog(@"名称:%@,昵称:%@",key,[dic valueForKey:key]);
//		}
		NSString *userName = strText;	
		if ([dic isKindOfClass:[NSDictionary class]]) {
			if ([userName hasPrefix:@"@"] && [userName length] > 1) {
				NSString *trueName = [userName substringFromIndex:[userName rangeOfString:@"@"].location+1];
				NSString *nickName = [dic objectForKey:trueName];
				if (nickName != nil && [nickName isKindOfClass:[NSString class]]) {
					string = nickName;
				}
				else {
					string = userName;
					type = 4;	// 没有对应名字则显示文字
				}
			}
			else {
				string = userName;
			}
		}
		else {
			string = userName;
		}
	}
	else if (type == 4) {//普通文本字符串特殊字符替换
		string = [strText stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
		string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
		string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
		string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
		string = [string stringByReplacingOccurrencesOfString:@"&39;" withString:@"\'"];
		string = [string stringByReplacingOccurrencesOfString:@"：" withString:@":"];
	}
	else {
		string = strText;
	}

	if (type==1){
		//绘制相应的表情
		NSString *imageString = [emoDic objectForKey:string];
		UIImage *emotion = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageString]];
		if (position.x > frameWidth - EmotionImageWidth) {
				//position.y += 25;
			position.y += wordHeight;
			position.y += VerticalSpaceBetweenText;
			position.x = 0;
		}
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
			emotionView.backgroundColor = [UIColor whiteColor];
		}
		if (bNeedAddToView) {
			[self addSubview:emotionView];
		}
		[arrImagesInUse addObject:emotionView];
		[emotionView release];		
		// 添加表情后坐标偏移
		position.x += EmotionImageWidth;
	}else {
			//绘制其他文本类型
		NSMutableString *tmpString = [NSMutableString stringWithCapacity:30];
		if ((int)[string sizeWithFont:textFont].width <= frameWidth - position.x) {
			if (type == 4) {
				// lichentao判断是否长按，如果长按则将文字加载到label上，否则直接绘制到originview上
				UILabel *strLabel = nil;
				BOOL bNeedAddToView = NO;
				if ([arrLablesFree count] > 0) {
					strLabel = [[arrLablesFree objectAtIndex:0] retain];
					[arrLablesFree removeObjectAtIndex:0];
					strLabel.hidden = NO;
				}
				else {
					bNeedAddToView = YES;
					strLabel = [[UILabel alloc] init];
					strLabel.textColor = [UIColor colorStringToRGB:[NSString stringWithFormat:@"%d",OriginTextColor]];
					strLabel.tag = TextLabelTag;
				}
				strLabel.font = textFont;
				CGSize strSize = [string sizeWithFont:textFont];
				// 文本距离右边屏幕间距为DPTimeRightSpaceWidth, 距离顶部边框宽度VSBetweenOriginTextAndFrame
				strLabel.text = string;
				strLabel.frame = CGRectMake(position.x, position.y, strSize.width, strSize.height);
				if (isLongPress) {
					strLabel.backgroundColor = [UIColor greenColor];
				}						
				if (bNeedAddToView) {
					[self addSubview:strLabel];
				}
				[arrLablesInUse addObject:strLabel];
				[strLabel release];
			}else if (type == 0) {
				//NSLog(@"tmpString:%@",tmpString);
				[self addLink:position withTmpString:string withString:strText withType:type];
			}else {
				[self addLink:position withTmpString:string withString:string withType:type];
			}

			position.x += [string sizeWithFont:textFont].width;
			if (position.x == frameWidth) {
				position.x = 0;
					//position.y += 25;
				position.y += wordHeight;
			}
		}else {//一个画不下 
			for (int i = 0; i < [string length]; i++) {
				NSString *subString = [string substringWithRange:NSMakeRange(i, 1)];
				wordSize = [subString sizeWithFont:textFont];
				if (lineWidth + wordSize.width > frameWidth - position.x) {
					if (type == 4) {
						// lichentao
						UILabel *strLabel = nil;
						BOOL bNeedAddToView = NO;
						if ([arrLablesFree count] > 0) {
							strLabel = [[arrLablesFree objectAtIndex:0] retain];
							[arrLablesFree removeObjectAtIndex:0];
							strLabel.hidden = NO;
						}
						else {
							bNeedAddToView = YES;
							strLabel = [[UILabel alloc] init];
							strLabel.textColor = [UIColor colorStringToRGB:[NSString stringWithFormat:@"%d",OriginTextColor]];
							strLabel.tag = TextLabelTag;
						}
						strLabel.font = textFont;
						CGSize strSize = [tmpString sizeWithFont:textFont];
						// 文本距离右边屏幕间距为DPTimeRightSpaceWidth, 距离顶部边框宽度VSBetweenOriginTextAndFrame
						strLabel.text = tmpString;
						strLabel.frame = CGRectMake(position.x, position.y, strSize.width, strSize.height);
						if (isLongPress) {
						strLabel.backgroundColor = [UIColor greenColor];
						}
						if (bNeedAddToView) {
							[self addSubview:strLabel];
						}
						[arrLablesInUse addObject:strLabel];
						[strLabel release];

					}else if (type == 0) {
						//NSLog(@"tmpString:%@",tmpString);
						[self addLink:position withTmpString:tmpString withString:strText withType:type];
					}else {
						[self addLink:position withTmpString:tmpString withString:string withType:type];
					}
					[tmpString deleteCharactersInRange:NSMakeRange(0, [tmpString length])];
					lineWidth = 0;
					position.x = 0;
					position.y += wordSize.height;
				}
				lineWidth += wordSize.width;
				[tmpString appendString:subString];
			}	
			if ([tmpString length] > 0) {//绘制剩余字符串
		//		NSLog(@"tmpStringFromDraw:%@",tmpString);
				if (type == 4) {
					UILabel *strLabel = nil;
					BOOL bNeedAddToView = NO;
					if ([arrLablesFree count] > 0) {
						strLabel = [[arrLablesFree objectAtIndex:0] retain];
						[arrLablesFree removeObjectAtIndex:0];
						strLabel.hidden = NO;
					}
					else {
						bNeedAddToView = YES;
						strLabel = [[UILabel alloc] init];
						strLabel.textColor = [UIColor colorStringToRGB:[NSString stringWithFormat:@"%d",OriginTextColor]];
						strLabel.tag = TextLabelTag;
					}
					strLabel.font = textFont;
					CGSize strSize = [tmpString sizeWithFont:textFont];
					// 文本距离右边屏幕间距为DPTimeRightSpaceWidth, 距离顶部边框宽度VSBetweenOriginTextAndFrame
					strLabel.text = tmpString;
					strLabel.frame = CGRectMake(position.x, position.y, strSize.width, strSize.height);
					//strLabel.textColor = [UIColor colorWithRed:0.502f green:0.502f blue:0.502f alpha:1];
					if (isLongPress) {
					strLabel.backgroundColor = [UIColor greenColor];
					}
					if (bNeedAddToView) {
						[self addSubview:strLabel];
					}
					[arrLablesInUse addObject:strLabel];
					[strLabel release];
				}else if (type == 0) {
					//NSLog(@"tmpString:%@",tmpString);
					[self addLink:position withTmpString:tmpString withString:strText withType:type];
				}else {
					[self addLink:position withTmpString:tmpString withString:string withType:type];
				}
				position.x += [tmpString sizeWithFont:textFont].width;
			}			
		}
	}	
	//CLog(@"---------------------%s position.x:%f, position.y:%f", __FUNCTION__, position.x, position.y);
}

// 绘制图片
- (void)drawPicture {
	for (NSInteger i = 0; i < [imageView.subviews count]; i++) {
		UIImageView *image = [imageView.subviews objectAtIndex:i];
		[image removeFromSuperview]; 
		image = nil;
	}
		if (!self.hasImage) {
			imageView.hidden = YES;
			return;
		}
	imageView.hidden = NO;
		
		// 初始化x,y方向坐标
		position.x = TLHSBetweenOriginFrameAndImage;
		position.y += VSpaceBetweenVideoAndText;
		// 1.设置图片url
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhoto:)];
		[imageView addGestureRecognizer:tapGesture];
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
					[imageView setFrame:CGRectMake(position.x, position.y, DefaultImageWidth, DefaultImageHeight)];
					// 只有url的情况下，从数据库或者网络异步加载
					NSData *data = [Info myImageDataWithUrl:info.image];
					[imageView setLink:info.image];
					if ([data length]>4) {
						[imageView addImageFromData:nil viewLocation:0];
						[imageView addImageFromData:data viewLocation:0];
					}
					else {
						self.hasLoadedImage = NO;
						[imageView loadImageFromURL:[NSString stringWithFormat:@"%@/%d",info.image,TLUrlImageRequestSize] 
										   withType:multiMediaTypeImage 
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
			case BroadSourceSytle:		{
				// 广播
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
					[imageView setFrame:CGRectMake(position.x, position.y + virticalSpace, DefaultImageWidth, DefaultImageHeight)];
					self.hasLoadedImage = NO;
					[imageView setLink:info.image];
					[imageView loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%d",info.image,DPUrlImageRequestSize]] 
									   withType:multiMediaTypeImage 
										 userId:info.uid 
										refresh:YES];
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
						[imageView setLink:info.image];
						//[imageView addImageFromData:info.imageImageData viewLocation:1];
						[imageView addImageFromData:info.imageImageData viewLocation:1 withFrame:YES];
						// 4. 计算label偏移高度
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
		imageView.hidden = NO;
}


-(void)addVideoPlayImageWithRul:(NSString *)url {
	// 播放图片
	UIImageView *playImage = [[UIImageView alloc] init];
	[playImage setLink:url];
	playImage.userInteractionEnabled = YES;
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapVideo:)];
	[playImage addGestureRecognizer:tapGesture];
	[tapGesture release];
	
	playImage.frame = CGRectMake((videoView.frame.size.width - DefaultPlayBtnWidth) / 2.0f, 
								 (videoView.frame.size.height - DefaultPlayBtnHeight) / 2.0f, 
								 DefaultPlayBtnWidth, 
								 DefaultPlayBtnHeight);
	playImage.image = [UIImage imageNamed:@"未标题-2.png"];
	[videoView addSubview:playImage];
	[playImage release];
}

- (void)drawVideoPic {//添加视频图片及点击事件
	
	for (NSInteger i = 0; i < [videoView.subviews count]; i++) {
		UIImageView *image = [videoView.subviews objectAtIndex:i];
		[image removeFromSuperview]; 
		image = nil;
	}
	if (!hasVideo) {
		videoView.hidden = YES;
		return;
	}
	videoView.hidden = NO;
	
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
				[videoView setFrame:CGRectMake(position.x, position.y, DefaultImageWidth, DefaultImageHeight)];
				// 只有url的情况下，从数据库或者网络异步加载
				NSData *data = nil;
				data =[Info myVideoDataWithUrl:vUrl.picurl];
				if ([data length]>4) {
					[videoView addVideoFromData:nil];
					[videoView addVideoFromData:data];
					[self addVideoPlayImageWithRul:vUrl.realurl];
				}
				else {
					//	[videoView addVideoFromData:nil];
					self.hasLoadedVideo = NO;
					[videoView loadVideoImageFromURL:[NSString stringWithFormat:@"%@", vUrl.picurl] withType:multiMediaTypeVideo userId:info.uid];
				}			
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
	videoView.hidden = NO;
	[videoView setLink:vUrl.realurl];

	
}

-(void)addMainText {
	if (info.origtext!=nil) {
		TextExtract *textExtract = [[TextExtract alloc] init];//声明文本解析对象
		position.y += VSBetweenOriginTextAndFrame;
		if (![[OriginView orgingHeight] objectForKey:info.uid]) {
			//if (YES) {
			//			NSMutableArray *infoArray = [textExtract getInfoNodeArray:@"看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆"];
			NSMutableArray *infoArray = [textExtract getInfoNodeArray:info.origtext];
			[orgingHeightStatic setObject:infoArray forKey:info.uid];
		}
		NSMutableArray *arrayOri = [orgingHeightStatic objectForKey:info.uid];
		for (int i = 1; i < [arrayOri count]; ) {
			[self draw:[arrayOri objectAtIndex:i-1] withType:[[arrayOri objectAtIndex:i] intValue]];
			i += 2;
		}
		[textExtract release];
	}
}

// x方向从0开始画, 文本宽度(不包括距离右边框宽度值)为frameWidth
//- (void)drawRect:(CGRect)rect {
-(void)addSubViews {	
	[self recycleSubViews];
	// 设置文本宽度
	
//	NSString *a = [[NSString alloc] initWithFormat:@"%s",__FUNCTION__];
//	TimeTrack* timeTrackHome = [[TimeTrack alloc] initWithName:a];
//	[a release];

	switch (self.showStyle) {
		case HotBroadcastShowStyle: {
			frameWidth = TLOriginFrameWidth - TLOriginTextRightSpaceWidth;//主页内容宽度
		}
			break;
		case HomeShowSytle:
			if (self.hasPortrait) {
				frameWidth = TLOriginFrameWidth - TLOriginTextRightSpaceWidth;//主页内容宽度
			}else {
				frameWidth = D_CONTENT_WIDTH;
			}
			break;
		case BroadShowSytle:
			frameWidth = D_CONTENT_WIDTH;//详细页内容宽度
			break;
		case MsgShowSytle:
			if (self.hasPortrait) {
				frameWidth = TLOriginFrameWidth - TLOriginTextRightSpaceWidth;//消息内容宽度
			}else {
				frameWidth = D_CONTENT_WIDTH;
			}			
			break;
		default:
			break;
	}
	
	// 清除子视图
	for (UIView *_view in self.subviews) {
		if ([_view isMemberOfClass:[UIImageView class]]
			) {
			UIImageView	*imgView = (UIImageView *)_view;
			if (EmotionViewTag != imgView.tag && imgView.tag != VIPImageTag
				&& ImageTag != imgView.tag && videoImageTag != imgView.tag) {
				[_view removeFromSuperview];
				_view = nil;
			}
		}
		if ([_view isMemberOfClass:[UIButton class]]) {
			UIButton *btn = (UIButton *)_view;
			if (LinkButtonTag != btn.tag && nickBtn != btn) {
				[_view removeFromSuperview];
				_view = nil;
			}
		}
		if ([_view isMemberOfClass:[UILabel class]]) {
			UILabel *lb = (UILabel *)_view;
			if (TextLabelTag != lb.tag && TimeLableTag != lb.tag) {
				[lb removeFromSuperview];
				lb = nil;
			}
		}
	}
	position = CGPointZero;//位置初始化
	CGSize nickSize = CGSizeZero;
	switch (self.showStyle) {
		case HotBroadcastShowStyle: 
		case MsgShowSytle:
		case HomeShowSytle:
			nickSize = [info.nick sizeWithFont:headFont];//获取昵称尺寸
			// 添加昵称标签
			[nickBtn setTitle:info.nick forState:UIControlStateNormal];
			// LICHENTAO 2012-02-15判断是否长按,如果长按nickButton更换背景颜色
			nickBtn.userInteractionEnabled = NO;
			nickBtn.frame = CGRectMake(0, VSBetweenOriginTextAndFrame, nickSize.width, nickSize.height);
			if ([info.isvip boolValue]) {
				//添加vip标识
				vipImage.hidden = NO;
				vipImage.image = [UIImage imageNamed:@"vip-btn.png"];
				vipImage.frame = CGRectMake(nickSize.width, VSBetweenOriginTextAndFrame + 2, VipImageWidth, VipImageWidth);
				}else if ([info.localAuth boolValue]) {
					// 添加本地认证标示
				vipImage.hidden = NO;
				vipImage.image = [UIImage imageNamed:@"localVip.png"];
				vipImage.frame = CGRectMake(nickSize.width, VSBetweenOriginTextAndFrame + 2, VipImageWidth, VipImageWidth);
				}else{
				vipImage.hidden = YES;
			}
			// 加上顶端空白和文字高度
			position.y = nickSize.height + VSBetweenOriginTextAndFrame;
			// 主页文本离上边昵称高度，要大于其他页面(如单条消息页)文字离边框高度，作修正处理
			//position.y += VerticalSpaceBetweenNikeAndText - VSBetweenOriginTextAndFrame;
			break;
		case BroadShowSytle:
			break;
		default:
			break;
	}
	
	//添加时间标签
	NSString *timeString = [Info intervalSinceNow:[info.timeStamp doubleValue]];
	CGSize timeSize = [timeString sizeWithFont:tailFont];
	// 文本距离右边屏幕间距为DPTimeRightSpaceWidth, 距离顶部边框宽度VSBetweenOriginTextAndFrame
	if (self.showStyle != 1) {
		//CGFloat leftMargin = ICON_LEFT_MARGIN + ICON_RIGHT_MARGIN + ICON_WIDTH;
		CGFloat posX = frameWidth - (timeSize.width + DPTimeRightSpaceWidth - 9.0f);
		timeLabel.frame = CGRectMake(posX, VSBetweenOriginTextAndFrame, timeSize.width, timeSize.height);
		timeLabel.hidden = NO;
	}
	timeLabel.text = timeString;
	//TimeTrack* timeTrackHomeText = [[TimeTrack alloc] initWithName:[NSString stringWithFormat:@"%s MainText",__FUNCTION__]];
	//[timeTrackHome printCurrentTime];
	// 画主体文本
	[self addMainText];
	
	//[timeTrackHomeText release];
	// 最后一行不足一行宽度的情况下，需要增加一个文字高度, x坐标变0.0f
	if (position.x > 0.1f) {
		position.y += [@"我" sizeWithFont:textFont].height;		// 加上一行高度
		position.x = TLHSBetweenOriginFrameAndImage;
	}
	// 画图片
//	[timeTrackHome printCurrentTime];
	[self drawPicture];
//	[timeTrackHome printCurrentTime];
	[self drawVideoPic];
//	[timeTrackHome release];
}

-(void)setInfo:(Info *)infoSource{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	hasLoadedImage = YES;
	hasLoadedVideo = YES;
	if (infoSource!= info) {
		[infoSource retain];
		[info release];
		info = infoSource;
		// 判断是否有图片
		if (info.image != nil && [info.image isKindOfClass:[NSString class]] && ![info.image isEqualToString:@""] && [info.image length] > 0) {
			hasImage = YES;
		}
		else {
			hasImage = NO;
		}

		// 判断是否有视频
		hasVideo = NO;
		if ([info.video isKindOfClass:[NSDictionary class]] && [info.video count] > 0) {
			NSString *videoStr = [info.video valueForKey:@"picurl"];
			if ([videoStr isKindOfClass:[NSString class]]
				&&![videoStr isKindOfClass:[NSNull class]]
				&& ![videoStr isEqualToString:@""] && [videoStr length] > 0) {
				hasVideo = YES;
			}
		}
	}
	[self addSubViews];	
	[pool drain];
	[self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
		//初始化
		self.hasPortrait = YES;
		self.backgroundColor = [UIColor whiteColor];
		self.opaque = YES;
		self.headFont = [UIFont fontWithName:@"helvetica" size:OriginTextFontSize];
		
		textFont = [UIFont fontWithName:@"helvetica" size:OriginTextFontSize];//自定义字体初始化
		tailFont = [UIFont fontWithName:@"helvetica" size:CommentCntsTextFontSize];
		// 时间标签
		timeLabel = [[UILabel alloc] init];
		timeLabel.frame = CGRectMake(0.0f, 0.0f, 20.0f, 18.0f);	// 任意框架
		timeLabel.backgroundColor = [UIColor whiteColor];
		timeLabel.textColor = [UIColor colorWithRed:0.502f green:0.502f blue:0.502f alpha:1];
		timeLabel.font = tailFont;
		timeLabel.tag = TimeLableTag;
		timeLabel.hidden = YES;
		[self addSubview:timeLabel];
		// 添加图片
		imageView = [[AsyncImageView alloc] init];
		imageView.myAsyncImageViewDelegate = self;
		imageView.contentMode = UIViewContentModeScaleToFill;
		[self addSubview:imageView];
		// 添加视频图片
		videoView = [[AsyncImageView alloc] init];
		videoView.contentMode = UIViewContentModeScaleToFill;
		videoView.myAsyncImageViewDelegate = self;
		[self addSubview:videoView];
		
		for (UIButton *btn in arrButtonsFree) {
			btn.titleLabel.font = textFont;
		}
		for (UILabel *lb in arrLablesFree) {
			lb.font = textFont;
		}
		nickBtn.titleLabel.font = textFont;
    }
    return self;
}

- (void)dealloc {
	if (orgingHeightStatic) {
		[orgingHeightStatic release];
		orgingHeightStatic=nil;
	}
	info.imageImageData = nil;
	info.videoImageData = nil;
	[info release];
	imageView.myAsyncImageViewDelegate = nil;
	videoView.myAsyncImageViewDelegate = nil;
	[imageView release];
	[videoView release];
	[timeLabel release];
	[super dealloc];
}

// 将链接替换成按钮
- (void)addLink:(CGPoint)mPosition withTmpString:(NSString *)tempString withString:(NSString *)string withType:(NSUInteger)type{
	NSString *tempString2 = [tempString copy];
	CGSize stringSize = [tempString sizeWithFont:textFont];
		//UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	UIButton *btn = nil;
	BOOL bNeedAddToView = NO;
	if ([arrButtonsFree count] > 0) {
		btn = [[arrButtonsFree objectAtIndex:0] retain];
		[arrButtonsFree removeObjectAtIndex:0];
		btn.hidden = NO;
	}
	else {
		bNeedAddToView = YES;
		btn = [[UIButton alloc] init];
		[btn addTarget:self action:@selector(touchUrl:) forControlEvents:UIControlEventTouchDown];
		btn.titleLabel.font = textFont;
        btn.tag = LinkButtonTag;
		[btn setTitleColor:[UIColor colorWithRed:0.2 green:0.455 blue:0.596 alpha:1] forState:UIControlStateNormal];
		[btn setTitleColor:[UIColor colorWithRed:0.2 green:0.455 blue:0.596 alpha:1] forState:UIControlStateHighlighted];
	}
	switch (self.showStyle) {
		case 0:
			btn.userInteractionEnabled = NO;
			break;
		case 1:
			btn.userInteractionEnabled = YES;
			break;
		case 3:
			btn.userInteractionEnabled = NO;
			break;
		default:
			break;
	}
	[btn setTitle:tempString2 forState:UIControlStateNormal];
	[btn setTitle:tempString2 forState:UIControlStateHighlighted];
	[tempString2 release];
	
	[btn setLink:string];
	[btn setType:[NSString stringWithFormat:@"%d",type]];
	btn.frame = CGRectMake(mPosition.x, mPosition.y, stringSize.width, stringSize.height);
	// lichentao 2012-02-15 url地址在长按下的时候有背景颜色
	if (isLongPress) {
		btn.backgroundColor = [UIColor greenColor];
	}
	else {
		btn.backgroundColor = [UIColor whiteColor];
	}
	if (bNeedAddToView) {
		[self addSubview:btn];
	}
	[arrButtonsInUse addObject:btn];
	[btn release];
}
// 添加链接
- (void)addLinkAt:(CGRect)rect withTmpString:(NSString *)tempString withString:(NSString *)string withType:(NSUInteger)type {
    NSString *tempString2 = [tempString copy];
//	CGSize stringSize = [tempString sizeWithFont:textFont];
    //UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	UIButton *btn = nil;
	BOOL bNeedAddToView = NO;
	if ([arrButtonsFree count] > 0) {
		btn = [[arrButtonsFree objectAtIndex:0] retain];
		[arrButtonsFree removeObjectAtIndex:0];
		btn.hidden = NO;
	}
	else {
		bNeedAddToView = YES;
		btn = [[UIButton alloc] init];
		[btn addTarget:self action:@selector(touchUrl:) forControlEvents:UIControlEventTouchDown];
		btn.titleLabel.font = textFont;
        btn.tag = LinkButtonTag;
		[btn setTitleColor:[UIColor colorWithRed:0.2 green:0.455 blue:0.596 alpha:1] forState:UIControlStateNormal];
		[btn setTitleColor:[UIColor colorWithRed:0.2 green:0.455 blue:0.596 alpha:1] forState:UIControlStateHighlighted];
	}
	switch (self.showStyle) {
		case 0:
			btn.userInteractionEnabled = NO;
			break;
		case 1:
			btn.userInteractionEnabled = YES;
			break;
		case 3:
			btn.userInteractionEnabled = NO;
			break;
		default:
			break;
	}
	[btn setTitle:tempString2 forState:UIControlStateNormal];
	[btn setTitle:tempString2 forState:UIControlStateHighlighted];
	[tempString2 release];
	[btn setLink:string];
	[btn setType:[NSString stringWithFormat:@"%d",type]];
	btn.frame = rect;
	// lichentao 2012-02-15 url地址在长按下的时候有背景颜色
	if (isLongPress) {
		btn.backgroundColor = [UIColor greenColor];
	}
	else {
		btn.backgroundColor = [UIColor whiteColor];
	}
	if (bNeedAddToView) {
		[self addSubview:btn];
	}
	[arrButtonsInUse addObject:btn];
	[btn release];
}
//点击链接
- (void) touchUrl:(id)sender{
	NSLog(@"touchUrl:%@\t%@",((UIButton *)sender).link,((UIButton *)sender).type);
	//做相关处理
	UIButton *btn = (UIButton *)sender;
	NSString *linkString = [btn link];
//	NSLog(@"btn.link:%@", linkString);
	// 1. url点击
	if ([((UIButton *)sender).type intValue]== 2 && [self.myOriginUrlDelegate respondsToSelector:@selector(OriginViewUrlClicked:)]) {
		[self.myOriginUrlDelegate OriginViewUrlClicked:linkString];
	}
	if ([btn.type intValue] == 0) {
		NSString *userName = [linkString substringFromIndex:[linkString rangeOfString:@"@"].location+1];
		UIImage *buttonImage = [UIImage imageNamed:@"DetailPageSelectedBg.png"];  
		UIImage *stretchableButtonImage = [buttonImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];//设置帽端为12px,也是就左边的12个像素不参与拉伸,有助于圆角图片美观  
		[btn setBackgroundImage:stretchableButtonImage forState:UIControlStateHighlighted];
		[[PushAndRequest shareInstance] pushControllerType:self.controllerType withName:userName];
	}
	if ([btn.type intValue] == 3) {
		/*
		iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
		HotTopicDetailController *hotTopicDetailController = [[HotTopicDetailController alloc] init];
		NSString *topicString = [linkString stringByReplacingOccurrencesOfString:@"#" withString:@""];
		hotTopicDetailController.searchString = topicString;
		switch (self.controllerType) {
			case 1:
				[delegate.homeNav pushViewController:hotTopicDetailController animated:YES];
				break;
			case 2:
				[delegate.msgNav pushViewController:hotTopicDetailController animated:YES];
				break;
			case 3:
				[delegate.searchNav pushViewController:hotTopicDetailController animated:YES];
				break;
			case 4:
				[delegate.moreNav pushViewController:hotTopicDetailController animated:YES];
				break;
			default:
				break;
		}
		[hotTopicDetailController release];		
		 */
	}
}

// 视频点击事件
- (void) tapVideo:(UITapGestureRecognizer *)gesture{
	NSLog(@"gesture:%@",((UIImageView *)gesture.view).link);
	if ([self.myOriginVideoDelegate respondsToSelector:@selector(OriginViewVideoClicked:)]) {
		[self.myOriginVideoDelegate OriginViewVideoClicked:((UIImageView *)gesture.view).link];
	}
}

//点击图片
- (void) tapPhoto:(UITapGestureRecognizer *)gesture{
	//NSLog(@"gesture:%@",((AsyncImageView *)gesture.view).link);
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
	NSString *url = [NSString stringWithFormat:@"%@",((AsyncImageView *)gesture.view).link];
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
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDelay:0.5];
			[delegate.window addSubview:photoView];
			[UIView commitAnimations];
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
- (void)storeGifToCache:(NSData *)gifImageData{
	NSString  *urlString = [[NSString alloc] initWithFormat:@"%@/%d",info.image,DPUrlImageRequestSize];
	[[IWBGifImageCache sharedImageCache] storeImageData:gifImageData forKey:urlString toDisk:YES];
	[urlString release];
}

#pragma mark protocol AsyncImageViewDelegate<NSObject> 图片加载完毕委托方法

-(void)AsyncImageViewHasLoadedImage:(NSData *)dataRef {
	self.hasLoadedImage = YES;
	info.imageImageData = dataRef;
	if ([IWBGifImageView isGifImage:dataRef]) {
		[self performSelectorInBackground:@selector(storeGifToCache:) withObject:dataRef];
	}
	// 通知父窗体图像变更
	if (self.hasLoadedVideo && [self.myOriginViewDelegate respondsToSelector:@selector(OriginViewHasLoadedImage)]) {
		[self.myOriginViewDelegate OriginViewHasLoadedImage];
	}
	if (self.hasLoadedVideo ) {
		[self setNeedsDisplay];
	}
}

-(void)AsyncImageViewHasLoadedVideo:(NSData *)dataRef {
	info.videoImageData = dataRef;
	self.hasLoadedVideo = YES;
	// 通知父窗体图像变更
	if (self.hasLoadedImage && [self.myOriginViewDelegate respondsToSelector:@selector(OriginViewHasLoadedImage)]) {
		[self.myOriginViewDelegate OriginViewHasLoadedImage];
	}
	// 2012-02-21 By Yi Minwen 不知道上边有什么意义
	if (self.hasLoadedImage ) {
		[self setNeedsDisplay];
	}
}

#pragma mark mapView


@end
