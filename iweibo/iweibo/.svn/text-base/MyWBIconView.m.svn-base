//
//  MyWBIconView.m
//  iweibo
//
//  Created by Cui Zhibo on 12-6-7.
//  Copyright (c) 2012年 Beyondsoft. All rights reserved.
//

#import "MyWBIconView.h"

@implementation MyWBIconView
@synthesize myButton,myLabel;

- (void) dealloc{
    self.myButton = nil;
    self.myLabel = nil;
    [super dealloc];
} 

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 67, 67);
        self.myButton = btn;
        [self addSubview:btn];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(-10, 67+2, 67+20, 29)];
        lab.textAlignment = UITextAlignmentCenter;
		lab.lineBreakMode = UILineBreakModeTailTruncation;
        lab.font = [UIFont systemFontOfSize:14];
        lab.backgroundColor = [UIColor clearColor];
        lab.userInteractionEnabled = YES;
        self.myLabel = lab;
        [self addSubview:lab];
        [lab release];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

@end
