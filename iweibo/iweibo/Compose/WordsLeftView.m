//
//  WordsLeftView.m
//  iweibo
//
//  Created by Minwen Yi on 12/31/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import "WordsLeftView.h"
#import <QuartzCore/QuartzCore.h>


@implementation WordsLeftView
@synthesize wordsLeftButton;
@synthesize deleteButton;
@synthesize wordsLeftCounts;
@synthesize myWordsLeftViewDelegate;
@synthesize showDeleteBtn;

// 求取文本宽度
- (NSInteger)getTextWidth:(NSString *)textNumber {
	CGSize detailSize = [textNumber sizeWithFont:[UIFont systemFontOfSize:LabelFontSize] 
						 constrainedToSize:CGSizeMake(100, MAXFLOAT) 
							 lineBreakMode:UILineBreakModeWordWrap];
	return detailSize.width;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		// 添加左边按钮
		wordsLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
		wordsLeftButton.tag = WordsLeftBtnTag;
		wordsLeftButton.titleLabel.font = [UIFont systemFontOfSize: LabelFontSize];
		// 添加删除按钮
		deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
		deleteButton.tag = DeleteBtnTag;
		[deleteButton setImage:[UIImage imageNamed:@"composeDel.png"] forState:UIControlStateNormal];
		[deleteButton setImage:[UIImage imageNamed:@"composeDel.png"] forState:UIControlStateHighlighted];
		// 设置圆角
		[[wordsLeftButton layer] setCornerRadius:8.0f];
		[[wordsLeftButton layer] setMasksToBounds:YES];
		// 不支持非绑定颜色，所以只能用图片替代
		//[[wordsLeftButton layer] setBackgroundColor:[UIColor colorWithRed:255.0 green:0.0 blue:0.0 alpha:1.0 ]];
		//[UIColor colorWithRed:156.0 green:195.0 blue:215.0 alpha:1.0 ]
		[wordsLeftButton setBackgroundImage:[UIImage imageNamed:@"composeWords.png"] forState:UIControlStateNormal];
		[wordsLeftButton setBackgroundImage:[UIImage imageNamed:@"composeWords.png"] forState:UIControlStateHighlighted];
		
		[wordsLeftButton addTarget:self action:@selector(ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
		[deleteButton addTarget:self action:@selector(ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
		[self setWordsLeftCounts:wordsLeftCounts];
		[self addSubview:wordsLeftButton];
		[self addSubview:deleteButton];
		showDeleteBtn = YES;
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
    [super dealloc];
}

- (void)ButtonClicked {
	if (wordsLeftCounts != MaxInputWords) {
		if ([self.myWordsLeftViewDelegate respondsToSelector:@selector(WordsLeftBtnClicked)]) {
			[self.myWordsLeftViewDelegate WordsLeftBtnClicked];
		}
	}
}

// 重载set方法
- (void)setWordsLeftCounts:(NSInteger)counts {
	wordsLeftCounts = counts;
	NSString *numString = [NSString stringWithFormat:@"%d", wordsLeftCounts];
	wordsLeftButton.titleLabel.font = [UIFont systemFontOfSize: LabelFontSize];
	NSInteger width = [self getTextWidth:numString];
	if (wordsLeftCounts == MaxInputWords || !showDeleteBtn) {
		// 没有删除符号 (按钮宽度)
		wordsLeftButton.frame = CGRectMake(self.frame.size.width - (width + 12) - SpatiumBetweenRightEdge, 0, width + 12, 17);
		[wordsLeftButton setTitle:numString forState:UIControlStateNormal];
		[wordsLeftButton setTitleColor:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0 ] forState:UIControlStateNormal];
		deleteButton.hidden = YES;
		if (wordsLeftCounts >= 0) {
			[wordsLeftButton setTitleColor:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0 ] forState:UIControlStateNormal];
		}
		else {
			[wordsLeftButton setTitleColor:[UIColor colorWithRed:255.0 green:0.0 blue:0.0 alpha:1.0 ] forState:UIControlStateNormal];
		}
	}
	else {
		// 有删除符号(删除符号占10宽度)
		wordsLeftButton.frame = CGRectMake(self.frame.size.width - (width + 12) - SpatiumBetweenRightEdge - 7, 0, width + 12, 17);
		deleteButton.frame = CGRectMake(self.frame.size.width - (SpatiumBetweenRightEdge) - 14, 0, 14, 17);
		[wordsLeftButton setTitle:numString forState:UIControlStateNormal];
		if (wordsLeftCounts >= 0) {
			[wordsLeftButton setTitleColor:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0 ] forState:UIControlStateNormal];
		}
		else {
			[wordsLeftButton setTitleColor:[UIColor colorWithRed:255.0 green:0.0 blue:0.0 alpha:1.0 ] forState:UIControlStateNormal];
		}
		deleteButton.hidden = NO;
	}
}


@end
