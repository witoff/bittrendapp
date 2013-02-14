//
//  BtToolbarViewController.h
//  bitcoin
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2013 Kevin Greene & Rob Witoff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BtStatusItemView.h"

@interface BtStatusItemViewController : NSViewController <NSMenuDelegate> {
@private
    NSStatusItem *_statusItem;
    BtStatusItemView *_statusItemView;
    NSString *_price;
    NSMenu *_menu;
    id _menuDelegate;
    NSMenuItem *_miLastUpdated;
    NSMenuItem *_miStartup;
    NSTimer *_lastUpdatedTimer;
    NSDate *_priceLastUpdated;
}

- (id)init;
- (void)mtGoxPriceDidChangeTo:(NSString *)text;
- (void)toggleStartup;
- (void)quit;

// Set Text to Red.
- (void)setWarning;
- (void)cancelWarning;

@end
