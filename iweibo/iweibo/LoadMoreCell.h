//
//  LoadingMoreCell.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-25.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
	loadMore=0,
	loading
}LoadMoreCellStatus;

@interface LoadMoreCell : UITableViewCell {

    UILabel*                    label;
    UIActivityIndicatorView*    spinner;
	LoadMoreCellStatus			cellState;
}

@property(nonatomic,assign) LoadMoreCellStatus cellState;
@property(nonatomic, retain) UILabel *label;
@property(nonatomic, readonly) UIActivityIndicatorView* spinner;

- (void)setState:(LoadMoreCellStatus)cellState;
@end
//@interface LoadMoreCell : UIView
//{
//	UILabel    *label;
//	UIActivityIndicatorView   *spinner;
//	LoadMoreCellStatus        cellState;
//}


//@property(nonatomic,assign) LoadMoreCellStatus	cellState;
//@property(nonatomic, retain) UILabel				*label;
//@property(nonatomic, readonly) UIActivityIndicatorView* spinner;
//- (void)setState:(LoadMoreCellStatus)cellState;

//@end
