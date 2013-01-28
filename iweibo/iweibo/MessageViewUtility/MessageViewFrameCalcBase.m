//
//  MessageViewFrameCalcBase.m
//  iweibo
//
//  Created by Minwen Yi on 2/10/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "MessageViewFrameCalcBase.h"
#import "HomePage.h"


@implementation MessageViewFrameCalcBase
@synthesize curPosition, textFont, tailFont, headFont, frameWidth, idMessage;
@synthesize bCached;

-(id)init {
	if (self = [super init]) {
		TextExtract *textExtract = [[TextExtract alloc] init];//声明文本解析对象
		emoDic = [HomePage emotionDictionary];
		if (![emoDic isKindOfClass:[NSDictionary class]]) {
			emoDic = [textExtract getEmoDictionary];//获取表情字典
		}
		[textExtract release];
		arrItems = [[NSMutableArray alloc] initWithCapacity:5];
        bCached = YES;
	}
	return self;
}

-(void)dealloc {
	[arrItems release];
	[super dealloc];
}

-(void)cacheUnitItem:(NSString *)strText withType:(UnitItemType)type link:(NSString *)strLink andFrame:(CGRect)rect {
}

// 将求取的数据存储到缓存字典
- (void)addItemArrayToDic {
}

// 模拟画消息文本(更新curPosition位置)
-(void)drawTextFromCurPos:(NSString *)strText withType:(NSUInteger)type andFont:(UIFont *)tFont {
//	CLog(@"++++++++++++++++++%s strText:%@ curPosition.x:%f, curPosition.y:%f", __FUNCTION__, strText, curPosition.x, curPosition.y);
	NSString *stringText = nil;
	CGFloat wordHeight = [@"我" sizeWithFont:tFont].height;		// 文本高度
	// 替换普通文本字符串
	if (type == TypeNickName) {
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
					type = TypeText;	// 没有对应名字则显示文字
				}
			}
			else {
				stringText = userName;
			}
		}
		else {
			stringText = userName;
		}
	}
	else if (type == TypeText) {
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

	if (type==TypeEmotion){
		NSString *imageString = [emoDic objectForKey:stringText];
		// 表情处理
		if (curPosition.x > frameWidth - EmotionImageWidth) {
			curPosition.x = 0;
			curPosition.y += wordHeight;
			curPosition.y += VerticalSpaceBetweenText;
		}
		[self cacheUnitItem:[NSString stringWithFormat:@"%@.png",imageString] withType:type link:nil andFrame:CGRectMake(curPosition.x, curPosition.y, 0.0f, 0.0f)];
		curPosition.x += EmotionImageWidth;
	}else {
		// 其他类型
        CGSize sz = [stringText sizeWithFont:tFont];
		if (sz.width <= frameWidth - curPosition.x) {
			if (type == TypeNickName) {
				[self cacheUnitItem:stringText withType:type link:strText andFrame:CGRectMake(curPosition.x, curPosition.y, sz.width, sz.height)];
			}
			else {
				[self cacheUnitItem:stringText withType:type link:stringText andFrame:CGRectMake(curPosition.x, curPosition.y, sz.width, sz.height)];
			}

			curPosition.x += [stringText sizeWithFont:tFont].width;
			if (curPosition.x == frameWidth) {
				curPosition.x = 0;
				curPosition.y += wordHeight;
				curPosition.y += VerticalSpaceBetweenText;
			}
		}else {
            // 2012-07-12 By Yi Minwen 增加多行存储(未完成)
            // 什么时候多算一行？从头到尾都是普通文本
            BOOL bLineStarted = (curPosition.x - 1.0f) < 1.0f ? YES:NO;     // 是否是从行的起始位置开始的
            bLineStarted = bLineStarted && (TypeText == type);              // 目前只处理普通文本
            
			NSMutableString *tmpString = [NSMutableString stringWithCapacity:30];
            NSMutableString *tmpLongString = [NSMutableString stringWithCapacity:30];
			CGFloat		lineWidth = 0;	// 文本在当前行的宽度
            if (TypeText == type) {
                CGPoint startPoint = curPosition;
                NSInteger nRowCount = 0;
                for (int i = 0; i < [stringText length]; i++) {
                    NSString *subString = [stringText substringWithRange:NSMakeRange(i, 1)];
                    CGSize wordSize = [subString sizeWithFont:tFont];
                    // 文本折行处理: 当当前文本剩于宽度小于下一个字符的宽度，则进行折行
                    if ((lineWidth + wordSize.width) > frameWidth - curPosition.x) {
                        //					CLog(@"AtmpString:%@, lineWidth:%f, wordSize.width:%f, self.frameWidth:%f, curPosition.x:%f",
                        //											 tmpString, lineWidth, wordSize.width, frameWidth, curPosition.x);
                        // 只有在起始位置非零，而且是第一行需要先缓存
                        if ((startPoint.x - 1.0f) > 1.0f && nRowCount == 0) {
                            CGSize szTemp = [tmpString sizeWithFont:tFont];
                            if (type == TypeNickName) {
                                [self cacheUnitItem:tmpString withType:type link:strText andFrame:CGRectMake(curPosition.x, curPosition.y, szTemp.width, szTemp.height)];
                            }
                            else {
                                [self cacheUnitItem:tmpString withType:type link:stringText andFrame:CGRectMake(curPosition.x, curPosition.y, szTemp.width, szTemp.height)];
                            }
                            lineWidth = 0;
                            curPosition.x = 0;
                            curPosition.y += wordHeight;
                            curPosition.y += VerticalSpaceBetweenText;
                            startPoint = curPosition;   // 更新起始位置
                            [tmpString deleteCharactersInRange:NSMakeRange(0, [tmpString length])];                        
                        }
                        else {
                            lineWidth = 0;
                            curPosition.x = 0;
                            curPosition.y += wordHeight;
                            curPosition.y += VerticalSpaceBetweenText;
                            nRowCount++;
                            [tmpLongString appendString:tmpString];
                            [tmpString deleteCharactersInRange:NSMakeRange(0, [tmpString length])]; 
                        }
                    }
                    lineWidth += wordSize.width;
                    [tmpString appendString:subString];
                }
                // 添加长字符串
                if (nRowCount > 0) {
                    [self cacheUnitItem:tmpLongString withType:type link:strText andFrame:CGRectMake(startPoint.x, startPoint.y, frameWidth, sz.height * nRowCount)];
                }
            }
            else {
                for (int i = 0; i < [stringText length]; i++) {
                    NSString *subString = [stringText substringWithRange:NSMakeRange(i, 1)];
                    CGSize wordSize = [subString sizeWithFont:tFont];
                    // 文本折行处理: 当当前文本剩于宽度小于下一个字符的宽度，则进行折行
                    if ((lineWidth + wordSize.width) > frameWidth - curPosition.x) {
    //					CLog(@"AtmpString:%@, lineWidth:%f, wordSize.width:%f, self.frameWidth:%f, curPosition.x:%f",
                        //											 tmpString, lineWidth, wordSize.width, frameWidth, curPosition.x);
                        CGSize szTemp = [tmpString sizeWithFont:tFont];
                        if (type == TypeNickName) {
                            [self cacheUnitItem:tmpString withType:type link:strText andFrame:CGRectMake(curPosition.x, curPosition.y, szTemp.width, szTemp.height)];
                        }
                        else {
                            [self cacheUnitItem:tmpString withType:type link:stringText andFrame:CGRectMake(curPosition.x, curPosition.y, szTemp.width, szTemp.height)];
                        }

                        lineWidth = 0;
                        curPosition.x = 0;
                        curPosition.y += wordHeight;
                        curPosition.y += VerticalSpaceBetweenText;
                        [tmpString deleteCharactersInRange:NSMakeRange(0, [tmpString length])];
                    }
                    lineWidth += wordSize.width;
                    [tmpString appendString:subString];
                }	
            }
			// 剩余
			if ([tmpString length] > 0) {
				//CLog(@"AtmpString:%@", tmpString);
                CGSize szTemp = [tmpString sizeWithFont:tFont];
				if (type == TypeNickName) {
					[self cacheUnitItem:tmpString withType:type link:strText andFrame:CGRectMake(curPosition.x, curPosition.y, szTemp.width, szTemp.height)];
				}
				else {
					[self cacheUnitItem:tmpString withType:type link:stringText andFrame:CGRectMake(curPosition.x, curPosition.y, szTemp.width, szTemp.height)];
				}
				curPosition.x += szTemp.width;
			}
		}
	}	
	
//	CLog(@"---------------------%s curPosition.x:%f, curPosition.y:%f", __FUNCTION__, curPosition.x, curPosition.y);
}

// 画消息头
-(void)drawHead {
}

// 模拟画消息文本
-(void)drawMainText {
}

// 模拟画图片
-(void)drawPicture {
}

// 模拟画底部文字
-(void)drawTail {
}

// 求取高度
-(CGFloat)getMsgViewFrameHeight {
	//CLog(@"%s", __FUNCTION__);
	curPosition = CGPointZero;	
	[self drawHead];
	[self drawMainText];
	[self drawPicture];
	[self drawTail];
	return curPosition.y;
}
@end
