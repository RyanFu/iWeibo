//
//  AddressForMapModel.h
//  iweibo
//
//  Created by Cui Zhibo on 12-4-23.
//  Copyright (c) 2012年 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressForMapModel : NSObject
{
    
    UIImage         * _icon;
    NSString        * _addrName;
    NSString        * _theAddr;
}

@property (nonatomic, retain) UIImage * icon;
@property (nonatomic, retain) NSString * addrName;
@property (nonatomic, retain) NSString * theAddr;

@end

