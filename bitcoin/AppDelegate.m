//
//  AppDelegate.m
//  bitcoin
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2013 Kevin Greene & Rob Witoff. All rights reserved.
//

#import "AppDelegate.h"

#import "BtBitstampApiController.h"
#import "BtStatusItemViewController.h"

@interface AppDelegate()<NSApplicationDelegate, BtBitstampApiDelegate>
@end

@implementation AppDelegate {
  BtStatusItemViewController *_statusItemViewController;
  BtBitstampApiController *_bistampApiController;
  bool _toggle;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  logInfo(1, @"Starting Up");
  _statusItemViewController = [[BtStatusItemViewController alloc] init];
  _bistampApiController = [[BtBitstampApiController alloc] initWithDelegate:self];
}

#pragma mark BtBitstampApiDelegate

- (void)bitstampDataDidChangeTo:(NSDictionary *)data {
  [_statusItemViewController bitstampDataDidChangeTo:data];
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
