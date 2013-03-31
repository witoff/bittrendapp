//
//  BtStartAtLoginController.m
//  bitcoin
//
//  Created by Robert Witoff on 2/8/13.
//  Copyright (c) 2013 Kevin Greene & Rob Witoff. All rights reserved.
//  -fno-objc-arc

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

/*
 NSBundle *loginItemBundle = [NSBundle bundleWithURL:loginItemURL];
 if (loginItemBundle == nil) {
 if (errorp != NULL) {
 *errorp = [NSError errorWithDomain:NSPOSIXErrorDomain code:EINVAL userInfo:@{
 NSLocalizedFailureReasonErrorKey: @"failed to load bundle",
 NSURLErrorKey: loginItemURL
 }];
 }
 return nil;
 }
 
 // Lookup the bundle identifier for the login item.
 // LaunchServices implicitly registers a mach service for the login
 // item whose name is the name as the login item's bundle identifier.
 NSString *loginItemBundleId = [loginItemBundle bundleIdentifier];
 if (loginItemBundleId == nil) {
 if (errorp != NULL) {
 *errorp = [NSError errorWithDomain:NSPOSIXErrorDomain code:EINVAL userInfo:@{
 NSLocalizedFailureReasonErrorKey: @"bundle has no identifier",
 NSURLErrorKey: loginItemURL
 }];
 }
 return nil;
 }
 
 // The login item's file name must match its bundle Id.
 NSString *loginItemBaseName = [[loginItemURL lastPathComponent] stringByDeletingPathExtension];
 if (![loginItemBundleId isEqualToString:loginItemBaseName]) {
 if (errorp != NULL) {
 NSString *message = [NSString stringWithFormat:@"expected bundle identifier \"%@\" for login item \"%@\", got \"%@\"",
 loginItemBaseName, loginItemURL,loginItemBundleId];
 *errorp = [NSError errorWithDomain:NSPOSIXErrorDomain code:EINVAL userInfo:@{
 NSLocalizedFailureReasonErrorKey: @"bundle identifier does not match file name",
 NSLocalizedDescriptionKey: message,
 NSURLErrorKey: loginItemURL
 }];
 }
 return nil;
 }
 
 // Enable the login item.
 // This will start it running if it wasn't already running.
 if (!SMLoginItemSetEnabled((__bridge CFStringRef)loginItemBundleId, true)) {
 if (errorp != NULL) {
 *errorp = [NSError errorWithDomain:NSPOSIXErrorDomain code:EINVAL userInfo:@{
 NSLocalizedFailureReasonErrorKey: @"SMLoginItemSetEnabled() failed"
 }];
 }
 return nil;
 }
*/

+ (BOOL) willStartAtLogin:(NSURL *)itemURL {
 
    
    NSString *bundleID = @"com.madebynotion.myLoginHelper";
    NSArray * jobDicts = nil;
    jobDicts = (NSArray *)SMCopyAllJobDictionaries( kSMDomainUserLaunchd );
    // Note: Sandbox issue when using SMJobCopyDictionary()
    
    if ( (jobDicts != nil) && [jobDicts count] > 0 ) {
        
        BOOL bOnDemand = NO;
        
        for ( NSDictionary * job in jobDicts ) {
            
            if ( [bundleID isEqualToString:[job objectForKey:@"Label"]] ) {
                bOnDemand = [[job objectForKey:@"OnDemand"] boolValue];
                break;
            }
        }
        
        CFRelease((CFDictionaryRef)jobDicts); jobDicts = nil;
        return bOnDemand;
        
    }
    return NO;

}

+ (void) setStartAtLogin:(NSURL *)itemURL enabled:(BOOL)enabled {
    // OSStatus status;
    logDebug(YES, @"setstart %d", enabled);
    
    /*
     if (!SMLoginItemSetEnabled((__bridge CFStringRef)loginItemBundleId, true)) {
     if (errorp != NULL) {
     *errorp = [NSError errorWithDomain:NSPOSIXErrorDomain code:EINVAL userInfo:@{
     NSLocalizedFailureReasonErrorKey: @"SMLoginItemSetEnabled() failed"
     }];
     }
     return nil;
     }
     */
    
    LSSharedFileListItemRef existingItem = NULL;
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (loginItems) {
        logInfo(YES, @"login items found");
        UInt32 seed = 0U;
        NSArray *currentLoginItems = [NSMakeCollectable(LSSharedFileListCopySnapshot(loginItems, &seed)) autorelease];
        for (id itemObject in currentLoginItems) {
            LSSharedFileListItemRef item = (LSSharedFileListItemRef)itemObject;
            
            UInt32 resolutionFlags = kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes;
            CFURLRef URL = NULL;
            OSStatus err = LSSharedFileListItemResolve(item, resolutionFlags, &URL, /*outRef*/ NULL);
            if (err == noErr) {
                Boolean foundIt = CFEqual(URL, itemURL);
                CFRelease(URL);
                
                if (foundIt) {
                    logDebug(YES, @"existing item was found.  Breaking");
                    existingItem = item;
                    break;
                }
            }
            else {
                logWarn(@"Error found in file list resolution");
            }
            
        }
        
        if (enabled && (existingItem == NULL)) {
            logDebug(YES, @"Inserting new item into file list");
            LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemBeforeFirst,
                                          NULL, NULL, (CFURLRef)itemURL, NULL, NULL);
            
        } else if (!enabled && (existingItem != NULL))
            LSSharedFileListItemRemove(loginItems, existingItem);
        else {
            logWarn(@"Existing Item was not matched");
        }
        
        CFRelease(loginItems);
    }
}

@end
