

#import <Foundation/Foundation.h>

@interface NSObject (NSObject_SBJSON)

/*
 该方法虽然是NSObject的一个类别方法，但它只支持NSArray和NSDictionary两种数据类型。
 将一个NSArray或NSDictionary对象转换为一个用NSString表示的JSON串。
 */
- (NSString *)JSONRepresentation;

@end

