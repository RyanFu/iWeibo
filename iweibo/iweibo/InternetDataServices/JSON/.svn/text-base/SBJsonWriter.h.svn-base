
#import <Foundation/Foundation.h>
#import "SBJsonBase.h"

@interface SBJsonWriter : SBJsonBase {

@private
    BOOL sortKeys, humanReadable;
}

/*
 决定是否产生用户可读的JSON结果。默认值为NO，如果设置为YES的话，则每一个数组或
 字典即键值对之间都会有一个换行符，并且不同层次的数据之间也有两个空格的缩进值。
 */
@property BOOL humanReadable;

/**
 在将字典转换为JSON串的时候是否要对键值进行排序，默认为不排序，即值为NO。
 如果设置为YES，则对字典的键值进行排序。
 */
@property BOOL sortKeys;

/*
 将value代表的数据转换为一个JSON串，value为任何可以转换为JSON串的对象。如果出现错误，则返回一个nil
 */
- (NSString*)stringWithObject:(id)value;

- (NSString*)stringWithObject:(id)value
                           error:(NSError**)error;


@end

/*
 目前该类仅支持NSArray和NSDictionary两个类的转换，如果想支持用户自定义的数据结构，则可以实现该
 方法，将用户自定义的数据类型转换为JSON串。
For example, a Person object might implement it like this:
 @code
 - (id)proxyForJson {
    return [NSDictionary dictionaryWithObjectsAndKeys:
        name, @"name",
        phone, @"phone",
        email, @"email",
        nil];
 }
 @endcode
 
 */
@interface NSObject (SBProxyForJson)
- (id)proxyForJson;
@end

