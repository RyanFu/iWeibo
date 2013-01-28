//
//  CustomView.h
//  iweibo
//
//  Created by ZhaoLilong on 2/4/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LISTENCELLSTARTPOS 2.5f

@interface CommentView : UIView {
	CGPoint				position;			// 位置
	CGFloat				emoSize;		// 表情尺寸
	CGFloat				startPos;		// 开始坐标
	NSString			*comment;		// 评论内容
	NSUInteger			kWidth;			// 文本宽度
	NSUInteger			fontSize;			// 文字大小
	NSMutableDictionary *emoDic;			// 表情字典
}

@property (nonatomic, copy) NSString		*comment;
@property (nonatomic, assign) NSUInteger kWidth;
@property (nonatomic, assign) NSUInteger fontSize;
@property (nonatomic, assign) CGFloat	emoSize;

// 添加视图
- (void)addSubViews;

// 根据类型添加子视图
- (void)draw:(NSString *)string withType:(NSUInteger)type;

@end
