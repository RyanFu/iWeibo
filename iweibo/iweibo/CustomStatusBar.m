//
//  CustomStatusBar.m
//  iweibo
//
//  Created by ZhaoLilong on 12-1-15.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "CustomStatusBar.h"


@implementation CustomStatusBar
@synthesize type;
@synthesize indicator;
@synthesize imageView;
@synthesize lblStatus;

- (id)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
		self.windowLevel = UIWindowLevelStatusBar + 1.0f;
		self.frame = [UIApplication sharedApplication].statusBarFrame;
		self.backgroundColor  = [UIColor blackColor];
		// 文字信息，用于和用户进行交互，最好能显示用户当前是什么操作
		lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, self.frame.size.height)];
		lblStatus.backgroundColor = [UIColor blackColor];
		lblStatus.textColor = [UIColor whiteColor];
		lblStatus.textAlignment = UITextAlignmentCenter;
		lblStatus.font = [UIFont boldSystemFontOfSize:10.0f];
		[self addSubview:lblStatus];
		// 添加图片
		self.imageView.hidden = YES;
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2.0f, 3.0f, 15, 15)];
		self.imageView.image = [UIImage imageNamed:@"对号.png"];
		[lblStatus addSubview:self.imageView];	
		// 加载显示
		indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		self.indicator.frame = CGRectMake(2.0f, 3.0f, 15, 15);
		self.indicator.hidesWhenStopped = YES;
		[lblStatus addSubview:self.indicator];
	}
	return self;
}

-(void) drawRect:(CGRect)rect{
	[super drawRect:rect];
	switch (self.type) {
		case statusTypeLoading:
			self.imageView.hidden= YES;
			self.indicator.hidesWhenStopped = YES;
			break;
		case statusTypeSuccess:
				//显示成功图标
			if (self.imageView.hidden) {
				self.imageView.hidden = NO;
			}
			[self.indicator stopAnimating];
			break;
		default:
			break;
	}
}

- (void)showWithStatusMessage:(NSString *)msg{
	if (!msg) return;
	self.imageView.hidden = YES;
	lblStatus.text = msg;
	[self.indicator startAnimating];
	self.hidden = NO;
}

- (void)dealloc{
	[lblStatus release];
	[indicator release];
	[imageView release];
	[super dealloc];
}
@end
