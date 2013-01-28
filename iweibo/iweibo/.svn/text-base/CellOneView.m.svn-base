//
//  CellOneView.m
//  iweibo
//
//  Created by LiQiang on 12-2-3.
//  Copyright 2012年 Beyondsoft. All rights reserved.
//

#import "CellOneView.h"
#import "PersonalMsgViewController.h"

@implementation CellOneView
@synthesize numListenerLbl,numListenToLbl,numBroadcastLbl,dataMsgDic,parentController,listener,listenTo;

- (id)constructFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CLog(@"cell1数据%@",self.dataMsgDic);
        listener = [UIButton buttonWithType:UIButtonTypeCustom];
        listener.frame = CGRectMake(0,0, 160, 47);
        [listener setBackgroundImage:[UIImage imageNamed:@"listenerBg.png"] forState:UIControlStateNormal];
        [listener setBackgroundImage:[UIImage imageNamed:@"listenerBg.png"] forState:UIControlStateHighlighted];
        [listener addTarget:self action:@selector(listenerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        listener.enabled = [[self.dataMsgDic objectForKey:KLISTENBTNENABLE] boolValue];
        [self addSubview:listener];
        
        int widthNumListenerLbl = [[self.dataMsgDic objectForKey:KWIDTHLISTENER] intValue];
        numListenerLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, widthNumListenerLbl, 30)];
        numListenerLbl.text = [self.dataMsgDic objectForKey:KNUMLISTENER];
        numListenerLbl.font = [UIFont boldSystemFontOfSize:20];
        numListenerLbl.backgroundColor = [UIColor clearColor];
        [numListenerLbl setTextColor:[UIColor colorWithRed:51.0f/255.0f green:116.0f/255.0f blue:152.0f/255.0f alpha:1.0]] ;
        
        [listener addSubview:numListenerLbl];
        
        UILabel *ListenerLbl = [[UILabel alloc] initWithFrame:CGRectMake(15+widthNumListenerLbl, 10, 30, 30)];
        ListenerLbl.text = @"听众";
        ListenerLbl.font = [UIFont systemFontOfSize:14];
        ListenerLbl.backgroundColor = [UIColor clearColor];
        [ListenerLbl setTextColor:[UIColor colorWithRed:97.0f/255.0f green:155.0f/255.0f blue:181.0f/255.0f alpha:1.0]];
        [listener addSubview:ListenerLbl];
		[ListenerLbl release];
        //========================================================================      
        listenTo = [UIButton buttonWithType:UIButtonTypeCustom];
        listenTo.frame = CGRectMake(160,0, 160, 47);
        [listenTo setBackgroundImage:[UIImage imageNamed:@"listenToBg.png"] forState:UIControlStateNormal];
        [listenTo setBackgroundImage:[UIImage imageNamed:@"listenToBg.png"] forState:UIControlStateHighlighted];
        [listenTo addTarget:self action:@selector(listenToBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        listenTo.enabled = [[self.dataMsgDic objectForKey:KLISTENTOBTNENABLE] boolValue];
        [self addSubview:listenTo];
        
        int widthNumListenToLbl = [[self.dataMsgDic objectForKey:KWIDTHLISTENTO] intValue];
        numListenToLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, widthNumListenToLbl, 30)];
        numListenToLbl.text = [self.dataMsgDic objectForKey:KNUMLISTENTO];
        numListenToLbl.font = [UIFont boldSystemFontOfSize:20];
        numListenToLbl.backgroundColor = [UIColor clearColor];
        [numListenToLbl setTextColor:[UIColor colorWithRed:51.0f/255.0f green:116.0f/255.0f blue:152.0f/255.0f alpha:1.0]];
        [listenTo addSubview:numListenToLbl];
        
        UILabel *listenToLbl = [[UILabel alloc] initWithFrame:CGRectMake(15+widthNumListenToLbl, 10, 30, 30)];
        listenToLbl.text = @"收听";
        listenToLbl.font = [UIFont systemFontOfSize:14];
        listenToLbl.backgroundColor = [UIColor clearColor];
        [listenToLbl setTextColor:[UIColor colorWithRed:97.0f/255.0f green:155.0f/255.0f blue:181.0f/255.0f alpha:1.0]];
        [listenTo addSubview:listenToLbl];
		[listenToLbl release];
        //===========================================================================    
        UIImageView *broadcastView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"broadcastBg.png"]];
        broadcastView.frame = CGRectMake(0, 47, 320, 51);
        [self addSubview:broadcastView];
        [broadcastView release];
        int widthNumBroad = [[self.dataMsgDic objectForKey:KWIDTHBROADCAST] intValue];
        numBroadcastLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, widthNumBroad, 30)];
        numBroadcastLbl.text = [self.dataMsgDic objectForKey:KNUMBROADCAST];
        numBroadcastLbl.font = [UIFont boldSystemFontOfSize:20];
        numBroadcastLbl.backgroundColor = [UIColor clearColor];
        [numBroadcastLbl setTextColor:[UIColor colorWithRed:51.0f/255.0f green:116.0f/255.0f blue:152.0f/255.0f alpha:1.0]];
        [broadcastView addSubview:numBroadcastLbl];
        
        UILabel *broadCastLbl = [[UILabel alloc] initWithFrame:CGRectMake(15+widthNumBroad, 10, 30, 30)];
        broadCastLbl.text = @"广播";
        broadCastLbl.font = [UIFont systemFontOfSize:14];
        broadCastLbl.backgroundColor = [UIColor clearColor];
        [broadCastLbl setTextColor:[UIColor colorWithRed:97.0f/255.0f green:155.0f/255.0f blue:181.0f/255.0f alpha:1.0]];
        [broadcastView addSubview:broadCastLbl];
		[broadCastLbl release];
        
    }
    return self;
}

- (void)listenerBtnClicked
{
    if([parentController respondsToSelector:@selector(listenerBtnAction)])
    {
        [parentController performSelector:@selector(listenerBtnAction)];
    }
}
- (void)listenToBtnClicked
{
    if([parentController respondsToSelector:@selector(listenToBtnAction)])
    {
        [parentController performSelector:@selector(listenToBtnAction)];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{ 
    [numListenerLbl release];
    [numListenToLbl release];
    [numBroadcastLbl release];
    [super dealloc];
}

@end
