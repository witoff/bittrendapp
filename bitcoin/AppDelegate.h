//
//  AppDelegate.h
//  bitcoin
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2013 Kevin Greene. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BtStatusItemViewController.h"
#import "BtMtGoxApiController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,BtMtGoxApiDelegate> {
 @private
  BtStatusItemViewController *_statusItemViewController;
  BtMtGoxApiController *_mtGoxApiController;
}

@end
