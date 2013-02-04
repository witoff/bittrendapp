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
        statusItemWithLength:NSVariableStatusItemLength];
    _statusItemText = @"฿";
    _statusItemView = [[BtStatusItemView alloc] initWithText:_statusItemText];
    [_statusItem setView:_statusItemView];
  }
  return self;
}

#pragma mark public interface

- (void)setText:(NSString *)text {
  if (![_statusItemText isEqualToString:text]) {
    _statusItemText = [text copy];
    [_statusItemView setText:text];
    [_statusItemView sizeToFit];
  }
}

@end
