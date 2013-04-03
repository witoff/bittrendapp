//
//  AppDelegate.h
//  bitcoin
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2013 Kevin Greene & Rob Witoff. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BtStatusItemViewController.h"
#import "BtceApiController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,BtceApiDelegate> {
@private
    BtStatusItemViewController *_statusItemViewController;
    BtceApiController *_btce;
    bool _toggle;
    
}

- (void)pollBtce:(NSTimer*)timer;

@end
