//
//  CellZeroView.m
//  iweibo
//
//  Created by LiQiang on 12-2-3.
//  Copyright 2012年 Beyondsoft. All rights reserved.
//

#import "CellZeroView.h"

@implementation CellZeroView
@synthesize parentController,dataMsgDic,accountLbl,sexLbl,addressLbl,listenStatusLbl,openStatus,fisrtMark;
- (id)constructFrame:(CGRect)frame
{
    CLog(@"构造主体");
    self = [super initWithFrame:frame];
    if (self) {
       int accountLblWidth = [[self.dataMsgDic objectForKey:KACCOUNTWIDTH] intValue];
       accountLblWidth = accountLblWidth>150?150:accountLblWidth;
        accountLbl = [[UILabel alloc] initWithFrame:CGRectMake(13,5,accountLblWidth,20)];
        accountLbl.backgroundColor = [UIColor clearColor];
        accountLbl.text = [self.dataMsgDic objectForKey:KACCOUNT];
        accountLbl.font = [UIFont systemFontOfSize:14];
        [self addSubview:accountLbl];

		// 记录性别标签的宽度，将性别标签的宽度随着上面文字数量的变化而变化
		CGFloat width = [[self.dataMsgDic objectForKey:KSEX] sizeWithFont:[UIFont systemFontOfSize:14]].width;
		
        sexLbl = [[UILabel alloc] initWithFrame:CGRectMake(13+accountLblWidth,5,width,20)];
        sexLbl.backgroundColor = [UIColor clearColor];
        sexLbl.text = [self.dataMsgDic objectForKey:KSEX];
		sexLbl.adjustsFontSizeToFitWidth = YES;
        sexLbl.font = [UIFont systemFontOfSize:14];
        [self addSubview:sexLbl];
        int listenStatusLblPostionX = 13+accountLblWidth+width;//收听状态X坐标
        Boolean addressExist = [[self.dataMsgDic allKeys] containsObject:KADDRESS];
        //Boolean identifyExist =  [[self.dataMsgDic allKeys] containsObject:KIDENTIFY];
		BOOL tecentIdenfifyExist = [[self.dataMsgDic objectForKey:KIDENTIFYTECENT] intValue];
		BOOL localIdentifyExist = [[self.dataMsgDic objectForKey:KIDENTIFYLOCAL] intValue];
        int addressLblWidth = 0;
        if (addressExist) {
            addressLblWidth = [[self.dataMsgDic objectForKey:KADDRESSWIDTH] intValue];
			NSString *strListen = [self.dataMsgDic objectForKey:KLISTENSTATUS];
			int nTempLength = 0;
			// 认证图标宽度
			if (tecentIdenfifyExist || localIdentifyExist) {
				nTempLength += 16;
			}
			// 收听宽度
			if (strListen && [strListen length] > 0) {
				nTempLength += 55;
			}
			addressLblWidth = 13+accountLblWidth+width + addressLblWidth + nTempLength > 319 ? 319 - (13+accountLblWidth+width + nTempLength):addressLblWidth;
			addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(13+accountLblWidth+width,5,addressLblWidth,20)];
            addressLbl.backgroundColor = [UIColor clearColor];
            addressLbl.text = [self.dataMsgDic objectForKey:KADDRESS];
            addressLbl.font = [UIFont systemFontOfSize:14];
            [self addSubview:addressLbl];
            listenStatusLblPostionX += addressLblWidth;
        }
		
        if (tecentIdenfifyExist || localIdentifyExist) {
            UIImageView *identifyMark = nil;
			if (tecentIdenfifyExist) {
				identifyMark = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vip-btn.png"]] autorelease];
			}else {
				identifyMark = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"localVip.png"]] autorelease];
			}

			
            if(addressExist)
            {
                identifyMark.frame = CGRectMake(13+accountLblWidth+width+addressLblWidth, 7, 16, 16);
            }else
            {
                identifyMark.frame = CGRectMake(13+accountLblWidth+width, 7, 16, 16);
            }
            [self addSubview:identifyMark];
            listenStatusLblPostionX += 16;
        }
        
        listenStatusLbl = [[UILabel alloc] initWithFrame:CGRectMake(listenStatusLblPostionX,5,55,20)];
        listenStatusLbl.backgroundColor = [UIColor clearColor];
        listenStatusLbl.text = [self.dataMsgDic objectForKey:KLISTENSTATUS];
        listenStatusLbl.font = [UIFont systemFontOfSize:14];
        [self addSubview:listenStatusLbl];
        
        UILabel *ziliaoLbl = [[UILabel alloc] initWithFrame:CGRectMake(13,30,65,20)];
        ziliaoLbl.backgroundColor = [UIColor clearColor];
        ziliaoLbl.text = @"个人资料";
        ziliaoLbl.font = [UIFont boldSystemFontOfSize:14];
        ziliaoLbl.textColor = [UIColor colorWithRed:97.0f/255.0f green:155.0f/255.0f blue:181.0f/255.0f alpha:1.0];
        [self addSubview:ziliaoLbl];
        [ziliaoLbl release];
        
        UILabel *personMsgPart1Lbl = [[UILabel alloc] initWithFrame:CGRectMake(78, 30, 220, 20)];
        personMsgPart1Lbl.backgroundColor = [UIColor clearColor];
        personMsgPart1Lbl.text = [self.dataMsgDic objectForKey:KMSGPART1];
        personMsgPart1Lbl.font = [UIFont systemFontOfSize:14];
        [self addSubview:personMsgPart1Lbl];
        [personMsgPart1Lbl release];
    }
    return self;
}

- (void)moreMsgBtnAction
{
    if ([parentController respondsToSelector:@selector(moreMsgBtn)]) {
        [parentController performSelector:@selector(moreMsgBtn)];
    }
}
- (void)drawMsgAndIdentify
{
    CLog(@"画文字");
    if([[self.dataMsgDic allKeys] containsObject:KMSGPART2])
    {
        NSString *msgPart2 = [self.dataMsgDic objectForKey:KMSGPART2];
        [self drawString:msgPart2 withDrawPoint:CGPointMake(13, 55) withWidth:KCONTENTW];
    }
	
	BOOL tecentIdenfifyExist = [[self.dataMsgDic objectForKey:KIDENTIFYTECENT] intValue];
	BOOL localIdentifyExist = [[self.dataMsgDic objectForKey:KIDENTIFYLOCAL] intValue];
	
	
    //if ([[self.dataMsgDic allKeys] containsObject:KIDENTIFY]) {
	if (tecentIdenfifyExist || localIdentifyExist) {
        int identifyLblY = [[self.dataMsgDic objectForKey:KIDENTIFYLABLEPOSTIONY] intValue];
		// 区分腾讯认证和本地认证
        UIImageView *identifyMark = nil;
		if (tecentIdenfifyExist) {
			identifyMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip-btn.png"]];
		}else {
			identifyMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"localVip.png"]];
		}

		
        identifyMark.frame = CGRectMake(13,identifyLblY+7, 16, 16);
        [self addSubview:identifyMark];
        [identifyMark release];
        if (identifyLbl == NULL) {
            identifyLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, identifyLblY+6, 150, 20)];
            identifyLbl.backgroundColor = [UIColor clearColor];
           // identifyLbl.text = @"腾讯认证资料";
			// 区分腾讯认证和本地认证
			if (tecentIdenfifyExist) {
				identifyLbl.text = @"腾讯认证资料";
			}else {
				identifyLbl.text = @"本地认证资料";
			}
			
            identifyLbl.font = [UIFont boldSystemFontOfSize:14];
            identifyLbl.textColor = [UIColor colorWithRed:97.0f/255.0f green:155.0f/255.0f blue:181.0f/255.0f alpha:1.0];
            [self addSubview:identifyLbl];
            [identifyLbl release];
        }
        NSString *identify = [self.dataMsgDic objectForKey:KIDENTIFY];
        int identifyPosY = identifyLblY+30;
        [self drawString:identify withDrawPoint:CGPointMake(13, identifyPosY) withWidth:KCONTENTW];
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{ 
    CLog(@"调用绘图CELL0");
    int totalH = [[self.dataMsgDic objectForKey:KCELL0OPENH] intValue];
    CLog(@"这时的打开状态%d",self.openStatus);

//    self.frame = CGRectMake(0, 0, 320, totalH);
//    [self drawRect:rect withStartPoint:CGPointMake(0, 0) withEndPoint:CGPointMake(0, totalH)];
//    [self drawMsgAndIdentify];   
    if (self.fisrtMark == 1) {
        CLog(@"画上部");
        [self drawRect:rect withStartPoint:CGPointMake(0, 0) withEndPoint:CGPointMake(0, CELL0H)];
    }else
    {
        CLog(@"画全部");
        self.frame = CGRectMake(0, 0, 320, totalH);
        [self drawRect:rect withStartPoint:CGPointMake(0, 0) withEndPoint:CGPointMake(0, totalH)];
        [self drawMsgAndIdentify];
    }
    self.fisrtMark = 110;
}
- (void)drawRect:(CGRect)rect withStartPoint:(CGPoint)startPoint withEndPoint:(CGPoint)endPoint
{
    UIColor* startColor = [UIColor colorWithRed:251.0f/255.0f green:252.0f/255.0f blue:252.0f/255.0f alpha:1.0];
    UIColor* endColor = [UIColor colorWithRed:237.0f/255.0f green:241.0f/255.0f blue:243.0f/255.0f alpha:1.0];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextClipToRect(context,rect);
    [self DrawGradientColor:context rect:rect point:startPoint point:endPoint options:(CGGradientDrawingOptions) NULL startColor:startColor endColor:endColor];
    CGContextRestoreGState(context);
}
/**
 
 画图形渐进色方法，此方法只支持双色值渐变
 @param context     图形上下文的CGContextRef
 @param clipRect    需要画颜色的rect
 @param startPoint  画颜色的起始点坐标
 @param endPoint    画颜色的结束点坐标
 @param options     CGGradientDrawingOptions
 @param startColor  开始的颜色值
 @param endColor    结束的颜色值
 */
- (void)DrawGradientColor:(CGContextRef)context 
                     rect:(CGRect)clipRect  
                    point:(CGPoint) startPoint
                    point:(CGPoint) endPoint 
                  options:(CGGradientDrawingOptions) options 
               startColor:(UIColor*)startColor 
                 endColor:(UIColor*)endColor 

{
    UIColor* colors [2] = {startColor,endColor};
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colorComponents[8];  
    for (int i = 0; i < 2; i++) {  
        UIColor *color = colors[i];  
        CGColorRef temcolorRef = color.CGColor;
        const CGFloat *components = CGColorGetComponents(temcolorRef);  
        for (int j = 0; j < 4; j++) {  
            colorComponents[i * 4 + j] = components[j];  
        }         
    }
    CGGradientRef gradient =  CGGradientCreateWithColorComponents(rgb, colorComponents, NULL, 2);  
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, options);
    CGGradientRelease(gradient);
    
}
- (void)drawString:(NSString *)string withDrawPoint:(CGPoint)position withWidth:(int)contentWidth
{
    NSUInteger kFontSize = 14;
    CGSize wordSize;
   // int lineCount = 0;
    int lineWidth = 0;
    //  int strHeight = 0;
    NSMutableString *tmpString = [NSMutableString stringWithCapacity:100];
    int wordHeight = [@"我" sizeWithFont:[UIFont systemFontOfSize:kFontSize]].height+5;
    CLog(@"单行高度是===%d",wordHeight);
    if ((int)[string sizeWithFont:[UIFont systemFontOfSize:kFontSize]].width <=contentWidth){
        [string drawAtPoint:CGPointMake(position.x, position.y) withFont:[UIFont systemFontOfSize:kFontSize]];
    }else {
        for (int i = 0; i < [string length]; i++) {
            NSString *subString = [string substringWithRange:NSMakeRange(i, 1)];
            wordSize = [subString sizeWithFont:[UIFont systemFontOfSize:kFontSize]];
            lineWidth += wordSize.width;
            if (lineWidth > contentWidth) {
                [tmpString drawAtPoint:CGPointMake(position.x, position.y) withFont:[UIFont systemFontOfSize:kFontSize]];
                [tmpString deleteCharactersInRange:NSMakeRange(0, [tmpString length])];
                lineWidth = 0;
                // strHeight += wordHeight;
                position.y+= wordHeight;
               // lineCount += 1;		// 换行
            }
            [tmpString appendString:subString];
        }	
        if ([tmpString length] > 0) {
       //     lineCount += 1;	
            [tmpString drawAtPoint:CGPointMake(position.x, position.y) withFont:[UIFont systemFontOfSize:kFontSize]];
            // strHeight+=wordHeight;
        }
    }
    
}

- (void)dealloc
{
    [accountLbl release];
    [sexLbl release];
    [addressLbl release];
    [listenStatusLbl release];
    [super dealloc];
}

@end
