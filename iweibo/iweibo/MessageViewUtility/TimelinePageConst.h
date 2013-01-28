//
//  TimelinePageConst.h
//  iweibo
//
//  Created by Minwen Yi on 2/10/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//
#import "Canstants.h"
#import "MessageFrameConsts.h"

// 1. 宽度
// 主消息: 框架宽度
#define TLOriginFrameWidth						270.0f
// 主消息: 文本左边空白宽度
#define TLOriginTextLeftSpaceWidth				0.0f
// 主消息: 文本右边空白宽度
#define TLOriginTextRightSpaceWidth				0.0f
// 主消息: 文本宽度
#define TLOriginTextWidth						(TLOriginFrameWidth-TLOriginTextLeftSpaceWidth-TLOriginTextRightSpaceWidth)
// 主消息: 图片(视频)距离左边框宽度
#define TLHSBetweenOriginFrameAndImage			0.0f
// 主消息: 视频图片之间间隔
#define TLHSBetweenImageAndVideo				10.0f

// 源消息: 框架宽度(与主消息文本宽度相同)
#define TLSourceFrameWidth						TLOriginTextWidth
// 源消息: 文本左边空白宽度(与边框相对距离)
#define TLSourceTextLeftSpaceWidth				6.0f
// 源消息: 文本右边空白宽度(与边框相对距离)
#define TLSourceTextRightSpaceWidth				12.0f
// 源消息: 文本宽度
#define TLSourceTextWidth						(TLSourceFrameWidth-TLSourceTextLeftSpaceWidth-TLSourceTextRightSpaceWidth)


// 3. 图像，表情宽度
