//
//  PersonalMsgModel.h
//  iweibo
//
//  Created by LiQiang on 12-2-3.
//  Copyright 2012年 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PersonalMsgModel : NSObject {
    NSMutableArray *personMsgArr;
    NSMutableString *personMsgPart1;
    NSMutableString *personMsgPart2;
    int listenStatusInfo;
}
@property(nonatomic,assign) int listenStatusInfo;
+ (PersonalMsgModel *)sharePersonMsg;
- (void)cutString:personMsg;
- (NSMutableArray *)getDataSourceMsg:(NSDictionary *)DataInfoDic;
- (int)getHeightOfString:(NSString *)string withWidth:(int)contentWidth;
- (CGFloat)getStringWidth:(NSString *)string;
- (CGFloat)getStringWidth:(NSString *)string withFont:(UIFont *)font;
- (NSString *)replaceSpecialString:(NSString *)string;
- (NSMutableString *)getIdolStatus:(int)isMyIdol withIsMyFans:(int)isMyFans;
- (NSMutableString *)listenStatusChange;
@end
