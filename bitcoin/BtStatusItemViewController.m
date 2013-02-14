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
        _statusItemText = @"฿";
        _statusItemView = [[BtStatusItemView alloc] initWithText:_statusItemText
                                                   andStatusItem: _statusItem];

        [self addMenu];
        [NSMenu setMenuBarVisible:YES];

        [_statusItem setView:_statusItemView];
    }
    return self;
}

-(void)addMenu {
    logDebug(0, @"adding menu");

    //Create the Menu
    _menu = [[NSMenu alloc] initWithTitle:@"title"];
    [_menu setDelegate:self];

    _miLastUpdated = [[NSMenuItem alloc] initWithTitle:@"Updated @ ..." action:@selector(toggleStartup) keyEquivalent:@""];
    [_menu addItem:_miLastUpdated];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];

    _miStartup = [[NSMenuItem alloc] initWithTitle:@"Run On Startup" action:@selector(toggleStartup) keyEquivalent:@""];
    [_miStartup setTarget:self];

    BtStartAtLoginController *login = [[BtStartAtLoginController alloc] init];
    if ([login willStartAtLogin])
        [_miStartup setState:NSOnState];
    else
        [_miStartup setState:NSOffState];
    [_menu addItem:_miStartup];

    NSMenuItem *miQuit = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(quit) keyEquivalent:@""];
    [miQuit setTarget:self];
    [_menu addItem:miQuit];

    // Register the menu.
    [_statusItemView setMenu:_menu];
    [_statusItem setMenu:_menu];
}

-(void)timerTicked:(NSTimer*)timer {
    logInfo(0, @"ticking");
    NSDate *now = [[NSDate alloc] init];
    float deltaSeconds = [now timeIntervalSinceDate:_statusItemView.lastUpdated];
    _miLastUpdated.title = [NSString stringWithFormat:@"Updated %.2fs ago", deltaSeconds];
    
    
    // Fade out even more when starts getting stale.  
    if (floor(deltaSeconds) == 60)
        [_statusItemView setTextAlpha:.4 doAnimate:YES];
    if (floor(deltaSeconds) == 90)
        [_statusItemView setTextAlpha:.2 doAnimate:YES];
}

#pragma mark public interface

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
    logInfo(1, @"Menu will open");
    [_statusItemView setHighlight:YES];
}

-(void)menuDidClose:(NSMenu *)menu {
    logInfo(1, @"Menu Closed");
    [_statusItemView setHighlight:NO];
}

- (void)quit {
    [NSApp terminate:self];
}

- (void)setText:(NSString *)text {
    if (![_statusItemText isEqualToString:text]) {
        _statusItemText = [text copy];
        [_statusItemView setText:text];
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

@end
