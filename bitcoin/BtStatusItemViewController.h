//
//  BtToolbarViewController.h
//  bitcoin
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2013 Kevin Greene & Rob Witoff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BtStatusItemView.h"

@interface BtStatusItemViewController : NSViewController

- (id)init;
- (void)mtGoxDataDidChangeTo:(NSDictionary *)data;
- (void)bitstampDataDidChangeTo:(NSDictionary *)data;
- (void)toggleStartup;
- (void)showDonate;
- (void)copyAddress:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
- (void)didSelectTickerKey:(id)sender;
- (void)openUrl:(NSMenuItem*)sender;
- (NSString*)getTickerKey;
- (void)updateStatusItem;
- (NSMenuItem*)getLinkMenu;
- (void)quit;

// Set Text to Red.
- (void)setWarning:(bool)doWarn;
- (void)setStatusText:(NSString*)text;

@end
