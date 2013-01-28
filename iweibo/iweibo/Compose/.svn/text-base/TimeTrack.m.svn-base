//
//  TimeTrack.mm
//  IcanMusic
//
//  Created by Minwen Yi on 12/13/11.
//  Copyright 2011 BYS. All rights reserved.
//

#import "TimeTrack.h"


@implementation TimeSlice

@synthesize timeStart;
@synthesize timeEnd;

-(TimeSlice*) init
{
	self = [super init];
    if (self) {
        self.timeStart	= nil;
        self.timeEnd	= nil;
    }
    return self;
}
-(void) dealloc
{
	self.timeStart = nil;
	self.timeEnd = nil;
	[super dealloc];
}

-(NSDate*) StartTimer
{
	self.timeStart	= [NSDate date];
	return self.timeStart;
}

-(NSDate*) EndTimer
{
	self.timeEnd	= [NSDate date];
	return self.timeEnd;
}

-(NSTimeInterval) getTimeSlice
{
	return [self.timeEnd timeIntervalSinceDate:self.timeStart];
}

@end


@implementation TimeTrack

@synthesize timeSlice;
@synthesize descName;

-(TimeTrack*) init
{
	self = [super init];
    if (self) {
        self.timeSlice = NULL;

    }
	return self;
}

-(TimeTrack*) initWithName:(NSString*) strDescription
{
	self = [super init];
	if (nil == timeSlice) {
		timeSlice = [[TimeSlice alloc] init];
	}
	[timeSlice StartTimer];
	self.descName = strDescription;
	//[self.descName retain];
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
	[formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *strBegin	= [formatter stringFromDate:[timeSlice timeStart]];
	NSLog(@"%@ start time:%@", self.descName, strBegin);
	[formatter release];
	return self;
}

-(void) printTimeSlice {
	[timeSlice EndTimer];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
	[formatter setTimeZone:[NSTimeZone localTimeZone]];
	NSString *strEnd	= [formatter stringFromDate:[timeSlice timeEnd]];
	//NSLog(@"%@ StartTime:%@ EndTick:%@, timeSlice:%f seconds.",self.descName, strBegin, strEnd, [timeSlice getTimeSlice]);
    NSLog(@"%@ end time:%@, timeSlice:%f seconds.",self.descName, strEnd, [timeSlice getTimeSlice]);
    [formatter release];
}

-(void) printCurrentTime {
	NSDate *cur = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
	[formatter setTimeZone:[NSTimeZone localTimeZone]];
	NSString *strCurrent	= [formatter stringFromDate:cur];
	NSLog(@"%@ current Time:%@",self.descName, strCurrent);
    [formatter release];
}

-(void) dealloc
{
	[timeSlice EndTimer];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
	[formatter setTimeZone:[NSTimeZone localTimeZone]];
	NSString *strEnd	= [formatter stringFromDate:[timeSlice timeEnd]];
	//NSLog(@"%@ StartTime:%@ EndTick:%@, timeSlice:%f seconds.",self.descName, strBegin, strEnd, [timeSlice getTimeSlice]);
    NSLog(@"%@ end time:%@, timeSlice:%f seconds.",self.descName, strEnd, [timeSlice getTimeSlice]);
    [formatter release];
	self.timeSlice = nil;
	self.descName = nil;
	[super dealloc];
}
@end