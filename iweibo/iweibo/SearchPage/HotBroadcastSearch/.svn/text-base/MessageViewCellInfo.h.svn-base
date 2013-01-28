//
//  MessageViewCellInfo.h
//  iweibo
//
//  Created by Minwen Yi on 3/1/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Info.h"
#import "TransInfo.h"

@interface MessageViewCellInfo : NSObject {
	CGFloat			sourceViewHeight;			// 源消息视图高度
	CGFloat			originViewHeight;			// 广播消息高度
	Info			*originInfo;				// 广播消息类对象
	TransInfo		*sourceInfo;				// 源消息类对象
}

@property (nonatomic, retain) Info				*originInfo;
@property (nonatomic, retain) TransInfo			*sourceInfo;
@property (nonatomic, assign) CGFloat			originViewHeight;
@property (nonatomic, assign) CGFloat			sourceViewHeight;

// 计算cell高度
-(CGFloat)calcCellHeight;
// 计算Info的高度
//-(CGFloat)calcOriginViewHeight;
// 计算TransInfo高度
//-(CGFloat)calcSourceViewHeight;
@end
