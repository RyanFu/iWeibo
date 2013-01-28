//
//  EmotionView.m
//  iweibo
//
//  Created by Minwen Yi on 12/30/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import "EmotionView.h"


@implementation EmotionView
@synthesize pageControl;
@synthesize scrollView;
@synthesize myEmotionViewDelegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		// 创建滑动页面视图
		scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 6.0f, 320.0f, BASEHEIGHT)];		// 跟默认键盘高度一样
		scrollView.contentSize = CGSizeMake(NPAGES * 320.0f, scrollView.frame.size.height);
		scrollView.pagingEnabled = YES;
		scrollView.delegate = self;
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.scrollsToTop = NO;
		
		for (int i = 0; i < NPAGES; i++) {
			NSString *fileName = [NSString stringWithFormat:@"composeFacePage%d.png", i + 1];
			UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:fileName]];
			iv.frame = CGRectMake(i * 320.0f, 0.0f, 320.0f, BASEHEIGHT);
			iv.tag = FirstPageTage + i;
			[iv setUserInteractionEnabled:YES];
			[scrollView addSubview:iv];
			UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped:)];
			[iv addGestureRecognizer:tapGesture];
			[tapGesture release];
			[iv release];
		}
		[self addSubview:self.scrollView];
		pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, 6.0f + BASEHEIGHT, 320.0f, PAGECONTROLHEIGHT)];
		pageControl.numberOfPages = NPAGES;
		pageControl.currentPage = 0;
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
	[scrollView release];
	scrollView = nil;
    [pageControl release];
	pageControl = nil;
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

-(void)imageTaped:(UITapGestureRecognizer *)recognizer {
	UIImageView	*iView = (UIImageView *)[recognizer view];
	CGPoint point = [recognizer locationInView: iView];
	NSInteger emotionIndex = (NSInteger)(point.x / (iView.frame.size.width / 8)) ;
	emotionIndex += 8 * (NSInteger)(point.y / (iView.frame.size.height / 4));
	// 求取页码
	NSInteger		pageIndex = pageControl.currentPage;
	// 求取对应字符串
	NSArray *array = [EMOTION componentsSeparatedByString:@","];
	if (pageIndex * 32 + emotionIndex < EMOTIONCOUNT) {
		NSString *currentEmotion = [array objectAtIndex:(pageIndex * 32 + emotionIndex)];
		NSString *desEmotion = [[currentEmotion componentsSeparatedByString:@"|"] objectAtIndex:1];
		NSString *fullDescription = [NSString stringWithFormat:@"/%@", desEmotion]; 
		// 发送
		if ([self.myEmotionViewDelegate respondsToSelector:@selector(toucheAtPage:EmotionIndex:WithDescription:)]) {
			[self.myEmotionViewDelegate toucheAtPage:pageIndex EmotionIndex:emotionIndex WithDescription:fullDescription];
		}
	}
}
@end
