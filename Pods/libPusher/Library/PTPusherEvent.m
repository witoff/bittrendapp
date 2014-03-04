//
//  PTPusherEvent.m
//  PusherEvents
//
//  Created by Luke Redpath on 22/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "PTPusherEvent.h"
#import "PTJSON.h"

NSString *const PTPusherDataKey    = @"data";
NSString *const PTPusherEventKey   = @"event";
NSString *const PTPusherChannelKey = @"channel";

@implementation PTPusherEvent

@synthesize name = _name;
@synthesize data = _data;
@synthesize channel = _channel;
@synthesize timeReceived = _timeReceived;

+ (id)eventFromMessageDictionary:(NSDictionary *)dictionary
{
  if ([[dictionary objectForKey:PTPusherEventKey] isEqualToString:@"pusher:error"]) {
    return [[PTPusherErrorEvent alloc] initWithEventName:[dictionary objectForKey:PTPusherEventKey] channel:nil data:[dictionary objectForKey:PTPusherDataKey]];
  }
  return [[self alloc] initWithEventName:[dictionary objectForKey:PTPusherEventKey] channel:[dictionary objectForKey:PTPusherChannelKey] data:[dictionary objectForKey:PTPusherDataKey]];
}

- (id)initWithEventName:(NSString *)name channel:(NSString *)channel data:(id)data
{
  if (self = [super init]) {
    _name = [name copy];
    _channel = [channel copy];
    _timeReceived = [NSDate date];
    
    // try and deserialize the data as JSON if possible
    if ([data respondsToSelector:@selector(dataUsingEncoding:)]) {
      _data = [[[PTJSON JSONParser] objectFromJSONString:data] copy];

      if (_data == nil) {
        NSLog(@"[pusher] Error parsing event data (not JSON?)");
        _data = [data copy];
      }
    }
    else {
      _data = [data copy];
    }
  }
  return self;
}


- (NSString *)description
{
  return [NSString stringWithFormat:@"<PTPusherEvent channel:%@ name:%@ data:%@>", self.channel, self.name, self.data];
}

@end

#pragma mark -

@implementation PTPusherErrorEvent

- (NSString *)message
{
  return [self.data objectForKey:@"message"];
}

- (NSInteger)code
{
  id eventCode = [self.data objectForKey:@"code"];

  if (eventCode == nil || eventCode == [NSNull null]) {
    return PTPusherErrorUnknown;
  }
  return [eventCode integerValue];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"<PTPusherErrorEvent code:%d message:%@>", self.code, self.message];
}

@end
