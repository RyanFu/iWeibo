//
//  SearchPageMainView.m
//  iweibo
//
//  Created by Minwen Yi on 2/23/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "SearchPageMainView.h"


@implementation SearchPageMainView
@synthesize firstView, pageControl, scrollView;
@synthesize mySearchPageMainViewDelegate;

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		// 创建滑动页面视图
		scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
		scrollView.contentSize = CGSizeMake(SPMPages * 320.0f, scrollView.frame.size.height);
		scrollView.pagingEnabled = YES;
		scrollView.delegate = self;
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.scrollsToTop = NO;
		[self addSubview:self.scrollView];
		// 添加第一张视图
		firstView = [[SearchPageFirstView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
		firstView.tag = SPMFirstPageTage;
		firstView.mySearchPageFirstViewDelegate = self;
		[scrollView addSubview:firstView];
		
		// 滚动点控制
		pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 20.0f, 320.0f, 20.0f)];
		pageControl.numberOfPages = SPMPages;
		pageControl.currentPage = 0;
		pageControl.hidesForSinglePage = YES;
		[pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
		[self addSubview:self.pageControl];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	firstView.mySearchPageFirstViewDelegate = nil;
	[firstView release];
	firstView = nil;
	[pageControl release];
	pageControl = nil;
	scrollView.delegate = nil;
	[scrollView release];
	scrollView = nil;
    [super dealloc];
}

- (void)pageTurn: (UIPageControl *)aPageControl {
	int whichPage = aPageControl.currentPage;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView	setAnimationCurve:UIViewAnimationCurveEaseInOut];
	scrollView.contentOffset = CGPointMake(320.0f * whichPage, 0.0f);
	[UIView commitAnimations];
}

- (void)scrollViewDidScroll:(UIScrollView *)ascrollView {
	CGPoint offset = ascrollView.contentOffset;
	pageControl.currentPage = offset.x / 320.0f;
}

#pragma mark -
#pragma protocol SearchPageFirstViewDelegate<NSObject>
// 按钮点击事件
// infoBtn:相应参数信息
- (void)SearchPageFirstViewBtnClicked:(UIButton *)btnClicked withInfo:(id)infoBtn {
	if ([self.mySearchPageMainViewDelegate respondsToSelector:@selector(SearchPageMainViewBtnClicked:withInfo:)]) {
		[self.mySearchPageMainViewDelegate SearchPageMainViewBtnClicked:btnClicked withInfo:infoBtn];
	}
}

@end
