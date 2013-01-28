//
//  DetailLayout.m
//  iweibo
//
//  Created by ZhaoLilong on 1/30/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "DetailLayout.h"


@implementation DetailLayout

- (void)draw:(NSString *)string withType:(NSUInteger)type{
	switch (sourceType) {
		case 0:
			kFontSize = 16;
			break;
		case 1:
			kFontSize = 14;
			break;
		default:
			assert(NO);
			break;
	}
	contentWidth = 285;
	int lineWidth = 0;
	CGSize wordSize;
//	int lastPos = 0;
	if (type == 4) {
		string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
		string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
		string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
		string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
		string = [string stringByReplacingOccurrencesOfString:@"&39;" withString:@"\'"];
		string = [string stringByReplacingOccurrencesOfString:@"：" withString:@":"];
	}
	if (type==1){
		if (position.x > contentWidth - 10) {
			position.x = 0;
			position.y += 20;
			lineCount++;
		}
		position.x += 10;
	}else {
		NSMutableString *tmpString = [NSMutableString stringWithCapacity:100];
		if ((int)[string sizeWithFont:[UIFont systemFontOfSize:kFontSize]].width <= contentWidth - position.x) {
			position.x += [string sizeWithFont:[UIFont systemFontOfSize:kFontSize]].width;
			if (position.x == contentWidth) {
				position.x = 0;
				position.y += [@"我" sizeWithFont:[UIFont systemFontOfSize:kFontSize]].height;
				position.y += 5;
			}
		}else {
			for (int i = 0; i < [string length]; i++) {
				NSString *subString = [string substringWithRange:NSMakeRange(i, 1)];
				wordSize = [subString sizeWithFont:[UIFont systemFontOfSize:kFontSize]];
				lineWidth += wordSize.width;
				if (lineWidth > contentWidth - position.x) {
					[tmpString deleteCharactersInRange:NSMakeRange(0, [tmpString length])];
					lineWidth = 0;
					position.x = 0;
					position.y += wordSize.height + 5;
					lineCount += 1;		// 换行
				}
				[tmpString appendString:subString];
			}	
			if ([tmpString length] > 0) {
					//NSString *lastString = [string substringWithRange:NSMakeRange(lastPos, ([string length] - lastPos - 1))];
				position.x += [tmpString sizeWithFont:[UIFont systemFontOfSize:kFontSize]].width;
			}
		}
	}	
}


- (CGFloat) calculateOriHeight:(Info *)info withWidth:(CGFloat)width{
	NSLog(@"yuanshigaodu");
	position = CGPointZero;
	sourceType = 0;
	TextExtract *textExtract = [[TextExtract alloc] init];
	
	if (info.origtext!=nil) {
		NSMutableArray *infoArray = [textExtract getInfoNodeArray:info.origtext];
		if ([infoArray count] >= 2) {
			lineCount = 0;
		}
		else {
			lineCount = 0;
		}
		
		for (int i = 1; i < [infoArray count]; ) {
			[self draw:[infoArray objectAtIndex:i-1] withType:[[infoArray objectAtIndex:i] intValue]];
			i += 2;
		}
		if (position.x > 0) {
			lineCount += 1;
		}
	}
	[textExtract release];

	if (info.image != nil && ![info.image isEqualToString:@""]) {
		position.y += 110;
	}

	if (info.video !=nil) {
		position.y += 110;
	}
	
	return position.y + 35;
}

- (CGFloat) calculateSouHeight:(TransInfo *)transInfo withWidth:(CGFloat)width{
	NSLog(@"zhuanfagaodu");
	position = CGPointZero;
	sourceType = 1;
	NSString *sourceNick = transInfo.transNick;
	CGSize sourceNickSize = [sourceNick sizeWithFont:[UIFont systemFontOfSize:14]];
	
	position.x += sourceNickSize.width;
	
	if (transInfo.transIsvip) {
		position.x += 10;
	}
	
	position.x += 2;
	TextExtract *textExtract = [[TextExtract alloc] init];
	NSMutableArray *sourceArray = [textExtract getInfoNodeArray:transInfo.transOrigtext];
	if ([sourceArray count] >= 2) {
		lineCount = 0;
	}
	else {
		lineCount = 0;
	}
	for (int i = 1; i < [sourceArray count]; ) {
		[self draw:[sourceArray objectAtIndex:i-1] withType:[[sourceArray objectAtIndex:i] intValue]];
		i += 2;
	}
	
	if (position.x > 0) {
		lineCount += 1;
	}
	position.y = ((float)lineCount )*  ([@"我" sizeWithFont:[UIFont systemFontOfSize:14]].height + 5);
	[textExtract release];
	
		// 求图像高度
	if (transInfo.transImage && ![transInfo.transImage isEqualToString:@""]) {
		if (transInfo.sourceImageData != nil && [transInfo.sourceImageData length] > 0) {
			UIImage *imageSrc = [[UIImage alloc] initWithData:transInfo.sourceImageData];
			position.y += imageSrc.size.height / 2.0f;		// 默认高度为100
			position.x += 70;		// 距离左边70
			[imageSrc release];
		}
		else {
			position.y += 100;		// 默认高度为100
			position.x += 70;		// 距离左边70
		}

	}
		
	if ((transInfo.transVideo && ![transInfo.transVideo isEqualToString:@""])) 
	{
		position.y += 100;
		position.x += 70;
	}
	return position.y + 25;	
}

@end
