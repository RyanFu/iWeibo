//
//  DetailOriginView.h
//  iweibo
//
//  Created by Minwen Yi on 5/7/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageViewBase.h"
#import "IWBGifImageView.h"
#import "Info.h"

@protocol DetailOriginViewDelegate;
@interface DetailOriginView : MessageViewBase {
	NSInteger					controllerType;
	BOOL						isLongPress;		     // 长按标识
	Info						*info;					// 原创信息
	IWBGifImageView				*imageViewEx;		// 图片
	IWBGifImageView				*videoViewEx;		// 视频图片
	// 2012-04-16 By Yi Minwen: 时间标签做成成员
	UILabel						*timeLabel;
	id<DetailOriginViewDelegate> myDetailOriginViewDelegate;
}

@property (nonatomic, assign) NSInteger				controllerType;
@property (nonatomic, assign) BOOL					isLongPress;
@property (nonatomic, retain) Info					*info;
@property (nonatomic, retain) IWBGifImageView		*imageViewEx;
@property (nonatomic, retain) IWBGifImageView		*videoViewEx;	
@property (nonatomic, assign) id<DetailOriginViewDelegate> myDetailOriginViewDelegate;

+(NSMutableDictionary *)DetailOriginViewUnitItemDic;

// 添加子视图方法
-(void)addSubViews;
- (void)storeGifToCache:(NSData *)gifImageData;
@end

// 2012-02-08 By Yi Minwen 
// 图片点击委托事件
@protocol DetailOriginViewDelegate<NSObject>
@optional
- (void)DetailOriginViewUrlClicked:(NSString *)urlSource;// 视频点击事件
- (void)DetailOriginViewVideoClicked:(NSString *)urlVideo;
@end
