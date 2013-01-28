//
//  CellZeroView.h
//  iweibo
//
//  Created by LiQiang on 12-2-3.
//  Copyright 2012年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonalMsgViewController;

@interface CellZeroView : UIView {
    PersonalMsgViewController *parentController;
    NSDictionary *dataMsgDic;
    UILabel *accountLbl;
    UILabel *sexLbl;
    UILabel *addressLbl;
    UILabel *listenStatusLbl;
    int openStatus;
    UILabel *identifyLbl;
    int fisrtMark;
}
@property(nonatomic,assign) PersonalMsgViewController *parentController;
@property(nonatomic,retain) NSDictionary *dataMsgDic;
@property(nonatomic,retain) UILabel *accountLbl;
@property(nonatomic,retain) UILabel *sexLbl;
@property(nonatomic,retain) UILabel *addressLbl;
@property(nonatomic,retain) UILabel *listenStatusLbl;
@property(nonatomic,assign) int openStatus;
@property(nonatomic,assign) int fisrtMark;

- (id)constructFrame:(CGRect)frame;
- (void)drawRect:(CGRect)rect withStartPoint:(CGPoint)startPoint withEndPoint:(CGPoint)endPoint;
- (void)DrawGradientColor:(CGContextRef)context 
                     rect:(CGRect)clipRect  
                    point:(CGPoint) startPoint
                    point:(CGPoint) endPoint 
                  options:(CGGradientDrawingOptions) options 
               startColor:(UIColor*)startColor 
                 endColor:(UIColor*)endColor;
- (void)drawString:(NSString *)string withDrawPoint:(CGPoint)position withWidth:(int)contentWidth;
- (void)drawMsgAndIdentify;
@end
