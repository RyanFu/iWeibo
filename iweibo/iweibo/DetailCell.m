//
//  detailCell.m
//  iweibo
//
//  Created by wangying on 1/29/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "detailCell.h"
#import "OriginView.h"
#import "SourceView.h"
#import "TransInfo.h"
#import "Info.h"
#import "DetailPageConst.h"
#import "MessageViewUtility.h"
#import "OriginViewFrameCalcBase.h"
#import <QuartzCore/QuartzCore.h>
#import "MessageViewUtility.h"
#import "OriginViewEx.h"
#import "DetailSrcView.h"
#import "IWBGifImageCache.h"

@implementation DetailCell
@synthesize sourceView,originView;
@synthesize sourceInfo,homeInfo,heightDic,remRow;
@synthesize firstRowHeight,sourceHeight,originHeight;
@synthesize myDetailCellDelegate;
@synthesize hasComment;
@synthesize sourceViewPicFinished;
@synthesize longPressCopy;
@synthesize picNotificationCount,rContrlType;
@synthesize imgManager;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier showStyle:(OriginShowSytle)showStyle{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		imgManager = [[DPUIImageManager alloc] initWithDelegate:self];
		imgManager.searchFromLocal = NO;
		self.backgroundColor = [UIColor brownColor];
		sourceView = [[DetailSrcView alloc] init];
		sourceView.myDetailSrcViewDelegate = self;
		//sourceView.sourceStyle = BroadSourceSytle;
//		sourceView.mySrcUrlDelegate = self;
//		sourceView.mySourceViewImageDelegate = self;
//		sourceView.mySrcVideoDelegate = self;
		// 调用系统粘贴板操作lichentao 2012-02-15
		UILongPressGestureRecognizer *sourceViewLongPressGesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMenuControl:)] autorelease];
		[sourceView addGestureRecognizer:sourceViewLongPressGesture];
		[self.contentView addSubview:sourceView];
		
		broadFromLabel = [[UILabel alloc] init];
			//broadFromLabel.frame = CGRectMake(5, position.y + 20, 80, 30);
		broadFromLabel.backgroundColor = [UIColor clearColor];
			//broadFromLabel.text = [NSString stringWithFormat:@"来自:%@",info.from];
		broadFromLabel.font = [UIFont systemFontOfSize:12];
		[self addSubview:broadFromLabel];
		[broadFromLabel release];
		
		broadTimeLabel = [[UILabel alloc] init];
			//broadTimeLabel.frame = CGRectMake(90, position.y + 20, 80, 30);
			//broadTimeLabel.text = [Info intervalSinceNow:[info.timeStamp doubleValue]];
		broadTimeLabel.backgroundColor = [UIColor clearColor];
		broadTimeLabel.font = [UIFont systemFontOfSize:12];
		[self addSubview:broadTimeLabel];
		[broadTimeLabel release];	
		
		originView = [[DetailOriginView alloc] init];
		originView.myDetailOriginViewDelegate = self;
//		originView.showStyle = BroadShowSytle;
//		originView.myOriginUrlDelegate = self;
//		originView.myOriginVideoDelegate = self;
//		originView.myOriginViewDelegate = self;

		// lichentao 2012-02-15给originView添加长按和点击手势，长按出现系统粘贴板，点击则恢复copy内容的背景颜色 
		UILongPressGestureRecognizer *originViewLongPressGesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMenuControl:)] autorelease];
		[originView addGestureRecognizer:originViewLongPressGesture];
		[self.contentView addSubview:originView];
		
		commentLabel = [[UILabel alloc] init];
		//commentLabel.hidden = YES;
		commentLabel.backgroundColor = [UIColor clearColor];
		commentLabel.font = [UIFont systemFontOfSize:12];
		[self addSubview:commentLabel];
		[commentLabel release];
		
		// lichentao 2012-02-16 当originView文字选中状态时，滑动DetailPage的表格将文字背景颜色去掉
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOriginandSourceView:) name:@"refreshOriginView" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canLongPress:) name:@"getPictureDownLoadingFinished" object:nil];
	}
    return self;
}

// lichentao 2012-02-16滑动数据表tableView时候刷新详细页面中的主消息文字和源消息背景色，逻辑判断避免多次刷新操作
- (void)refreshOriginandSourceView:(id)sender{
	if (originView.isLongPress) {
		[self originViewNeedDisplay];
	}
	if (sourceView.isLongPress) {
		[self sourceViewNeedDisplay];
	}
}

// lichentao 2012-02-21源图片加载完毕后将sourceViewPicFinished置为YES,可以长按
- (void)canLongPress:(id)sender{
	picNotificationCount ++;
	if (picNotificationCount == 1) {
		sourceViewPicFinished = YES;
	}
}

// lichentao 2012-02-16点击文字区域以外的部分，在复制状态下，取消文字背景颜色
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	NSArray *touch = [touches allObjects];
	UITouch *firstTouch = [touch objectAtIndex:0];
	// 在有住消息的情况下
	if (originView.info) {
		// 主消息与源消息点击位置坐标点
		CGPoint originViewPoint = [firstTouch locationInView:originView];
		CGFloat originViewTextHeight = [MessageViewUtility getOriginViewTextHeight:originView.info];
		// 逻辑判断：当点击位置大于文本高度，则刷新背景色
		if (originViewPoint.y > originViewTextHeight){
			if (originView.isLongPress) {
				[self originViewNeedDisplay];
			}
		}else if(originViewPoint.y > 0 && originViewPoint.y < originViewTextHeight){
			if (originView.isLongPress) {
				[self showCopyMenu:originView];
			}
		}

	}
	// 在有源消息的情况下
	if (sourceView.transInfo) {
		CGPoint sourceViewPoint = [firstTouch locationInView:sourceView];
		CGFloat sourceViewTextHeight = [MessageViewUtility getSourceViewTextHeight:sourceView.transInfo];
		// 逻辑判断：当点击位置大于文本高度，或者点击的是主消息位置将会刷新源消息背景颜色
		if (sourceViewPoint.y > sourceViewTextHeight) {
			if (sourceView.isLongPress) {
				[self sourceViewNeedDisplay];
			}
		}else if (sourceViewPoint.y > 0 && sourceViewPoint.y < sourceViewTextHeight) {
			if (sourceView.isLongPress) {
				[self showCopyMenu:sourceView];
			}
		}
	}
}

// 重新刷新sourceView
- (void)sourceViewNeedDisplay{
	sourceView.isLongPress = NO;
	[sourceView addSubViews];
}

// 重新刷新originView
- (void)originViewNeedDisplay{
	originView.isLongPress = NO;
	[originView addSubViews];
}
#pragma mark -
#pragma mark UIMenuController显示粘贴板
// 调用系统粘贴板相关方法lichentao 2012-02-15
- (void)showMenuControl:(id)sender{
		UILongPressGestureRecognizer *gesture = (UILongPressGestureRecognizer *)sender;
		CGPoint location = [gesture locationInView:[gesture view]];
		CGFloat  textViewHeight;
		if ([gesture.view isKindOfClass:[DetailSrcView class]]) {
			longPressCopy = 1;
			textViewHeight = [MessageViewUtility getSourceViewTextHeight:sourceView.transInfo];
		}else {
			longPressCopy = 0;
			textViewHeight = [MessageViewUtility getOriginViewTextHeight:originView.info];
		}
		if (location.y < textViewHeight) {
			if ([gesture.view isKindOfClass:[DetailOriginView class]]) {//  判断长按主消息
				originView.isLongPress = YES;					  //  将长按状态改变,YES（可以长按）	  
				if ([originView.info.image length] == 0) {		  //  如果住消息没有图片,看源消息是否有图片，没有则刷新复制背景
					if ([sourceView.transInfo.transImage length] == 0) {
						[self showCopyMenu:originView];
						[originView addSubViews];
					}else {										  //  如果主消息没有图片,源消息有图片，当源消息加载完后可以刷新复制背景
						if (sourceViewPicFinished) {
							[self showCopyMenu:originView];
							[originView addSubViews];
						}
					}

				}else {											 // 如果主消息有图片，等图片加载完后可以刷新主消息文本背景
					if (sourceViewPicFinished) {
					[self showCopyMenu:originView];
					[originView addSubViews];
					}
				}
				// 主消息与源消息之间切换长按操作，长按主消息，则更改源消息文本背景状态
				if (sourceView.isLongPress) {
					[self sourceViewNeedDisplay];
				}
			}else if ([gesture.view isKindOfClass:[DetailSrcView class]]) {
				sourceView.isLongPress = YES;
				// 没有图片，长按后立即刷新显示绿色背景
				if ([sourceView.transInfo.transImage length] == 0) {
					if ([originView.info.image length] == 0) {
						[self showCopyMenu:sourceView];
						[sourceView addSubViews];
					}else {
						if (sourceViewPicFinished) {
							[self showCopyMenu:sourceView];
							[sourceView addSubViews];
						}
					}

				}else {
				// 有图片，则等图片加载完毕后才能刷新北京	
					if (sourceViewPicFinished) {
					[self showCopyMenu:sourceView];
					[sourceView addSubViews];
					}
				}
				// 如果主消息是复制状态，将其恢复默认状态(无背景状态)
				if (originView.isLongPress) {
					[self originViewNeedDisplay];
				}
			} else{
				//如果长按位置在其他地方不会产生副作用

			}
	  }
}

// lichentao 2012-01-15显示粘贴板复制按钮
- (void)showCopyMenu:(UIView *)touchView{
	// 显示粘贴板菜单
	[self becomeFirstResponder];
	UIMenuController * menu = [UIMenuController sharedMenuController];
	[menu setTargetRect:CGRectMake(touchView.frame.size.width/2, 2, 0, 0) inView: touchView];
	[menu setMenuVisible: YES animated:YES];	 
}

// 粘贴板系统必须返回操作
-(BOOL)canBecomeFirstResponder {
	return YES;
}

// 粘贴板只是显示复制按钮
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    BOOL retValue = NO;	
	if (action == @selector(copy:)) {
		// The square must hold a ColorTile object.
		retValue = YES;
	}else{
		retValue = NO;
	}
	return retValue;
}

// 选择复制后将复制内容存入粘贴板库中
- (void)copy:(id)sender {
	UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
	if (longPressCopy == 1) {
		[gpBoard setString:sourceView.transInfo.transOrigtext];
	}else if (longPressCopy == 0) {
		[gpBoard setString:originView.info.origtext];
	}
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//}

-(void)setHomeInfo:(Info *)info{
	homeInfo = info;
	[imgManager cancelAllIconDownloading];
	enumHeadStatus = IconDefault;
	enumOriginImageStatus = IconDefault;
	enumOriginVideoImgStatus = IconDefault;
	enumSrcImageStatus = IconDefault;
	enumSrcVideoStatus = IconDefault;
	originView.frame = CGRectMake(DPOriginTextLeftSpaceWidth, 0, DPOriginTextWidth,originHeight);	
	originView.info = info;
	originView.controllerType = self.rContrlType;
	if([info.from isEqualToString:@""]||info.from == nil){
		broadFromLabel.text = @"来自:腾讯微博";
	}else {
		broadFromLabel.text = [NSString stringWithFormat:@"来自:%@",info.from];
	}

	CGSize fromSize = [broadFromLabel.text sizeWithFont:[UIFont systemFontOfSize:12]];

	broadFromLabel.frame = CGRectMake(DPOriginTextLeftSpaceWidth, originHeight , fromSize.width, fromSize.height);
	broadFromLabel.textColor = [UIColor colorWithRed:0.502f green:0.502f blue:0.502f alpha:1];
	
	NSString *timeString = [Info intervalSinceNow:[info.timeStamp doubleValue]];
	CGSize timeSize = [timeString sizeWithFont:[UIFont systemFontOfSize:12]];
	broadTimeLabel.text = timeString;
	broadTimeLabel.frame = CGRectMake(DPOriginTextLeftSpaceWidth + fromSize.width + 10, originHeight, timeSize.width, timeSize.height);
	broadTimeLabel.textColor = [UIColor colorWithRed:0.502f green:0.502f blue:0.502f alpha:1];

	// 来自...高度
	//CGFloat fromHeight = [@"来自..." sizeWithFont:[UIFont systemFontOfSize:12]].height + VSpaceBetweenOriginFrameAndFrom;

	//if (hasComment) {
//		commentLabel.text = [NSString stringWithFormat:@"原文共%d次转播/评论",[info.count intValue] + [info.mscount intValue]];
//		CGSize commentSize = [commentLabel.text sizeWithFont:[UIFont systemFontOfSize:12]];
//		CGFloat space = 0.0f;
//		if (sourceHeight > 1) {
//			space = VSBetweenSourceFrameAndFrom;
//		}
//		commentLabel.frame = CGRectMake(10, originHeight + sourceHeight + space + fromHeight, commentSize.width, commentSize.height);
//		commentLabel.textColor = [UIColor colorWithRed:0.502f green:0.502f blue:0.502f alpha:1];
//		//}else {
//		//commentLabel.hidden = YES;
//		//}
//	}
	//[iconView loadImageFromURL:[NSString stringWithFormat:@"%@/41",info.head] withType:multiMediaTypeHead userId:info.uid];
}	

-(void)setSourceInfo:(TransInfo *)transInfo{
	if (transInfo != sourceInfo) {
		sourceInfo = transInfo;
	}
		// 判断是否有评论
	if ([transInfo.transCount intValue] + [transInfo.transCommitcount intValue] > 0) {
		hasComment = YES;
	}
	else {
		hasComment = NO;
	}
	
		
	sourceView.hidden = NO;
	// 来自...高度
	CGFloat fromHeight = [@"来自..." sizeWithFont:[UIFont systemFontOfSize:12]].height + VSpaceBetweenOriginFrameAndFrom;
	sourceView.frame = CGRectMake(DPOriginTextLeftSpaceWidth, originHeight + fromHeight, DPSourceFrameWidth, sourceHeight);
	sourceView.transInfo = transInfo;
	 sourceView.controllerType = self.rContrlType;
	if (hasComment) {
		commentLabel.text = [NSString stringWithFormat:@"原文共%d次转播/评论",[transInfo.transCount intValue] + [transInfo.transCommitcount intValue]];
		CGSize commentSize = [commentLabel.text sizeWithFont:[UIFont systemFontOfSize:12]];
		CGFloat space = 0.0f;
		if (sourceHeight > 1) {
			space = VSBetweenSourceFrameAndFrom;
		}
		commentLabel.frame = CGRectMake(10, originHeight + sourceHeight + space + fromHeight, commentSize.width, commentSize.height);
		commentLabel.textColor = [UIColor colorWithRed:0.502f green:0.502f blue:0.502f alpha:1];
			//}else {
			//commentLabel.hidden = YES;
			//}
	}	
	
}

- (void)dealloc {
	[imgManager release];
	//originView.myOriginUrlDelegate = nil;
	//originView.myOriginVideoDelegate = nil;
	//sourceView.mySourceViewImageDelegate = nil;
//	sourceView.mySrcVideoDelegate = nil;
//	sourceView.mySrcUrlDelegate = nil;
	sourceView.myDetailSrcViewDelegate = nil;
	originView.myDetailOriginViewDelegate = nil;
	//originView.myOriginViewDelegate = nil;
	[originView release];
	[sourceView release];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshOriginView" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"getPictureDownLoadingFinished" object:nil];
	[super dealloc];
}

-(void)doneLoadingGif {
	if ((originView.hasLoadedImage && originView.hasLoadedVideo) 
		&& (nil == sourceInfo || (sourceView.hasLoadedVideo && sourceView.hasLoadedImage))) {
		if ([self.myDetailCellDelegate respondsToSelector:@selector(DetailCellImageHasLoadedImage)]) {
			[self.myDetailCellDelegate DetailCellImageHasLoadedImage];
		}
	}
}
// 开始下载图片资源
- (void)startIconDownload {
	[imgManager cancelAllIconDownloading];
	//if (IconDoneDownloading != enumHeadStatus) {
//		enumHeadStatus = IconInDownloading;
//		[imgManager startGettingImageWithUrl:homeInfo.head requestID:homeInfo.uid andType:ICON_HEAD];
//	}
	// 图片加载
	if (originView.hasImage && !originView.hasLoadedImage && IconDoneDownloading != enumOriginImageStatus) {
		NSString *urlString = [[NSString alloc] initWithFormat:@"%@/%d", homeInfo.image, DPUrlImageRequestSize];
		NSData *gifData = [[IWBGifImageCache sharedImageCache] imageFromKey:urlString fromDisk:YES];
		[urlString release];
		if (gifData) {
			homeInfo.imageImageData = gifData;
			originView.hasLoadedImage = YES;
			enumSrcImageStatus = IconDoneDownloading;
			[self performSelector:@selector(doneLoadingGif) withObject:nil afterDelay:0.0f];
		}
		else {
			enumOriginImageStatus = IconInDownloading;
			[imgManager startGettingImageWithUrl:homeInfo.image requestID:homeInfo.uid andType:ICON_ORIGIN_IMAGE];
		}
	}
	if (originView.hasVideo && !originView.hasLoadedVideo && IconDoneDownloading != enumOriginVideoImgStatus) {
		DataManager *dataManager = [[DataManager alloc] init];
		videoUrl *vUrl = [dataManager manageVideoInfo:homeInfo.video];
		enumOriginVideoImgStatus = IconInDownloading;
		[imgManager startGettingImageWithUrl:vUrl.picurl requestID:homeInfo.uid andType:ICON_ORIGIN_VIDEO_IMAGE];
		[dataManager release];
	}
	if (NO == sourceView.hidden && sourceView.hasImage && !sourceView.hasLoadedImage && IconDoneDownloading != enumSrcImageStatus ) {
		NSString *urlString = [[NSString alloc] initWithFormat:@"%@/%d",sourceInfo.transImage,DPUrlImageRequestSize];
		NSData *gifData = [[IWBGifImageCache sharedImageCache] imageFromKey:urlString fromDisk:YES];
		[urlString release];
		if (gifData) {
			sourceInfo.sourceImageData = gifData;
			sourceView.hasLoadedImage = YES;
			enumSrcImageStatus = IconDoneDownloading;
			[self performSelector:@selector(doneLoadingGif) withObject:nil afterDelay:0.0f];
		}
		else{
			enumSrcImageStatus = IconInDownloading;
			[imgManager startGettingImageWithUrl:sourceInfo.transImage requestID:sourceInfo.transId andType:ICON_SOURCE_IMAGE];
		}
	}
	if (NO == sourceView.hidden && sourceView.hasVideo && !sourceView.hasLoadedVideo && IconDoneDownloading != enumSrcVideoStatus) {
		enumSrcVideoStatus = IconInDownloading;
		[imgManager startGettingImageWithUrl:sourceInfo.transVideo requestID:sourceInfo.transId andType:ICON_SOURCE_VIDEO_IMAGE];
		
	}
}

#pragma mark -

//#pragma mark protocol OriginViewUrlDelegate<NSObject> 地图缩略图点击委托事件
//
//-(void)OrignViewMapClicked:(CLLocationCoordinate2D)center{
//
//    if ([self.myDetailCellDelegate respondsToSelector:@selector(DetailCellMapClicked:)]) {
//        [self.myDetailCellDelegate DetailCellMapClicked:center];
//    }
//}
#pragma mark DetailOriginViewDelegate<NSObject>

- (void)DetailOriginViewUrlClicked:(NSString *)urlSource {
	if ([self.myDetailCellDelegate respondsToSelector:@selector(DetailCellUrlClicked:)]) {
		[self.myDetailCellDelegate DetailCellUrlClicked:urlSource];
	}
}
- (void)DetailOriginViewVideoClicked:(NSString *)urlVideo {
	if ([self.myDetailCellDelegate respondsToSelector:@selector(DetailCellVideoClicked:)]) {
		[self.myDetailCellDelegate DetailCellVideoClicked:urlVideo];
	}
}

#pragma mark DetailSrcViewDelegate<NSObject>
- (void)DetailSrcViewUrlClicked:(NSString *)urlSource {
	if ([self.myDetailCellDelegate respondsToSelector:@selector(DetailCellUrlClicked:)]) {
		[self.myDetailCellDelegate DetailCellUrlClicked:urlSource];
	}
}

- (void)DetailSrcViewVideoClicked:(NSString *)urlVideo {
	if ([self.myDetailCellDelegate respondsToSelector:@selector(DetailCellVideoClicked:)]) {
		[self.myDetailCellDelegate DetailCellVideoClicked:urlVideo];
	}
}

#pragma mark protocol UIImageManagerDelegate<NSObject>
// 加载图片完毕
-(void)UIImageManagerDoneLoadingWithData:(NSData *)imgData andType:(IconType)iType; {
	UIImage *img = [UIImage imageWithData:imgData];
	if (nil == img) {
		return;
	}
	switch (iType) {
		case ICON_ORIGIN_IMAGE: {
			[originView performSelectorInBackground:@selector(storeGifToCache:) withObject:imgData];
			homeInfo.imageImageData = imgData;
			originView.hasLoadedImage = YES;
			enumSrcImageStatus = IconDoneDownloading;
		}
			break;
		case ICON_ORIGIN_VIDEO_IMAGE: {
			homeInfo.videoImageData = imgData;
			originView.hasLoadedVideo = YES;
			enumSrcVideoStatus = IconDoneDownloading;
		}
			break;
		case ICON_SOURCE_IMAGE: {
			[sourceView performSelectorInBackground:@selector(storeGifToCache:) withObject:imgData];
			sourceInfo.sourceImageData = imgData;
			sourceView.hasLoadedImage = YES;
			enumSrcImageStatus = IconDoneDownloading;
		}
			break;
		case ICON_SOURCE_VIDEO_IMAGE: {
			sourceInfo.sourceVideoData = imgData;
			sourceView.hasLoadedVideo = YES;
			enumSrcVideoStatus = IconDoneDownloading;
		}
			break;
		default:
			break;
	}
	// 所有图片加载完毕则发送刷新通知
	if ((originView.hasLoadedImage && originView.hasLoadedVideo) 
		&& (nil == sourceInfo || (sourceView.hasLoadedVideo && sourceView.hasLoadedImage))) {
		if ([self.myDetailCellDelegate respondsToSelector:@selector(DetailCellImageHasLoadedImage)]) {
			[self.myDetailCellDelegate DetailCellImageHasLoadedImage];
		}
	}
}

@end
