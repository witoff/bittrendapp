//
//  AppDelegate.h
//  bitcoin
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2013 Kevin Greene & Rob Witoff. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BtStatusItemViewController.h"
#import "BtMtGoxApiController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,BtMtGoxApiDelegate> {
@private
    BtStatusItemViewController *_statusItemViewController;
    BtMtGoxApiController *_mtGoxApiController;
    bool _toggle;
    int _state;
    
    NSDate *_startTime;
    NSDate *_lastStateChange;
    NSDate *_lastUpdate;
    
}

-(void)timerTicked:(NSTimer*)timer;
-(void)connectToMtGox:(NSTimer*)timer;
-(void)watchDogTick:(NSTimer*)timer;

@end
