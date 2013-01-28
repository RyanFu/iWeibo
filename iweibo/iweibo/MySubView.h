//
//  MySubView.h
//  iweibo
//
//  Created by Cui Zhibo on 12-6-12.
//  Copyright (c) 2012年 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySubView : UIView{
    UIButton *delateBtn;
    UIButton *editBtn;
}

@property (nonatomic, retain)UIButton *delateBtn;
@property (nonatomic, retain)UIButton *editBtn;
@property (nonatomic, retain)NSString *imgName;

- (id)initWithFrame:(CGRect)frame WithImageName:(NSString *)str;
@end
