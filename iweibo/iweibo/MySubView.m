//
//  MySubView.m
//  iweibo
//
//  Created by Cui Zhibo on 12-6-12.
//  Copyright (c) 2012年 Beyondsoft. All rights reserved.
//

#import "MySubView.h"

@implementation MySubView
@synthesize delateBtn, editBtn, imgName;

- (id)initWithFrame:(CGRect)frame WithImageName:(NSString *)str{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:self.bounds];
        img.image = [UIImage imageNamed:str];
        img.userInteractionEnabled = YES;
        [self addSubview:img];
        [img release];
        
        delateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [delateBtn setImage:[UIImage imageNamed:@"homeDethover.png"] forState:UIControlStateNormal];
        delateBtn.frame = CGRectMake( (20/3)+0.5, 11.25, 75, 35);
        [img addSubview:delateBtn];
        
        editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [editBtn setImage:[UIImage imageNamed:@"homeDetailhover.png"] forState:UIControlStateNormal];
        editBtn.frame = CGRectMake(75 + (20/3) * 2-0.5 ,11.25, 75, 35);
        [img addSubview:editBtn];
    }
    return self;
}

- (void)dealloc{
    [super dealloc];
}
@end
