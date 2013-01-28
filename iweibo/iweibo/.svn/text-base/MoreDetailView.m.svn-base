//
//  moreDetailView.m
//  iweibo
//
//  Created by wangying on 2/27/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "moreDetailView.h"
#import "Asyncimageview.h"

@implementation MoreDetailView

@synthesize headPortrait,nameLabel,nickLabel,segmentedControl,delegate;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) 
	{
		int imageOriginX = 9;
		int imageOriginY = 6;
		int labelOriginX = 67;
		int ButtonOriginY = 26;
		int HeadWidth = 50;
		int HeadHeight = 50;
		
		self.backgroundColor = [UIColor clearColor];
		CGRect rc = CGRectMake(imageOriginX, imageOriginY, HeadWidth, HeadHeight);
		headPortrait = [[AsyncImageView alloc] init];
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHead:)];
		[headPortrait addGestureRecognizer:tapGesture];
		[tapGesture release];
		headPortrait.layer.masksToBounds = YES;
		headPortrait.layer.cornerRadius = 3.0f;
		headPortrait.frame = rc;
		[self.contentView addSubview:headPortrait];
		[headPortrait release];
		
		rc = CGRectMake(labelOriginX, imageOriginY, 150, 20);
		nameLabel = [[UILabel alloc] initWithFrame:rc];
		nameLabel.backgroundColor = [UIColor clearColor];
		nameLabel.font = [UIFont systemFontOfSize:16];
		nameLabel.text = @"kenZhu";
		nameLabel.textColor = [UIColor colorWithRed:0.2 green:0.455 blue:0.596 alpha:1];
		[self.contentView addSubview:nameLabel];
		[nameLabel release];
		
		rc = CGRectMake(labelOriginX, ButtonOriginY, 75, 30);
		nickLabel = [[UILabel alloc] initWithFrame:rc];
		nickLabel.backgroundColor = [UIColor clearColor];
		nickLabel.font = [UIFont systemFontOfSize:16];
		nickLabel.text = @"@kenZhu";
		nickLabel.textColor = [UIColor colorWithRed:0.2 green:0.455 blue:0.596 alpha:1];
		[self.contentView addSubview:nickLabel];
		[nickLabel release];
		
		NSArray *segmentTextContent = [[NSArray alloc]initWithObjects: @"广播", @"听众", @"收听", nil];
		segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
		segmentedControl.frame = CGRectMake(5,70,290,55);
		segmentedControl.segmentedControlStyle = UISegmentedControlStyleBordered;
		[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
		[self.contentView addSubview:segmentedControl];
		[segmentTextContent release];
    }
    return self;
}

- (void)segmentAction:(id)sender{
	if ([delegate conformsToProtocol:@protocol(MoreDetailViewDelegate)]) {
		[delegate segmentedControldidSelectButtonAtIndex:[sender selectedSegmentIndex]];
	}
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
	[headPortrait addHeadImageFromData:nil];// 加载默认头像
}


- (void)dealloc {
	
	[headPortrait		release];
	[nameLabel			release];
	[nickLabel			release];
	[segmentedControl	release];
    [super				dealloc];
}


@end
