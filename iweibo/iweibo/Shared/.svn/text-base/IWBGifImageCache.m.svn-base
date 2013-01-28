//
//  IWBGifImageCache.m
//  iweibo
//
//  Created by wangying on 4/18/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "IWBGifImageCache.h"
#import "IWBGifImageCompat.h"
#import <CommonCrypto/CommonDigest.h>

static NSInteger cacheMaxCacheAge = 60*60*24*7; // 1 week

static IWBGifImageCache *instance;

@implementation IWBGifImageCache

#pragma mark NSObject

- (id)init
{
    if ((self = [super init]))
    {
        // Init the memory cache
        memCache = [[NSMutableDictionary alloc] init];
		
        // Init the disk cache
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        diskCachePath = SDWIReturnRetained([[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"]);
		
        if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
		
        // Init the operation queue
        cacheInQueue = [[NSOperationQueue alloc] init];
        cacheInQueue.maxConcurrentOperationCount = 1;
        cacheOutQueue = [[NSOperationQueue alloc] init];
        cacheOutQueue.maxConcurrentOperationCount = 1;
		
#if TARGET_OS_IPHONE
        // Subscribe to app events
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
		
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanDisk)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
		
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0
        UIDevice *device = [UIDevice currentDevice];
        if ([device respondsToSelector:@selector(isMultitaskingSupported)] && device.multitaskingSupported)
        {
            // When in background, clean memory in order to have less chance to be killed
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(clearMemory)
                                                         name:UIApplicationDidEnterBackgroundNotification
                                                       object:nil];
        }
#endif
#endif
    }
	
    return self;
}

- (void)dealloc
{
    SDWISafeRelease(memCache);
    SDWISafeRelease(diskCachePath);
    SDWISafeRelease(cacheInQueue);
	
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	
    SDWISuperDealoc;
}

#pragma mark SDImageCache (class methods)

+ (IWBGifImageCache *)sharedImageCache
{
    if (instance == nil)
    {
        instance = [[IWBGifImageCache alloc] init];
    }
	
    return instance;
}

#pragma mark SDImageCache (private)

- (NSString *)cachePathForKey:(NSString *)key
{
    const char *str = [key UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
	
    return [diskCachePath stringByAppendingPathComponent:filename];
}

- (void)storeKeyWithDataToDisk:(NSArray *)keyAndData
{
    // Can't use defaultManager another thread
    NSFileManager *fileManager = [[NSFileManager alloc] init];
	
    NSString *key = [keyAndData objectAtIndex:0];
    NSData *data = [keyAndData count] > 1 ? [keyAndData objectAtIndex:1] : nil;
	
    if (data)
    {
        [fileManager createFileAtPath:[self cachePathForKey:key] contents:data attributes:nil];
    }
    else
    {
        // If no data representation given, convert the UIImage in JPEG and store it
        // This trick is more CPU/memory intensive and doesn't preserve alpha channel
        UIImage *image =(UIImage *) SDWIReturnRetained([self imageFromKey:key fromDisk:YES]); // be thread safe with no lock
        if (image)
        {
#if TARGET_OS_IPHONE
            [fileManager createFileAtPath:[self cachePathForKey:key] contents:UIImageJPEGRepresentation(image, (CGFloat)1.0) attributes:nil];
#else
            NSArray*  representations  = [image representations];
            NSData* jpegData = [NSBitmapImageRep representationOfImageRepsInArray: representations usingType: NSJPEGFileType properties:nil];
            [fileManager createFileAtPath:[self cachePathForKey:key] contents:jpegData attributes:nil];
#endif
            SDWIRelease(image);
        }
    }
	
    SDWIRelease(fileManager);
}

#pragma mark ImageCache

// 存储gif图片到cache中
- (void)storeImageData:(NSData *)data forKey:(NSString *)key toDisk:(BOOL)toDisk{
	if (!data) {
		return;
	}
	[memCache setObject:data forKey:key];
	if (toDisk) {
		
		NSArray *keyWithData = [NSArray arrayWithObjects:key,data,nil];
	
		NSInvocationOperation *operation = SDWIReturnAutoreleased([[NSInvocationOperation alloc] initWithTarget:self
																								   selector:@selector(storeKeyWithDataToDisk:)
																									 object:keyWithData]);
		[cacheInQueue addOperation:operation];
	}
}

// 从磁盘读出gif图片
- (NSData *)imageFromKey:(NSString *)key fromDisk:(BOOL)fromDisk{
	if (key == nil){
        return nil;
    }
	NSData *gifData = [memCache objectForKey:key];
	
	if (!gifData && fromDisk) {
		
		gifData = [NSData dataWithContentsOfFile:[self cachePathForKey:key]];
		if (gifData) {
			[memCache setObject:gifData forKey:key];
		}
	}
    return gifData;
}

// 磁盘中移除相应的图片
- (void)removeImageForKey:(NSString *)key
{
    if (key == nil)
    {
        return;
    }
	
    [memCache removeObjectForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:[self cachePathForKey:key] error:nil];
}

- (void)clearMemory
{
    [cacheInQueue cancelAllOperations]; 
    [memCache removeAllObjects];
}

- (void)clearDisk
{
    [cacheInQueue cancelAllOperations];
    [[NSFileManager defaultManager] removeItemAtPath:diskCachePath error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
}

- (void)cleanDisk
{
    NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-cacheMaxCacheAge];
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        if ([[[attrs fileModificationDate] laterDate:expirationDate] isEqualToDate:expirationDate])
        {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }
}

-(int)getSize
{
    int size = 0;
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
    }
    return size;
}

@end