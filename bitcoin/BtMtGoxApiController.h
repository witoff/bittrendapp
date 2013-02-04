//
//  BtSocketIOController.h
//  bitcoin
//
//  Created by Kevin Greene on 2/3/13.
//  Copyright (c) 2013 Kevin Greene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketIO.h"

#define DEBUGMTGOXAPI 1
#define DEBUGMTGOXAPI_DATA 0

#if DEBUGMTGOXAPI
  #define DEBUGMTGOXAPI_LOG(...) NSLog(__VA_ARGS__)
#else
  #define DEBUGMTGOXAPI_LOG(...)
#endif

#if DEBUGMTGOXAPI_DATA
  #define DEBUGMTGOXAPI_DATA_LOG(...) NSLog(__VA_ARGS__)
#else
  #define DEBUGMTGOXAPI_DATA_LOG(...)
#endif

@protocol BtMtGoxApiDelegate
  - (void)mtGoxPriceDidChangeTo:(NSString *)price;
@end

@interface BtMtGoxApiController : NSObject <SocketIODelegate> {
 @private
  SocketIO *_socket;
  NSObject<BtMtGoxApiDelegate> *_delegate;
}

- (id)initWithDelegate:(NSObject *)delegate;

@end
