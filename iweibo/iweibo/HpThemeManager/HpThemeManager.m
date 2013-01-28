//
//  HpThemeManager.m
//  iweibo
//
//  Created by wangying on 6/7/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "HpThemeManager.h"

@implementation HpThemeManager
@synthesize currentTheme,themeDictionary;

-(id)init{
	self = [super init];
	if(self){
		[self copyDefaultThemeSettingsFileToCachedDir];
		self.currentTheme = @"TimelineImage"; 
	}
	return self;
}

// 拷贝plist到cach目录
-(BOOL)copyDefaultThemeSettingsFileToCachedDir {
	BOOL bResult = NO;
	NSString *srcPath = [[NSBundle mainBundle] pathForResource:@"ThemeManager" ofType:@"plist"];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *destPlistPath = [[paths objectAtIndex:0] stringByAppendingPathComponent: THEMESKIN_SETTINGS_FILE_NAME];
	NSFileManager *manager = [NSFileManager defaultManager];
	BOOL find = [manager fileExistsAtPath:destPlistPath];
	if (!find) { 
		NSError *error;
		bResult = [manager copyItemAtPath:srcPath toPath:destPlistPath error:&error];
		if (!bResult) {
			CLog(@"Failed to copy files '%@'.", [error localizedDescription]);
		}
	}
	return bResult;
}

+(HpThemeManager*)sharedThemeManager{   
	static HpThemeManager *instance = nil;
	if (!instance) 
	{
		instance = [[HpThemeManager alloc] init];
	}
	return instance;
}

- (void)dealloc{
	[currentTheme release];
	[themeDictionary release];
	[super dealloc];
}

@end
