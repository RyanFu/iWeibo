
#import <Foundation/Foundation.h>
#import "SBJsonBase.h"

@interface SBJsonParser : SBJsonBase {
    
@private
    const char *c;
}

/**
 将代表json串的字符串转换为json支持的数据类型，然后返回，如果在解析的
 过程中出现了错误，则返回nil值。
 */
- (id)objectWithString:(NSString *)repr;

/**
 将代表json串的字符串转换为json支持的数据类型，然后返回，如果在解析的
 过程中出现了错误，则返回nil值。并切错误信息将通过error参数返回给主调
 函数。
 */

- (id)objectWithString:(NSString*)jsonText
                 error:(NSError**)error;


@end


