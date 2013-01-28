//
//  SelectServer.m
//  iweibo
//
//  Created by Cui Zhibo on 12-5-7.
//  Copyright (c) 2012年 Beyondsoft. All rights reserved.
//

#import "SelectServer.h"
#import "Canstants.h"
#import "IWBSvrSettingsManager.h"

@implementation SelectServer

+ (NSString *)getServerInfoFromPlist{
	return [IWBSvrSettingsManager sharedSvrSettingManager].activeSite.descriptionInfo.svrUrl;
    NSLog(@"come in!!!");
    NSString *urlString = nil;
    NSString *serverPath = [[NSBundle mainBundle] pathForResource:@"ServerSettings" ofType:@"plist"];
    NSArray *serverArray = [NSArray arrayWithContentsOfFile:serverPath];
    NSDictionary *serverDic = [serverArray objectAtIndex:0];
    for(NSDictionary *serverDic in serverArray){
        
        NSLog(@"dic is %@",serverDic);
    } 
    NSString *activeServer = [NSString stringWithFormat:@"%@",[serverDic objectForKey:@"IsActive"]];
    NSLog(@"activeServer is %@", activeServer);
	if (YES) {
    //if ([activeServer integerValue] == 1) {
        urlString = @"http://dev.i.t.qq.com/index.php/mobile/";
    }else{
        urlString = @"http://t.oeeee.com/index.php/mobile/";
    }
    NSLog(@"urlString is %@",  urlString);
    return urlString;
}

@end
