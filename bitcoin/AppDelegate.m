//
//  AppDelegate.m
//  bitcoin
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2013 Kevin Greene. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  NSLog(@"Starting Up");
  _statusItemViewController = [[BtStatusItemViewController alloc] init];
  _mtGoxApiController = [[BtMtGoxApiController alloc] initWithDelegate:self];
}

- (void)mtGoxPriceDidChangeTo:(NSString *)price {
  [_statusItemViewController setText:price];
}

@end
