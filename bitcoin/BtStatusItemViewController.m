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
    // TODO(kgk): Add dopdown menu on click to quit, etc.
    // [_statusItem setMenu:statusMenu];
    // [_statusItem setAction:@selector(menuClick:)];

    NSFont *stringFont = [NSFont fontWithName:@"Helvetica" size:15.0];
    NSDictionary *titleAttributes =
        [NSDictionary dictionaryWithObject:stringFont
                                    forKey:NSFontAttributeName];
    NSAttributedString *title =
        [[NSAttributedString alloc] initWithString:@"19.00"
                                        attributes:titleAttributes];
    [_statusItem setAttributedTitle:title];
  }
  return self;
}

@end
