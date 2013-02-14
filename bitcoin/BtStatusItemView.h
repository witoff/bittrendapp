//
//  BtStatusItemView.h
//  bitcoin
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2013 Kevin Greene & Rob Witoff. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BtStatusItemView : NSView {
@private
    NSTextField *_textField;
    NSDate *_lastUpdated;
    BOOL _isHighlighted;
    NSStatusItem *_statusItem;
    NSColor *textColor;
    
}

@property (nonatomic, retain) NSColor *textColor;

- (id)initWithText:(NSString *)text andStatusItem:(NSStatusItem*)item;
- (void)setText:(NSString *)text;
- (void)sizeToFit;
-(void)setHighlight:(BOOL)isHighlighted;
-(NSDate*)lastUpdated;
-(void)setTextAlpha:(CGFloat)alpha doAnimate:(BOOL)doAnimate;

@end
