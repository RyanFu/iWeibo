//
//  MessageViewBase.h
//  iweibo
//
//  Created by Minwen Yi on 4/16/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageFrameConsts.h"
#import "MessageUnitItemInfo.h"


#define EmotionViewTag			800
#define LinkButtonTag			(EmotionViewTag + 1)
#define TextLabelTag			(LinkButtonTag + 1)
#define VIPImageTag				(TextLabelTag + 1)
#define ImageTag				(VIPImageTag + 1)
#define videoImageTag			(ImageTag + 1)


#define SourceViewTagBase			(EmotionViewTag + 200)
#define ColonLabelTag				(SourceViewTagBase + 1)
#define BroadcastSourceFromTag		(SourceViewTagBase + 2)
#define BroadcastSourceFromTimeTag	(BroadcastSourceFromTag + 3)


#define OriginViewTagBase			(EmotionViewTag + 100)
#define TimeLableTag				(OriginViewTagBase + 1)


@interface MessageViewBase : UIView {
	NSMutableArray			*arrButtonsFree;			// 可用按钮数组
	NSMutableArray			*arrButtonsInUse;			// 保存使用中按钮数组
	NSMutableArray			*arrLablesFree;				// 标签
	NSMutableArray			*arrLablesInUse;
	NSMutableArray			*arrImagesFree;				// 图像
	NSMutableArray			*arrImagesInUse;
	UIFont					*headFont;					// 头文本字体
	UIFont					*tailFont;					// 尾部文本字体
	UIFont					*textFont;					// 主体文本字体
	UIButton				*nickBtn;					// 昵称
	UIImageView				*vipImage;					// vip图片
	BOOL					hasPortrait;				// 头像标识
	BOOL					hasImage;					// 是否有视频
	BOOL					hasLoadedImage;				// 是否网络图片数据已经传回本地
	BOOL					hasVideo;					// 是否有图片
	BOOL					hasLoadedVideo;				// 是否网络视频数据已经传回本地
	CGPoint					position;					// 位置坐标
	CGFloat					frameWidth;					// 消息框架宽度
	CGFloat					labelLocation;				// 标签位置(目前只有源消息采用到)
	// 由原来类复制过来的数据，可能以后会清除
	NSMutableDictionary		*emoDic;						// 表情字典
}

@property (nonatomic, retain) UIFont		*headFont;
@property (nonatomic, assign) BOOL			hasPortrait;
@property (nonatomic, assign) BOOL			hasImage;		// 是否有视频
@property (nonatomic, assign) BOOL			hasLoadedImage;
@property (nonatomic, assign) BOOL			hasVideo;		// 是否有图片
@property (nonatomic, assign) BOOL			hasLoadedVideo;
@property (nonatomic, assign) CGFloat		frameWidth;	
@property (nonatomic, assign) CGFloat		labelLocation;
// 回收资源
-(void)recycleSubViews;
// 链接点击相应事件
- (void) touchUrl:(id)sender;
- (void)touchNick;
@end
