//
//  BtToolbarViewController.h
//  bitcoin
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2013 Kevin Greene & Rob Witoff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BtStatusItemView.h"

@interface BtStatusItemViewController : NSViewController <NSMenuDelegate>

- (id)init;
- (void)mtGoxDataDidChangeTo:(NSDictionary *)data;
- (void)bitstampDataDidChangeTo:(NSDictionary *)data;
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
