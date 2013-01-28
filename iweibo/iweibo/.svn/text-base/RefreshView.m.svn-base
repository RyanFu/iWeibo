//
//  RefreshView.m
//  iweibo
//
//  Created by wangying on 2/9/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "RefreshView.h"


@implementation RefreshView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"bgLabel" ofType:@"png"];
		broadCastImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
		broadCastImage.frame = CGRectMake(0, -30, 320, 30);
		
		NSString *pathError = [[NSBundle mainBundle] pathForResource:@"errorler" ofType:@"png"];
		errorCastImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:pathError]];
		errorCastImage.frame = CGRectMake(70, 8, 20, 20);
		errorCastImage.backgroundColor = [UIColor clearColor];
		errorCastImage.hidden = YES;
		[broadCastImage addSubview:errorCastImage];
		[errorCastImage release];
		
		NSString *pathIcon = [[NSBundle mainBundle] pathForResource:@"iconPull" ofType:@"png"];
		IconCastImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:pathIcon]];
		IconCastImage.frame = CGRectMake(70, 8, 15, 15);
		IconCastImage.backgroundColor = [UIColor clearColor];
		IconCastImage.hidden = YES;
		[broadCastImage addSubview:IconCastImage];
		[IconCastImage release];
		
		broadCastLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 100, 30)];
		broadCastLabel.backgroundColor = [UIColor clearColor];
		broadCastLabel.textColor = [UIColor colorWithRed:166/255.0 green:137/255.0 blue:67/255.0 alpha:1.];
		broadCastLabel.font = [UIFont systemFontOfSize:15];
		[broadCastImage addSubview:broadCastLabel];
		[broadCastLabel release];
		[self addSubview:broadCastImage];
		[broadCastImage release];
		
    }
    return self;
}

- (void)moveUp{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2.0];
	broadCastImage.frame = CGRectMake(0, -31, 320, 30);
	[UIView commitAnimations];
}

- (void)moveDown{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.1];
    broadCastImage.frame = CGRectMake(0, 0, 320, 30);
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(moveUp)];
	[UIView commitAnimations];
}

- (void)doneLoadingTableViewData:(NSUInteger) n{
	if (n>0) {
		if(n >0 && n <=30) {
			broadCastLabel.text = [NSString stringWithFormat:@"%d条新广播",n];
		}
		errorCastImage.hidden = YES;
		IconCastImage.hidden = NO;
	}
	else{
		broadCastLabel.text = @"没有新广播";
		errorCastImage.hidden = YES;
		IconCastImage.hidden = NO;
	}
	[self moveDown];
}

- (void)setErrorState{
	broadCastLabel.text = @"加载失败，请重试";   
	errorCastImage.hidden = NO;
	IconCastImage.hidden = YES;
}

- (void)dealloc {
	[broadCastImage release];
	[errorCastImage release];
	[IconCastImage release];
	[broadCastLabel release];
    [super dealloc];
}


@end
