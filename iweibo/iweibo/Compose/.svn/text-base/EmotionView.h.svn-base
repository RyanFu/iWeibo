//
//  EmotionView.h
//  iweibo
//
//	表情页面
//
//  Created by Minwen Yi on 12/30/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Canstants.h"

// 定义表情页面页数
#define NPAGES				4
#define EMOTIONCOUNT		105
#define BASEHEIGHT			185.0f
#define PAGECONTROLHEIGHT	(216.0f-6.0f-BASEHEIGHT)
// 第一个表情页标记
#define FirstPageTage		1000

@protocol EmotionViewDelegate;

@interface EmotionView : UIView <UIScrollViewDelegate> {
	UIPageControl				*pageControl;			// 表情页面控制器
	UIScrollView				*scrollView;				// 滑动视图
	id<EmotionViewDelegate>		myEmotionViewDelegate;		
}

@property (nonatomic, retain) UIPageControl				*pageControl;
@property (nonatomic, retain) UIScrollView				*scrollView;
@property (nonatomic, assign) id<EmotionViewDelegate>	myEmotionViewDelegate;
@end

// 协议
@protocol EmotionViewDelegate <NSObject>
// 点击当前页面单个表情时产生的响应事件
- (void)toucheAtPage:(NSInteger)pageIndex EmotionIndex:(NSInteger)emotionIndex 
	 WithDescription:(NSString *)emotionDescription;
@end
