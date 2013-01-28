//
//  DetailPageOriginViewFrameCalc.h
//  iweibo
//
//	单条消息页主消息高度计算
//
//  Created by Minwen Yi on 2/11/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OriginViewFrameCalcBase.h"

@interface DetailPageOriginViewFrameCalc : OriginViewFrameCalcBase {

}
// 画消息头
-(void)drawHead;
// 模拟画图片
//-(void)drawPicture;
// 求取消息底部文字信息高度
//-(void)drawTail;

-(void)cacheUnitItem:(NSString *)strText withType:(UnitItemType)type link:(NSString *)strLink andFrame:(CGRect)rect;
// 将求取的数据存储到缓存字典
- (void)addItemArrayToDic;
@end
