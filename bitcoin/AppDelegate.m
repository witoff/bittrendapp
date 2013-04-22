//
//  AppDelegate.m
//  bitcoin
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2013 Kevin Greene & Rob Witoff. All rights reserved.
//

#import "AppDelegate.h"

#define DEBUG_MTGOX 0

@implementation AppDelegate

#define DISCONNECTED 0
#define CONNECTED 1
#define UPDATING 2


- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    logInfo(1, @"Starting Up");
    _state = DISCONNECTED;
    _lastUpdate = nil;
    _lastStateChange = [NSDate date];
    _startTime = [NSDate date];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(watchDogTick:)
                                   userInfo:nil
                                    repeats:YES];
    
    _statusItemViewController = [[BtStatusItemViewController alloc] init];
    [self connectToMtGox:nil];
}

- (void)timerTicked:(NSTimer*)timer {
    logDebug(DEBUG_MTGOX, @"ticking");
    [self mtGoxDataDidChangeTo:qDict((_toggle ? @"1.00" : @"2.00"), @"last")];
    _toggle = !_toggle;
}


#pragma mark MtGOX DELEGATE
- (void)mtGoxDataDidChangeTo:(NSDictionary *)data {
    _state = UPDATING;
    _lastStateChange = [NSDate date];
    _lastUpdate = [NSDate date];
    
    [_statusItemViewController setWarning:NO];
    [_statusItemViewController mtGoxDataDidChangeTo:data];
}

- (void)mtGoxDidDisconnect {
    _state = DISCONNECTED;
    _lastStateChange = [NSDate date];
    
    // Tear down mtgox and restart
    [_mtGoxApiController invalidate];
    _mtGoxApiController = nil;
    
    // Highlight Text in Red
    [_statusItemViewController setWarning:YES];

    // Wait for 10s and reconnect
    logInfo(1, @"queuing timer to restart mtGox API");
    [NSTimer scheduledTimerWithTimeInterval:10.0
                                     target:self
                                   selector:@selector(connectToMtGox:)
                                   userInfo:nil
                                    repeats:NO];
    
}

-(void)watchDogTick:(NSTimer*)timer {
    logInfo(@"...watchdog ticking");
    
    int stateSecs = [[NSDate date] timeIntervalSinceDate:_lastStateChange];
    int changeSecs = [[NSDate date] timeIntervalSinceDate:_lastUpdate];
    int runSecs = [[NSDate date] timeIntervalSinceDate:_startTime];
    
    logInfo(@"runtime: %i, state: %i, change: %i", runSecs, stateSecs, changeSecs);
    
    if (runSecs > 30 && (_lastUpdate == nil || changeSecs > 90)) {
        //no change in 30 seconds
        logInfo(@"api down");
        [_statusItemViewController setStatusText:@"WARNING: MtGox API not responding.  API may be down."];
        [_statusItemViewController setWarning:YES];
        
        if (changeSecs > 90 ) {
            //restart
            [self mtGoxDidDisconnect];
        }
    }
    else {
        switch (_state) {
            case DISCONNECTED:
                logInfo(@"disconnected");
                //If not connected for more than 60s, MtGox may be down
                //[_statusItemViewController setStatusText:@"MtGox May Be Down"];
                if (stateSecs > 30) {
                    //restart
                    [self mtGoxDidDisconnect];
                }
                break;
            case CONNECTED:
                logInfo(@"connected");
                //If connected for more than 30s without update, restart
                if (stateSecs > 60) {
                    //restart
                    [self mtGoxDidDisconnect];
                }
                
                break;
            case UPDATING:
                logInfo(@"updating");
                //If no Updates for more than 90s, restart the connection
                if (stateSecs > 90) {
                    //restart
                    [self mtGoxDidDisconnect];
                }
                break;
            default:
                logInfo(@"bad case!!");
        }
    }
    
}

-(void)connectToMtGox:(NSTimer*)timer {
    _state = CONNECTED;
    _lastStateChange = [NSDate date];
    
    #if DEBUG_MTGOX
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(timerTicked:)
                                       userInfo:nil
                                        repeats:YES];
    #else
        _mtGoxApiController =
            [[BtMtGoxApiController alloc] initWithDelegate:self];
    #endif
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
