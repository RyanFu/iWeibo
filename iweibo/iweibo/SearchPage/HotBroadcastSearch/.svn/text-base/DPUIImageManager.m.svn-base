//
//  DPUIImageManager.m
//  iweibo
//
//  Created by Minwen Yi on 5/7/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "DPUIImageManager.h"
#import "MessageFrameConsts.h"

@implementation DPUIImageManager
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
			strUrl = [NSString stringWithFormat:@"%@/%d",strUrl,DPUrlImageRequestSize];
			NSDictionary *dicParam = [[NSDictionary alloc] initWithObjectsAndKeys:strUrl, KEYURL, unType, KEYTYPE, strRequestID, KEYREQID, nil];
			[imageDownloader startDownloadWithParam:dicParam];
			[dicParam release];
		}
			break;
		case ICON_ORIGIN_VIDEO_IMAGE: {
			//strUrl = [NSString stringWithFormat:@"%@/%d", strUrl, DPUrlImageRequestSize];
			NSDictionary *dicParam = [[NSDictionary alloc] initWithObjectsAndKeys:strUrl, KEYURL, unType, KEYTYPE, strRequestID, KEYREQID, nil];
			[videoImageDownloader startDownloadWithParam:dicParam];
			[dicParam release];
		}
			break;
		case ICON_SOURCE_IMAGE: {
			strUrl = [NSString stringWithFormat:@"%@/%d",strUrl, DPUrlImageRequestSize];
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

@end
