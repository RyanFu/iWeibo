//
//  NSString+CaclHeight.m
//  DriverLicenseExam
//
//  Created by Minwen Yi on 5/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+CaclHeight.h"


@implementation NSString(CaclHeight)

-(CGFloat)calcCellHeightWithFont:(UIFont *)tFont andWidth:(CGFloat)frameWidth {
	CGPoint curPosition = CGPointZero;
	CGFloat wordHeight = [@"我" sizeWithFont:tFont].height;		// 文本高度
	if ((int)[self sizeWithFont:tFont].width <= frameWidth - curPosition.x) {		
		curPosition.y += wordHeight;
	}else {
		NSMutableString *tmpString = [NSMutableString stringWithCapacity:30];
		CGFloat		lineWidth = 0;	// 文本在当前行的宽度
		for (int i = 0; i < [self length]; i++) {
			NSString *subString = [self substringWithRange:NSMakeRange(i, 1)];
			CGSize wordSize = [subString sizeWithFont:tFont];
			// 文本折行处理: 当当前文本剩于宽度小于下一个字符的宽度，则进行折行
			if ((lineWidth + wordSize.width) > frameWidth - curPosition.x) {
				lineWidth = 0;
				curPosition.y += wordHeight;
				[tmpString deleteCharactersInRange:NSMakeRange(0, [tmpString length])];
			}
			lineWidth += wordSize.width;
			[tmpString appendString:subString];
		}	
		// 剩余
		if ([tmpString length] > 0) {
			curPosition.y += wordHeight;
		}
	}
	return curPosition.y;
}
@end
