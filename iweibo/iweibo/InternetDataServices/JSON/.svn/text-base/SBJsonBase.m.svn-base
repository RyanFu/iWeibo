

#import "SBJsonBase.h"
NSString * SBJSONErrorDomain = @"org.brautaset.JSON.ErrorDomain";


@implementation SBJsonBase

@synthesize errorTrace;
@synthesize maxDepth;

- (id)init {
    self = [super init];
    if(nil != self)
        self.maxDepth = 512;
    return self;
}


- (void)dealloc {
    [errorTrace release];
	
    [super dealloc];
}


// 向错误栈中添加错误信息，以错误代码和描述信息这种键值对的方式体现
- (void)addErrorWithCode:(NSUInteger)code description:(NSString*)str {
    NSDictionary *userInfo;
    if (!errorTrace) {
        errorTrace = [NSMutableArray new];
        userInfo = [NSDictionary dictionaryWithObject:str forKey:NSLocalizedDescriptionKey];
        
    } else {
        userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                    str, NSLocalizedDescriptionKey,
                    [errorTrace lastObject], NSUnderlyingErrorKey,
                    nil];
    }
    
    NSError *error = [NSError errorWithDomain:SBJSONErrorDomain code:code userInfo:userInfo];

    [self willChangeValueForKey:@"errorTrace"];
    [errorTrace addObject:error];
    [self didChangeValueForKey:@"errorTrace"];
}


// 清除错误栈，包括其中的所有数据信息
- (void)clearErrorTrace {
    [self willChangeValueForKey:@"errorTrace"];
    [errorTrace release];
    errorTrace = nil;
    [self didChangeValueForKey:@"errorTrace"];
}

@end
