//
//  DataCheck.h
//  iweibo
//
//  Created by zhaoguohui on 12-2-16.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataCheck : NSObject {

}

+ (id)checkDictionary:(NSDictionary *)dictionary forKey:(NSString *)key withType:(Class)type;
@end
