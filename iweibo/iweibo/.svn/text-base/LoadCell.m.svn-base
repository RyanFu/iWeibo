//
//  LoadCell.m
//  iweibo
//
//  Created by LICHENTAO on 12-1-17.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "LoadCell.h"

@implementation LoadCell
@synthesize spinner,label,cellState;

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {

		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		spinner.frame = CGRectMake(80, 15, 18, 18);
		spinner.backgroundColor = [UIColor clearColor];
		[spinner stopAnimating];
		[self addSubview:spinner];
		[spinner release];		

		label = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 100, 50)];
		label.backgroundColor = [UIColor clearColor];
		label.highlightedTextColor = [UIColor whiteColor];
		label.font = [UIFont systemFontOfSize:14];
		label.textColor = [UIColor grayColor];
		label.textAlignment = UITextAlignmentCenter;    
		label.text = @"获取更多";
		[self addSubview:label];
		[label release];
		
	}
    return self;
}

- (void)dealloc {
	label = nil;
	spinner = nil;
	[super dealloc];
}

- (void)setState:(LoadMoreStatus)state{
	switch (state) {
		case loadMore1:
			[spinner stopAnimating];
			label.text = @"获取更多";
			break;
		case loading1:
			[spinner startAnimating];
			label.text = @"载入中...";
			break;
		case loadFinished:
			[spinner stopAnimating];
			label.text = @"已全部加载完毕";
			break;
		case noResult:
			[spinner stopAnimating];
			label.text = @"没有搜索到相关数据";
			break;
       case intermitCom:
			[spinner stopAnimating];
		    label.text = @"暂无转播/评论";
		    break;
	   case errorInfo:
			[spinner stopAnimating];
			label.text = @"网络加载错误";
		   break;
		default:
			break;
	}
	cellState = state;
}

@end
