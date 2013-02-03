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
    // Use something other than the system font? Not just yet.
    // NSFont *font =
    //     [NSFont fontWithName:@"HelveticaNeueLTStd-Cn" size:16.0];
    NSFont *font = [NSFont menuBarFontOfSize:0];
    [_textField setFont:font];
    [_textField setStringValue:text];
    [self addSubview:_textField];
    [self sizeToFit];
  }
  return self;
}

- (void)setText:(NSString *)text {
  NSLog(@"Setting status item text to \"%@\"", text);
  [_textField setStringValue:text];
  [self sizeToFit];
}

// Recalculate frame based on subviews.
- (void)sizeToFit {
  [_textField sizeToFit];
  NSRect textFrame = [_textField frame];
  NSRect selfFrame = textFrame;
  selfFrame.size.height = [[NSStatusBar systemStatusBar] thickness];
  [self setFrame:selfFrame];
  // It seems necessary to add 1 pixel because it is too low otherwise.
  textFrame.origin.y +=
      floor((selfFrame.size.height - textFrame.size.height) / 2) + 1;
  [_textField setFrame:textFrame];
}

@end
