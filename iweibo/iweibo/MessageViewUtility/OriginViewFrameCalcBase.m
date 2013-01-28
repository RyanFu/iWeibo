//
//  OriginViewFrameCalcBase.m
//  iweibo
//
//  Created by Minwen Yi on 2/10/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "OriginViewFrameCalcBase.h"
#import "OriginView.h"



@implementation OriginViewFrameCalcBase

-(void) dealloc {
	[super dealloc];
}

//-(void)cacheUnitItem:(NSString *)strText withType:(UnitItemType)type link:(NSString *)strLink andPos:(CGPoint)pos {
//	MessageUnitItemInfo *item = [[MessageUnitItemInfo alloc] initItem:strText
//															 withType:type 
//																 link:strLink 
//															   andPos:pos];
//	[arrItems addObject:item];
//	[item release];
//}

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
    if (bCached) {
        [[OriginView originViewUnitItemDic] setObject:arrItems forKey:info.uid];
    }
}

// 获取文本距离上边框高度
-(CGFloat)getUpVerticalSpaceBetweenSourceTextAndFrame {
	return VSBetweenOriginTextAndFrame;
}

// 获取文本距离下边框高度
-(CGFloat)getDownVerticalSpaceBetweenSourceTextAndFrame {
	return VSBetweenOriginFrameAndOriginCommentCnt;
}
// 画消息头
-(void)drawHead {
	// 1.1 加上昵称距离边框高度
	curPosition.y += VSBetweenOriginTextAndFrame;
	// 1.2 文字高度
	curPosition.y += [@"昵称" sizeWithFont:self.headFont].height;
	// 主页文本离上边昵称高度，要大于其他页面(如单条消息页)文字离边框高度，作修正处理
	//curPosition.y += VerticalSpaceBetweenNikeAndText - VSBetweenOriginTextAndFrame;
}

// 模拟画消息文本
-(void)drawMainText {
	// 2.1 主体文本距离昵称高度(放到这里是因为在文本为空的情况下下边"来自..."要离昵称相对远一些)
	curPosition.y += VSBetweenOriginTextAndFrame;
	Info *info = (Info *)idMessage;
	// 2.2 解析文本
	TextExtract *textExtract = [[TextExtract alloc] init];
	if (info.origtext!=nil) {
		if (![[OriginView orgingHeight] objectForKey:info.uid]) {
			NSMutableArray *infoArray = [textExtract getInfoNodeArray:info.origtext];
			[[OriginView orgingHeight] setObject:infoArray forKey:info.uid];
		}
		NSMutableArray *arrayOri = [[OriginView orgingHeight] objectForKey:info.uid];
		for (int i = 1; i < [arrayOri count]; ) {
			[self drawTextFromCurPos:[arrayOri objectAtIndex:i-1]  
							withType:[[arrayOri objectAtIndex:i] intValue] 
							 andFont:self.textFont];
			i += 2;
		}
	}
	
	// 最后不满一行，按一行计算(由于有名字存在，至少会有一行)
	if (curPosition.x > 0.1f) {
		curPosition.y += [@"我" sizeWithFont:self.textFont].height;		// 加上一行高度
	}
	[textExtract release];
	[self addItemArrayToDic];
}

// 模拟画图片
-(void)drawPicture {
	Info *info = (Info *)idMessage;
	
	BOOL bHasPic = NO;
	if ((info.image != nil && [info.image isKindOfClass:[NSString class]] && [info.image length] > 0)) { 
		//有图或者有视频加偏移
		curPosition.x = 0;
		// 图片高度，加上距离上方空白高度
		curPosition.y += DefaultImageHeight + VSpaceBetweenVideoAndText;
		bHasPic = YES;
	}
	
	if (bHasPic) {
		return;
	}
	
	// 判断是否有视频
	if ([info.video isKindOfClass:[NSDictionary class]] && [info.video count] > 0) {
		NSString *videoStr = [info.video valueForKey:@"picurl"];
		if ([videoStr isKindOfClass:[NSString class]] && [videoStr length] > 0) {
			curPosition.y += DefaultImageHeight + VSpaceBetweenVideoAndText;
		}
	}
}

// 求取消息底部文字信息高度
-(void)drawTail {
	// 距离底部边框高度
	curPosition.y += VSpaceBetweenOriginFromAndText;
//	curPosition.y += [@"来自..." sizeWithFont:tailFont].height + VSpaceBetweenOriginFromAndText;
//	curPosition.y += [self getDownVerticalSpaceBetweenSourceTextAndFrame];
}

@end
