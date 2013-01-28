//
//  LoadCell.h
//  iweibo
//
//  Created by LICHENTAO on 12-1-17.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

 typedef enum{
	loadMore1=0,
	loading1,
	loadFinished,
	noResult,
	intermitCom,
	errorInfo,
}LoadMoreStatus;

@interface LoadCell : UIView {
    UILabel						*label;
    UIActivityIndicatorView     *spinner;
	LoadMoreStatus				cellState;
}

@property(nonatomic,assign) LoadMoreStatus				   cellState;
@property(nonatomic, retain) UILabel					   *label;
@property(nonatomic, readonly) UIActivityIndicatorView*    spinner;

- (void)setState:(LoadMoreStatus)state;
@end
