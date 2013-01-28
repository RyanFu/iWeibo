//
//  CalculateHeight.m
//  iweibo
//
//  Created by ZhaoLilong on 2/4/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "CalculateUtil.h"
#import "TextExtract.h"
#import "HomePage.h"

@implementation CalculateUtil

// 计算评论文本的高度
- (CGFloat)calculateHeight:(NSString *)string fontSize:(CGFloat)size andWidth:(CGFloat)width{
	// 位置初始化
	position = CGPointZero;
	
	// 解析字符串
	TextExtract *textExtract = [[TextExtract alloc] init];
	NSMutableArray *txtArray = [textExtract getInfoNodeArray:string];
	
	// 模拟绘制
	for (int i = 1; i < [txtArray count]; ) {
		[self drawTextFromCurPos:[txtArray objectAtIndex:i-1]  
						withType:[[txtArray objectAtIndex:i] intValue] 
					 andFontSize:size
						  andWidth:width];
		i += 2;
	}

	// 最后不满一行，按一行计算(由于有名字存在，至少会有一行)
	if (position.x > 0.1f) {
		// 加上一行高度
		position.y += [@"我" sizeWithFont:[UIFont systemFontOfSize:size]].height;		
	}
	
	// 释放资源
	[textExtract release];
	
	// 返回纵坐标
	return position.y;
}

// 模拟绘制字符串
-(void)drawTextFromCurPos:(NSString *)strText withType:(NSUInteger)type andFontSize:(CGFloat)tFont andWidth:(CGFloat)tWidth{
	UIFont *font = [UIFont systemFontOfSize:tFont];
	// 文本高度
	CGFloat wordHeight = [@"我" sizeWithFont:font].height;		
	NSString *stringText = strText;
	if (type == 0) {
		NSMutableDictionary *dic = [HomePage nickNameDictionary];
		NSString *userName = strText;	
		if ([dic isKindOfClass:[NSDictionary class]]) {
			if ([userName hasPrefix:@"@"] && [userName length] > 1) {
				NSString *trueName = [userName substringFromIndex:[userName rangeOfString:@"@"].location+1];
				NSString *nickName = [dic objectForKey:trueName];
				if (nickName != nil && [nickName isKindOfClass:[NSString class]]) {
					stringText = nickName;
				}
				else {
					stringText = userName;
					// 没有对应名字则显示文字
					type = 4;	
				}
			}
			else {
				stringText = userName;
			}
		}
		else {
			stringText = userName;
		}
	}else if (type == 4) {
		// 替换普通文本字符串
		stringText = [strText stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
		stringText = [stringText stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
		stringText = [stringText stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
		stringText = [stringText stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
		stringText = [stringText stringByReplacingOccurrencesOfString:@"&39;" withString:@"\'"];
		stringText = [stringText stringByReplacingOccurrencesOfString:@"：" withString:@":"];
	}
	else {
		stringText = strText;
	}
	
	if (type==1){
		// 表情处理
		if (position.x > tWidth - 20) {
			position.x = 0;
			position.y += wordHeight;
		}
		position.x += 20;
	}else {
		// 其他类型
		if ((int)[stringText sizeWithFont:font].width <= tWidth - position.x) {
			position.x += [stringText sizeWithFont:font].width;
			if (position.x == tWidth) {
				position.x = 0;
				position.y += wordHeight;
			}
		}else {
			NSMutableString *tmpString = [NSMutableString stringWithCapacity:30];
			// 文本在当前行的宽度
			CGFloat		lineWidth = 0;	
			for (int i = 0; i < [stringText length]; i++) {
				NSString *subString = [stringText substringWithRange:NSMakeRange(i, 1)];
				CGSize wordSize = [subString sizeWithFont:font];
				// 文本折行处理: 当当前文本剩于宽度小于下一个字符的宽度，则进行折行
				if ((lineWidth + wordSize.width) > tWidth - position.x) {
					[tmpString deleteCharactersInRange:NSMakeRange(0, [tmpString length])];
					lineWidth = 0;
					position.x = 0;
					position.y += wordHeight;
				}
				lineWidth += wordSize.width;
				[tmpString appendString:subString];
			}	
			if ([tmpString length] > 0) {
				// 剩余字符串
				position.x += [tmpString sizeWithFont:font].width;
			}
		}
	}	
}
 
@end
