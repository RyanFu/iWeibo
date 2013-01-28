//
//  TextExtract.h
//  iweibo
//
//  Created by ZhaoLilong on 12/29/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegexKitLite.h"

@interface TextExtract : NSObject {
	
}

- (NSMutableDictionary *)getNameDictionary:(NSString *)text;

- (NSMutableDictionary *)getHttpDictionary:(NSString *)text;

- (NSMutableDictionary *)getTopicDictionary:(NSString *)text;

- (NSMutableDictionary *)getEmoDictionary;

- (NSMutableDictionary *)getEmoDictionary:(NSString *)text;

- (NSMutableDictionary *)getLastDictionary:(NSString *)text;

- (NSMutableDictionary *)getDictionaryByArray:(NSArray *)array withString:(NSString *)text;

- (NSString *)removeEmotionString:(NSString *)text;

- (NSString *)replaceNick:(NSString *)text withDictionary:(NSDictionary *)dictionary;

- (NSMutableArray *)lastString:(NSString *)text;

- (NSMutableArray *)sortByRange:(NSArray *)array;

- (NSRange)convertToRange:(NSString *)string;

- (NSMutableArray *)getInfoNodeArray:(NSString *)text;

@end
