//
//  DetailLayout.h
//  iweibo
//
//  Created by ZhaoLilong on 1/30/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Info.h"
#import "TransInfo.h"
#import "OriginView.h"

@interface DetailLayout : NSObject {
	CGPoint position;
	NSMutableDictionary *emoDic;
	CGFloat contentWidth;
	NSUInteger sourceType;
	NSUInteger kFontSize;
	int lineCount;		// 行数
}


- (CGFloat)calculateOriHeight:(Info *)info withWidth:(CGFloat)width;

- (CGFloat)calculateSouHeight:(TransInfo *)transInfo withWidth:(CGFloat)width;

@end
