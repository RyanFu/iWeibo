//
//  SourceViewFrameCalcBase.m
//  iweibo
//
//  Created by Minwen Yi on 2/10/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "SourceViewFrameCalcBase.h"
#import "SourceView.h"

@implementation SourceViewFrameCalcBase

// 获取文本距离上边框高度
-(CGFloat)getUpVerticalSpaceBetweenSourceTextAndFrame {
	return VSBetweenSourceTextAndFrame;
}

// 获取文本距离下边框高度
-(CGFloat)getDownVerticalSpaceBetweenSourceTextAndFrame {
	return VSBetweenSourceFrameAndFrom;
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
    if (bCached) {
        TransInfo *transInfo  = (TransInfo *)idMessage;
        [[SourceView srcViewUnitItemDic] setObject:arrItems forKey:transInfo.transId];
    }
}

// 1. 画消息头
// 源消息头与文本一起显示，字体大小相同
-(void)drawHead {
	TransInfo *transInfo = (TransInfo *)idMessage;
	// 1.1 加上顶部文本距离边框高度
	curPosition.y += [self getUpVerticalSpaceBetweenSourceTextAndFrame];
	// 1.2 获取昵称宽度
	curPosition.x += [transInfo.transNick sizeWithFont:self.textFont].width;
	// 1.3 判断是否是vip用户,假如是，需要加上vip图表宽度(源消息没有)
	if ([transInfo.transIsvip boolValue]||[transInfo.translocalAuth boolValue]) {	// 2012-03-12 zhaolilong 添加本地认证
		curPosition.x += VipImageWidth;
	}
	// 1.4 加上":"宽度
	//curPosition.x += [@":" sizeWithFont:self.textFont].width;
	curPosition.x += [@":" sizeWithFont:self.textFont].width;
}

// 2. 模拟画消息文本
-(void)drawMainText {
	TransInfo *transInfo = (TransInfo *)idMessage;
//	CLog(@"transInfo.transOrigtext:%@, curPosition.x:%f, curPosition.y:%f", 
//		 transInfo.transOrigtext, curPosition.x, curPosition.y);
	// 2.1 解析文本
	TextExtract *textExtract = [[TextExtract alloc] init];
	if (![[SourceView sourceHeight] objectForKey:transInfo.transId]) {
		NSMutableArray *infoArray = [textExtract getInfoNodeArray:transInfo.transOrigtext];
		[[SourceView sourceHeight] setObject:infoArray forKey:transInfo.transId];
	}
	NSMutableArray *sourceArray = [[SourceView sourceHeight] objectForKey:transInfo.transId];
	for (int i = 1; i < [sourceArray count]; ) {
		[self drawTextFromCurPos:[sourceArray objectAtIndex:i-1]  
						withType:[[sourceArray objectAtIndex:i] intValue] 
						 andFont:self.textFont];
		i += 2;
	}
	// 最后不满一行，按一行计算(由于有名字存在，至少会有一行)
	if (curPosition.x > 0.1f) {
		curPosition.y += [@"我" sizeWithFont:self.textFont].height;		// 加上一行高度
	}
//	CLog(@"final curPosition.x:%f, curPosition.y:%f", curPosition.x, curPosition.y);
	[textExtract release];
	[self addItemArrayToDic];
}

// 3. 模拟画图片
-(void)drawPicture {
	TransInfo *transInfo = (TransInfo *)idMessage;
	BOOL bHasPic = NO;
	curPosition.x = 0;
	if ([transInfo.transImage isKindOfClass:[NSString class]] && 0 < [transInfo.transImage length]) 
	{
		curPosition.y += VSBetweenSourceImageAndText;
		[self cacheUnitItem:(NSString *)[NSNull null] withType:TypeImage link:transInfo.transImage andFrame:CGRectMake(curPosition.x, curPosition.y, DefaultImageWidth, DefaultImageHeight)];
		curPosition.y += DefaultImageHeight;
		curPosition.x += DefaultImageWidth;	
		bHasPic = YES;
	}
	if (([transInfo.transVideo isKindOfClass:[NSString class]] && 0 < [transInfo.transVideo length])) {
		if (!bHasPic) {
			curPosition.y += VSBetweenSourceImageAndText;
			[self cacheUnitItem:(NSString *)[NSNull null] withType:TypeImage link:transInfo.transImage andFrame:CGRectMake(curPosition.x, curPosition.y, DefaultImageWidth, DefaultImageHeight)];
			curPosition.y += DefaultImageHeight;
			curPosition.x += DefaultImageWidth;	// 由于视频图片在同一行显示, x变化无特殊意义
		}
		else {
			curPosition.y -= DefaultImageHeight;
			[self cacheUnitItem:(NSString *)[NSNull null] withType:TypeImage link:transInfo.transImage andFrame:CGRectMake(curPosition.x, curPosition.y, DefaultImageWidth, DefaultImageHeight)];
			curPosition.y += DefaultImageHeight;	// 复原
			curPosition.x += DefaultImageWidth;	// 由于视频图片在同一行显示, x变化无特殊意义
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
	curPosition.y += [self getDownVerticalSpaceBetweenSourceTextAndFrame];
}

@end
