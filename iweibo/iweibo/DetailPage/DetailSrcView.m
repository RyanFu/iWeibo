//
//  DetailSrcView.m
//  iweibo
//
//  Created by Minwen Yi on 5/7/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "DetailSrcView.h"
#import "ColorUtil.h"
#import <QuartzCore/QuartzCore.h>
#import "DetailPageConst.h"
#import "IWBGifImageCache.h"
#import "UIImageManager.h"
#import "VideoLink.h"
#import "ZoomView.h"
#import "iweiboAppDelegate.h"
#import "CustomLink.h"
#import "PushAndRequest.h"

static  NSMutableDictionary *g_DetailSrcUnitItemDic = nil;

@implementation DetailSrcView
@synthesize transInfo;
@synthesize myDetailSrcViewDelegate;
@synthesize imageViewEx, videoImageEx;
@synthesize controllerType;
@synthesize isLongPress;

+(NSMutableDictionary *)DetailSrcViewUnitItemDic {
	if (nil == g_DetailSrcUnitItemDic) {
		g_DetailSrcUnitItemDic = [[NSMutableDictionary alloc] initWithCapacity:1];
	}
	return g_DetailSrcUnitItemDic;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		hasLoadedImage = NO;
		// 初始化设置
		self.tag = 003;
		self.hasPortrait = NO;
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
		// ”来自..."
		broadSourceFrom = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 15.0f, 18.0f)];
		broadSourceFrom.backgroundColor = [UIColor clearColor];		
		broadSourceFrom.textColor = [UIColor colorWithRed:0.502f green:0.502f blue:0.502f alpha:1];
		broadSourceFrom.font = tailFont;
		broadSourceFrom.tag = BroadcastSourceFromTag;
		[self addSubview:broadSourceFrom];
		broadSourceTime = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 15.0f, 18.0f)];
		broadSourceTime.textColor = [UIColor colorWithRed:0.502f green:0.502f blue:0.502f alpha:1];
		broadSourceTime.backgroundColor = [UIColor clearColor];
		broadSourceTime.font = tailFont;
		broadSourceTime.tag = BroadcastSourceFromTimeTag;
		[self addSubview:broadSourceTime];
		for (UIButton *btn in arrButtonsFree) {
			btn.titleLabel.font = textFont;
		}
		for (UILabel *lb in arrLablesFree) {
			lb.font = textFont;
			lb.textColor = [UIColor colorStringToRGB:[NSString stringWithFormat:@"%d",OriginTextColor]];
		}
		nickBtn.titleLabel.font = textFont;
    }
    return self;
}

-(void)dealloc {
	[colonLabel release];
	[broadSourceFrom release];
	[broadSourceTime release];
	transInfo.sourceImageData = nil;
	transInfo.sourceVideoData = nil;
	[transInfo release];
	self.imageViewEx = nil;
	self.videoImageEx = nil;
	[super dealloc];
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
	btn.userInteractionEnabled = YES;
	[btn setTitle:tempString2 forState:UIControlStateNormal];									     // 设置按钮标题
	[tempString2 release];
	[btn setLink:string];																	    // 设置链接
	[btn setType:[NSString stringWithFormat:@"%d",type]];									    // 设置链接类型
	btn.frame = CGRectMake(mPosition.x, mPosition.y, stringSize.width, stringSize.height);
	if (isLongPress) {
		btn.backgroundColor = [UIColor greenColor];
	}
	else {
		btn.backgroundColor = [UIColor clearColor];
	}

	if (bNeedAddToView) {
		[self addSubview:btn];
	}
	[arrButtonsInUse addObject:btn];
	[btn release];	
	
}

// 点击图片
- (void) tapPhoto:(UITapGestureRecognizer *)gesture{
	NSLog(@"gesture:%@",((UIImageView *)gesture.view).link);
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
	NSString *url = [NSString stringWithFormat:@"%@",((UIImageView *)gesture.view).link];		
	delegate.draws = 0;			// 2012-3-12 zhaolilong 处理导航栏
	ZoomView *zoomView = [[ZoomView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	zoomView.imageUrl = url;
	[delegate.window addSubview:zoomView];
	[zoomView release];
}

// 点击URL
- (void)touchUrl:(id)sender{
	UIButton *btn = (UIButton *)sender;
	NSString *linkString = [btn link];
	NSLog(@"btn.link:%@", linkString);
	//	[[NSNotificationCenter defaultCenter] postNotificationName:@"WebUrlClicked" object:linkString];
	if ([btn.type intValue] == TypeHttpLink && [self.myDetailSrcViewDelegate respondsToSelector:@selector(DetailSrcViewUrlClicked:)]) {
		[self.myDetailSrcViewDelegate DetailSrcViewUrlClicked:linkString];
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
//	NSLog(@"gesture:%@",((AsyncImageView *)gesture.view).link);
	if ([self.myDetailSrcViewDelegate respondsToSelector:@selector(DetailSrcViewVideoClicked:)]) {
		[self.myDetailSrcViewDelegate DetailSrcViewVideoClicked:((UIImageView *)gesture.view).link];
	}
	// 目前还没有视频对应url
}

// 绘制转发图片
- (void)drawPicture {
	for (NSInteger i = 0; i < [imageViewEx.subviews count]; i++) {
		UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[imageViewEx.subviews objectAtIndex:i];
		[activityIndicator stopAnimating]; 
		[activityIndicator removeFromSuperview];
		activityIndicator = nil;
		break;
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
			if (originVideo.size.height > MaxVideoHeight) {
				virticalSpace += MaxVideoHeight + VSBetweenImageAndVideo;
			}
			else {
				virticalSpace += originVideo.size.height + VSBetweenImageAndVideo;
			}
			[originVideo release];
		}					
	}
	// 加载图片
	[imageViewEx setLink:transInfo.transImage];
	self.hasLoadedImage = YES;
	if (nil == transInfo.sourceImageData || 0 == [transInfo.sourceImageData length]) {
		position.x = (DPOriginTextWidth - DefaultImageWidth) / 2.0f;
		[imageViewEx setFrame:CGRectMake(position.x, position.y + virticalSpace, DefaultImageWidth, DefaultImageHeight)];
		//self.labelLocation = position.y + virticalSpace;
		self.hasLoadedImage = NO;
		UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(27.0f, 27.0f, 25.0f, 25.0f)];
		[activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
		[imageViewEx addSubview:activityIndicator];
		[activityIndicator startAnimating];
		[activityIndicator release];
		imageViewEx.image = [UIImageManager defaultImage:ICON_SOURCE_IMAGE];
		// 4. 计算label偏移高度
		self.labelLocation =  position.y + virticalSpace + DefaultImageHeight + VSBetweenSourceFromAndText;
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
			imageViewEx.autoresizingMask = UIViewAutoresizingFlexibleHeight;
			// 3. 加载图片
			[imageViewEx setLink:transInfo.transImage];
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
			self.labelLocation = imageViewEx.frame.origin.y + imageViewEx.frame.size.height + ImageFrameWidth + VSBetweenSourceImageAndText;
			
		}
		else {
			position.x = (DPOriginTextWidth - DefaultImageWidth) / 2.0f;
			[imageViewEx setFrame:CGRectMake(position.x - ImageFrameWidth, position.y + virticalSpace, DefaultImageWidth + 2 * ImageFrameWidth, DefaultImageHeight + 2 * ImageFrameWidth)];
			[imageViewEx setLink:transInfo.transImage];
			imageViewEx.image = [UIImageManager defaultImage:ICON_SOURCE_IMAGE];
			self.labelLocation = imageViewEx.frame.origin.y + imageViewEx.frame.size.height + 2*ImageFrameWidth + VSBetweenSourceImageAndText;
			
		}
		// lichntao 2012-02-21 发送通知，告诉DetailCell图片从本地加载
		//[[NSNotificationCenter defaultCenter] postNotificationName:@"getPictureDownLoadingFinished" object:nil];
	}
	
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
	// 详细页面视频缩略图
	if (nil == transInfo.sourceVideoData || 0 == [transInfo.sourceVideoData length]) {
		self.hasLoadedVideo = NO;
		videoImageEx.frame = CGRectMake((DPOriginTextWidth - DefaultImageWidth) / 2.0f , position.y, DefaultImageWidth, DefaultImageHeight);
		videoImageEx.image = [UIImageManager defaultImage:ICON_SOURCE_VIDEO_IMAGE];
		[self addVideoPlayImageWithRul:transInfo.transVideoRealUrl];
		position.y += DefaultImageHeight + VSBetweenSourceImageAndText;
	}
	else {
		// 从数据流加载
		// 1. 求取图片规格
		UIImage *imageVideo = [[UIImage alloc] initWithData:transInfo.sourceVideoData];
		if (imageVideo != nil) {
			CGFloat imageHeight = imageVideo.size.height;
			CGFloat imageScaleWidth = imageVideo.size.width;
			if (imageVideo.size.height > MaxVideoHeight) {
				imageHeight = MaxVideoHeight;
				imageScaleWidth = imageVideo.size.width * (imageVideo.size.height / MaxVideoHeight);	// 按比例收缩
			}
			// 假如收缩后还大于MaxVideoWidth，则取MaxVideoWidth
			if (imageScaleWidth > MaxVideoWidth) {
				imageScaleWidth = MaxVideoWidth;
			}
			position.x = (DPOriginTextWidth - imageScaleWidth) / 2.0f;
			
			[videoImageEx setFrame:CGRectMake(position.x , position.y, imageScaleWidth, imageHeight)];
			videoImageEx.image = imageVideo;
			[self addVideoPlayImageWithRul:transInfo.transVideoRealUrl];
			
			// 4. 计算label偏移高度
			//self.labelLocation = position.y + imageSrc.size.height / 2.0f;
			position.y += imageHeight  + VSBetweenSourceImageAndText;
			[imageVideo release];
			
		}
		else {
			// 视频加载异常的情况
			position.x = (DPOriginTextWidth - DefaultImageWidth) / 2.0f;
			[videoImageEx setFrame:CGRectMake(position.x, position.y, DefaultImageWidth, DefaultImageHeight)];
			videoImageEx.image = [UIImageManager defaultImage:ICON_SOURCE_VIDEO_IMAGE];
			position.y += DefaultImageHeight + VSBetweenSourceImageAndText;
		}
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

-(void)addMainText {
	// 文本处理
	NSString *sourceOrigtext = self.transInfo.transOrigtext;
	if (sourceOrigtext != nil) {
		NSMutableArray *arrItem = (NSMutableArray *)[[DetailSrcView DetailSrcViewUnitItemDic] objectForKey:transInfo.transId];
		for (MessageUnitItemInfo *unitItem in arrItem) {
			position = unitItem.itemPos;
			position.x += 5;	// 边距
			CLog(@"position.x:%f, position.y:%f", position.x, position.y);
			switch (unitItem.itemType) {
				case TypeEmotion: {
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
						emotionView.backgroundColor = [UIColor clearColor];
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
					[self addLink:position withTmpString:unitItem.itemText withString:unitItem.itemLink withType:unitItem.itemType];
					position.x += [unitItem.itemText sizeWithFont:textFont].width;
				}
					break;
				case TypeText: {
                    CLog(@"%s, %@", __FUNCTION__, unitItem);
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
						lb.backgroundColor = [UIColor clearColor];
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


// x方向从5开始画, 文本宽度为frameWidth
- (void)addSubViews {
	[self recycleSubViews];
	/************************************绘制字符串****************************************/
	//宽度初始化
	self.frameWidth = D_SOURCE_WIDTH - 13;	// 减掉右边距
	// 清除子视图
	for (UIView *_view in self.subviews) {
		if ([_view isMemberOfClass:[UIImageView class]]
			) {
			UIImageView	*imgView = (UIImageView *)_view;
			// 去除边框
			if (EmotionViewTag != imgView.tag && imgView.tag != VIPImageTag && ImageTag != imgView.tag && videoImageTag != imgView.tag) {
				[_view removeFromSuperview];
				_view = nil;
			}
		}
		//if ([_view isMemberOfClass:[UIButton class]]) {
//			UIButton *btn = (UIButton *)_view;
//			if (LinkButtonTag != btn.tag && nickBtn != btn) {
//				[_view removeFromSuperview];
//				_view = nil;
//			}
//		}
//		if ([_view isMemberOfClass:[UILabel class]]) {
//			UILabel *lb = (UILabel *)_view;
//			if (TextLabelTag != lb.tag && ColonLabelTag != lb.tag && BroadcastSourceFromTag != lb.tag
//				&& BroadcastSourceFromTimeTag != lb.tag) {
//				[lb removeFromSuperview];
//				lb = nil;
//			}
//		}
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
	else {
		nickBtn.backgroundColor = [UIColor clearColor];
	}
	[nickBtn setLink:[NSString stringWithFormat:@"@%@", transInfo.transName]];
	nickBtn.userInteractionEnabled = YES;
	nickBtn.frame = CGRectMake(position.x, position.y, sourceNickSize.width, sourceNickSize.height);
	position.x += sourceNickSize.width;
	//NSLog(@"本地认证1:%@",transInfo.translocalAuth);
	// 1.3 判断是否是vip用户,假如是，需要加上vip图表宽度(源消息没有)
	if ([transInfo.transIsvip boolValue]) {
		vipImage.hidden = NO;
		if (isLongPress) {
			vipImage.backgroundColor = [UIColor greenColor];
		}else {
			vipImage.backgroundColor = [UIColor clearColor];
		}
		vipImage.image = [UIImage imageNamed:@"vip-btn.png"];
		vipImage.frame = CGRectMake(position.x, position.y, VipImageWidth, VipImageWidth);
		position.x += VipImageWidth;
	}else if ([transInfo.translocalAuth boolValue]) {
		vipImage.hidden = NO;
		if (isLongPress) {
			vipImage.backgroundColor = [UIColor greenColor];
		}else {
			vipImage.backgroundColor = [UIColor clearColor];
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
		colonLabel.backgroundColor = [UIColor clearColor];
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
}
- (void)storeGifToCache:(NSData *)gifImageData{
	if ([IWBGifImageView isGifImage:gifImageData]) {
		NSString *urlString = [[NSString alloc] initWithFormat:@"%@/%d",self.transInfo.transImage,DPUrlImageRequestSize];
		[[IWBGifImageCache sharedImageCache] storeImageData:gifImageData forKey:urlString toDisk:YES];
		[urlString release];
	}
}
@end
