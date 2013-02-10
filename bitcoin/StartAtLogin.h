//
//  StartAtLogin.h
//  bitcoin
//
//  Created by Robert Witoff on 2/8/13.
//  Copyright (c) 2013 Kevin Greene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StartAtLogin : NSObject

- (BOOL)willStartAtLogin;
- (void)setStartAtLogin:(BOOL)enabled;

@end
