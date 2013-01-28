//
//  OriginViewFrameCalcBase.h
//  iweibo
//
//  Created by Minwen Yi on 2/10/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageViewFrameCalcBase.h"
#import "Info.h"


@interface OriginViewFrameCalcBase : MessageViewFrameCalcBase {
}

// 缓存数据
//-(void)cacheUnitItem:(NSString *)strText withType:(UnitItemType)type link:(NSString *)strLink andPos:(CGPoint)pos;

-(void)cacheUnitItem:(NSString *)strText withType:(UnitItemType)type link:(NSString *)strLink andFrame:(CGRect)rect;
// 将求取的数据存储到缓存字典
- (void)addItemArrayToDic;

// 获取文本距离上边框高度
-(CGFloat)getUpVerticalSpaceBetweenSourceTextAndFrame;
// 获取文本距离下边框高度
-(CGFloat)getDownVerticalSpaceBetweenSourceTextAndFrame;
// 画消息头
-(void)drawHead;
// 模拟画消息文本
-(void)drawMainText;
// 模拟画图片
-(void)drawPicture;
// 求取消息底部文字信息高度
-(void)drawTail;
@end
