//
//  HpThemeManager.h
//  iweibo
//
//  Created by wangying on 6/7/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//	实现换肤的功能

#import <Foundation/Foundation.h>

#define		THEMESKIN_SETTINGS_FILE_NAME	@"ThemeManager.plist"

@interface HpThemeManager : NSObject {
	NSDictionary *themeDictionary;
	NSString *currentTheme;
}

@property(nonatomic,retain) NSDictionary *themeDictionary;
@property(nonatomic,copy) NSString *currentTheme;

+(HpThemeManager *)sharedThemeManager;
// 拷贝plist到cach目录
-(BOOL)copyDefaultThemeSettingsFileToCachedDir;
@end
