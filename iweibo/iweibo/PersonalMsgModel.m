//
//  PersonalMsgModel.m
//  iweibo
//
//  Created by LiQiang on 12-2-3.
//  Copyright 2012年 Beyondsoft. All rights reserved.
//

#import "PersonalMsgModel.h"

@implementation PersonalMsgModel
@synthesize listenStatusInfo;
static PersonalMsgModel *personMsg = nil;
+ (PersonalMsgModel *)sharePersonMsg
{
    if (personMsg ==nil) {
        personMsg = [[PersonalMsgModel alloc] init];
        personMsg.listenStatusInfo =120;//无用的值
    }
    return personMsg;
}
- (NSMutableDictionary *)getCell0dic:(NSDictionary *)DataInfoDic
{
    NSMutableString *accountStr = [NSMutableString stringWithString:@"@"];
    NSString *strName = [DataInfoDic objectForKey:@"name"];
    if (nil == strName) {
        strName = @"";
    }
    [accountStr appendString:strName];
    NSNumber *accountStrWidth = [NSNumber numberWithInt:[self getStringWidth:accountStr]];
    NSMutableString *addressStr = [NSMutableString stringWithString:@"·"];
    NSString *strLocation = [DataInfoDic objectForKey:@"location"];
    if (nil == strLocation) {
        strLocation = @"";
    }
    [addressStr appendString:strLocation];
    NSNumber *addressStrWidth = [NSNumber numberWithInt:[self getStringWidth:addressStr]];
    NSString *personMsgStr = [DataInfoDic objectForKey:@"introduction"];
    if (nil == personMsgStr) {
        personMsgStr = @"";
    }
    [self cutString:[self replaceSpecialString:personMsgStr]];
    NSString *strVerifyInfo = [DataInfoDic objectForKey:@"verifyinfo"];
    if (nil == strVerifyInfo) {
        strVerifyInfo = @"";
    }
    NSString *verifyinfo = [self replaceSpecialString:strVerifyInfo];
    NSString *identifyStr;
    if ([verifyinfo length]>0) {
        identifyStr = verifyinfo;
    }else
    {
        NSString *strLocalauthText = [DataInfoDic objectForKey:@"localauthtext"];
        if (nil == strLocalauthText) {
            strLocalauthText = @"";
        }
         NSString *localauthtext = [self replaceSpecialString:strLocalauthText];
        identifyStr = localauthtext;
    }
    
    NSMutableString *sexInfo = [NSMutableString stringWithString:@"·"];
    if ([[DataInfoDic objectForKey:@"sex"] intValue]==1) {
        [sexInfo appendString:@"男"];
    }else if ([[DataInfoDic objectForKey:@"sex"] intValue]==0) {
		[sexInfo appendString:@"未知"];
	}else {
		[sexInfo appendString:@"女"];
	}

    int ismyidol = [[DataInfoDic objectForKey:@"ismyidol"] intValue];
    int ismyfans = [[DataInfoDic objectForKey:@"ismyfans"] intValue];
	// 存储本地认证和腾讯认证信息
	NSNumber *localVerify = [DataInfoDic objectForKey:@"is_auth"];
	NSNumber *tecentVerify = [DataInfoDic objectForKey:@"isvip"];
							 
    NSMutableString *idolAndListenInfo = [self getIdolStatus:ismyidol withIsMyFans:ismyfans];
    NSMutableDictionary *cell0Dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     accountStr,KACCOUNT,
                                     accountStrWidth,KACCOUNTWIDTH,
                                     sexInfo,KSEX,
                                     addressStr,KADDRESS,
                                     addressStrWidth,KADDRESSWIDTH,
                                     idolAndListenInfo,KLISTENSTATUS,
                                     personMsgPart1,KMSGPART1,
									 localVerify,KIDENTIFYLOCAL,
									 tecentVerify, KIDENTIFYTECENT,
                                     nil];
    int msgPart2Height = 0;
    if (personMsgPart2 != NULL) {
        [cell0Dic setObject:personMsgPart2 forKey:KMSGPART2];
        msgPart2Height = [self getHeightOfString:personMsgPart2 withWidth:KCONTENTW];
    }
    int cell0TotalHeight = CELL0H + msgPart2Height;
    int identfyHeight = 0;
    if ([identifyStr length]>0) {
        [cell0Dic setObject:identifyStr forKey:KIDENTIFY];
        identfyHeight = [self getHeightOfString:identifyStr withWidth:KCONTENTW];
        NSNumber *identifyLblY = [NSNumber numberWithInt:50+msgPart2Height];
        [cell0Dic setObject:identifyLblY forKey:KIDENTIFYLABLEPOSTIONY];
        cell0TotalHeight += 30 + identfyHeight;
    }
    NSNumber *cell0TotalH = [NSNumber numberWithInt:cell0TotalHeight];
    [cell0Dic setObject:cell0TotalH forKey:KCELL0OPENH];
    return cell0Dic;
}
- (NSDictionary *)getCell1dic:(NSDictionary *)DataInfoDic
{
    int  intfansnum = [[DataInfoDic objectForKey:@"fansnum"] intValue];
    NSString *fansnum = [NSString stringWithFormat:@"%d",intfansnum];
    NSNumber *fansW = [NSNumber numberWithInt:[self getStringWidth:fansnum withFont:[UIFont boldSystemFontOfSize:20]]];
    
    int intIdolnum = [[DataInfoDic objectForKey:@"idolnum"] intValue];
    NSString *idolnum = [NSString stringWithFormat:@"%d",intIdolnum];
    NSNumber *idolnumW = [NSNumber numberWithInt:[self getStringWidth:idolnum withFont:[UIFont boldSystemFontOfSize:20]]];
    
    int intTweetnum = [[DataInfoDic objectForKey:@"tweetnum"] intValue];
    NSString *tweetnum = [NSString stringWithFormat:@"%d",intTweetnum];;
    NSNumber *tweetnumW = [NSNumber numberWithInt:[self getStringWidth:tweetnum withFont:[UIFont boldSystemFontOfSize:20]]];
    CLog(@"广播的宽度%@",tweetnumW);
    NSDictionary *cell1Dic =[NSDictionary dictionaryWithObjectsAndKeys:
                             fansnum,KNUMLISTENER,
                             fansW,KWIDTHLISTENER,
                             @"1",KLISTENBTNENABLE,
                             idolnum,KNUMLISTENTO,
                             idolnumW,KWIDTHLISTENTO,
                             @"1",KLISTENTOBTNENABLE,
                             tweetnum,KNUMBROADCAST,
                             tweetnumW,KWIDTHBROADCAST,
                             nil];
    return cell1Dic;
}
- (NSMutableString *)getIdolStatus:(int)isMyIdol withIsMyFans:(int)isMyFans
{
   
    NSMutableString *combineStr = [NSMutableString stringWithCapacity:2];
    NSString *myidol = [NSString stringWithFormat:@"%d",isMyIdol];
    NSString *myfans = [NSString stringWithFormat:@"%d",isMyFans];
     [combineStr appendString:myidol];
    [combineStr appendString:myfans];
    int status = [combineStr intValue];
    NSMutableString *listenStatus;
    switch (status) {
        case 0:
            self.listenStatusInfo = 0;
            listenStatus = [NSMutableString stringWithString:@""];
            break;
        case 1:
            self.listenStatusInfo = 1;
            listenStatus = [NSMutableString stringWithString:@"(收听你)"];
            break;
        case 10:
            self.listenStatusInfo = 10;
            listenStatus = [NSMutableString stringWithString:@"(已收听)"];
            break;
        case 11:
            self.listenStatusInfo = 11;
            listenStatus = [NSMutableString stringWithString:@"(已互听)"] ;
            break;
        default:
            self.listenStatusInfo = 120;
            listenStatus = [NSMutableString stringWithString:@""];
            break;
    }
    return listenStatus;
}
- (NSMutableString *)listenStatusChange
{
    NSMutableString *listenStatus;
    switch (self.listenStatusInfo) {
        case 0://00
            self.listenStatusInfo = 10;
            listenStatus = [NSMutableString stringWithString:@"(已收听)"];
            break;
        case 1://01
            self.listenStatusInfo = 11;
            listenStatus = [NSMutableString stringWithString:@"(已互听)"];
            break;
        case 10:
            self.listenStatusInfo = 0;
            listenStatus = [NSMutableString stringWithString:@""];
            break;
        case 11:
            self.listenStatusInfo = 1;
            listenStatus = [NSMutableString stringWithString:@"(收听你)"] ;
            break;
        default:
            self.listenStatusInfo = 120;//无用的值
            listenStatus = [NSMutableString stringWithString:@""];
            break;
    }
    return listenStatus;

}
- (NSMutableArray *)getDataSourceMsg:(NSDictionary *)DataInfoDic
{
    if (DataInfoDic == NULL) {
        NSMutableDictionary *cellZeroDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         @"",KACCOUNT,
                                         @"",KACCOUNTWIDTH,
                                         @"",KSEX,
                                         @"",KADDRESS,
                                         @"",KADDRESSWIDTH,
                                         @"",KLISTENSTATUS,
                                         @"",KMSGPART1,
										 [NSNumber numberWithInt:0], KIDENTIFYLOCAL,
										 [NSNumber numberWithInt:0], KIDENTIFYTECENT,
                                         nil];
        NSDictionary *cellOneDic =[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"─",KNUMLISTENER,
                                 @"10",KWIDTHLISTENER,
                                 @"0",KLISTENBTNENABLE,
                                 @"─",KNUMLISTENTO,
                                 @"10",KWIDTHLISTENTO,
                                 @"0",KLISTENTOBTNENABLE,
                                 @"─",KNUMBROADCAST,
                                 @"10",KWIDTHBROADCAST,
                                 nil];
       personMsgArr = [NSMutableArray arrayWithObjects:cellZeroDic,cellOneDic,nil];
        CLog(@"默认数据%@",personMsgArr);
        return personMsgArr;
    }
    NSMutableDictionary *cell0Dic = [self getCell0dic:DataInfoDic];
    NSDictionary *cell1Dic = [self getCell1dic:DataInfoDic];
    personMsgArr = [NSMutableArray arrayWithObjects:cell0Dic,cell1Dic,nil];
    return personMsgArr;
}
- (int)getHeightOfString:(NSString *)string withWidth:(int)contentWidth
{
    NSUInteger kFontSize = 14;
    CGSize wordSize;
    //int lineCount = 0;
    int lineWidth = 0;
    int strHeight = 0;
    NSMutableString *tmpString = [NSMutableString stringWithCapacity:100];
    int wordHeight = [@"我" sizeWithFont:[UIFont systemFontOfSize:kFontSize]].height+5;
    CLog(@"单行高度是===%d",wordHeight);
    if ((int)[string sizeWithFont:[UIFont systemFontOfSize:kFontSize]].width <=contentWidth){
        strHeight = wordHeight; 
    }else {
        for (int i = 0; i < [string length]; i++) {
            NSString *subString = [string substringWithRange:NSMakeRange(i, 1)];
            wordSize = [subString sizeWithFont:[UIFont systemFontOfSize:kFontSize]];
            lineWidth += wordSize.width;
            if (lineWidth > contentWidth) {
                [tmpString deleteCharactersInRange:NSMakeRange(0, [tmpString length])];
                lineWidth = 0;
                strHeight += wordSize.height + 5;
                //lineCount += 1;		// 换行
            }
            [tmpString appendString:subString];
        }	
        if ([tmpString length] > 0) {
            //lineCount += 1;	
            strHeight+=wordHeight;
        }
    }
    return strHeight;
}
- (CGFloat)getStringWidth:(NSString *)string
{
    CLog(@"获取字符串宽度%@",string);
    CGSize stringSize = [string sizeWithFont:[UIFont systemFontOfSize:14]];
    return stringSize.width+5;
}
- (CGFloat)getStringWidth:(NSString *)string withFont:(UIFont *)font
{
    CGSize stringSize = [string sizeWithFont:font];
    return stringSize.width+5;
}
- (NSString *)replaceSpecialString:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&39;" withString:@"\'"];
    string = [string stringByReplacingOccurrencesOfString:@"：" withString:@":"];
    return string;
}
- (void)cutString:personMsg
{
    int personMsgPartWidth = 205;
    if ([self getStringWidth:personMsg]>personMsgPartWidth) {
        NSMutableString *tempString = [NSMutableString stringWithCapacity:100];
        CGSize wordSize;
        int lineWidth = 0;
        for (int i=0; i<[personMsg length];i++ ) {
            NSString *subString = [personMsg substringWithRange:NSMakeRange(i, 1)];
            wordSize = [subString sizeWithFont:[UIFont systemFontOfSize:14]];
            lineWidth += wordSize.width;
            [tempString appendString:subString];
            if (lineWidth>personMsgPartWidth) {
                personMsgPart1 = tempString;
                personMsgPart2 = [NSMutableString stringWithString:personMsg];
                [personMsgPart2 deleteCharactersInRange:NSMakeRange(0,[tempString length])];
                break;
            }
        }
    }else
    {
        personMsgPart1 = [NSMutableString stringWithCapacity:10];
        if ([personMsg length]==0) {
           [personMsgPart1 appendString:@"还没想好写什么"];
        }
        [personMsgPart1 appendString:personMsg];
        personMsgPart2 = NULL;
    }
}
- (void)dealloc
{
    [personMsg release];
    [super dealloc];
}
@end
