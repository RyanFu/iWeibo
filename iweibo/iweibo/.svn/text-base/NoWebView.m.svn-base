//
//  NoWebView.m
//  iweibo
//
//  Created by wangying on 2/9/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "NoWebView.h"


@implementation NoWebView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cup.png"]];
		imageView.frame = CGRectMake(90, 70, 140, 150);
		label = [[UILabel alloc] initWithFrame:CGRectMake(50, 220, 300, 80)];
		
		label.font = [UIFont systemFontOfSize:12];
		label.textColor = [UIColor lightGrayColor];
		[self addSubview:label];
		[self addSubview:imageView];
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
- (void)setState:(sourceType)type{
	switch (type) {
		case broadCastType:
			label.text = @"您还没有发表广播，快去说点什么吧";
			break;
		case listenType:
			label.text = @"你还没有收听任何人，快去关注别人吧";
			break;
		case audienceType:
			label.text = @"你还没有听众，快让朋友来收听你吧";
			break;
		case messageType:
			label.text = @"他人对你的转播，评论和对话会出现在这里";
			break;
		case catalogSearchType:
			label.text = @"                没有找到相关的结果";
			break;
		case noTextType:
			label.text = @"";
			break;
		default:
			break;
	}
}

- (void)dealloc {
	[label release];
	[imageView release];
	[super dealloc];
}


@end
