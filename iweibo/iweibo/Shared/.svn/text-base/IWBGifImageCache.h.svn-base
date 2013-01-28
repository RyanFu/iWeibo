//
//  IWBGifImageCache.h
//  iweibo
//
//  Created by wangying on 4/18/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface IWBGifImageCache : NSObject{
    NSMutableDictionary *memCache;
    NSString *diskCachePath;
    NSOperationQueue *cacheInQueue, *cacheOutQueue;
}

+ (IWBGifImageCache *)sharedImageCache;

// 存储gif图片到cache中
- (void)storeImageData:(NSData *)data forKey:(NSString *)key toDisk:(BOOL)toDisk;

// 从磁盘读出gif图片
- (NSData *)imageFromKey:(NSString *)key fromDisk:(BOOL)fromDisk;

// 磁盘中移除相应的图片
- (void)removeImageForKey:(NSString *)key;
- (void)clearMemory;
- (void)clearDisk;
- (void)cleanDisk;
- (int)getSize;

@end