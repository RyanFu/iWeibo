//
//  ModelAlertDelegate.h
//  iweibo
//
//  Created by Minwen Yi on 3/30/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ModalAlertDelegate : NSObject<UIAlertViewDelegate>
{
	CFRunLoopRef currentLoop;
	NSUInteger index;
}
@property(readonly) NSUInteger index;

-(id)initWithRunLoop:(CFRunLoopRef)runLoop;
@end
