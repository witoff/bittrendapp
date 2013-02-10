//
//  AppDelegate.m
//  bitcoin
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2013 Kevin Greene and Rob!. All rights reserved.
//

#import "AppDelegate.h"

#define DEBUG_MTGOX NO

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    logInfo(1, @"Starting Up");
    _statusItemViewController = [[BtStatusItemViewController alloc] init];
    
    //Connect to MtGox
    [self connect:nil];
}

- (void)timerTicked:(NSTimer*)timer {
    logDebug(DEBUG_MTGOX, @"ticking");
    [self mtGoxPriceDidChangeTo: (_toggle ? @"1.00" : @"2.00")];
    _toggle = !_toggle;
}


#pragma mark MtGOX DELEGATE
- (void)mtGoxPriceDidChangeTo:(NSString *)price {
    [_statusItemViewController setText:price];
}

- (void)mtGoxDidDisconnect {
    //Tear down mtgox and restart
    [_mtGoxApiController invalidate];
    _mtGoxApiController = nil;
    
    //TODO: Highlight Text in Red
    [_statusItemViewController setWarning];

    //Wait 30 seconds and reconnect
    logInfo(1, @"queuing timer to restart mtGox API");
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(connect:) userInfo:nil repeats:NO];
    
}
-(void)connect:(NSTimer*)timer {
    [_statusItemViewController cancelWarning];
    if (DEBUG_MTGOX)
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
    else
        _mtGoxApiController = [[BtMtGoxApiController alloc] initWithDelegate:self];
}

#pragma mark APPLICATION LIFECYCLE

-(void)applicationDidResignActive:(NSNotification *)notification {
    
    logInfo(1, @"did resign active");
}

-(void)applicationDidBecomeActive:(NSNotification *)notification {
    logInfo(1, @"did become active");
}

-(void)applicationDidUnhide:(NSNotification *)notification {
    logInfo(1, @"did unhide");
}

@end
