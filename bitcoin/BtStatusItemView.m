//
//  BtStatusItemView.m
//  bitcoin
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2013 Kevin Greene. All rights reserved.
//

#import "BtStatusItemView.h"

@implementation BtStatusItemView

- (id)initWithText:(NSString *)text {
  self = [super init];
  if (self ) {
    _textField = [[NSTextField alloc] init];
    [_textField setEditable:NO];
    [_textField setSelectable:NO];
    [_textField setBordered:NO];
    [_textField setBezeled:NO];
    [_textField setBackgroundColor:[NSColor clearColor]];
    [_textField setFont:[NSFont menuBarFontOfSize:0]];
    [self setText:text];
    [self addSubview:_textField];
    [self sizeToFit];
  }
  return self;
}

#pragma mark public interface

- (void)setText:(NSString *)text {
  NSLog(@"Setting status item text to \"%@\"", text);
  [_textField setStringValue:text];
}

// Recalculate frame based on subviews.
- (void)sizeToFit {
  [_textField sizeToFit];
  NSRect textFrame = [_textField frame];
  CGFloat statusBarHeight = [[NSStatusBar systemStatusBar] thickness];
  [self setFrame:NSMakeRect(0, 0, textFrame.size.width, statusBarHeight)];
  // Center the _textField vertically in the status bar.
  // It seems necessary to add 1 pixel because it is too low otherwise *shrug*
  textFrame.origin.y =
      floor((statusBarHeight - textFrame.size.height) / 2) + 1;
  textFrame.origin.x = 0;
  [_textField setFrame:textFrame];
}

@end
