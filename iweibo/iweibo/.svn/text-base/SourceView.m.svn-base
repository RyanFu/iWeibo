//
//  SourceView.m
//  iweibo
//
//  Created by ZhaoLilong on 1/9/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "SourceView.h"
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
#import "IWBGifImageCache.h"
#import "IWBGifImageView.h"

@implementation SourceView
@synthesize transInfo;
@synthesize imageView,videoImage;
@synthesize sourceStyle;
@synthesize mySrcVideoDelegate, mySrcUrlDelegate, mySourceViewImageDelegate;
@synthesize isLongPress;
@synthesize controllerType;

static  NSMutableDictionary *sourceHeightStaic = nil;
static  NSMutableDictionary *g_srcUnitItemDic = nil;

+(NSMutableDictionary *) sourceHeight{
	if (sourceHeightStaic == nil) {
		sourceHeightStaic = [[NSMutableDictionary alloc] init];
	}
	return sourceHeightStaic;
}

+(NSMutableDictionary *)srcViewUnitItemDic {
	if ( nil == g_srcUnitItemDic) {
		g_srcUnitItemDic = [[NSMutableDictionary alloc] initWithCapacity:30];
	}
	return g_srcUnitItemDic;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		hasLoadedImage = NO;
		//添加刷新图的通知
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadImage:) name:@"updateImage" object:nil];
		
		// 初始化设置
		self.tag = 003;
		self.hasPortrait = YES;
		self.labelLocation = 0.0f;
		self.layer.borderWidth = 0.5;
		self.layer.cornerRadius = 3;
		self.layer.masksToBounds = YES;
		
		// 字体设置
		textFont = [UIFont fontWithName:@"helvetica" size:SourceTextFontSize];
		headFont = [UIFont fontWithName:@"helvetica" size:SourceTextFontSize];
		tailFont = [UIFont fontWithName:@"helvetica" size:CommentCntsTextFontSize];
		// “:"
		colonLabel = [[UILabel alloc] init];
		colonLabel.frame = CGRectMake(0.0f, 0.0f, 10.0f, 18.0f);
		colonLabel.text = @":";
		colonLabel.tag = ColonLabelTag;
		[self addSubview:colonLabel];
		// 添加图片
		imageView = [[AsyncImageView alloc] init];
		self.imageView.myAsyncImageViewDelegate = self;
		self.layer.borderColor = [UIColor colorWithRed:0.827 green:0.843 blue:0.855 alpha:1].CGColor;
		self.backgroundColor = [UIColor colorWithRed:0.945 green:0.949 blue:0.953 alpha:1];
		[self addSubview:self.imageView];

		// 添加视频缩略图
		videoImage = [[AsyncImageView alloc] init];
		videoImage.contentMode = UIViewContentModeScaleToFill;
		videoImage.myAsyncImageViewDelegate = self;
		[self addSubview:videoImage];
		// ”来自..."
		broadSourceFrom = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 15.0f, 18.0f)];
		broadSourceFrom.backgroundColor = [UIColor colorWithRed:0.945 green:0.949 blue:0.953 alpha:1];		
		broadSourceFrom.textColor = [UIColor colorWithRed:0.502f green:0.502f blue:0.502f alpha:1];
		broadSourceFrom.font = tailFont;
		broadSourceFrom.tag = BroadcastSourceFromTag;
        // 2012-07-12 By Yiminwen 把详情页从当前类剔除以后，这两个按钮已经没有意义了
//		[self addSubview:broadSourceFrom];
		broadSourceTime = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 15.0f, 18.0f)];
		broadSourceTime.textColor = [UIColor colorWithRed:0.502f green:0.502f blue:0.502f alpha:1];
		broadSourceTime.backgroundColor = [UIColor colorWithRed:0.945 green:0.949 blue:0.953 alpha:1];
		broadSourceTime.font = tailFont;
		broadSourceTime.tag = BroadcastSourceFromTimeTag;
         // 2012-07-12 By Yiminwen 把详情页从当前类剔除以后，这两个按钮已经没有意义了
//		[self addSubview:broadSourceTime];
		for (UIButton *btn in arrButtonsFree) {
			btn.titleLabel.font = textFont;
            btn.backgroundColor = [UIColor colorWithRed:0.945 green:0.949 blue:0.953 alpha:1];
		}
		for (UILabel *lb in arrLablesFree) {
			lb.font = textFont;
			lb.textColor = [UIColor colorStringToRGB:[NSString stringWithFormat:@"%d",OriginTextColor]];
            lb.backgroundColor = [UIColor colorWithRed:0.945 green:0.949 blue:0.953 alpha:1];
		}
		nickBtn.titleLabel.font = textFont;
    }
    return self;
}

// 绘制表情及文本
- (void)draw:(NSString *)strText withType:(NSUInteger)type{
	//CLog(@"++++++++++%s strText:%@ position.x:%f, position.y:%f", __FUNCTION__, strText, position.x, position.y);
	NSString *stringText = nil;
	CGFloat wordHeight = [@"我" sizeWithFont:textFont].height;		// 文本高度
    // 替换普通文本字符串
	if (type == 0) {
		NSMutableDictionary *dic = [HomePage nickNameDictionary];
		NSString *userName = strText;	
		if ([dic isKindOfClass:[NSDictionary class]]) {
			if ([userName hasPrefix:@"@"] && [userName length] > 1) {
				NSString *trueName = [userName substringFromIndex:[userName rangeOfString:@"@"].location+1];
				NSString *nickName = [dic objectForKey:trueName];
				if (nickName != nil && [nickName isKindOfClass:[NSString class]]) {
					stringText = nickName;
				}
				else {
					stringText = userName;
					type = 4;	// 没有对应名字则显示文字
				}
			}
			else {
				stringText = userName;
			}
		}
		else {
			stringText = userName;
		}
	}
	else if (type == 4) {
		stringText = [strText stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
		stringText = [stringText stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
		stringText = [stringText stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
		stringText = [stringText stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
		stringText = [stringText stringByReplacingOccurrencesOfString:@"&39;" withString:@"\'"];
		stringText = [stringText stringByReplacingOccurrencesOfString:@"：" withString:@":"];
	}
	else {
		stringText = strText;
	}
	
	if (type==1){
			// 表情处理
		NSString *imageString = [emoDic valueForKey:stringText];
		UIImage *emotion = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageString]];
		CLog(@"imageString:*%@** emotion.size.width:%f, emotion.size.height:%f", imageString, emotion.size.width, emotion.size.height);
		if (position.x > self.frameWidth - EmotionImageWidth) {
			position.x = 5;
			position.y += wordHeight;
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
			emotionView.backgroundColor = [UIColor colorWithRed:0.945 green:0.949 blue:0.953 alpha:1];
		}
		if (bNeedAddToView) {
			[self addSubview:emotionView];
		}
		[arrImagesInUse addObject:emotionView];
		[emotionView release];		
		position.x += EmotionImageWidth;
	}else {
			// 其他类型
		if ((int)[stringText sizeWithFont:textFont].width <= self.frameWidth - position.x) {
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
				CGSize strSize = [stringText sizeWithFont:textFont];
				// 文本距离右边屏幕间距为DPTimeRightSpaceWidth, 距离顶部边框宽度VSBetweenOriginTextAndFrame
				strLabel.text = stringText;
				strLabel.frame = CGRectMake(position.x, position.y, strSize.width, strSize.height);
				if (isLongPress) {
					strLabel.backgroundColor = [UIColor greenColor];
				}else {
					strLabel.backgroundColor = [UIColor colorWithRed:0.945 green:0.949 blue:0.953 alpha:1];
				}	
				if (bNeedAddToView) {
					[self addSubview:strLabel];
				}
				[arrLablesInUse addObject:strLabel];
				[strLabel release];
				//[stringText drawAtPoint:position withFont:textFont];
			}else if (type == 0) {
				[self addLink:position withTmpString:stringText withString:strText withType:type];
			}
			else {
				[self addLink:position withTmpString:stringText withString:stringText withType:type];
			}

			position.x += [stringText sizeWithFont:textFont].width;
			if (position.x == self.frameWidth) {
				position.x = 5;
				position.y += wordHeight;
			}
		}else {
			NSMutableString *tmpString = [NSMutableString stringWithCapacity:30];
			CGFloat		lineWidth = 0;	// 文本在当前行的宽度
			for (int i = 0; i < [stringText length]; i++) {
				NSString *subString = [stringText substringWithRange:NSMakeRange(i, 1)];
				CGSize wordSize = [subString sizeWithFont:textFont];
				// 文本折行处理: 当当前文本剩于宽度小于下一个字符的宽度，则进行折行
				if ((lineWidth + wordSize.width) > self.frameWidth - position.x) {
					//CLog(@"tmpString:%@, lineWidth:%f, wordSize.width:%f, self.kSourceWidth:%d,position.x:%f ",
//						 tmpString, lineWidth, wordSize.width, self.kSourceWidth, position.x);
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
						if (isLongPress) {
							strLabel.backgroundColor = [UIColor greenColor];
						}else {
							strLabel.backgroundColor = [UIColor colorWithRed:0.945 green:0.949 blue:0.953 alpha:1];
						}			
						if (bNeedAddToView) {
							[self addSubview:strLabel];
						}
						[arrLablesInUse addObject:strLabel];
						[strLabel release];
						//[tmpString drawAtPoint:CGPointMake(position.x, position.y) withFont:textFont];
					}else if (type == 0) {
						//NSLog(@"tmpString:%@",tmpString);
						[self addLink:position withTmpString:tmpString withString:strText withType:type];
					}
					else {
						[self addLink:position withTmpString:tmpString withString:stringText withType:type];
					}

					[tmpString deleteCharactersInRange:NSMakeRange(0, [tmpString length])];
					lineWidth = 0;
					position.x = 5;
					position.y += wordHeight;
				}
				lineWidth += wordSize.width;
				[tmpString appendString:subString];
			}	
				// 剩余
			if ([tmpString length] > 0) {
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
					strLabel.textColor = [UIColor colorStringToRGB:[NSString stringWithFormat:@"%d",OriginTextColor]];
					strLabel.frame = CGRectMake(position.x, position.y, strSize.width, strSize.height);
					if (isLongPress) {
						strLabel.backgroundColor = [UIColor greenColor];
					}else {
						strLabel.backgroundColor = [UIColor colorWithRed:0.945 green:0.949 blue:0.953 alpha:1];
					}
					if (bNeedAddToView) {
						[self addSubview:strLabel];
					}
					[arrLablesInUse addObject:strLabel];
					[strLabel release];
					//[tmpString drawAtPoint:position withFont:textFont];
				}else if (type == 0) {
					//NSLog(@"tmpString:%@",tmpString);
					[self addLink:position withTmpString:tmpString withString:strText withType:type];
				}else {
					[self addLink:position withTmpString:tmpString withString:stringText withType:type];
				}
				position.x += [tmpString sizeWithFont:textFont].width;
			}
		}
	}	
}

// 昵称点击响应
- (void)touchNick
{
    NSString *accountName = self.transInfo.transName;
    [[PushAndRequest shareInstance] pushControllerType:self.controllerType withName:accountName];
}

// 绘制转发图片
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
	position.x = 5;
	position.y += VSpaceBetweenVideoAndText;
	// 1.设置图片url
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhoto:)];
	[imageView addGestureRecognizer:tapGesture];
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
					[imageView loadImageFromURL:[NSString stringWithFormat:@"%@/%d",transInfo.transImage,TLUrlImageRequestSize] 
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
			[imageView setLink:transInfo.transImage];
			// 加载图片
			//if (nil == transInfo.sourceImageData || 0 == [transInfo.sourceImageData length]) {
			if (YES) {
				[imageView setFrame:CGRectMake(5, position.y, DefaultImageWidth, DefaultImageHeight)];
				// 只有url的情况下，从数据库或者网络异步加载
				NSData *data = nil;
				data =[TransInfo mySourceImageDataWithUrl:transInfo.transImage];
				if ([data length]>4) {
					[imageView addImageFromData:nil viewLocation:0];
					[imageView addImageFromData:data viewLocation:0];
				}
				else {
					self.hasLoadedImage = NO;
					[imageView loadImageFromURL:[NSString stringWithFormat:@"%@/%d",transInfo.transImage,TLUrlImageRequestSize] 
									   withType:multiMediaTypeSourceImage 
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
		case BroadSourceSytle:		{
			// 广播
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
				[imageView setFrame:CGRectMake(position.x, position.y + virticalSpace, DefaultImageWidth, DefaultImageHeight)];
				//self.labelLocation = position.y + virticalSpace;
				self.hasLoadedImage = NO;
				[imageView setLink:transInfo.transImage];
				[imageView loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%d",transInfo.transImage, DPUrlImageRequestSize]] 
								   withType:multiMediaTypeSourceImage 
									 userId:transInfo.transId 
									refresh:YES];
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
					[imageView setLink:transInfo.transImage];
					//[imageView addImageFromData:transInfo.sourceImageData viewLocation:1];
					[imageView addImageFromData:transInfo.sourceImageData viewLocation:1 withFrame:YES];
					[imageSrc release];
					// 4. 计算label偏移高度
					self.labelLocation = imageView.frame.origin.y + imageView.frame.size.height + 2*ImageFrameWidth + VSBetweenSourceImageAndText;
					
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
					[imageView loadImageFromURL:[NSString stringWithFormat:@"%@/%d",transInfo.transImage,TLUrlImageRequestSize] 
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


-(void)addVideoPlayImageWithRul:(NSString *)url {
	// 播放图片
	// 添加播放箭头
	UIImageView *playImage = [[UIImageView alloc] init];
	//CLog(@"%s, videoImage.frame.size.origin.x:%f, y:%f videoImage.frame.size.width:%f, videoImage.frame.size.height:%f", 
	//		 videoImage.frame.origin.x, videoImage.frame.origin.y, videoImage.frame.size.width, videoImage.frame.size.height);
	playImage.frame = CGRectMake((videoImage.frame.size.width - DefaultPlayBtnWidth) / 2.0f, 
								 (videoImage.frame.size.height - DefaultPlayBtnHeight) / 2.0f, 
								 DefaultPlayBtnWidth, 
								 DefaultPlayBtnHeight);
	playImage.image = [UIImage imageNamed:@"未标题-2.png"];
	[videoImage addSubview:playImage];
	[playImage release];
}

// 绘制视频图片
- (void)drawVideoPic {
	if (!hasVideo) {
		videoImage.hidden = YES;
		return;
	}
	videoImage.hidden = NO;
	for (NSInteger i = 0; i < [videoImage.subviews count]; i++) {
		UIImageView *image = [videoImage.subviews objectAtIndex:i]; 
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
					[videoImage loadVideoImageFromURL:transInfo.transVideo withType:multiMediaTypeSourceVideo userId:transInfo.transId];
				}		
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
					self.videoImage.frame = CGRectMake(position.x , position.y, imageWidth, imageVideo.size.height / 2.0f);
					// 3. 加载图片
					[videoImage addImageFromData:transInfo.sourceVideoData viewLocation:1];
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
		// 
		//CGFloat posY = position.y;
//		if (!bAddPic) {
//			posY += VSBetweenSourceImageAndText;
//		}
//		switch (self.sourceStyle) {
//			case HomeSourceSytle:
//				videoImage.frame = CGRectMake(position.x, posY, DefaultImageWidth, DefaultImageHeight);
//				break;
//			case BroadSourceSytle:
//				if (!bAddPic) {
//					self.labelLocation = position.y + DefaultImageHeight + VSBetweenSourceImageAndText + VSBetweenSourceImageAndText;
//				}
//				videoImage.frame = CGRectMake((DPSourceFrameWidth - DefaultImageWidth)/2, posY , DefaultImageWidth, DefaultImageHeight);
//				break;
//			case MsgSourceSytle:
//				videoImage.frame = CGRectMake(position.x, posY, DefaultImageWidth, DefaultImageHeight);
//				break;
//			default:
//				break;
//		}
	// 添加点击响应
	videoImage.hidden = NO;
	videoImage.userInteractionEnabled = YES;
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapVideo:)];
	[videoImage setLink:transInfo.transVideoRealUrl];
	[videoImage addGestureRecognizer:tapGesture];
	[tapGesture release];
	
	

	if (!hasImage) {
		self.labelLocation = videoImage.frame.origin.y + videoImage.frame.size.height + VSBetweenSourceImageAndText;
	}
	

//	if (![transInfo.transImage isEqualToString:@""]||(![transInfo.transVideo isKindOfClass:[NSNull class]] && ![transInfo.transVideo isEqualToString:@""])) {
//		position.y += 75.0f;   //加载完图像或视频后再计算y坐标，显示来自和时间
//	}
//	else {
//		position.y += 10.0f;
//	}
//	
}

-(void)addMainText {
	// 文本处理
	NSString *sourceOrigtext = self.transInfo.transOrigtext;
	if (sourceOrigtext != nil) {
		TextExtract *textExtract = [[TextExtract alloc] init];
		if (![[SourceView sourceHeight] objectForKey:transInfo.transId]) {
			NSMutableArray *infoArray = [textExtract getInfoNodeArray:sourceOrigtext];
			//if (YES) {
			//			NSMutableArray *infoArray = [textExtract getInfoNodeArray:@"看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆看银装素裹分外妖娆"];
			[[SourceView sourceHeight] setObject:infoArray forKey:transInfo.transId];
		}
		NSArray *array = [[SourceView sourceHeight] objectForKey:transInfo.transId];
		for (int i = 1; i < [array count]; ) {
			[self draw:[array objectAtIndex:i-1] withType:[[array objectAtIndex:i] intValue]];
			//NSLog(@"nsstring:%@ \t type:%@",[array objectAtIndex:i-1],[array objectAtIndex:i]);
			i += 2;
		}	
		[textExtract release];
	}
}

// x方向从5开始画, 文本宽度为frameWidth
//- (void)drawRect:(CGRect)rect {
- (void)addSubViews {
	[self recycleSubViews];
	//[super drawRect:rect];
	/************************************绘制字符串****************************************/
	//宽度初始化
	//TimeTrack* timeTrackSrc = [[TimeTrack alloc] initWithName:[NSString stringWithFormat:@"%s",__FUNCTION__]];
	switch (self.sourceStyle) {
		case HotBroadcastSourceStyle: {
			self.frameWidth = SOURCE_WIDTH - 5;		// 减掉右边距
		}
			break;
		case HomeSourceSytle:
			if (self.hasPortrait) {
				self.frameWidth = SOURCE_WIDTH - 5;		// 减掉右边距
			}else {
				self.frameWidth = D_SOURCE_WIDTH - 13;	// 减掉右边距
			}
			break;
		case BroadSourceSytle:
			self.frameWidth = D_SOURCE_WIDTH - 13;	// 减掉右边距
			break;
		case MsgSourceSytle:
			if (self.hasPortrait) {
				self.frameWidth = SOURCE_WIDTH - 5;		// 减掉右边距
			}else {
				self.frameWidth = D_SOURCE_WIDTH - 13;	// 减掉右边距
			}
			break;
		default:
			break;
	}

	// 清除图片资源
	for (NSInteger i = 0; i < [imageView.subviews count]; i++) {
		UIImageView *view = [imageView.subviews objectAtIndex:i];
		[view removeFromSuperview];
	//	[[imageView.subviews objectAtIndex:i] removeFromSuperview]; 
		view = nil;
	}
	
	for (NSInteger i = 0; i < [videoImage.subviews count]; i++) {
		UIImageView  *video = [videoImage.subviews objectAtIndex:i];
		[video removeFromSuperview]; 
		video = nil;
	}
	
	// 清除子视图
	for (UIView *_view in self.subviews) {
		if ([_view isMemberOfClass:[UIImageView class]]
			) {
			UIImageView	*imgView = (UIImageView *)_view;
			if (EmotionViewTag != imgView.tag && imgView.tag != VIPImageTag && ImageTag != imgView.tag && videoImageTag != imgView.tag) {
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
			if (TextLabelTag != lb.tag && ColonLabelTag != lb.tag && BroadcastSourceFromTag != lb.tag
				&& BroadcastSourceFromTimeTag != lb.tag) {
				[lb removeFromSuperview];
				lb = nil;
			}
		}
	}
	// 1.1 加上顶部文本距离边框高度
	position = CGPointMake(5, VSBetweenSourceTextAndFrame);//坐标初始化
	NSString *sourceNick = self.transInfo.transNick;
	// 1.2 获取昵称宽度
	CGSize sourceNickSize = [sourceNick sizeWithFont:textFont];
	// 昵称
	[nickBtn setTitle:sourceNick forState:UIControlStateNormal];
	// LICHENTAO 2012-02-15判断是否长按,如果长按nickButton更换背景颜色
	if (isLongPress) {
		nickBtn.backgroundColor = [UIColor greenColor];
	}
	if (self.sourceStyle == HomeSourceSytle) {
		nickBtn.userInteractionEnabled = NO;
	}
	else {
		nickBtn.userInteractionEnabled = YES;
	}
    
    [nickBtn setLink:[NSString stringWithFormat:@"@%@", transInfo.transName]];
	nickBtn.frame = CGRectMake(position.x, position.y, sourceNickSize.width, sourceNickSize.height);
	position.x += sourceNickSize.width;
	//NSLog(@"本地认证1:%@",transInfo.translocalAuth);
	// 1.3 判断是否是vip用户,假如是，需要加上vip图表宽度(源消息没有)
	if ([transInfo.transIsvip boolValue]) {
		vipImage.hidden = NO;
		if (isLongPress) {
			vipImage.backgroundColor = [UIColor greenColor];
		}else {
			vipImage.backgroundColor = [UIColor colorWithRed:0.945 green:0.949 blue:0.953 alpha:1];
		}
		vipImage.image = [UIImage imageNamed:@"vip-btn.png"];
		vipImage.frame = CGRectMake(position.x, position.y, VipImageWidth, VipImageWidth);
		position.x += VipImageWidth;
	}else if ([transInfo.translocalAuth boolValue]) {
		vipImage.hidden = NO;
		if (isLongPress) {
			vipImage.backgroundColor = [UIColor greenColor];
		}else {
			vipImage.backgroundColor = [UIColor colorWithRed:0.945 green:0.949 blue:0.953 alpha:1];
		}
		vipImage.image = [UIImage imageNamed:@"localVip.png"];
		vipImage.frame = CGRectMake(position.x, position.y, VipImageWidth, VipImageWidth);
		position.x += VipImageWidth;	
	}
	else {
		vipImage.hidden = YES;
	}
	
	CGSize colonSize = [@":" sizeWithFont:textFont];
	colonLabel.frame = CGRectMake(position.x, position.y, colonSize.width, colonSize.height);
	colonLabel.text = @":";
	colonLabel.font = textFont;
	// lichentao 2012-02-15
	if (isLongPress) {
		colonLabel.backgroundColor = [UIColor greenColor];
	}else {
		colonLabel.backgroundColor = [UIColor colorWithRed:0.945 green:0.949 blue:0.953 alpha:1];
	}
	
	// 1.4 加上":"宽度	
	position.x += colonSize.width;
	
	// 2.1 解析文本
	[self addMainText];
	
	// 最后不满一行，按一行计算(由于有名字存在，至少会有一行)
	if (position.x > 5.1f) {
		position.y += [@"我" sizeWithFont:textFont].height;		// 加上一行高度
		position.x = 5;
	}
	
	// 画图片
	// 初始化标签位置
	self.labelLocation = position.y + VSBetweenSourceImageAndText;
	[self drawPicture];
	[self drawVideoPic];
	if (sourceStyle == BroadSourceSytle) {
		broadSourceFrom.frame = CGRectMake(5, self.labelLocation, 80, [@"我" sizeWithFont:tailFont].width);
		if ([transInfo.transFrom isEqualToString:@""]||transInfo.transFrom == nil) {
			broadSourceFrom.text = @"来自:腾讯微博";
		}else {
			broadSourceFrom.text = [NSString stringWithFormat:@"来自:%@",transInfo.transFrom];
		}
		if (transInfo.transTime != nil) {
			broadSourceTime.text = [Info intervalSinceNow:[transInfo.transTime doubleValue]];
		}
		broadSourceTime.frame = CGRectMake(90, self.labelLocation, 80, [@"我" sizeWithFont:tailFont].width);		
	}
	
	//[timeTrackSrc release];		
	
}

-(void)setTransInfo:(TransInfo *)infoTrans{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	hasLoadedImage = YES;
	hasLoadedVideo = YES;
	if (infoTrans!= transInfo) {
		[infoTrans retain];
		[transInfo release];
		transInfo = infoTrans;
		// 判断是否有图片
		if ([transInfo.transImage isKindOfClass:[NSString class]] && 0 < [transInfo.transImage length]) {
			hasImage = YES;
		}
		else {
			hasImage = NO;
		}

		// 判断是否有视频
		//if (transInfo.transVideo != nil && 0 < [transInfo.transVideo length]) {
//			hasVideo = YES;
//		}
		if ([transInfo.transVideo isKindOfClass:[NSString class]]
			&&![transInfo.transVideo isKindOfClass:[NSNull class]]
			&& ![transInfo.transVideo isEqualToString:@""]
			&& 0 < [transInfo.transVideo length]) {
			hasVideo = YES;
		}	
		else {
			hasVideo = NO;
		}	
	}
	[self addSubViews];
	[pool drain];
	[self setNeedsDisplay];
}

- (void)addLink:(CGPoint)mPosition withTmpString:(NSString *)tempString withString:(NSString *)string withType:(NSUInteger)type{
	NSString *tempString2 = [tempString copy];// 将传入字符串进行拷贝，否则会造成后一个字符串覆盖前一个字符串
	CGSize stringSize = [tempString sizeWithFont:textFont];
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
		[btn addTarget:self action:@selector(touchUrl:) forControlEvents:UIControlEventTouchUpInside];
		btn.tag = LinkButtonTag;
		btn.titleLabel.font = textFont;
		[btn setTitleColor:[UIColor colorWithRed:0.2 green:0.455 blue:0.596 alpha:1] forState:UIControlStateNormal];
		[btn setTitleColor:[UIColor colorWithRed:0.2 green:0.455 blue:0.596 alpha:1] forState:UIControlStateHighlighted];
	}
		switch (self.sourceStyle) {
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
	[btn setTitle:tempString2 forState:UIControlStateNormal];									     // 设置按钮标题
	[tempString2 release];
	[btn setLink:string];																	    // 设置链接
	[btn setType:[NSString stringWithFormat:@"%d",type]];									    // 设置链接类型
	btn.frame = CGRectMake(mPosition.x, mPosition.y, stringSize.width, stringSize.height);
	if (isLongPress) {
		btn.backgroundColor = [UIColor greenColor];
	}
	if (bNeedAddToView) {
		[self addSubview:btn];
	}
	[arrButtonsInUse addObject:btn];
	[btn release];	
	
}
// 添加链接
- (void)addLinkAt:(CGRect)rect withTmpString:(NSString *)tempString withString:(NSString *)string withType:(NSUInteger)type {
    NSString *tempString2 = [tempString copy];// 将传入字符串进行拷贝，否则会造成后一个字符串覆盖前一个字符串
//	CGSize stringSize = [tempString sizeWithFont:textFont];
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
		[btn addTarget:self action:@selector(touchUrl:) forControlEvents:UIControlEventTouchUpInside];
		btn.tag = LinkButtonTag;
		btn.titleLabel.font = textFont;
		[btn setTitleColor:[UIColor colorWithRed:0.2 green:0.455 blue:0.596 alpha:1] forState:UIControlStateNormal];
		[btn setTitleColor:[UIColor colorWithRed:0.2 green:0.455 blue:0.596 alpha:1] forState:UIControlStateHighlighted];
	}
    switch (self.sourceStyle) {
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
	[btn setTitle:tempString2 forState:UIControlStateNormal];									     // 设置按钮标题
	[tempString2 release];
	[btn setLink:string];																	    // 设置链接
	[btn setType:[NSString stringWithFormat:@"%d",type]];									    // 设置链接类型
	btn.frame = rect;
	if (isLongPress) {
		btn.backgroundColor = [UIColor greenColor];
	}
	if (bNeedAddToView) {
		[self addSubview:btn];
	}
	[arrButtonsInUse addObject:btn];
	[btn release];
}
// 释放资源
- (void)dealloc {
	if (sourceHeightStaic) {
		[sourceHeightStaic release];
		sourceHeightStaic = nil;
	}
	transInfo.sourceImageData = nil;
	transInfo.sourceVideoData = nil;
	[transInfo release];
	imageView.myAsyncImageViewDelegate = nil;
	videoImage.myAsyncImageViewDelegate = nil;
	[videoImage release];
	[imageView release];
	[colonLabel release];
	colonLabel = nil;
	[broadSourceFrom release];
	broadSourceFrom = nil;
	[broadSourceTime release];
	broadSourceFrom = nil;
	[super dealloc];
}

// 点击图片
- (void) tapPhoto:(UITapGestureRecognizer *)gesture{
	NSLog(@"gesture:%@",((AsyncImageView *)gesture.view).link);
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
	NSString *url = [NSString stringWithFormat:@"%@",((AsyncImageView *)gesture.view).link];
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

// 点击URL
- (void)touchUrl:(id)sender{
	UIButton *btn = (UIButton *)sender;
	NSString *linkString = [btn link];
	NSLog(@"btn.link:%@", linkString);
//	[[NSNotificationCenter defaultCenter] postNotificationName:@"WebUrlClicked" object:linkString];
	if ([btn.type intValue] == TypeHttpLink && [self.mySrcUrlDelegate respondsToSelector:@selector(SourceViewUrlClicked:)]) {
		[self.mySrcUrlDelegate SourceViewUrlClicked:linkString];
	}
	if ([btn.type intValue] == TypeNickName) {
		NSString *userName = [linkString substringFromIndex:[linkString rangeOfString:@"@"].location+1];
		UIImage *buttonImage = [UIImage imageNamed:@"DetailPageSelectedBg.png"];  
		UIImage *stretchableButtonImage = [buttonImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];//设置帽端为12px,也是就左边的12个像素不参与拉伸,有助于圆角图片美观  
		[btn setBackgroundImage:stretchableButtonImage forState:UIControlStateHighlighted];
		[[PushAndRequest shareInstance] pushControllerType:self.controllerType withName:userName];
	}
	if ([btn.type intValue] == TypeTopic) {
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

// 点击视频
- (void) tapVideo:(UITapGestureRecognizer *)gesture{
	NSLog(@"gesture:%@",((AsyncImageView *)gesture.view).link);
	if ([self.mySrcVideoDelegate respondsToSelector:@selector(SourceViewVideoClicked:)]) {
		[self.mySrcVideoDelegate SourceViewVideoClicked:((AsyncImageView *)gesture.view).link];
	}
	// 目前还没有视频对应url
}

- (void)storeGifToCache:(NSData *)gifImageData{
	NSString *urlString = [[NSString alloc] initWithFormat:@"%@/%d",self.transInfo.transImage,DPUrlImageRequestSize];
	[[IWBGifImageCache sharedImageCache] storeImageData:gifImageData forKey:urlString toDisk:YES];
	[urlString release];
}

#pragma mark protocol AsyncImageViewDelegate<NSObject> 图片加载完毕委托方法

-(void)AsyncImageViewHasLoadedImage:(NSData *)dataRef {
	self.transInfo.sourceImageData = dataRef;
	if ([IWBGifImageView isGifImage:dataRef]) {
		[self performSelectorInBackground:@selector(storeGifToCache:) withObject:dataRef];
	}
	self.hasLoadedImage = YES;
	// 通知父窗体图像变更
	if (self.hasLoadedVideo && [self.mySourceViewImageDelegate respondsToSelector:@selector(SourceViewHasLoadedImage)]) {
		[self.mySourceViewImageDelegate SourceViewHasLoadedImage];
	}
	// 刷新当前窗体
	if (self.hasLoadedVideo) {
		[self setNeedsDisplay];
	}
}

-(void)AsyncImageViewHasLoadedVideo:(NSData *)dataRef {
	self.transInfo.sourceVideoData = dataRef;
	
	self.hasLoadedVideo = YES;
	// 通知父窗体图像变更
	if (self.hasLoadedImage && [self.mySourceViewImageDelegate respondsToSelector:@selector(SourceViewHasLoadedImage)]) {
		[self.mySourceViewImageDelegate SourceViewHasLoadedImage];
	}
	// 刷新当前窗体
	if (self.hasLoadedImage) {
		[self setNeedsDisplay];
	}
}
@end
