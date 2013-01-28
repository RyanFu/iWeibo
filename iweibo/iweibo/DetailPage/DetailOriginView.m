//
//  DetailOriginView.m
//  iweibo
//
//  Created by Minwen Yi on 5/7/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "DetailOriginView.h"
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
#import "DataManager.h"
#import "TimelinePageConst.h"

static  NSMutableDictionary *g_DetailOriginUnitItemDic = nil;

@implementation DetailOriginView
@synthesize controllerType, isLongPress;
@synthesize info;
@synthesize imageViewEx, videoViewEx;
@synthesize myDetailOriginViewDelegate;

+(NSMutableDictionary *)DetailOriginViewUnitItemDic {
	if (nil == g_DetailOriginUnitItemDic) {
		g_DetailOriginUnitItemDic = [[NSMutableDictionary alloc] initWithCapacity:1];
	}
	return g_DetailOriginUnitItemDic;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		//初始化
		self.hasPortrait = NO;
		self.backgroundColor = [UIColor clearColor];
		self.opaque = YES;
		self.headFont = [UIFont fontWithName:@"helvetica" size:OriginTextFontSize];
		textFont = [UIFont fontWithName:@"helvetica" size:OriginTextFontSize];//自定义字体初始化
		tailFont = [UIFont fontWithName:@"helvetica" size:CommentCntsTextFontSize];
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
		
		// 时间标签
		timeLabel = [[UILabel alloc] init];
		timeLabel.frame = CGRectMake(0.0f, 0.0f, 20.0f, 18.0f);	// 任意框架
		timeLabel.backgroundColor = [UIColor clearColor];
		timeLabel.textColor = [UIColor colorWithRed:0.502f green:0.502f blue:0.502f alpha:1];
		timeLabel.font = tailFont;
		timeLabel.tag = TimeLableTag;
		timeLabel.hidden = YES;
		[self addSubview:timeLabel];		
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
	self.imageViewEx = nil;
	self.videoViewEx = nil;
	info.imageImageData = nil;
	info.videoImageData = nil;
	[info release];
	[timeLabel release];
    [super dealloc];
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
		[btn setTitleColor:[UIColor colorWithRed:0.2 green:0.455 blue:0.596 alpha:1] forState:UIControlStateNormal];
		[btn setTitleColor:[UIColor colorWithRed:0.2 green:0.455 blue:0.596 alpha:1] forState:UIControlStateHighlighted];
	}
	btn.userInteractionEnabled = YES;
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
		btn.backgroundColor = [UIColor clearColor];
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
	// 1. url点击
	if ([((UIButton *)sender).type intValue]== TypeHttpLink && [self.myDetailOriginViewDelegate respondsToSelector:@selector(DetailOriginViewUrlClicked:)]) {
		[self.myDetailOriginViewDelegate DetailOriginViewUrlClicked:linkString];
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

// 视频点击事件
- (void) tapVideo:(UITapGestureRecognizer *)gesture{
	NSLog(@"gesture:%@",((UIImageView *)gesture.view).link);
	if ([self.myDetailOriginViewDelegate respondsToSelector:@selector(DetailOriginViewVideoClicked:)]) {
		[self.myDetailOriginViewDelegate DetailOriginViewVideoClicked:((UIImageView *)gesture.view).link];
	}
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
	self.hasLoadedImage = YES;
	[imageViewEx setLink:info.image];
	if (nil == info.imageImageData || 0 == [info.imageImageData length]) {
		position.x = (DPOriginTextWidth - DefaultImageWidth) / 2.0f;
		[imageViewEx setFrame:CGRectMake(position.x, position.y + virticalSpace, DefaultImageWidth, DefaultImageHeight)];
		self.hasLoadedImage = NO;
		imageViewEx.image = [UIImageManager defaultImage:ICON_ORIGIN_IMAGE];	
		UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(27.0f, 27.0f, 25.0f, 25.0f)];
		[activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
		[imageViewEx addSubview:activityIndicator];
		[activityIndicator startAnimating];
		[activityIndicator release];
		//self.labelLocation = position.y + virticalSpace;
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
			//imageViewEx.autoresizingMask = UIViewAutoresizingFlexibleHeight;
			// 4.0f为边框宽度
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
			[imageViewEx setFrame:CGRectMake(position.x - ImageFrameWidth, position.y + virticalSpace, DefaultImageWidth + 2 * ImageFrameWidth, DefaultImageHeight + 2 * ImageFrameWidth)];
			imageViewEx.image = [UIImageManager defaultImage:ICON_ORIGIN_IMAGE];
		}
	}
	// x座标偏移量:(视频总是居中显示，修改x无实际意义)
	//position.x += TLHSBetweenImageAndVideo + DefaultImageWidth;
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
	if (nil == info.videoImageData || 0 == [info.videoImageData length]) {
		videoViewEx.frame = CGRectMake((DPOriginTextWidth - DefaultImageWidth) / 2.0f , position.y, DefaultImageWidth, DefaultImageHeight);
		NSData *gifData = [[IWBGifImageCache sharedImageCache] imageFromKey:vUrl.picurl fromDisk:YES];
		if (gifData) {
			[videoViewEx setGIFData:gifData];
			self.hasLoadedVideo = YES;
		}
		else{
			self.hasLoadedVideo = NO;
			videoViewEx.image = [UIImageManager defaultImage:ICON_ORIGIN_VIDEO_IMAGE];
		}
		[self addVideoPlayImageWithRul:vUrl.realurl];
	}
	else {
		// 从数据流加载
		// 1. 求取图片规格
		UIImage *imageVideo = [[UIImage alloc] initWithData:info.videoImageData];
		//assert(imageVideo);
		if (imageVideo != nil) {
			// 高度计算,最大尺寸为MaxVideoWidth * MaxVideoHeight
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
			//CLog(@"imageVideo.size.width:%f position.x:%f position.y", imageVideo.size.width, position.x);
			videoViewEx.frame = CGRectMake(position.x , position.y, imageScaleWidth, imageHeight);
			// 3. 加载图片
			videoViewEx.image = imageVideo;
			[self addVideoPlayImageWithRul:vUrl.realurl];
			[imageVideo release];
		}
		else {
			// 视频加载异常的情况
			position.x = (DPOriginTextWidth - DefaultImageWidth) / 2.0f;
			[videoViewEx setFrame:CGRectMake(position.x, position.y, DefaultImageWidth, DefaultImageHeight)];
			videoViewEx.image = [UIImageManager defaultImage:ICON_ORIGIN_VIDEO_IMAGE];
			[self addVideoPlayImageWithRul:vUrl.realurl];
		}
		
	}	
	[videoViewEx setLink:vUrl.realurl];
	[dataManager release];	
}

//点击图片
- (void) tapPhoto:(UITapGestureRecognizer *)gesture{
	//NSLog(@"gesture:%@",((AsyncImageView *)gesture.view).link);
	iweiboAppDelegate *delegate = (iweiboAppDelegate *)[UIApplication sharedApplication].delegate;
	NSString *url = [NSString stringWithFormat:@"%@",((UIImageView *)gesture.view).link];	
	delegate.draws = 0;	// 2012-3-12 zhaolilong 处理导航栏
	ZoomView *zoomView = [[ZoomView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	zoomView.imageUrl = url;
	[delegate.window addSubview:zoomView];
	[zoomView release];
}

-(void)addMainText {
	if (info.origtext!=nil) {
		NSMutableArray *arrItem = (NSMutableArray *)[[DetailOriginView DetailOriginViewUnitItemDic] objectForKey:info.uid];
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
					position = unitItem.itemPos;
					[self addLink:position withTmpString:unitItem.itemText withString:unitItem.itemLink withType:unitItem.itemType];
					position.x += [unitItem.itemText sizeWithFont:textFont].width;
				}
					break;
				case TypeText: {
                    CLog(@"%s, %@", __FUNCTION__, unitItem);
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
		if (position.x == frameWidth) {
			position.x = 0;
			//position.y += 25;
			CGFloat wordHeight = [@"我" sizeWithFont:textFont].height;		// 文本高度
			position.y += wordHeight;
		}
	}
}

// x方向从0开始画, 文本宽度(不包括距离右边框宽度值)为frameWidth
//- (void)drawRect:(CGRect)rect {
-(void)addSubViews {	
	[self recycleSubViews];
	// 设置文本宽度
	frameWidth = D_CONTENT_WIDTH;//详细页内容宽度
	
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
	}
	position = CGPointZero;//位置初始化	
	[self addMainText];
	
	//[timeTrackHomeText release];
	// 最后一行不足一行宽度的情况下，需要增加一个文字高度, x坐标变0.0f
	if (position.x > 0.1f) {
		position.y += [@"我" sizeWithFont:textFont].height;		// 加上一行高度
		position.x = TLHSBetweenOriginFrameAndImage;
	}
	[self drawPicture];
	[self drawVideoPic];
}
- (void)storeGifToCache:(NSData *)gifImageData{
	if ([IWBGifImageView isGifImage:gifImageData]) {
		NSString  *urlString = [[NSString alloc] initWithFormat:@"%@/%d",info.image,DPUrlImageRequestSize];
		[[IWBGifImageCache sharedImageCache] storeImageData:gifImageData forKey:urlString toDisk:YES];
		[urlString release];
	}
}
@end
