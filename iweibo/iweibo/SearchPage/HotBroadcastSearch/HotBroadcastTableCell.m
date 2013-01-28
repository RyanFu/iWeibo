//
//  HotBroadcastTableCell.m
//  iweibo
//
//  Created by Minwen Yi on 2/24/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "HotBroadcastTableCell.h"
#import "HotBroadcastInfo.h"

@implementation HotBroadcastTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		originView.showStyle = HotBroadcastShowStyle;
		sourceView.sourceStyle = HotBroadcastSourceStyle;
		self.rootContrlType = 3;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}

// 开始加载图片数据
- (void)startIconDownload {
	MessageViewCellInfo *messageViewCellInfo = (MessageViewCellInfo *)cellInfo;
	Info *infoItem = messageViewCellInfo.originInfo;
	//如果数据库没有，从网络请求
	NSData *data = nil;
	if (infoItem.headImageData == nil) {
		data = [HotBroadcastInfo myHotBroadCastHeadImageDataWithUrl:infoItem.head];
		if ([data length]>4) {
			infoItem.headImageData = data;
			[self appImageDidLoadWithData:infoItem.headImageData andType:ICON_HEAD];
		}
		else {
			[headImageDownloader startDownloadWithUrl:[NSString stringWithFormat:@"%@/100",infoItem.head] andType:ICON_HEAD];
		}	
	}
	else {
		[self appImageDidLoadWithData:infoItem.headImageData andType:ICON_HEAD];
	}

}

- (void)appImageDidLoadWithData:(NSData *)imgData andType:(IconType)iType {
	UIImage *img = nil;
	if (imgData == nil || [imgData length] < 10) {
		img = [UIImage imageNamed:@"compseLogo.png"];	 // 如果没图显示默认图片
	}
	else {
		img = [[[UIImage alloc] initWithData:imgData] autorelease];
	}
	if (img) {
		CGFloat iwidth = 0.0f;
		CGFloat iheight = 0.0f;
		switch (iType) {
			case ICON_HEAD: {
				iwidth = ICON_WIDTH;
				iheight = ICON_HEIGHT;
			}
				break;
			default:
				assert(NO);
				break;
		} 
		if (img.size.width != iwidth && img.size.height != iheight)
		{
			CGSize itemSize = CGSizeMake(iwidth, iheight);
			UIGraphicsBeginImageContext(itemSize);
			CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
			[img drawInRect:imageRect];
			iconView.image = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
		}
		else
		{
			iconView.image = img;
		}
		MessageViewCellInfo *messageViewCellInfo = (MessageViewCellInfo *)cellInfo;
		Info *infoItem = messageViewCellInfo.originInfo;
		infoItem.headImageData = imgData;
	}
	[iconView setNeedsLayout];
}

// 设置默认头像
- (void)initHead {
	MessageViewCellInfo *messageViewCellInfo = (MessageViewCellInfo *)cellInfo;
	Info *infoItem = messageViewCellInfo.originInfo;
	NSData *data = nil;
	if (infoItem.headImageData == nil) {
		data = [HotBroadcastInfo myHotBroadCastHeadImageDataWithUrl:infoItem.head];
		if ([data length]>4) {
			infoItem.headImageData = data;
		}
	}
	[self appImageDidLoadWithData:infoItem.headImageData andType:ICON_HEAD];
}

//- (void)updateHead {
//	MessageViewCellInfo *messageViewCellInfo = (MessageViewCellInfo *)cellInfo;
//	Info *infoItem = messageViewCellInfo.originInfo;
//	
//	[iconView removeFromSuperview];
//	[iconView release];
//	iconView = nil;
//	iconView = [[AsyncImageView alloc] init];     // 头像初始化
//	// 添加点击手势及圆角处理
//	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHead:)];
//	iconView.layer.masksToBounds = YES;
//	iconView.layer.cornerRadius = 3.0f;
//	iconView.tag = 001;
//	iconView.frame = CGRectMake(5, 7.5, ICON_WIDTH, ICON_HEIGHT);
//	[iconView addGestureRecognizer:tapGesture];
//	[tapGesture release];
//	[self.contentView addSubview:iconView];	
//		
//	//如果数据库没有，从网络请求
//	NSData *data = nil;
//	data = [HotBroadcastInfo myHotBroadCastHeadImageDataWithUrl:infoItem.head];
//	if ([data length]>4) {
//		[iconView addHeadImageFromData:nil];
//		[iconView addHeadImageFromData:data];
//	}
//	else {
//		[iconView addHeadImageFromData:nil];
//		[iconView loadImageFromURL:[NSString stringWithFormat:@"%@/100",infoItem.head] withType:multiMediaTypeHotBroadcastHead userId:infoItem.uid];
//	}
//}

#pragma mark protocol OriginViewUrlDelegate<NSObject> // 图片点击委托事件
- (void)OriginViewUrlClicked:(NSString *)urlSource {
	
}

#pragma mark protocol OriginViewVideoDelegate<NSObject> // 视频点击事件
- (void)OriginViewVideoClicked:(NSString *)urlVideo {
	HotBroadcastTableViewController *broadcastCtrller = (HotBroadcastTableViewController *)self.controllerID;
	[broadcastCtrller videoImageClicked:urlVideo];
}

#pragma mark protocol SourceViewVideoDelegate<NSObject> 视频点击事件
- (void)SourceViewVideoClicked:(NSString *)urlVideo {
	HotBroadcastTableViewController *broadcastCtrller = (HotBroadcastTableViewController *)self.controllerID;
	[broadcastCtrller videoImageClicked:urlVideo];
}
@end
