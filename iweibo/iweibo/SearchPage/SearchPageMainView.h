//
//  SearchPageMainView.h
//  iweibo
//
//	搜索页面主视图
//
//  Created by Minwen Yi on 2/23/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchPageFirstView.h"

// 定义表情页面页数
#define SPMPages					1
//#define BASEHEIGHT					185.0f
//#define PAGECONTROLHEIGHT			(216.0f-6.0f-BASEHEIGHT)
// 第一个表情页标记
#define SPMFirstPageTage		1100

@protocol SearchPageMainViewDelegate<NSObject>

@optional
// 按钮点击事件
// infoBtn:相应参数信息
- (void)SearchPageMainViewBtnClicked:(UIButton *)btnClicked withInfo:(id)infoBtn;
@end


@interface SearchPageMainView : UIView<UIScrollViewDelegate, SearchPageFirstViewDelegate> {
	UIPageControl				*pageControl;				// 搜索页面控制器
	UIScrollView				*scrollView;				// 滑动视图
	SearchPageFirstView			*firstView;					// 第一张视图
	id<SearchPageMainViewDelegate> mySearchPageMainViewDelegate;
}

@property (nonatomic, retain) UIPageControl						*pageControl;
@property (nonatomic, retain) UIScrollView						*scrollView;
@property (nonatomic, retain) SearchPageFirstView				*firstView;	
@property (nonatomic, assign) id<SearchPageMainViewDelegate>	mySearchPageMainViewDelegate;

@end
