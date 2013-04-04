//
//  BtStartAtLoginController.m
//  bitcoin
//
//  Created by Robert Witoff on 2/8/13.
//  Copyright (c) 2013 Kevin Greene & Rob Witoff. All rights reserved.
//  -fno-objc-arc
//  Help from here: http://blog.timschroeder.net/2012/07/03/the-launch-at-login-sandbox-project/

#import <ServiceManagement/SMLoginItem.h>
#import "BtStartAtLoginController.h"

@interface BtStartAtLoginController(private)

- (NSURL *)appURL;

@end

@implementation BtStartAtLoginController

- (NSURL *)appURL {
    return [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
}

- (BOOL)willStartAtLogin {
    return [BtStartAtLoginController willStartAtLogin:[self appURL]];
}

- (void)setStartAtLogin:(BOOL)enabled {
    [self willChangeValueForKey:@"startAtLogin"];
    [BtStartAtLoginController setStartAtLogin:[self appURL] enabled:enabled];
    [self didChangeValueForKey:@"startAtLogin"];
}

+ (BOOL) willStartAtLogin:(NSURL *)itemURL {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"startAtLogin"];
 
}

+ (void) setStartAtLogin:(NSURL *)itemURL enabled:(BOOL)enabled {
    
    NSString *bundleId = @"com.bittrends.litetrendsHelper";
    if (SMLoginItemSetEnabled ((__bridge CFStringRef)bundleId,enabled)) {
        logInfo(YES, @"SMLogin succesfully set");
    } else {
        logWarn(@"Warning, could not process startup toggle");
    }
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:enabled forKey:@"startAtLogin"];
    [defaults synchronize];
}

@end
