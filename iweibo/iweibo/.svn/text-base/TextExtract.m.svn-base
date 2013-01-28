//
//  TextExtract.m
//  iweibo
//
//  Created by ZhaoLilong on 12/29/11.
//  Copyright 2011 Beyondsoft. All rights reserved.
//

#import "TextExtract.h"
#import "TimeTrack.h"
#import "HomePage.h"

@implementation TextExtract

// 将字符串数组封装成字典
- (NSMutableDictionary *)getDictionaryByArray:(NSArray *)array withString:(NSString *)text{
	NSMutableDictionary *mDictionary = [NSMutableDictionary dictionary];
	NSRange rangeNext = {0};
	NSInteger tLen = [text length];
	rangeNext.length = tLen;
	for (NSString *str in array) {
		// 2012-02-16 By Yi Minwen 增加重复判断
		NSRange range = [text rangeOfString:str options:NSLiteralSearch range:rangeNext];
		if (range.location != NSNotFound) {
			[mDictionary setValue:[text substringWithRange:range] forKey:[NSString stringWithFormat:@"%@",[NSValue valueWithRange:range]]];
			rangeNext.location = range.location + range.length;
			rangeNext.length = tLen - rangeNext.location;
		}
	}
	return mDictionary;
	
}

// 根据用户名正则表达式提取字符串中的用户名并生成对应的字典
- (NSMutableDictionary *) getNameDictionary:(NSString *)text{
	NSArray *array = [text componentsMatchedByRegex:NAME_REGEX];
	return [self getDictionaryByArray:array withString:text];
}

// 根据http正泽表达式提取字符串中的http链接并生成对应的字典
- (NSMutableDictionary *)getHttpDictionary:(NSString *)text{
	NSArray *array = [text componentsMatchedByRegex:HTTP_REGEX];
	return [self getDictionaryByArray:array withString:text];
}

// 根据主题正则表达式提取字符串中的主题信息并生成对应的字典
- (NSMutableDictionary *)getTopicDictionary:(NSString *)text{
	NSArray *array = [text componentsMatchedByRegex:TOPIC_REGEX];
	return [self getDictionaryByArray:array withString:text];
}

//获取剩余普通文本
- (NSMutableDictionary *)getLastDictionary:(NSString *)text{
	NSArray *lastArray = [NSArray arrayWithArray:[self lastString:text]];
	NSMutableDictionary *mDictionary = [self getDictionaryByArray:lastArray withString:text];
	return mDictionary;
}

// 生成表情字典
- (NSMutableDictionary *)getEmoDictionary{

	NSArray *emoArray = [EMOTION componentsSeparatedByString:@","];
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:104];
	for (NSString *str in emoArray) {
		NSArray *tempArray = [str componentsSeparatedByString:@"|"];
		[dictionary setValue:[tempArray objectAtIndex:0] forKey:[NSString stringWithFormat:@"/%@",[tempArray objectAtIndex:1]]];
	}
	return dictionary;
}

// 移除字符串中的表情
- (NSString *)removeEmotionString:(NSString *)text{
	NSArray *array = [[self getEmoDictionary:text] allValues];
	NSString *string = text;
	for (NSString *str in array) {
		string = [string stringByReplacingOccurrencesOfString:str withString:@""];
	}
	return string;
}

// 根据字典替换字符串中用户名的昵称
- (NSString *) replaceNick:(NSString *)text withDictionary:(NSDictionary *)dictionary{
	NSArray *nameArray = [dictionary allKeys];
	NSString *string = text;
	for (NSString *str in nameArray) {
		string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"@%@",str] withString:[NSString stringWithFormat:@"%@",[dictionary valueForKey:str]]];
	}
	return string;
}

// 将字符串转换成NSRange结构体
-(NSRange) convertToRange:(NSString *)string{
	string = [string stringByReplacingOccurrencesOfString:@"NSRange: {" withString:@""];
	string = [string stringByReplacingOccurrencesOfString:@"}" withString:@""];
	NSArray *rangeArray = [string componentsSeparatedByString:@","];
	NSUInteger location = [[rangeArray objectAtIndex:0] intValue];
	NSUInteger length = [[rangeArray objectAtIndex:1] intValue];
	return NSMakeRange(location,length);
}

// 提取剩余普通字符串
-(NSMutableArray *) lastString:(NSString *)text{
	NSMutableArray *mutableArray = [NSMutableArray array];
	
	//提取用户名字典
	NSMutableDictionary *nameDictionary = [self getNameDictionary:text];
	
	//提取主题字典
	NSMutableDictionary *topicDicionary = [self getTopicDictionary:text];
	
	//提取表情字典
	NSMutableDictionary *emoDictionary = [self getEmoDictionary:text];
	
	//提取http字典
	NSMutableDictionary *httpDictionary = [self getHttpDictionary:text];
	
	//如果字典均为空，则剩余字符串为传入的字符串
	if ([nameDictionary count]==0&&[topicDicionary count]==0&&[emoDictionary count]==0&&[httpDictionary count]==0){
		[mutableArray addObject:text];
	}else {
		NSMutableDictionary *totalDictionary = [NSMutableDictionary dictionary];
		[topicDicionary addEntriesFromDictionary:httpDictionary];
		[totalDictionary addEntriesFromDictionary:topicDicionary];
		[totalDictionary addEntriesFromDictionary:nameDictionary];
		[totalDictionary addEntriesFromDictionary:emoDictionary];
		
		NSArray *rangeArray = [totalDictionary allKeys];
		NSMutableArray *sequencedArray  =  [self sortByRange:rangeArray];
		if ([sequencedArray count]!=0) {
			
			NSUInteger position;
			NSUInteger lastPostion = [self convertToRange:[sequencedArray objectAtIndex:([sequencedArray count]-1)]].location + [self convertToRange:[sequencedArray objectAtIndex:([sequencedArray count]-1)]].length;
			NSUInteger textLength = [text length];
			NSRange preRange;
			NSRange nextRange;
			if ([sequencedArray count]!=1) {
				for (int i = 1; i < [sequencedArray count]; i++) {
					preRange = [self convertToRange:[sequencedArray objectAtIndex:i-1]];
					nextRange = [self convertToRange:[sequencedArray objectAtIndex:i]];
					position = preRange.location + preRange.length;
					if ([self convertToRange:[sequencedArray objectAtIndex:0]].location!=0) {
						[mutableArray addObject:[text substringWithRange:NSMakeRange(0, [self convertToRange:[sequencedArray objectAtIndex:0]].location)]];
					}
					if (position != nextRange.location) {
						if(nextRange.location > position ) {
							[mutableArray addObject:[text substringWithRange:NSMakeRange(position, nextRange.location - position)]];
						}
					}
					if (i== ([sequencedArray count]-1)&&lastPostion!=textLength){
						[mutableArray addObject:[text substringWithRange:NSMakeRange(lastPostion, [text length]-lastPostion)]];
					}
				}	
			}else {
				if ([self convertToRange:[sequencedArray objectAtIndex:0]].location!=0) {
					[mutableArray addObject:[text substringWithRange:NSMakeRange(0, [self convertToRange:[sequencedArray objectAtIndex:0]].location)]];
				}
				if (lastPostion != textLength) {
					[mutableArray addObject:[text substringWithRange:NSMakeRange(lastPostion, [text length]-lastPostion)]];
				}
			}		
		}
	}
	return mutableArray;
}

// 根据数组来排序NSRange，确定字符串先后顺序
-(NSMutableArray *) sortByRange:(NSArray *)array{
	NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
	NSUInteger tempLocation;
	NSUInteger nextLocation;
	NSUInteger iPos;
	if ([mutableArray count] > 1) {
		for (int i = 0; i < [mutableArray count]; i++) {
			tempLocation = [self convertToRange:[mutableArray objectAtIndex:i]].location;
			iPos = i;
			for (int j = i + 1; j < [mutableArray count]; j++) {
				nextLocation = [self convertToRange:[mutableArray objectAtIndex:j]].location;
				if (nextLocation < tempLocation) {
					tempLocation = [self convertToRange:[mutableArray objectAtIndex:j]].location;
					iPos = j;
				}
			}
			if (iPos > i) {
				[mutableArray exchangeObjectAtIndex:i withObjectAtIndex:iPos];
			}
		}		
	}
	return mutableArray;
}

//获取信息节点数组
- (NSMutableArray *) getInfoNodeArray:(NSString *)text{
	NSMutableArray *mArray = [NSMutableArray array];
	NSMutableDictionary *nameDic = [self getNameDictionary:text];
	NSMutableDictionary *emoDic = [self getEmoDictionary:text];
	NSMutableDictionary *httpDic = [self getHttpDictionary:text];
	NSMutableDictionary *topicDic = [self getTopicDictionary:text];
	NSMutableDictionary *lastDic = [self getLastDictionary:text];
	NSMutableDictionary *totalDic = [NSMutableDictionary dictionary];
	if ([nameDic count]==0&&[emoDic count]==0&&[httpDic count]==0&&[topicDic count]==0){
		[mArray addObject:text];
		[mArray addObject:[NSString stringWithFormat:@"%d",4]];
	}else {
		
		if ([nameDic count]!=0) {
			[totalDic addEntriesFromDictionary:nameDic];
		}
		if ([emoDic count]!=0) {
			[totalDic addEntriesFromDictionary:emoDic];
		}
		if ([httpDic count]!=0) {
			[totalDic addEntriesFromDictionary:httpDic];
		}
		if ([topicDic count]!=0) {
			[totalDic addEntriesFromDictionary:topicDic];
		}
		if ([lastDic count]!=0) {
			[totalDic addEntriesFromDictionary:lastDic];
		}
		NSMutableArray *mutableArray = [self sortByRange:[totalDic allKeys]];
		for (NSString *str in mutableArray) {
			if ([nameDic valueForKey:str]) {
				[mArray addObject:[nameDic valueForKey:str]];
				[mArray addObject:[NSString stringWithFormat:@"%d",0]]; //用户名
			}	
			if ([emoDic valueForKey:str]) {
				[mArray addObject:[emoDic valueForKey:str]];
				[mArray addObject:[NSString stringWithFormat:@"%d",1]]; //表情
			}
			if ([httpDic valueForKey:str]) {
				[mArray addObject:[httpDic valueForKey:str]];
				[mArray addObject:[NSString stringWithFormat:@"%d",2]]; //http
			}
			if ([topicDic valueForKey:str]) {
				[mArray addObject:[topicDic valueForKey:str]];
				[mArray addObject:[NSString stringWithFormat:@"%d",3]];  //主题
			}
			if ([lastDic valueForKey:str]) {
				[mArray addObject:[lastDic valueForKey:str]];
				[mArray addObject:[NSString stringWithFormat:@"%d",4]];  //普通字符串
			}
		}		
	}
	return mArray;
}

// 表情完全解析
- (NSMutableDictionary *)getEmoDictionary:(NSString *)text{
	NSMutableDictionary *mDictionary = [NSMutableDictionary dictionaryWithCapacity:5];
	NSMutableDictionary *mutableDictionary = [HomePage emotionDictionary];
	NSArray *array = [mutableDictionary allKeys];
	for (NSString *emoStr in array) {
		NSRange searchRange = NSMakeRange(0, [text length]);
		NSRange range;
		NSUInteger location = 0;
		do {
			range = [text rangeOfString:emoStr options:NSCaseInsensitiveSearch range:searchRange];
			location = range.location + range.length;
			if (range.location < [text length]) {
				searchRange = NSMakeRange(location, [text length]-location);
				[mDictionary setValue:[text substringWithRange:range] forKey:[NSString stringWithFormat:@"%@",[NSValue valueWithRange:range]]];
			}
		} while (range.location != NSNotFound);		
	}
	return mDictionary;
}

@end
