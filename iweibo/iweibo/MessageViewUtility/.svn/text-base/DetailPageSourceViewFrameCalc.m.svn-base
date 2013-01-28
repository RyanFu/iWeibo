//
//  DetailPageSourceViewFrameCalc.m
//  iweibo
//
//  Created by Minwen Yi on 2/10/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "DetailPageSourceViewFrameCalc.h"
#import "DetailSrcView.h"


@implementation DetailPageSourceViewFrameCalc


// 3. 模拟画图片
-(void)drawPicture {
	TransInfo *transInfo = (TransInfo *)idMessage;
	// 3.1 求图像高度(与视频分行显示)
	if (transInfo.transImage && [transInfo.transImage isKindOfClass:[NSString class]] && 0 < [transInfo.transImage length]) {
		if (transInfo.sourceImageData != nil && [transInfo.sourceImageData length] > 0) {
			UIImage *imageSrc = [[UIImage alloc] initWithData:transInfo.sourceImageData];
			if (imageSrc) {
				curPosition.y = imageSrc.size.height / 2.0f + curPosition.y +VSBetweenSourceImageAndText;		
				curPosition.x += 70;		// 距离左边70(可忽略)
				curPosition.y += ImageFrameWidth * 2;		// 2012-3-5 By Yi Minwen 添加边框
				[imageSrc release];
			}
			else {
				curPosition.y += DefaultImageHeight + VSBetweenSourceImageAndText;		// 默认高度为100
				curPosition.x += 70;		// 距离左边70(可忽略)
			}

		}
		else {
			curPosition.y += DefaultImageHeight + VSBetweenSourceImageAndText;		// 默认高度为100
			curPosition.x += 70;		// 距离左边70(可忽略)
		}
		
	}
	
	// 3.2 求视频高度
	if ((transInfo.transVideo && [transInfo.transVideo isKindOfClass:[NSString class]] && 0 < [transInfo.transVideo length])) 
	{
		if (transInfo.sourceVideoData != nil && [transInfo.sourceVideoData length] > 0) {
			UIImage *imageSrc = [[UIImage alloc] initWithData:transInfo.sourceVideoData];
			if (imageSrc) {
				if (imageSrc.size.height > MaxVideoHeight) {
					curPosition.y += MaxVideoHeight + VSBetweenSourceImageAndText;
				}
				else {
					curPosition.y += imageSrc.size.height + VSBetweenSourceImageAndText;	
				}
				curPosition.x += 70;		// 距离左边70
				[imageSrc release];
			}
			else {
				curPosition.y += DefaultImageHeight + VSBetweenSourceImageAndText;				// 默认高度为100
				curPosition.x += 70;
			}

		}
		else {
			curPosition.y += DefaultImageHeight + VSBetweenSourceImageAndText;				// 默认高度为100
			curPosition.x += 70;
		}

	}
}
// 4. 求取消息底部文字信息高度
-(void)drawTail {
	// 2012-04-24 增加坐标信息显示
	TransInfo *transInfo = (TransInfo *)idMessage;
	if (transInfo.bUserLocationEnabled) {
		// 间隔 + 文本高度
		curPosition.y += VSBetweenSourceImageAndText + [@"地理位置" sizeWithFont:tailFont].height;
	}
	// 距离底部边框高度
	curPosition.y += [@"来自..." sizeWithFont:tailFont].height + VSBetweenSourceFromAndText;
	curPosition.y += VSBetweenSourceFrameAndFrom;
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
	// 不缓存
	TransInfo *transInfo  = (TransInfo *)idMessage;
	[[DetailSrcView DetailSrcViewUnitItemDic] setObject:arrItems forKey:transInfo.transId];
}

@end
