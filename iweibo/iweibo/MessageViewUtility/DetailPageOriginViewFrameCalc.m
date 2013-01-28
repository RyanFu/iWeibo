//
//  DetailPageOriginViewFrameCalc.m
//  iweibo
//
//  Created by Minwen Yi on 2/11/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "DetailPageOriginViewFrameCalc.h"
#import "DetailOriginView.h"


@implementation DetailPageOriginViewFrameCalc

// 画消息头
-(void)drawHead {
	// 广播消息页没有头信息
}
// 模拟画图片
-(void)drawPicture {
	Info *info = (Info *)idMessage;
	
	// 3.1 求图像高度(与视频分行显示)
	if (info.image != nil && [info.image isKindOfClass:[NSString class]] && ![info.image isEqualToString:@""]) {
		if (nil == info.imageImageData || 0 == [info.imageImageData length]) {
			curPosition.y += DefaultImageHeight + VSBetweenSourceImageAndText;		// 默认高度为100
			//curPosition.x += 70;		// 距离左边70(可忽略)
		}
		else {
			UIImage *imageSrc = [[UIImage alloc] initWithData:info.imageImageData];
			if (imageSrc) {
				curPosition.y += imageSrc.size.height / 2.0f + VSBetweenSourceImageAndText;		
				//curPosition.x += 70;		// 距离左边70(可忽略)
				curPosition.y += ImageFrameWidth * 2;		// 2012-3-5 By Yi Minwen 添加边框
				[imageSrc release];
			}
			else {
				curPosition.y += DefaultImageHeight + VSBetweenSourceImageAndText;		// 默认高度为100
				//curPosition.x += 70;		// 距离左边70(可忽略)
			}

		}
	}
	// 判断是否有视频
	if ([info.video isKindOfClass:[NSDictionary class]] && [info.video count] > 0 && [info.video valueForKey:@"picurl"]) {
		if (nil == info.videoImageData || 0 == [info.videoImageData length]) {
			curPosition.y += DefaultImageHeight + VSBetweenSourceImageAndText;		// 默认高度为100
		}
		else {
			UIImage *imageSrc = [[UIImage alloc] initWithData:info.videoImageData];
			if (imageSrc) {
				if (imageSrc.size.height > MaxVideoHeight) {
					curPosition.y += MaxVideoHeight + VSBetweenSourceImageAndText;
				}
				else {
					curPosition.y += imageSrc.size.height + VSBetweenSourceImageAndText;	
				}
	
				//curPosition.x += 70;		// 距离左边70(可忽略)
				[imageSrc release];
			}
			else {
				curPosition.y += DefaultImageHeight + VSBetweenSourceImageAndText;		// 默认高度为100
			}

		}

	}
}
// 求取消息底部文字信息高度
-(void)drawTail {
	// 需要判断，假如有转播或者评论次数时，要加上文字高度
//	Info *info = (Info *)idMessage;
//	if ([info.count intValue] + [info.mscount intValue] > 0) {
//		curPosition.y += [@"本文共...转播" sizeWithFont:tailFont].height + VSBetweenOriginFrameAndOriginCommentCnt;
//	}
	[super drawTail];
}

-(void)cacheUnitItem:(NSString *)strText withType:(UnitItemType)type link:(NSString *)strLink andFrame:(CGRect)rect {
	MessageUnitItemInfo *item = [[MessageUnitItemInfo alloc] initItem:strText
															 withType:type 
																 link:strLink 
															   andFrame:rect];
	[arrItems addObject:item];
	[item release];
}
// 将求取的数据存储到缓存字典
- (void)addItemArrayToDic {
	Info *info = (Info *)idMessage;
	[[DetailOriginView DetailOriginViewUnitItemDic] setObject:arrItems forKey:info.uid];
}
@end
