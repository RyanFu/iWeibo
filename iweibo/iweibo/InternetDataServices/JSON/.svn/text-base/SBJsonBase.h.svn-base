#import <Foundation/Foundation.h>

extern NSString * SBJSONErrorDomain;


enum {
    EUNSUPPORTED = 1,
    EPARSENUM,
    EPARSE,
    EFRAGMENT,
    ECTRL,
    EUNICODE,
    EDEPTH,
    EESCAPE,
    ETRAILCOMMA,
    ETRAILGARBAGE,
    EEOF,
    EINPUT
};

/**
 该类是一个公共类，包含了解析json和构建json中的错误处理代码
 */
@interface SBJsonBase : NSObject {
    NSMutableArray *errorTrace;

@protected
    NSUInteger depth, maxDepth;
}

/*
 json文件的最大递归深度，默认值为512，如果超过该值，则会提示层次太深。并且返回nil，表示结果出错。
 可以通过将该值设置为0，来关闭这个安全检查特性。
 */
@property NSUInteger maxDepth;

/*
 返回错误栈信息，如果没有错误信息，则返回nil值。
 该方法仅仅返回最近一次的调用失败的错误信息，因此，每调用一次方法，
 都应该查看一下是否有错误，从而可以及时跟踪。
 */
 @property(copy,readonly) NSArray* errorTrace;

// 子类重写该方法，可以向错误栈中添加错误信息，包括错误代码和对象的描述信息
- (void)addErrorWithCode:(NSUInteger)code description:(NSString*)str;

// 子类可以重写该方法，在进行下一次的解析之前，清除错误栈
- (void)clearErrorTrace;

@end
