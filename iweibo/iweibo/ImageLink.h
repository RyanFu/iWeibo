//
//  ImageLink.h
//  iweibo
//
//  Created by ZhaoLilong on 2/3/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Asyncimageview.h"
#import <objc/runtime.h>

@interface AsyncImageView(AddVaribles)

@property (nonatomic, copy)NSString *link; // 为AsyncImageView添加链接属性

@property (nonatomic, copy)NSString *type;// 为AsyncImageView添加链接类型

@end
