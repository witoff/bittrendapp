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

- (id)initWithPriceData:(NSDictionary *)priceData andStatusItem:(NSStatusItem*)item;
- (void)setPrice:(NSString *)price;
- (void)sizeToFit;
- (void)setHighlight:(BOOL)isHighlighted;
- (void)setLastUpdatedTime:(NSDate *)time;
- (void)setTextAlpha:(CGFloat)alpha doAnimate:(BOOL)doAnimate;

@end
