//
//  MessageViewUtility.h
//  iweibo
//
//	消息视图相关数值计算
// 
//  Created by Minwen Yi on 2/10/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Info.h"
#import "TransInfo.h"
#import "Canstants.h"
#import <mach/mach.h>
#import <mach/mach_host.h>


@interface MessageViewUtility : NSObject {
}

// 打印内存使用情况
+ (void)printAvailableMemory;
// 求取详情页: 主消息高度
+(CGFloat)getDetailPageOriginViewHeight:(Info *)info;
// 求取详情页: 源消息高度
+(CGFloat)getDetailPageSourceViewHeight:(TransInfo *)transInfo;
// 求取详情页: 评论或者转播消息高度
//+(CGFloat)getDetailPageCommentViewHeight:(TransInfo *)transInfo;
// 求取主timeline页: 主消息高度
+(CGFloat)getTimelineOriginViewHeight:(Info *)info;
// 求取主timeline页: 源消息高度
+(CGFloat)getTimelineSourceViewHeight:(TransInfo *)transInfo;
// 求取我的广播页: 主消息高度
+(CGFloat)getBroadcastOriginViewHeight:(Info *)info;
// 求取我的广播页: 源消息高度
+(CGFloat)getBroadcastSource:(TransInfo *)transInfo;
// 求取详情页面,主消息文本高度
+(CGFloat)getOriginViewTextHeight:(Info *)info;
// 求取详情页面，源消息文本高度
+ (CGFloat)getSourceViewTextHeight:(TransInfo *)info;

// 根据类型求取对应值
//+(CGFloat)getOriginViewHeight:(Info *)info WithType:(TableCellType)cellType;
@end
