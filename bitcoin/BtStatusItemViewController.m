//
//  BtToolbarViewController.m
//  bitcoin
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2013 Kevin Greene. All rights reserved.
//

#import "BtStatusItemViewController.h"

@implementation BtStatusItemViewController

- (id)init {
  self = [super init];
  if (self) {
    _statusItem = [[NSStatusBar systemStatusBar]
        statusItemWithLength:NSVariableStatusItemLength] ;
    [_statusItem setTitle:@"$19.00"];
    // TODO(kgk): Add dopdown menu on click to quit, etc.
    // [_statusItem setMenu:statusMenu];
    // [_statusItem setAction:@selector(menuClick:)];

    _statusItemTextField =
        [[NSTextField alloc] init];
    [_statusItemTextField setStringValue:@"$19.00"];
    [_statusItemTextField setBezeled:NO];
    [_statusItemTextField setDrawsBackground:NO];
    [_statusItemTextField setEditable:NO];
    [_statusItemTextField setSelectable:NO];

    [_statusItem setView:_statusItemTextField];
  }
  return self;
}

@end
