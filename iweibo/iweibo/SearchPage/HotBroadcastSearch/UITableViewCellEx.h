//
//  UITableViewCellEx.h
//  iweibo
//
//  Created by Minwen Yi on 3/1/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageViewCellInfo.h"

@interface UITableViewCellEx : UITableViewCell {
	id				cellInfo;					// 保存当前行数据
	CGFloat			cellHeight;					// 整个cell高度(外部设置)
	id				controllerID;				// 控制器id
}

@property (nonatomic, assign) id				cellInfo;
@property (nonatomic, assign) CGFloat			cellHeight;
@property (nonatomic, assign) id				controllerID;
// 设置cell内容
- (void)configCell;
// 开始加载图片数据
- (void)startIconDownload;
@end
