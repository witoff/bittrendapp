//
//  BtToolbarViewController.m
//  bitcoin
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2013 Kevin Greene & Rob Witoff. All rights reserved.
//

#import "BtStatusItemViewController.h"
#import "BtStartAtLoginController.h"
#import "BTMenuDelegate.h"

@implementation BtStatusItemViewController

- (id)init {
    self = [super init];
    if (self) {
        _statusItem = [[NSStatusBar systemStatusBar]
                       statusItemWithLength:NSVariableStatusItemLength];
        _price = @"฿";
        _statusItemView = [[BtStatusItemView alloc] initWithPrice:_price
                                                    andStatusItem:_statusItem];
        [_statusItem setView:_statusItemView];
        [self createMenu];
        [NSMenu setMenuBarVisible:YES];
    }
    return self;
}

-(void)createMenu {
    logDebug(0, @"adding menu");

    // Create the Menu.
    _menu = [[NSMenu alloc] initWithTitle:@"title"];
    [_menu setDelegate:self];

    _miLastUpdated = [[NSMenuItem alloc] initWithTitle:@"Updated @ ..."
                                                action:@selector(toggleStartup)
                                         keyEquivalent:@""];
    [_menu addItem:_miLastUpdated];

    _miStartup = [[NSMenuItem alloc] initWithTitle:@"Run On Startup"
                                            action:@selector(toggleStartup)
                                     keyEquivalent:@""];
    [_miStartup setTarget:self];

    BtStartAtLoginController *login = [[BtStartAtLoginController alloc] init];
    if ([login willStartAtLogin])
        [_miStartup setState:NSOnState];
    else
        [_miStartup setState:NSOffState];
    [_menu addItem:_miStartup];

    NSMenuItem *miQuit = [[NSMenuItem alloc] initWithTitle:@"Quit"
                                                    action:@selector(quit)
                                             keyEquivalent:@""];
    [miQuit setTarget:self];
    [_menu addItem:miQuit];

    // Register the menu.
    [_statusItemView setMenu:_menu];
    [_statusItem setMenu:_menu];
}

#pragma mark Public Interface

- (void)toggleStartup {
    BtStartAtLoginController *login = [[BtStartAtLoginController alloc] init];

    bool state = _miStartup.state==NSOnState;
    [login setStartAtLogin:!state];

    if ([login willStartAtLogin])
        [_miStartup setState:NSOnState];
    else
        [_miStartup setState:NSOffState];
    
}

-(void)menuWillOpen:(NSMenu *)menu {
    NSAssert([NSThread isMainThread], @"Must run on the main thread");
    [_statusItemView setHighlight:YES];
    [self updateUpdatedLastMenuText];
    [self startLastUpdatedTimer];
}

-(void)menuDidClose:(NSMenu *)menu {
    NSAssert([NSThread isMainThread], @"Must run on the main thread");
    [_statusItemView setHighlight:NO];
    [self stopLastUpdatedTimer];
}

- (void)quit {
    [NSApp terminate:self];
}

- (void)mtGoxPriceDidChangeTo:(NSString *)price {
    _priceLastUpdated = [[NSDate alloc] init];
    [_statusItemView setLastUpdatedTime:_priceLastUpdated];
    if (![_price isEqualToString:price]) {
        _price = [price copy];
        [_statusItemView setPrice:price];
    }
}

- (void)setWarning {
    logInfo(1, @"Setting Warning");

    // Set text Red.
    _statusItemView.textColor = [NSColor redColor];
    [_statusItemView setNeedsDisplay:YES];
    
}
- (void)cancelWarning {
    logInfo(1, @"Canceling Warning");

    // Canceling Warning.
    _statusItemView.textColor = [NSColor blackColor];
    [_statusItemView setNeedsDisplay:YES];
}

#pragma mark Private Methods

- (void)updateUpdatedLastMenuText {
    NSDate *now = [[NSDate alloc] init];
    float deltaSeconds = [now timeIntervalSinceDate:_priceLastUpdated];
    _miLastUpdated.title =
        [NSString stringWithFormat:@"Updated %.1fs ago", deltaSeconds];
}

- (void)lastUpdatedTimerTicked:(NSTimer *)timer {
    [self updateUpdatedLastMenuText];
}

- (void)startLastUpdatedTimer {
    [self stopLastUpdatedTimer];
    _lastUpdatedTimer =
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(lastUpdatedTimerTicked:)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_lastUpdatedTimer
                                 forMode:NSRunLoopCommonModes];
}

- (void)stopLastUpdatedTimer {
    if (_lastUpdatedTimer) {
        [_lastUpdatedTimer invalidate];
        _lastUpdatedTimer = nil;
    }
}

@end
