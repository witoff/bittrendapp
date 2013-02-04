//
//  BtSocketIOController.m
//  bitcoin
//
//  Created by Kevin Greene on 2/3/13.
//  Copyright (c) 2013 Kevin Greene. All rights reserved.
//

#import "BtMtGoxApiController.h"
#import "SocketIOPacket.h"

static NSString *CHANNELID_TRADES = @"dbf1dee9-4f2e-4a08-8cb7-748919a71b21";
static NSString *CHANNELID_TICKER = @"d5f06780-30a8-4a48-a2f8-7ed181b4a13f";
static NSString *CHANNELID_DEPTH  = @"24e67e0d-1cad-4cc0-9e7a-f8523ef460fe";

// Notification that the user is subscribed/unsubscribed to a channel.
static NSString *OPTYPE_SUBSCRIBE   = @"subscribe";
static NSString *OPTYPE_UNSUBSCRIBE = @"unsubscribe";
// A server message, usually a warning.
static NSString *OPTYPE_REMARK = @"remark";
//The operation for depth, trade, and ticker messages.
static NSString *OPTYPE_PRIVATE = @"private";
// The response for op:call operations.
static NSString *OPTYPE_RESULT = @"result";

@implementation BtMtGoxApiController

- (id)initWithDelegate:(NSObject<BtMtGoxApiDelegate> *)delegate {
  self = [super init];
  if (self) {
    DEBUGMTGOXAPI_LOG(@"MtGox SocketIO connecting...");
    _delegate = delegate;
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
  DEBUGMTGOXAPI_LOG(@"MtGox SocketIO connected");
}

- (void)socketIODidDisconnect:(SocketIO *)socket
        disconnectedWithError:(NSError *)error {
  if (!error) {
    DEBUGMTGOXAPI_LOG(@"MtGox SocketIO disconnected");
  } else {
    DEBUGMTGOXAPI_LOG(@"MtGox SocketIO disconnected with error \"%@\"",
        [error localizedDescription]);
  }
}

- (void)socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet {
  DEBUGMTGOXAPI_DATA_LOG(@"MtGox SocketIO received JSON %@", packet.data);
  [self parseJSONResponse:[packet dataAsJSON]];
}

- (void)socketIO:(SocketIO *)socket onError:(NSError *)error {
  NSLog(@"MtGox SocketIO error \"%@\"", [error localizedDescription]);
}

#pragma mark Private Methods

- (NSString *)parseJSONResponse:(NSDictionary *)jsonObject {
  if (!jsonObject) {
    return nil;
  }
  NSString *displayPrice = nil;

  // TODO(kgk): Handle all operation types and channel ids.
  NSString *operationType = [jsonObject valueForKey:@"op"];
  if ([operationType isEqualToString:OPTYPE_PRIVATE]) {
    NSString *channelId = [jsonObject valueForKey:@"channel"];
    if ([channelId isEqualToString:CHANNELID_TICKER]) {
      displayPrice = [[[jsonObject valueForKey:@"ticker"]
                                   valueForKey:@"avg"]
                                   valueForKey:@"display_short"];
    }
  }

  if (displayPrice &&
      [_delegate respondsToSelector:@selector(mtGoxPriceDidChangeTo:)]) {
    [_delegate mtGoxPriceDidChangeTo:displayPrice];
  }
  return nil;
}

@end
