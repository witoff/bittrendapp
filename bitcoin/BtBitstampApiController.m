//
//  BtBitstampApiController.m
//  bittrends
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2014 Kevin Greene & Rob Witoff. All rights reserved.
//

#import "BtBitstampApiController.h"

#import "PTPusher.h"
#import "PTPusherChannel.h"
#import "PTPusherDelegate.h"
#import "PTPusherEvent.h"

@interface BtBitstampApiController ()<PTPusherDelegate>
@end

@implementation BtBitstampApiController {
  PTPusher *_client;
  PTPusherChannel *_channel;
  id<BtBitstampApiDelegate> _delegate;
}

- (id)initWithDelegate:(id<BtBitstampApiDelegate>)delegate {
  self = [super init];
  if (self) {
    _delegate = delegate;
    _client = [PTPusher pusherWithKey:@"de504dc5763aeef9ff52" delegate:self encrypted:YES];
    _client.reconnectAutomatically = YES;
    _client.reconnectDelay = 10;
    [_client connect];
  }
  return self;
}

- (void)dealloc {
  [_client disconnect];
  _channel = nil;
}

#pragma mark PTPusherDelegate

- (void)pusher:(PTPusher *)pusher connectionDidConnect:(PTPusherConnection *)connection {
  _channel = [_client subscribeToChannelNamed:@"live_trades"];
  [_channel bindToEventNamed:@"trade" handleWithBlock:^(PTPusherEvent *event) {
    [_delegate bitstampDataDidChangeTo:event.data];
  }];
}

@end
