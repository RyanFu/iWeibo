//
//  CellOneView.h
//  iweibo
//
//  Created by LiQiang on 12-2-3.
//  Copyright 2012年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonalMsgViewController;

@interface CellOneView : UIView {
    UILabel *numListenerLbl;
    UILabel *numListenToLbl;
    UILabel *numBroadcastLbl;
    NSDictionary *dataMsgDic;
    UIButton *listener;
    UIButton *listenTo;
    PersonalMsgViewController *parentController;
}
@property(nonatomic,retain) UIButton *listener;
@property(nonatomic,retain) UIButton *listenTo;
@property(nonatomic,retain) UILabel *numListenerLbl;
@property(nonatomic,retain) UILabel *numListenToLbl;
@property(nonatomic,retain) UILabel *numBroadcastLbl;
@property(nonatomic,retain) NSDictionary *dataMsgDic;
@property(nonatomic,assign) PersonalMsgViewController *parentController;
- (id)constructFrame:(CGRect)frame;
@end
