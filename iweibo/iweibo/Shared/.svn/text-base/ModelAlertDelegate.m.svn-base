//
//  ModelAlertDelegate.m
//  iweibo
//
//  Created by Minwen Yi on 3/30/12.
//  Copyright 2012 Beyondsoft. All rights reserved.
//

#import "ModelAlertDelegate.h"


@implementation ModalAlertDelegate
@synthesize index;

-(id)initWithRunLoop:(CFRunLoopRef)runLoop {
	if (self = [super init]) {
		currentLoop = runLoop;
	}
	return self;
}

#pragma mark protocol UIAlertViewDelegate <NSObject>
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	index = buttonIndex;
	CFRunLoopStop(currentLoop);
}

@end
