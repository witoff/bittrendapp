//
//  BtStatusItemView.m
//  bitcoin
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2013 Kevin Greene & Rob Witoff. All rights reserved.
//

#import "BtStatusItemView.h"


@implementation BtStatusItemView

@synthesize textColor;

- (id)initWithPriceData:(NSDictionary *)priceData andStatusItem:(NSStatusItem *)item {
    self = [super init];
    if (self) {
        _lastUpdated = [[NSDate alloc] init];
        _isHighlighted = NO;
        _statusItem = item;
        _doWarn = NO;
        
        _textField = [[NSTextField alloc] init];
        [_textField setEditable:NO];
        [_textField setSelectable:NO];
        [_textField setBordered:NO];
        [_textField setBezeled:NO];
        [_textField setBackgroundColor:[NSColor clearColor]];
        [_textField setFont:[NSFont menuBarFontOfSize:0]];
        self.textColor = [self getTextColor];
        
        [self addSubview:_textField];
        [self setPrice:[priceData valueForKey:@"last"]];
    }
    return self;
}

#pragma mark Public Interface
#pragma mark Mouse tracking

- (void)mouseDown:(NSEvent *)event {
    logDebug(1, @"MOUSE DOWN");
    // [self rightMouseDown:event];

    // TODO: Implement a way to unhighlith when focus is lost.
    // Showing an NSWindow that loses focus is one way to do this.
    // A better way is probably to implement menuWillClose in an NSMenuDelegate.
    CGPoint point = CGPointMake(0, -4);
    [_statusItem.menu popUpMenuPositioningItem:nil
                                    atLocation:point
                                        inView:_statusItem.view];
}

-(void)setHighlight:(BOOL)isHighlighted {
    _isHighlighted = isHighlighted;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect) rect {
    if (_isHighlighted) {
        [_textField setTextColor:[NSColor whiteColor]];
        [[NSColor selectedMenuItemColor] set];
        [NSBezierPath fillRect:rect];
    } else {
        [_textField setTextColor:[self getTextColor]];
        [super drawRect: rect];
    }
}

- (void)setWarning:(BOOL)doWarn {
    if (doWarn != _doWarn) {
        _doWarn = doWarn;
        self.textColor = [self getTextColor];
        [self setNeedsDisplay:YES];
    }

}

-(NSColor*)getTextColor {
    if (_doWarn)
         return [NSColor redColor];
    else
        return [NSColor blackColor];
}

- (void)setLastUpdatedTime:(NSDate *)time {
    // Set Tooltip
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE, h:mm:ssa"];
    NSDate *now = [[NSDate alloc] init];
    NSString *updated = [NSString stringWithFormat:@"Last updated at %@",
        [dateFormat stringFromDate:now]];
    [_textField setToolTip:updated];
    [self setToolTip:updated];
    _lastUpdated = now;
    logInfo(1, @"Setting tooltip to: %@", updated);
}

- (void)setPrice:(NSNumber *)price {
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setFormat:@"0.##"];
    NSString *formatted = [NSString stringWithFormat:@"%@/฿", [fmt stringFromNumber:price]];
    NSLog(@"Setting status item text to \"%@\"", formatted);
    [_textField setStringValue:formatted];
    [self sizeToFit];
    
    // Slowly fade out to indicate staleness
    [self setTextAlpha:1 doAnimate:NO];
    [self setTextAlpha:.55 doAnimate:YES];
}

- (void)setTextAlpha:(CGFloat)alpha doAnimate:(BOOL)doAnimate {
    if (doAnimate) {
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:1.1];
        [_textField.animator setAlphaValue:alpha];
        [NSAnimationContext endGrouping];
    }
    else
        [_textField setAlphaValue:alpha];
}

// Recalculate frame based on subviews.
- (void)sizeToFit {
    [_textField sizeToFit];
    NSRect textFrame = [_textField frame];
    CGFloat statusBarHeight = [[NSStatusBar systemStatusBar] thickness];
    [self setFrame:NSMakeRect(0, 0, textFrame.size.width, statusBarHeight)];

    #if 0
        // TODO: Figure out how to perfectly center the text vertically.
        // Center the _textField vertically in the status bar.
        // It seems necessary to add 1 pixel because it is too low otherwise.
        textFrame.origin.y =
        floor((statusBarHeight - textFrame.size.height) / 2) + 1;
        textFrame.origin.x = 0;
        textFrame.size.height = statusBarHeight;
        [_textField setFrame:textFrame];
    #else
        // Centering doesn't work with color'd background.  *double sigh*  Need this.
        [_textField setFrame:NSMakeRect(0, 0, textFrame.size.width, statusBarHeight)];
    #endif
}

@end
