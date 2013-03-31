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
    NSDictionary *_lastPriceData;
    NSMenu *_menu;
    id _menuDelegate;
    NSMenuItem *_miLastUpdated;
    
    NSMenuItem *_miLow;
    NSMenuItem *_miHigh;
    NSMenuItem *_miBuy;
    NSMenuItem *_miLast;
    NSMenuItem *_miSell;
    NSMenuItem *_miAlerts;
    NSMenuItem *_miLinks;
    NSDictionary *_allSelectableMenuItems;
    
    NSMenuItem *_miStartup;
    NSTimer *_lastUpdatedTimer;
    NSDate *_priceLastUpdated;
    
    NSDictionary *_links;
}

- (id)init;
- (void)mtGoxDataDidChangeTo:(NSDictionary *)data;
- (void)toggleStartup;
- (void)didSelectTickerKey:(id)sender;
- (void)openUrl:(NSMenuItem*)sender;
- (NSString*)getTickerKey;
- (void)updateStatusItem;
- (NSMenuItem*)getLinkMenu;
- (void)quit;

// Set Text to Red.
- (void)setWarning;
- (void)cancelWarning;

@end
