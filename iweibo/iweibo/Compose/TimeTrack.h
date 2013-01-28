//
//  TimeTrack.h
//  IcanMusic
//
//  Created by Minwen Yi on 12/13/11.
//  Copyright 2011 BYS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TimeSlice : NSObject {
	NSDate* timeStart;		// start time
	NSDate*	timeEnd;		// end time
}
@property (nonatomic, retain) NSDate*	timeStart;
@property (nonatomic, retain) NSDate*	timeEnd;
-(NSDate*) StartTimer;
-(NSDate*) EndTimer;
-(NSTimeInterval) getTimeSlice;
@end


@interface TimeTrack : NSObject {
	TimeSlice*	timeSlice;
	NSString*	descName;
}
@property (nonatomic, retain) TimeSlice*	timeSlice;
@property (nonatomic, retain) NSString*		descName;
-(TimeTrack*) initWithName:(NSString*) strDescription;
-(void) printTimeSlice;
-(void) printCurrentTime;
@end