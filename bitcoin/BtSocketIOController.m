//
//  BtSocketIOController.m
//  bitcoin
//
//  Created by Kevin Greene on 2/3/13.
//  Copyright (c) 2013 Kevin Greene. All rights reserved.
//

#import "BtSocketIOController.h"

@implementation BtSocketIOController

- (id)init {
  self = [super init];
  if (self) {
    _socket = [[SocketIO alloc] initWithDelegate:self];
    [_socket setUseSecure:YES];
    [_socket connectToHost:@"socketio.mtgox.com"
                    onPort:443
                withParams:nil
             withNamespace:@"/mtgox"];
  }
  return self;
}

#pragma mark SocketIODelegate callbacks

- (void)socketIODidConnect:(SocketIO *)socket {
  NSLog(@"SocketIO connected");
}

- (void)socketIODidDisconnect:(SocketIO *)socket
        disconnectedWithError:(NSError *)error {
  if (!error) {
    NSLog(@"SocketIO disconnected");
  } else {
    NSLog(@"SocketIO disconnected with error \"%@\"",
        [error localizedDescription]);
  }
}

- (void)socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet {
  NSLog(@"SocketIO received JSON %@", packet);
}

- (void)socketIO:(SocketIO *)socket onError:(NSError *)error {
  NSLog(@"SocketIO error \"%@\"", [error localizedDescription]);
}

@end
