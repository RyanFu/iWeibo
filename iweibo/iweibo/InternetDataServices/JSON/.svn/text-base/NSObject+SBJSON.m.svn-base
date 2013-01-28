

#import "NSObject+SBJSON.h"
#import "SBJsonWriter.h"

@implementation NSObject (NSObject_SBJSON)

- (NSString *)JSONRepresentation {
    SBJsonWriter *jsonWriter = [SBJsonWriter new]; 
    NSString *json = [jsonWriter stringWithObject:self];
    if (!json)
        NSLog(@"-JSONRepresentation failed. Error trace is: %@", [jsonWriter errorTrace]);
    [jsonWriter release];
    return json;
}

@end
