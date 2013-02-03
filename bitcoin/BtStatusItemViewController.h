//
//  BtToolbarViewController.h
//  bitcoin
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2013 Kevin Greene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BtStatusItemView.h"

@interface BtStatusItemViewController : NSViewController {
 @private
  NSStatusItem *_statusItem;
  BtStatusItemView *_statusItemView;
  NSString *_statusItemText;
}

- (id)init;
- (void)setText:(NSString *)text;

@end
