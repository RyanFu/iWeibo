//
//  FriendSearchTableViewCell.h
//  iweibo
//
//  Created by Yi Minwen on 7/2/12.
//  Copyright (c) 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendSearchImageManager.h"
#import "IconDownloader.h"

@interface FriendSearchTableViewCell : UITableViewCell<IconDownloaderDelegate> {
	IconDownloader                  *headImageDownloader;   // 头像下载对象
	IconStatus                      enumHeadStatus;         // 头像加载状态
    UIImageView                     *bgView;                // 头像背景视图
    UIView                          *headImageViewBg;             // 头像背景
    UIImageView                     *headImageView;             // 头像
    UIImageView                     *vipImageView;          // vip标示
    UILabel                         *lbNick;                  // 昵称
    UILabel                         *lbName;                // 名称
    UILabel                         *lbIndexLast;           // 去网络搜索
    UILabel                         *lbIndexFirst;          // 首行
    NSString                        *strUrlHead;
    
    
}
@property (nonatomic, retain) IconDownloader                    *headImageDownloader;
@property (nonatomic, retain) UIImageView                       *bgView;
@property (nonatomic, retain) UIView                            *headImageViewBg;
@property (nonatomic, retain) UIImageView                       *headImageView;
@property (nonatomic, retain) UIImageView                       *vipImageView;  
@property (nonatomic, copy)  NSString                           *strUrlHead;
@property (nonatomic, retain) UILabel                           *lbNick;
@property (nonatomic, retain) UILabel                           *lbName;
@property (nonatomic, retain) UILabel                           *lbIndexLast;
@property (nonatomic, retain) UILabel                           *lbIndexFirst;


// 开始下载图片资源
- (void)startIconDownload;
// 是否为vip
- (void)setIsVip:(BOOL)bIsVip;
@end
