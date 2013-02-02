//
//  BtToolbarViewController.m
//  bitcoin
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2013 Kevin Greene. All rights reserved.
//

#import "BtToolbarViewController.h"

@implementation BtToolbarViewController

- (id)init {
  self = [super init];
  if (self) {
    _toolbar = [[NSToolbar alloc] initWithIdentifier:@"bittrends"];
    [_toolbar setDisplayMode:NSToolbarDisplayModeLabelOnly];
    [_toolbar setDelegate:self];
  }
  return self;
}

@end
