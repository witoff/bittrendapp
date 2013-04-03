//
//  AppDelegate.m
//  bitcoin
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2013 Kevin Greene & Rob Witoff. All rights reserved.
//

#import "AppDelegate.h"
#import "BtceApiController.h"

#define DEBUG_MTGOX 0

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    logInfo(1, @"Starting Up");
    
    _statusItemViewController = [[BtStatusItemViewController alloc] init];

    
    
    _btce = [[BtceApiController alloc] initWithDelegate:self];
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(pollBtce:)
                                   userInfo:nil
                                    repeats:YES];


}

- (void)pollBtce:(NSTimer*)timer {
    logDebug(DEBUG_MTGOX, @"ticking");
    [_btce poll];
}


#pragma mark MtGOX DELEGATE
- (void)btceDataDidChangeTo:(NSDictionary *)data {
    [_statusItemViewController mtGoxDataDidChangeTo:data];
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
