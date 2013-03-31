//
//  BthAppDelegate.m
//  bittrendsHelper
//
//  Created by Robert Witoff on 3/30/13.
//  Copyright (c) 2013 Robert Witoff. All rights reserved.
//

#import "BthAppDelegate.h"

@implementation BthAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSLog(@"STARTING bittrendsHelper.app\n\n\n");
    
    // Check if main app is already running; if yes, do nothing and terminate helper app
    BOOL alreadyRunning = NO;
    NSArray *running = [[NSWorkspace sharedWorkspace] runningApplications];
    for (NSRunningApplication *app in running) {
        if ([[app bundleIdentifier] isEqualToString:@"com.bittrends.bittrends"]) {
            alreadyRunning = YES;
        }
    }
    
    if (!alreadyRunning) {
        NSLog(@"not already running");
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSArray *p = [path pathComponents];
        NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:p];
        [pathComponents removeLastObject];
        [pathComponents removeLastObject];
        [pathComponents removeLastObject];
        [pathComponents addObject:@"MacOS"];
        [pathComponents addObject:@"bittrends"];
        NSString *newPath = [NSString pathWithComponents:pathComponents];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:@"bittrends"], NSWorkspaceLaunchConfigurationArguments, nil];
        [[NSWorkspace sharedWorkspace] launchApplicationAtURL:[NSURL fileURLWithPath:newPath]
                                                      options:NSWorkspaceLaunchWithoutActivation
                                                configuration:dict
                                                        error:nil];
    }
    [NSApp terminate:nil];
}

@end
