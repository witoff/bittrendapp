//
//  AppDelegate.h
//  bitcoin
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2013 Kevin Greene. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BtStatusItemViewController.h"
#import "BtSocketIOController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
 @private
  BtStatusItemViewController *_statusItemViewController;
  BtSocketIOController *_mtGoxSocketIOController;
}

@end
