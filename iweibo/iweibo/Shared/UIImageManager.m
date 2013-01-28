//
//  UIImageManager.m
//  iweibo
//
//  Created by Minwen Yi on 4/13/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "UIImageManager.h"
#import "Info.h"
#import "TransInfo.h"
#import "MessageFrameConsts.h"
#import "DataManager.h"

static NSMutableDictionary *g_dicHeadImages = nil;
@implementation UIImageManager
@synthesize searchFromLocal;

- (id)initWithDelegate:(id)delegate {
	if (self = [super init]) {
		myUIIMageManagerDelegate = delegate;
		headImageDownloader = [[IconDownloader alloc] init];
		headImageDownloader.delegate = self;
		imageDownloader = [[IconDownloader alloc] init];
		imageDownloader.delegate = self;
		videoImageDownloader = [[IconDownloader alloc] init];
		videoImageDownloader.delegate = self;
		sourceImageDownloader = [[IconDownloader alloc] init];
		sourceImageDownloader.delegate = self;
		sourceVideoImageDownloader = [[IconDownloader alloc] init];
		sourceVideoImageDownloader.delegate = self;
		searchFromLocal = YES;
	}
	return self;
}

-(void)dealloc {
	[imageDownloader cancelDownload];
	[imageDownloader release];
	imageDownloader = nil;
	[videoImageDownloader cancelDownload];
	[videoImageDownloader release];
	videoImageDownloader = nil;
	[headImageDownloader cancelDownload];
	[headImageDownloader release];
	headImageDownloader = nil;
	[sourceVideoImageDownloader cancelDownload];
	[sourceVideoImageDownloader release];
	sourceVideoImageDownloader = nil;
	[sourceImageDownloader cancelDownload];
	[sourceImageDownloader release];
	sourceImageDownloader = nil;
	[super dealloc];
}
// 取消当前所有请求
- (void)cancelAllIconDownloading {
	// 尝试修正一个bug: 268
	imageDownloader.delegate = nil;
	videoImageDownloader.delegate = nil;
	headImageDownloader.delegate = nil;
	sourceVideoImageDownloader.delegate = nil;
	sourceImageDownloader.delegate = nil;
	[imageDownloader cancelDownload];
	[videoImageDownloader cancelDownload];
	[headImageDownloader cancelDownload];
	[sourceVideoImageDownloader cancelDownload];
	[sourceImageDownloader cancelDownload];
	imageDownloader.delegate = self;
	videoImageDownloader.delegate = self;
	headImageDownloader.delegate = self;
	sourceVideoImageDownloader.delegate = self;
	sourceImageDownloader.delegate = self;
}

// 派生类中，图片数据类型
//- (IconType)convertToBaseImageType:(IconType)iType {
//	return IconType;
//}

+(NSDictionary *)cachedHeadImages {
	if (nil == g_dicHeadImages) {
		g_dicHeadImages = [[NSMutableDictionary alloc] initWithCapacity:10];
	}
	return g_dicHeadImages;
}

// 获取默认图片
+ (UIImage *)defaultImage:(IconType)iType {
	UIImage *img = nil;
	switch (iType) {
		case ICON_HEAD: {
			img = [UIImage imageNamed:@"compseLogo.png"];
		}
			break;
		case ICON_SOURCE_IMAGE:
		case ICON_ORIGIN_IMAGE: {
			img = [UIImage imageNamed:@"imageDefault.png"];	 // 如果没图显示默认图片
		}
			break;
		case ICON_SOURCE_VIDEO_IMAGE:
		case ICON_ORIGIN_VIDEO_IMAGE: {
			img = [UIImage imageNamed:@"视频默认图片.png"];	 // 如果没图显示默认图片
		}
			break;
		default:
			break;
	}
	return img;
}

// 获取缓存图片
+ (UIImage *)cachedImage:(IconType)iType forUrl:(NSString *)strUrl {
	UIImage *img = nil;
	switch (iType) {
		case ICON_HEAD: {
			img = [[UIImageManager cachedHeadImages] objectForKey:[NSString stringWithFormat:@"%@/100",strUrl]];
		}
			break;
			//case ICON_ORIGIN_IMAGE: {
			//			strUrl = [NSString stringWithFormat:@"%@/%d",strUrl,TLUrlImageRequestSize];
			//			NSDictionary *dicParam = [[NSDictionary alloc] initWithObjectsAndKeys:strUrl, KEYURL, unType, KEYTYPE, strRequestID, KEYREQID, nil];
			//			[imageDownloader startDownloadWithParam:dicParam];
			//			[dicParam release];
			//		}
			//			break;
			//		case ICON_ORIGIN_VIDEO_IMAGE: {
			//			strUrl = [NSString stringWithFormat:@"%@/%d", strUrl, TLUrlImageRequestSize];
			//			NSDictionary *dicParam = [[NSDictionary alloc] initWithObjectsAndKeys:strUrl, KEYURL, unType, KEYTYPE, strRequestID, KEYREQID, nil];
			//			[videoImageDownloader startDownloadWithParam:dicParam];
			//			[dicParam release];
			//		}
			//			break;
			//		case ICON_SOURCE_IMAGE: {
			//			strUrl = [NSString stringWithFormat:@"%@/%d",strUrl, TLUrlImageRequestSize];
			//			NSDictionary *dicParam = [[NSDictionary alloc] initWithObjectsAndKeys:strUrl, KEYURL, unType, KEYTYPE, strRequestID, KEYREQID, nil];
			//			[sourceImageDownloader startDownloadWithParam:dicParam];
			//			[dicParam release];
			//		}
			//			break;
			//		case ICON_SOURCE_VIDEO_IMAGE: {
			//			NSDictionary *dicParam = [[NSDictionary alloc] initWithObjectsAndKeys:strUrl, KEYURL, unType, KEYTYPE, strRequestID, KEYREQID, nil];
			//			[sourceVideoImageDownloader startDownloadWithParam:dicParam];
			//			[dicParam release];
			//		}
			//			break;
		default:
			break;
	}			
	return img;
	
}

// 获取默认图片
+ (UIImage *)defaultImage:(IconType)iType forUrl:(NSString *)strUrl {
	UIImage *img = [UIImageManager cachedImage:iType forUrl:strUrl];
	if (nil == img) {
		img = [UIImageManager defaultImage:iType];
	}
	return img;
}

// 从网络加载图片数据
-(void)getImageFromWeb:(NSDictionary *)dic {
	NSNumber *unType = [dic objectForKey:KEYTYPE];
	IconType iType = [unType intValue];
	NSString *strRequestID = [dic objectForKey:KEYREQID];
	NSString *strUrl = [[[dic objectForKey:KEYURL] copy] autorelease];
	switch (iType) {
		case ICON_HEAD: {
			strUrl = [NSString stringWithFormat:@"%@/100",strUrl];
			NSDictionary *dicParam = [[NSDictionary alloc] initWithObjectsAndKeys:strUrl, KEYURL, unType, KEYTYPE, strRequestID, KEYREQID, nil];
			[headImageDownloader startDownloadWithParam:dicParam];
			[dicParam release];
		}
			break;
		case ICON_ORIGIN_IMAGE: {
			strUrl = [NSString stringWithFormat:@"%@/%d",strUrl,TLUrlImageRequestSize];
			NSDictionary *dicParam = [[NSDictionary alloc] initWithObjectsAndKeys:strUrl, KEYURL, unType, KEYTYPE, strRequestID, KEYREQID, nil];
			[imageDownloader startDownloadWithParam:dicParam];
			[dicParam release];
		}
			break;
		case ICON_ORIGIN_VIDEO_IMAGE: {
			NSDictionary *dicParam = [[NSDictionary alloc] initWithObjectsAndKeys:strUrl, KEYURL, unType, KEYTYPE, strRequestID, KEYREQID, nil];
			[videoImageDownloader startDownloadWithParam:dicParam];
			[dicParam release];
		}
			break;
		case ICON_SOURCE_IMAGE: {
			strUrl = [NSString stringWithFormat:@"%@/%d",strUrl, TLUrlImageRequestSize];
			NSDictionary *dicParam = [[NSDictionary alloc] initWithObjectsAndKeys:strUrl, KEYURL, unType, KEYTYPE, strRequestID, KEYREQID, nil];
			[sourceImageDownloader startDownloadWithParam:dicParam];
			[dicParam release];
		}
			break;
		case ICON_SOURCE_VIDEO_IMAGE: {
			NSDictionary *dicParam = [[NSDictionary alloc] initWithObjectsAndKeys:strUrl, KEYURL, unType, KEYTYPE, strRequestID, KEYREQID, nil];
			[sourceVideoImageDownloader startDownloadWithParam:dicParam];
			[dicParam release];
		}
			break;
		default:
			break;
	}
	//[strUrl release];
}
	
// 从本地加载图片数据
-(UIImage *)getImageFromDB:(NSString *)strUrl WithType:(IconType)iType{
    if (nil == strUrl || [strUrl length] == 0) {
        return nil;
    }
	UIImage *img = nil;
	NSData *imgData = nil;
	BOOL bFoundCachedImg = NO;
	switch (iType) {
		case ICON_HEAD: {
			img = [[UIImageManager cachedHeadImages] objectForKey:[NSString stringWithFormat:@"%@/100",strUrl]];
			if (nil != img) {
				bFoundCachedImg = YES;
			}
			else {
               imgData = [DataManager getCachedImageFromDB:strUrl withType:IMAGE_SMALL];
			}
		}
			break;
		case ICON_ORIGIN_IMAGE: 
		case ICON_ORIGIN_VIDEO_IMAGE: 
		case ICON_SOURCE_IMAGE: 
		case ICON_SOURCE_VIDEO_IMAGE: {
            imgData = [DataManager getCachedImageFromDB:strUrl withType:IMAGE_ORIGIN];
		}
			break;
//		case ICON_HEAD: {
//			img = [[UIImageManager cachedHeadImages] objectForKey:[NSString stringWithFormat:@"%@/100",strUrl]];
//			if (nil != img) {
//				bFoundCachedImg = YES;
//			}
//			else {
//				imgData = [Info myHeadImageDataWithUrl:strUrl];
//			}
//		}
//			break;
//		case ICON_ORIGIN_IMAGE: {
//			imgData = [Info myImageDataWithUrl:strUrl];
//		}
//			break;
//		case ICON_ORIGIN_VIDEO_IMAGE: {
//			imgData = [Info myVideoDataWithUrl:strUrl];
//		}
//			break;
//		case ICON_SOURCE_IMAGE: {
//			imgData = [TransInfo mySourceImageDataWithUrl:strUrl];
//		}
//			break;
//		case ICON_SOURCE_VIDEO_IMAGE: {
//			imgData = [TransInfo mySourceVideoDataWithUrl:strUrl];
//		}
//			break;
		default:
			break;
	}
	if (!bFoundCachedImg && imgData && [imgData length] > 0) {
		img = [UIImage imageWithData:imgData];
	}
		
	return img;
}

// 缓存图片到数据库
-(void)saveImageToDB:(NSData *)imgData WithBaseInfo:(NSDictionary *)param {
	NSNumber *unType = [param objectForKey:KEYTYPE];
	IconType iType = [unType intValue];
	NSString *strRequestID = [param objectForKey:KEYREQID];
    NSString *StrWithSize = [param objectForKey:KEYURL];
    NSRange rg = {0};
    rg.location = [StrWithSize length] - 4;  //   '/100'
    rg.length = 4;
    NSString *strUrl = [StrWithSize stringByReplacingCharactersInRange:rg withString:@""];
	//CLog(@"%s, param=%@", __FUNCTION__, param);
	if (imgData == nil || strRequestID == nil || [strRequestID isEqualToString:@""]) {
		return;
	}
	switch (iType) {
		case ICON_HEAD: {
            [DataManager insertCachedImageToDB:strUrl withData:imgData andType:IMAGE_SMALL];
		}
			break;
		case ICON_ORIGIN_IMAGE: 
		case ICON_ORIGIN_VIDEO_IMAGE: 
		case ICON_SOURCE_IMAGE: 
		case ICON_SOURCE_VIDEO_IMAGE: {
            [DataManager insertCachedImageToDB:strUrl withData:imgData andType:IMAGE_ORIGIN];
		}
			break;
//		case ICON_HEAD: {
//			[Info updateHeadData:imgData withUrl:strRequestID];
//		}
//			break;
//		case ICON_ORIGIN_IMAGE: {
//			[Info updateImageData:imgData withUrl:strRequestID];
//		}
//			break;
//		case ICON_ORIGIN_VIDEO_IMAGE: {
//			[Info updateVideoData:imgData withUrl:strRequestID];
//		}
//			break;
//		case ICON_SOURCE_IMAGE: {
//			[TransInfo updateSourceImageData:imgData withUrl:strRequestID];
//		}
//			break;
//		case ICON_SOURCE_VIDEO_IMAGE: {
//			[TransInfo updateSourceVideoData:imgData withUrl:strRequestID];
//		}
//			break;
		default:
			break;
	}
}

- (void)getImageWithParam:(NSDictionary *)param {
	//CLog(@"%s, param:%@", __FUNCTION__, param);
	// 扩充: 查找本地UIImage缓存库是否有对应图片数据(未完成)
	// 从数据库中查找是否有图片资源
	NSNumber *unType = [param objectForKey:KEYTYPE];
	NSString *strUrl = [param objectForKey:KEYURL];
	IconType iType = [unType intValue];
	if (!searchFromLocal) {
		[self getImageFromWeb:param];
		return;
	}
	UIImage *img = [self getImageFromDB:strUrl WithType:iType];
	if (nil == img) {
		[self getImageFromWeb:param];
	}
	else {
		switch (iType) {
			case ICON_HEAD: {
				[g_dicHeadImages setObject:img forKey:[NSString stringWithFormat:@"%@/100",strUrl]];
			}
				break;
			default:
				break;
		}
		if ([myUIIMageManagerDelegate respondsToSelector:@selector(UIImageManagerDoneLoading:WithType:)]) {
			[myUIIMageManagerDelegate UIImageManagerDoneLoading:img WithType:iType];
		}
	}
}
						 
// 根据url获取图像
- (void)startGettingImageWithParam:(NSDictionary *)param {
	//CLog(@"%s, param:%@", __FUNCTION__, param);
	// 启动图片加载
	[self performSelector:@selector(getImageWithParam:) withObject:param afterDelay:0.01f];
}

- (void)startGettingImageWithUrl:(NSString *)strUrl requestID:(NSString *)rID andType:(IconType)iType {
	//CLog(@"%s, rID:%@", __FUNCTION__, rID);
	NSNumber *unType = [[NSNumber alloc] initWithInt:iType];
	NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:strUrl, KEYURL, unType, KEYTYPE, rID, KEYREQID, nil];
	[unType release];
	[self startGettingImageWithParam:dic];
	[dic release];
}

#pragma mark protocol IconDownloaderDelegate 
- (void)appImageDidLoadWithData:(NSData *)imgData andBaseInfo:(NSDictionary *)param {
	// 发送到接收对象
	UIImage *img = [UIImage imageWithData:imgData];
	if (nil == img) {
		// 2012-5-02 取消下载时，图片数据会有问题，直接返回
		return;
	}
	// 缓存数据到数据库
	if (param || searchFromLocal) {
		[self saveImageToDB:imgData WithBaseInfo:param];
	}
	NSNumber *unType = [param objectForKey:KEYTYPE];
	IconType iType = [unType intValue];
	
	switch (iType) {
		case ICON_HEAD: {
			[g_dicHeadImages setObject:img forKey:[param objectForKey:KEYURL]];
		}
			break;
		default:
			break;
	}
	if ([myUIIMageManagerDelegate respondsToSelector:@selector(UIImageManagerDoneLoading:WithType:)]) {
		[myUIIMageManagerDelegate UIImageManagerDoneLoading:img WithType:iType];
	}
	if ([myUIIMageManagerDelegate respondsToSelector:@selector(UIImageManagerDoneLoadingWithData:andType:)]) {
		[myUIIMageManagerDelegate UIImageManagerDoneLoadingWithData:imgData andType:iType];
	}
}
@end
