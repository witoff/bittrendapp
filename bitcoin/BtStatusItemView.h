//
//  BtStatusItemView.h
//  bitcoin
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2013 Kevin Greene. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BtStatusItemView : NSView {
 @private
  NSTextField *_textField;
}

- (id)initWithText:(NSString *)text;

- (void)setText:(NSString *)text;

@end
