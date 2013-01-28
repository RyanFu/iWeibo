//
//  NSString+CaclHeight.h
//  DriverLicenseExam
//
//  Created by Minwen Yi on 5/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString(CaclHeight)

// 求取文本高度
-(CGFloat)calcCellHeightWithFont:(UIFont *)tFont andWidth:(CGFloat)frameWidth;
@end
