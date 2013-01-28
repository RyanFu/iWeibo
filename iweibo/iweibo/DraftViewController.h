//
//  DraftViewController.h
//  iweibo
//
//  Created by zhaoguohui on 12-3-6.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
//http://wenku.baidu.com/view/aa4a578071fe910ef12df820.html?from=rec&pos=0&weight=11&lastweight=5&count=5
@class DataManager;
@interface DraftViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	UITableView *draftBox;
	NSMutableArray *draftData;
	UIButton *editBtn;		// 2012-03-23 By Yi Minwen: 编辑按钮
    UIButton *backBtn;
}

@property (nonatomic, retain) UITableView *draftBox;

@end


@interface CustomDraftCell : UITableViewCell {
	UILabel *typeLabel;
	UILabel *textLabels;
	UILabel *timeLabel;
	UILabel *nameLabel;
	UILabel *forwardLabel;
	UIImageView *picFlag;
}

@property (nonatomic, retain) UILabel *typeLabel;
@property (nonatomic, retain) UILabel *textLabels;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *forwardLabel;
@property (nonatomic, retain) UIImageView *picFlag;
@property (nonatomic, retain) UILabel *nameLabel;

- (id)initWithBroadcastCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)idendifier;
- (id)initWithForwardCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)idendifier;

@end