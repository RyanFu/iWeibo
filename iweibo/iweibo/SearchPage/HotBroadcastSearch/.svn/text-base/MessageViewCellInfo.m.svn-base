//
//  MessageViewCellInfo.m
//  iweibo
//
//  Created by Minwen Yi on 3/1/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "MessageViewCellInfo.h"
#import "MessageViewUtility.h"
#import "DetailPageConst.h"

@implementation MessageViewCellInfo
@synthesize originInfo, sourceInfo, originViewHeight, sourceViewHeight;

// 计算cell高度
-(CGFloat)calcCellHeight {
	CGFloat retValue = 0.0f;
	// 主消息高度
	originViewHeight = [MessageViewUtility getTimelineOriginViewHeight:self.originInfo];
	retValue += originViewHeight;
	// 源消息高度
	if ([self.sourceInfo isKindOfClass:[TransInfo class]]) {
		sourceViewHeight = [MessageViewUtility getTimelineSourceViewHeight:self.sourceInfo];
		retValue += sourceViewHeight + VSBetweenSourceFrameAndFrom;
	}
	// 来自...高度
	CGFloat fromHeight = [@"来自..." sizeWithFont:[UIFont systemFontOfSize:12]].height + VSpaceBetweenOriginFrameAndFrom;
	retValue += fromHeight;
	return retValue;
}

// 计算Info的高度(默认用主timeline)
//-(CGFloat)calcOriginViewHeight {
//	if ([self.originInfo isKindOfClass:[Info class]]) {
//		return [MessageViewUtility getTimelineOriginViewHeight:self.originInfo];
//	}
//	else {
//		return 0.0f;
//	}
//}
//
// 计算TransInfo高度(默认用主timeline)
//-(CGFloat)calcSourceViewHeight {
//	if ([self.sourceInfo isKindOfClass:[TransInfo class]]) {
//		return [MessageViewUtility getTimelineSourceViewHeight:self.sourceInfo];
//	}
//	else {
//		return 0.0f;
//	}
//
//}

- (void)setOriginInfo:(Info *)oriInfo {
	if (originInfo != oriInfo) {
		[originInfo release];
		originInfo = [oriInfo retain];
	}
}

- (void)setSourceInfo:(TransInfo *)tInfo {
	if (sourceInfo != tInfo) {
		[sourceInfo release];
		sourceInfo = [tInfo retain];
	}
}

- (void)dealloc {
	self.originInfo = nil;
	self.sourceInfo = nil;
    [super dealloc];
}
@end
