//
//  LoadingMoreCell.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-25.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "LoadMoreCell.h"


@implementation LoadMoreCell
@synthesize spinner,label,cellState;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		label = [[UILabel alloc] initWithFrame:CGRectZero];
	//	label.backgroundColor = [UIColor colorWithWhite:0xF5/255.0F alpha:1];
		label.backgroundColor = [UIColor clearColor];
		label.highlightedTextColor = [UIColor whiteColor];
		label.font = [UIFont boldSystemFontOfSize:16];
	//	label.numberOfLines = 1;
		label.textAlignment = UITextAlignmentCenter;    
		label.frame = CGRectMake(0, 0, 320, 200);
		label.text = @"获取更多";
		[self.contentView addSubview:label];
		[label release];
		
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[self.contentView addSubview:spinner];
		[spinner release];
	}
	return self;
}

//-(id)init{
//	self = [super init];
//	if (self) {
//		label = [[UILabel alloc] initWithFrame:CGRectZero];
//		label.backgroundColor = [UIColor clearColor];
//		label.highlightedTextColor = [UIColor whiteColor];
//		label.font = [UIFont boldSystemFontOfSize:16];
//		label.textAlignment = UITextAlignmentCenter;    
//		label.frame = CGRectMake(0, 0, 320, 200);
//		label.text = @"获取更多";
//		[self addSubview:label];
//		[label release];
//		
//		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//		[self addSubview:spinner];
//		[spinner release];
//	}
//	return self;
//}
- (void)dealloc {
	label = nil;
	spinner = nil;
	[super dealloc];
}

- (void)setState:(LoadMoreCellStatus)state{
	switch (state) {
		case loadMore:
			label.text = @"获取更多";
			break;
		case loading:
			label.text = @"载入中";
		default:
			break;
	}
	cellState = state;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = [label textRectForBounds:CGRectMake(0, 0, self.bounds.size.width, 48) limitedToNumberOfLines:1];
    spinner.frame = CGRectMake(bounds.origin.x + bounds.size.width + 4, (self.frame.size.height / 2) - 8, 16, 16);
    label.frame = CGRectMake(0, 0, self.bounds.size.width, self.frame.size.height - 1);
}


@end
