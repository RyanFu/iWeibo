//
//  moreDetailView.h
//  iweibo
//
//  Created by wangying on 2/27/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AsyncImageView;

@protocol MoreDetailViewDelegate<NSObject>

@required
- (void)segmentedControldidSelectButtonAtIndex:(int)theIndex;

@end

@interface MoreDetailView : UITableViewCell {
	AsyncImageView				*headPortrait;
	UISegmentedControl			*segmentedControl;
	UILabel						*nameLabel;
	UILabel						*nickLabel;
	id<MoreDetailViewDelegate>   delegate;
}

@property (nonatomic, retain) AsyncImageView		*headPortrait;
@property (nonatomic, retain) UISegmentedControl	*segmentedControl;
@property (nonatomic, retain) UILabel				*nameLabel;
@property (nonatomic, retain) UILabel				*nickLabel;
@property (nonatomic, assign) id<MoreDetailViewDelegate>	delegate;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
