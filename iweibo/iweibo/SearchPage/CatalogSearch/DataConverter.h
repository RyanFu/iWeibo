//
//  DataConverter.h
//  iweibo
//
//  Created by ZhaoLilong on 2/27/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchCatalogViewController.h" 

@interface DataConverter : NSObject {

}

// 根据类型将字典转换成数组
+ (NSMutableArray *)convertToArray:(NSDictionary *)dict withType:(SearchCatalogType)type;

// 将广播信息字典转换成数组
+ (NSMutableArray *)convertToInfoArray:(NSDictionary *)dict;

// 将话题信息字典转成数组
+ (NSMutableArray *)convertToTopicArray:(NSDictionary *)dict;

// 将用户信息字典转换成数组
+ (NSMutableArray *)convertToUserArray:(NSDictionary *)dict;

@end
