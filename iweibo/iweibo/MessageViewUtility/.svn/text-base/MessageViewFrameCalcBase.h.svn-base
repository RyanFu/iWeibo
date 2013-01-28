//
//  MessageViewFrameCalcBase.h
//  iweibo
//
//	单条消息显示框架高度计算基础类(只处理字符串偏移)
//
//  Created by Minwen Yi on 2/10/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailPageConst.h"
#import "TextExtract.h"
#import "MessageUnitItemInfo.h"


@interface MessageViewFrameCalcBase : NSObject {
	CGPoint				curPosition;		// 模拟画消息时文本实时偏移坐标
	UIFont				*headFont;			// 头文本字体
	UIFont				*tailFont;			// 尾部文本字体
	UIFont				*textFont;			// 主体文本字体
	CGFloat				frameWidth;			// 消息框架宽度
	id					idMessage;			// 主消息对象
	NSDictionary		*emoDic;
	NSMutableArray		*arrItems;			// 按类型拆分文本后缓存数组
    BOOL                bCached;         // 是否缓存
}

@property(nonatomic, assign)CGPoint				curPosition;
@property(nonatomic, retain)UIFont				*textFont;
@property(nonatomic, retain)UIFont				*tailFont;
@property(nonatomic, retain)UIFont				*headFont;
@property(nonatomic, assign)CGFloat				frameWidth;	
@property(nonatomic, assign)id					idMessage;
@property(nonatomic, assign)BOOL                bCached;

//-(void)cacheUnitItem:(NSString *)strText withType:(UnitItemType)type link:(NSString *)strLink andPos:(CGPoint)pos;
-(void)cacheUnitItem:(NSString *)strText withType:(UnitItemType)type link:(NSString *)strLink andFrame:(CGRect)rect;
// 将求取的数据存储到缓存字典
- (void)addItemArrayToDic;
// 模拟画消息文本(更新curPosition位置)
-(void)drawTextFromCurPos:(NSString *)strText withType:(NSUInteger)type andFont:(UIFont *)tFont;
// 画消息头
-(void)drawHead;
// 模拟画消息文本
-(void)drawMainText;
// 模拟画图片
-(void)drawPicture;
// 求取消息底部文字信息高度
-(void)drawTail;
// 求取高度
-(CGFloat)getMsgViewFrameHeight;

//-(CGFloat)getTextViewFrameHeight;
@end
