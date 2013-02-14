//
//  BtStartAtLoginController.h
//  bitcoin
//
//  Created by Robert Witoff on 2/8/13.
//  Copyright (c) 2013 Kevin Greene & Rob Witoff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BtStartAtLoginController : NSObject

- (BOOL)willStartAtLogin;
- (void)setStartAtLogin:(BOOL)enabled;

@end
