//
//  CustomView.m
//  iweibo
//
//  Created by ZhaoLilong on 2/4/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "CommentView.h"
#import "TextExtract.h"
#import "DetailsPage.h"
#import "MessageFrameConsts.h"
#import "DetailPageConst.h"

@implementation CommentView

@synthesize comment;
@synthesize kWidth;
@synthesize fontSize;
@synthesize emoSize;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];// 初始化背景颜色
		self.fontSize = 16; // 默认字体大小
		self.emoSize = 20.0f;
		self.userInteractionEnabled = NO; // 屏蔽用户界面交互
    }
    return self;
}

- (void)draw:(NSString *)string withType:(NSUInteger)type{
	if (type == 0) {
		NSMutableDictionary *dic = [HomePage nickNameDictionary];
		NSString *userName = string;	
		if ([dic isKindOfClass:[NSDictionary class]]) {
			if ([userName hasPrefix:@"@"] && [userName length] > 1) {
				NSString *trueName = [userName substringFromIndex:[userName rangeOfString:@"@"].location+1];
				NSString *nickName = [dic objectForKey:trueName];
				if (nickName != nil && [nickName isKindOfClass:[NSString class]]) {
					string = nickName;
				}
				else {
					string = userName;
				}
			}
			else {
				string = userName;
			}
		}
		else {
			string = userName;
		}
	}
	
	// 替换字符串中的特殊字符
	if (type == 4) {
		string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
		string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
		string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
		string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
		string = [string stringByReplacingOccurrencesOfString:@"&39;" withString:@"\'"];
		string = [string stringByReplacingOccurrencesOfString:@"：" withString:@":"];
	}
	if (type==1){
		// 绘制相应的表情
		NSString *imageString = [emoDic valueForKey:string];
		UIImage *emotion = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageString]];
		UIImageView *emotionView = [[UIImageView alloc] init];
		emotionView.image = emotion;
		if (position.x > kWidth - emoSize) {
			position.y += emoSize;
			position.x = startPos;
		}
		CGFloat eWidth = emoSize;
		if (emoSize > emotion.size.width) {
			position.x += (emoSize - emotion.size.width) / 2.0f;
			eWidth = emotion.size.width;
		}
		if ([imageString isEqualToString:@"f63"]) {
			emotionView.frame = CGRectMake(position.x, position.y, eWidth, emotion.size.height);
		}else {
			CGFloat emoGap = 0.0f;
			if (emotion.size.height > EmotionImageWidth) {
				emoGap = emotion.size.height - EmotionImageWidth;
			}else {
				emoGap = EmotionImageWidth - emotion.size.height;
			}
			emotionView.frame = CGRectMake(position.x, position.y, eWidth, eWidth+emoGap);
		}
		[self addSubview:emotionView];	
		[emotionView release];
		position.x += emoSize;
	}else {
		//绘制其他文本类型
		if ((int)[string sizeWithFont:[UIFont systemFontOfSize:self.fontSize]].width <= kWidth - position.x) {// 如果文本宽度小于当前剩余宽度
			UILabel *strLabel = [[UILabel alloc] init];
			CGSize strSize = [string sizeWithFont:[UIFont systemFontOfSize:self.fontSize]];
			strLabel.text = string;
			strLabel.textColor = [UIColor colorStringToRGB:[NSString stringWithFormat:@"%d",OriginTextColor]];
			strLabel.backgroundColor = [UIColor clearColor];
			strLabel.frame =CGRectMake(position.x, position.y, strSize.width, strSize.height);
			strLabel.font = [UIFont systemFontOfSize:self.fontSize];
			[self addSubview:strLabel];
			[strLabel release];
			position.x += [string sizeWithFont:[UIFont systemFontOfSize:self.fontSize]].width;// 绘制完成后添加坐标偏移
			if (position.x == kWidth) {
				// 临界状态坐标偏移
				position.x = startPos;
				position.y += 20;
			}
		}else {//一行画不下
			// 为临时字符串分配存储大小
			NSMutableString *tmpString = [NSMutableString stringWithCapacity:30];
	
			// 初始化文本宽度
			CGFloat		lineWidth = 0;	
			for (int i = 0; i < [string length]; i++) {
				NSString *subString = [string substringWithRange:NSMakeRange(i, 1)];// 获取每个字符
				CGSize wordSize = [subString sizeWithFont:[UIFont systemFontOfSize:self.fontSize]];// 获取每个字符的大小
				if ((lineWidth + wordSize.width) > kWidth - position.x) {
					UILabel *strLabel = [[UILabel alloc] init];
					CGSize strSize = [tmpString sizeWithFont:[UIFont systemFontOfSize:self.fontSize]];
					strLabel.text = tmpString;
					strLabel.backgroundColor = [UIColor clearColor];
					strLabel.textColor = [UIColor colorStringToRGB:[NSString stringWithFormat:@"%d",OriginTextColor]];
					strLabel.frame =CGRectMake(position.x, position.y, strSize.width, strSize.height);
					strLabel.font = [UIFont systemFontOfSize:self.fontSize];
					[self addSubview:strLabel];
					[strLabel release];
					
					// 绘制完成后清空当前字符串
					[tmpString deleteCharactersInRange:NSMakeRange(0, [tmpString length])];
					
					// 绘制完成后将文本宽度置零
					lineWidth = 0;
								  
					// 添加坐标位置偏移
					position.x = startPos;
					position.y += wordSize.height;
				}
				lineWidth += wordSize.width;
				[tmpString appendString:subString];
			}	
			if ([tmpString length] > 0) {
				// 绘制剩余字符串
				UILabel *strLabel = [[UILabel alloc] init];
				CGSize strSize = [tmpString sizeWithFont:[UIFont systemFontOfSize:self.fontSize]];
				strLabel.text = tmpString;
				strLabel.backgroundColor = [UIColor clearColor];
				strLabel.textColor = [UIColor colorStringToRGB:[NSString stringWithFormat:@"%d",OriginTextColor]];
				strLabel.frame =CGRectMake(position.x, position.y, strSize.width, strSize.height);
				strLabel.font = [UIFont systemFontOfSize:self.fontSize];
				[self addSubview:strLabel];
				[strLabel release];
				
				// 绘制完成后添加偏移
				position.x += [tmpString sizeWithFont:[UIFont systemFontOfSize:self.fontSize]].width;
			}			
		}
	}	
		//CLog(@"-------%s", __FUNCTION__);
}

// 添加子视图
- (void)addSubViews{
	// 坐标初始化
	if (self.emoSize == 14.0f) {
		startPos = LISTENCELLSTARTPOS;
		position = CGPointMake(LISTENCELLSTARTPOS,5.0f);
	}else {
		startPos = 0.0f;
		position = CGPointZero;
	}
	for (UIView *_view in self.subviews) {
		if ([_view isMemberOfClass:[UIImageView class]]||[_view isMemberOfClass:[UILabel class]]) {
			[_view removeFromSuperview];
		}
	}
	// 创建文本解析器对象
	TextExtract *textExtract = [[TextExtract alloc] init];
	
	//获取表情字典
	emoDic = [HomePage emotionDictionary];
	if (![emoDic isKindOfClass:[NSDictionary class]]) {
		emoDic = [textExtract getEmoDictionary];
	}
	
	// 判断不为空
	if (nil != self.comment&&[self.comment length] > 0) {
		// 解析信息节点
		NSMutableArray *array = [textExtract getInfoNodeArray:self.comment];
		for (int i = 1; i < [array count]; ) {
			// 绘制每个信息节点
			[self draw:[array objectAtIndex:i-1] withType:[[array objectAtIndex:i] intValue]];
			i += 2;
		}	
	}
	[textExtract release];
}

// 评论赋值
- (void)setComment:(NSString *)comm{
	if (comm!= comment) {
		[comm retain];
		[comment release];
		comment = comm;
	}		
	[self addSubViews];	
	[self setNeedsDisplay];
}	

- (void)dealloc {
    [super dealloc];
}

@end
