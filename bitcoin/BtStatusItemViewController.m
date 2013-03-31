;//
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
        _priceLastUpdated = nil;
        _statusItem = [[NSStatusBar systemStatusBar]
                       statusItemWithLength:NSVariableStatusItemLength];
        _lastPriceData = qDict(@"฿", @"last");
        _statusItemView = [[BtStatusItemView alloc] initWithPriceData:_lastPriceData
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
    
    /* LAST UPDATED */
    _miLastUpdated = [[NSMenuItem alloc] initWithTitle:@"Connecting..."
                                                action:nil keyEquivalent:@""];
    [_menu addItem:_miLastUpdated];
    [_menu addItem:[NSMenuItem separatorItem]];
    
    /* TICKER VALUES */
    _miBuy = [[NSMenuItem alloc] initWithTitle:@"Buy: ..."
                                        action:@selector(didSelectTickerKey:) keyEquivalent:@""];
    [_miBuy setTarget:self];
    [_menu addItem:_miBuy];
    
    _miLast = [[NSMenuItem alloc] initWithTitle:@"Last: ..."
                                         action:@selector(didSelectTickerKey:) keyEquivalent:@""];
    [_miLast setTarget:self];
    [_menu addItem:_miLast];
    
    _miSell = [[NSMenuItem alloc] initWithTitle:@"Sell: ..."
                                         action:@selector(didSelectTickerKey:) keyEquivalent:@""];
    [_miSell setTarget:self];
    [_menu addItem:_miSell];
    
    [_menu addItem:[NSMenuItem separatorItem]];
    
    _miLow = [[NSMenuItem alloc] initWithTitle:@"Low: ..."
                                        action:@selector(didSelectTickerKey:) keyEquivalent:@""];
    [_miLow setTarget:self];
    [_menu addItem:_miLow];
    
    _miHigh = [[NSMenuItem alloc] initWithTitle:@"High: ..."
                                         action:@selector(didSelectTickerKey:) keyEquivalent:@""];
    [_miHigh setTarget:self];
    [_menu addItem:_miHigh];
    
    [_menu addItem:[NSMenuItem separatorItem]];
    _allSelectableMenuItems = qDict(_miBuy, @"buy", _miLast, @"last", _miSell, @"sell", _miLow, @"low", _miHigh, @"high");
    [self checkDisplayed];
    
    /* Extras */
    /*
     _miAlerts = [[NSMenuItem alloc] initWithTitle:@"Alerts" action:@selector(toggleStartup) keyEquivalent:@""];
     [_menu addItem:_miAlerts];
     [_miAlerts setTarget:self];
     */
    
    /* LINKS */
    [_menu addItem:[self getLinkMenu]];
    
    [_menu addItem:[NSMenuItem separatorItem]];
    
    
    /* START ON LOGIN */
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
    
    /* QUIT */
    NSMenuItem *miQuit = [[NSMenuItem alloc] initWithTitle:@"Quit"
                                                    action:@selector(quit)
                                             keyEquivalent:@""];
    [miQuit setTarget:self];
    [_menu addItem:miQuit];
    
    // Register the menu.
    [_statusItemView setMenu:_menu];
    [_statusItem setMenu:_menu];
}

- (NSMenuItem*)getLinkMenu {
    _links = qDict(@"http://www.coinbase.com", @"Coinbase",
                   @"http://www.mtgox.com", @"MtGox",
                   @"http://mtgoxlive.com/orders)", @"MtGox Live",
                   @"http://bitcoincharts.com/charts/mtgoxUSD#rg10zig5-minztgSzbgBza1gEMAzm1g10za2gEMAzm2g25zv", @"Bitcoin Charts",
                   @"http://blockchain.info/stats", @"Blockchain.info - Stats");
    
    
    
    _miLinks = [[NSMenuItem alloc] initWithTitle:@"Links" action:nil keyEquivalent:@""];
    NSMenu* linkMenu = [[NSMenu alloc] initWithTitle:@"Links"];
    for (NSString *key in [_links keyEnumerator]) {
        NSMenuItem *mi = [[NSMenuItem alloc] initWithTitle:key action:@selector(openUrl:) keyEquivalent:@""];
        [mi setTarget:self];
        [linkMenu addItem:mi];
    }
    [_miLinks setSubmenu:linkMenu];
    return _miLinks;
}

#pragma mark Public Interface

/* On startup, check the correct ticker key in the menu */
- (void)checkDisplayed {
    NSString *selectedKey = [self getTickerKey];
    for (NSString *key in [_allSelectableMenuItems keyEnumerator]) {
        NSMenuItem *item = [_allSelectableMenuItems valueForKey:key];
        if ([key isEqualToString:selectedKey])
            [item setState:YES];
        else
            [item setState:NO];
    }
}



- (void)didSelectTickerKey:(NSMenuItem*)sender {
    logInfo(YES, @"displayed: %@", sender.title);
    
    NSString *selectedKey = nil;
    for (NSString *key in [_allSelectableMenuItems keyEnumerator]) {
        NSMenuItem *item = [_allSelectableMenuItems valueForKey:key];
        if (sender == item) {
            selectedKey = key;
            [item setState:YES];
        }
        else
            [item setState:NO];
        
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:selectedKey forKey:@"SELECTED_TICKER"];
    [defaults synchronize];
    
    //Refresh view because displayed text may be different now
    [self updateStatusItem];
}

- (NSString*)getTickerKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* selected = [defaults valueForKey:@"SELECTED_TICKER"];
    return selected ? selected : @"last";
}

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

- (void)mtGoxDataDidChangeTo:(NSDictionary *)newData {
    _priceLastUpdated = [[NSDate alloc] init];
    [_statusItemView setLastUpdatedTime:_priceLastUpdated];
    
    /* UPDATE MENU */
    [_miBuy setTitle: [NSString stringWithFormat:@"Buy: \t%@", [newData valueForKey:@"buy"]]];
    [_miLast setTitle:[NSString stringWithFormat:@"Last: \t%@", [newData valueForKey:@"last"]]];
    [_miSell setTitle:[NSString stringWithFormat:@"Sell: \t%@", [newData valueForKey:@"sell"]]];
    [_miLow setTitle: [NSString stringWithFormat:@"Low: \t%@", [newData valueForKey:@"low"]]];
    [_miHigh setTitle:[NSString stringWithFormat:@"High: \t%@", [newData valueForKey:@"high"]]];
    
    /* UPDATE STATUS BAR */
    NSString *oldPrice = [_lastPriceData valueForKey:[self getTickerKey]];
    NSString *newPrice = [newData valueForKey:[self getTickerKey]];
    _lastPriceData = [newData copy];  //TODO: Deep Copy
    
    if (![oldPrice isEqualToString:newPrice]) {
        [self updateStatusItem];
    }
    else {
        logInfo(YES, @"not updated!!\n\n");
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

- (void)updateStatusItem {
    logInfo(YES, @"updating status item");
    [_statusItemView setPrice:[_lastPriceData valueForKey:[self getTickerKey]]];
    [_statusItemView setNeedsDisplay:YES];
}

#pragma mark Private Methods

- (void)updateUpdatedLastMenuText {
    if (!_priceLastUpdated) {
        _miLastUpdated.title = @"Connecting....";
        
    }
    else {
        NSDate *now = [[NSDate alloc] init];
        float deltaSeconds = [now timeIntervalSinceDate:_priceLastUpdated];
        _miLastUpdated.title =
        [NSString stringWithFormat:@"Updated %.1fs ago", deltaSeconds];
    }
}

- (void)lastUpdatedTimerTicked:(NSTimer *)timer {
    [self updateUpdatedLastMenuText];
}

- (void)startLastUpdatedTimer {
    [self stopLastUpdatedTimer];
    _lastUpdatedTimer =
    [NSTimer scheduledTimerWithTimeInterval:0.1
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

-(void)openUrl:(NSMenuItem*)sender {
    NSString* url = [_links valueForKey:sender.title];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
}

@end
