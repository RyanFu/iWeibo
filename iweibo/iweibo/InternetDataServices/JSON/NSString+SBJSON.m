
#import "NSString+SBJSON.h"
#import "SBJsonParser.h"

@implementation NSString (NSString_SBJSON)

- (id)JSONValue
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    id repr = [jsonParser objectWithString:self];
    if (!repr)
        NSLog(@"-JSONValue failed. Error trace is: %@", [jsonParser errorTrace]);
    [jsonParser release];
    return repr;
}

@end
