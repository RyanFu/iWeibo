//
//  SubViewForThreeItems.m
//  iweibo
//
//  Created by Cui Zhibo on 12-7-2.
//  Copyright (c) 2012年 Beyondsoft. All rights reserved.
//

#import "SubViewForThreeItems.h"

@implementation SubViewForThreeItems
@synthesize editBtn,aboutBtn, addBtn;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.bounds];
    NSLog(@"self.bounds %@",NSStringFromCGRect(self.bounds));
    bgView.image = [UIImage imageNamed:@"homeMorebg.png"];// 249 * 55
    bgView.userInteractionEnabled = YES;
    [self addSubview:bgView];
    [bgView release];
    
    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setImage:[UIImage imageNamed:@"homeEdithover.png"] forState:UIControlStateNormal];
    editBtn.frame = CGRectMake(7, 11.25, 75, 35);
    [bgView addSubview:editBtn];
    
    aboutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [aboutBtn setImage:[UIImage imageNamed:@"homeAbouthover.png"] forState:UIControlStateNormal];
    aboutBtn.frame = CGRectMake(6 + 75 + 5.5, 11.25, 75, 35);
    [bgView addSubview:aboutBtn];
    
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"homeAddhover.png"] forState:UIControlStateNormal];
    addBtn.frame = CGRectMake(3.5 + (75 + 6)*2, 11.25, 75, 35);
    [bgView addSubview:addBtn];
    
    return self;
}

@end
