//
//  DetailSrcView.h
//  iweibo
//
//	详情页源消息视图:(与主timeline差异较大，单独拿出来处理)
//
//  Created by Minwen Yi on 5/7/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageViewBase.h"
#import "TransInfo.h"
#import "IWBGifImageView.h"

@protocol DetailSrcViewDelegate;
@interface DetailSrcView : MessageViewBase {
	NSInteger					controllerType;
	TransInfo					*transInfo;					// 转发内容	
	// 2012-02-15 lichentao 是否进行复制
	BOOL						isLongPress;		// 长按标识
	// 2012-04-16 By Yi Minwen
	UILabel						*colonLabel;		// 昵称后边":"标签
	UILabel						*broadSourceFrom;	// ”来自..."
	UILabel						*broadSourceTime;	// 后边跟的时间戳
	IWBGifImageView				*imageViewEx;		// 转发图片
	IWBGifImageView				*videoImageEx;		// 转发视频缩略图
	id<DetailSrcViewDelegate>	myDetailSrcViewDelegate;
}

@property (nonatomic, assign) NSInteger				controllerType;
@property (nonatomic, assign) BOOL					isLongPress;
@property (nonatomic, retain) TransInfo				*transInfo;	
@property (nonatomic, retain) IWBGifImageView		*imageViewEx;
@property (nonatomic, retain) IWBGifImageView		*videoImageEx;
@property (nonatomic, assign) id<DetailSrcViewDelegate>	myDetailSrcViewDelegate;

+(NSMutableDictionary *)DetailSrcViewUnitItemDic;

- (void)addSubViews;
- (void)storeGifToCache:(NSData *)gifImageData;
@end
// 2012-02-08 By Yi Minwen 
// 图片点击委托事件
@protocol DetailSrcViewDelegate<NSObject>
@optional
- (void)DetailSrcViewUrlClicked:(NSString *)urlSource;
- (void)DetailSrcViewVideoClicked:(NSString *)urlVideo;
// 图片和图片加载完毕委托方法
//-(void)DetailSrcViewHasLoadedImage;
@end