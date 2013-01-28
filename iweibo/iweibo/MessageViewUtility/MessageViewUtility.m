//
//  MessageViewUtility.m
//  iweibo
//
//  Created by Minwen Yi on 2/10/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "MessageViewUtility.h"
#import "SourceViewFrameCalcBase.h"
#import "OriginViewFrameCalcBase.h"
#import "DetailPageSourceViewFrameCalc.h"
#import "DetailPageOriginViewFrameCalc.h"
#import "OriginViewTextCalcBase.h"
#import "SourceViewTextCalcBase.h"
#import "TimelinePageConst.h"

@implementation MessageViewUtility

+ (void)printAvailableMemory
{
	vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
	host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
	//if(kernReturn != KERN_SUCCESS)
	//return NSNotFound;
	NSLog(@"memoryCheck:%f",((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0);
}
// 求取详情页: 主消息高度
+(CGFloat)getDetailPageOriginViewHeight:(Info *)info {
	DetailPageOriginViewFrameCalc *dpOriginViewFrameCalc = [[DetailPageOriginViewFrameCalc alloc] init];
	dpOriginViewFrameCalc.idMessage		= info;
	dpOriginViewFrameCalc.frameWidth	= DPOriginTextWidth;
	dpOriginViewFrameCalc.textFont		= [UIFont fontWithName:@"helvetica" size:OriginTextFontSize];
	dpOriginViewFrameCalc.headFont		= [UIFont fontWithName:@"helvetica" size:SourceTextFontSize];
	dpOriginViewFrameCalc.tailFont		= [UIFont fontWithName:@"helvetica" size:CommentCntsTextFontSize];
	CGFloat result = [dpOriginViewFrameCalc getMsgViewFrameHeight];	
	[dpOriginViewFrameCalc release];
	return result;
}

// 求取详情页: 源消息高度
+(CGFloat)getDetailPageSourceViewHeight:(TransInfo *)transInfo {
	DetailPageSourceViewFrameCalc *dpSourceViewFrameCalc = [[DetailPageSourceViewFrameCalc alloc] init];
	dpSourceViewFrameCalc.idMessage		= transInfo;
	dpSourceViewFrameCalc.frameWidth	= DPSourceTextWidth;
	dpSourceViewFrameCalc.textFont		= [UIFont fontWithName:@"helvetica" size:SourceTextFontSize];
	dpSourceViewFrameCalc.headFont		= [UIFont fontWithName:@"helvetica" size:SourceTextFontSize];
	dpSourceViewFrameCalc.tailFont		= [UIFont fontWithName:@"helvetica" size:CommentCntsTextFontSize];
	CGFloat result = [dpSourceViewFrameCalc getMsgViewFrameHeight];	
	[dpSourceViewFrameCalc release];
	return result;
}

// 求取详情页: 评论或者转播消息高度
//+(CGFloat)getDetailPageCommentViewHeight:(TransInfo *)transInfo {
//	return 0.0f;
//}

// 求取主timeline页: 主消息高度
+(CGFloat)getTimelineOriginViewHeight:(Info *)info {
	OriginViewFrameCalcBase *tlOriginViewFrameCalc = [[OriginViewFrameCalcBase alloc] init];
	tlOriginViewFrameCalc.idMessage		= info;
	tlOriginViewFrameCalc.frameWidth	= TLOriginTextWidth;
	tlOriginViewFrameCalc.textFont		= [UIFont fontWithName:@"helvetica" size:OriginTextFontSize];
	tlOriginViewFrameCalc.headFont		= [UIFont fontWithName:@"helvetica" size:OriginTextFontSize];
	tlOriginViewFrameCalc.tailFont		= [UIFont fontWithName:@"helvetica" size:CommentCntsTextFontSize];
	CGFloat result = [tlOriginViewFrameCalc getMsgViewFrameHeight];	
	[tlOriginViewFrameCalc release];
	return result;
}

// lichentao 2012-02-20获得详细页：主消息文本的高度
+(CGFloat)getOriginViewTextHeight:(Info *)info{
	OriginViewTextCalcBase *originViewTextHeight = [[OriginViewTextCalcBase alloc] init];
	originViewTextHeight.idMessage		= info;
	originViewTextHeight.frameWidth	= TLOriginTextWidth;
	originViewTextHeight.textFont		= [UIFont fontWithName:@"helvetica" size:OriginTextFontSize];
	CGFloat result = [originViewTextHeight getMsgViewFrameHeight];	
	[originViewTextHeight release];
	return result;
}

// lichentao  2012-02-20获得详细页，源消息文本的高度
+(CGFloat)getSourceViewTextHeight:(TransInfo *)info{
	SourceViewTextCalcBase *sourceViewTextHeight = [[SourceViewTextCalcBase alloc] init];
	sourceViewTextHeight.idMessage = info;
	sourceViewTextHeight.frameWidth = TLSourceTextWidth;
	sourceViewTextHeight.textFont = [UIFont fontWithName:@"helvetica" size:SourceTextFontSize];
	CGFloat result = [sourceViewTextHeight getMsgViewFrameHeight];	
	[sourceViewTextHeight release];
    return result;
}

// 求取主timeline页: 源消息高度
+(CGFloat)getTimelineSourceViewHeight:(TransInfo *)transInfo {
	SourceViewFrameCalcBase *timeLineSourceViewFrameCalc = [[SourceViewFrameCalcBase alloc] init];
	timeLineSourceViewFrameCalc.idMessage		= transInfo;
	timeLineSourceViewFrameCalc.frameWidth		= 253;
	timeLineSourceViewFrameCalc.textFont		= [UIFont fontWithName:@"helvetica" size:SourceTextFontSize];
	timeLineSourceViewFrameCalc.headFont		= [UIFont fontWithName:@"helvetica" size:SourceTextFontSize];
	timeLineSourceViewFrameCalc.tailFont		= [UIFont fontWithName:@"helvetica" size:CommentCntsTextFontSize];
	CGFloat result = [timeLineSourceViewFrameCalc getMsgViewFrameHeight];	
	[timeLineSourceViewFrameCalc release];
	return result;
}

// 求取我的广播页: 主消息高度
+(CGFloat)getBroadcastOriginViewHeight:(Info *)info {
	OriginViewFrameCalcBase *tlOriginViewFrameCalc = [[OriginViewFrameCalcBase alloc] init];
    tlOriginViewFrameCalc.bCached       = NO;           // 不缓存数据
	tlOriginViewFrameCalc.idMessage		= info;
	tlOriginViewFrameCalc.frameWidth	= DPCommentTextWidth;
	tlOriginViewFrameCalc.textFont		= [UIFont fontWithName:@"helvetica" size:OriginTextFontSize];
	tlOriginViewFrameCalc.headFont		= [UIFont fontWithName:@"helvetica" size:OriginTextFontSize];
	tlOriginViewFrameCalc.tailFont		= [UIFont fontWithName:@"helvetica" size:CommentCntsTextFontSize];
	CGFloat result = [tlOriginViewFrameCalc getMsgViewFrameHeight];	
	[tlOriginViewFrameCalc release];
	return result;
}

// 求取我的广播页: 源消息高度
+(CGFloat)getBroadcastSource:(TransInfo *)transInfo {
	SourceViewFrameCalcBase *timeLineSourceViewFrameCalc = [[SourceViewFrameCalcBase alloc] init];
    timeLineSourceViewFrameCalc.bCached         = NO;   // 不缓存数据
	timeLineSourceViewFrameCalc.idMessage		= transInfo;
	timeLineSourceViewFrameCalc.frameWidth		= DPSourceTextWidth;
	timeLineSourceViewFrameCalc.textFont		= [UIFont fontWithName:@"helvetica" size:SourceTextFontSize];
	timeLineSourceViewFrameCalc.headFont		= [UIFont fontWithName:@"helvetica" size:SourceTextFontSize];
	timeLineSourceViewFrameCalc.tailFont		= [UIFont fontWithName:@"helvetica" size:CommentCntsTextFontSize];
	CGFloat result = [timeLineSourceViewFrameCalc getMsgViewFrameHeight];	
	[timeLineSourceViewFrameCalc release];
	return result;
}

// 根据类型求取对应值
//+(CGFloat)getOriginViewHeight:(Info *)info WithType:(TableCellType)cellType {
//	CGFloat height = 0.0f;
//	switch (cellType) {
//		case HotBroadcastCell: {
//			
//		}
//			break;
//		default:
//			assert(NO);
//			break;
//	}
//}
@end
