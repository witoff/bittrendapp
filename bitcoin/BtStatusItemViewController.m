//
//  BtToolbarViewController.m
//  bitcoin
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2013 Kevin Greene. All rights reserved.
//

#import "BtStatusItemViewController.h"
#import "BtStatusItemView.h"

@implementation BtStatusItemViewController

- (id)init {
  self = [super init];
  if (self) {
    _statusItem = [[NSStatusBar systemStatusBar]
        statusItemWithLength:NSVariableStatusItemLength];
    BtStatusItemView *statusItemView =
        [[BtStatusItemView alloc] initWithText:@"19.00"];
    [_statusItem setView:statusItemView];
  }
  return self;
}

@end
