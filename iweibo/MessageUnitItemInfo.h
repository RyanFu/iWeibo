//
//  MessageUnitItemInfo.h
//  iweibo
//
//	消息文本单元信息
//
//  Created by Minwen Yi on 4/18/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Canstants.h"
#import "MessageUnitItemInfo.h"

@interface MessageUnitItemInfo : NSObject {
	NSString			*itemText;                  // 文本
	NSString			*itemLink;                  // 链接
	UnitItemType		itemType;                   // 文本类型
	CGPoint				itemPos;                    // 坐标
    CGRect              itemRect;       // 2012-07-12 frame大小(为保持兼容，与pos分开存)
}

@property (nonatomic, copy) NSString			*itemText;
@property (nonatomic, copy) NSString			*itemLink;
@property (nonatomic, assign) UnitItemType		itemType;
@property (nonatomic, assign) CGPoint			itemPos;
@property (nonatomic, assign) CGRect            itemRect;

//-(id)initItem:(NSString *)strText withType:(UnitItemType)type link:(NSString *)strLink andPos:(CGPoint)pos;
// 新版，增加高度
-(id)initItem:(NSString *)strText withType:(UnitItemType)type link:(NSString *)strLink andFrame:(CGRect)rect;
-(NSString *)description;
@end
