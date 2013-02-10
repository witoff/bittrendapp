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

@protocol BtMtGoxApiDelegate
- (void)mtGoxPriceDidChangeTo:(NSString *)price;
- (void)mtGoxDidDisconnect;
@end

@interface BtMtGoxApiController : NSObject <SocketIODelegate> {
@private
    SocketIO *_socket;
    NSObject<BtMtGoxApiDelegate> *_delegate;
}

- (id)initWithDelegate:(NSObject *)delegate;

/* Tearing down this object to reconnect fresh.  Shutodwn connections */
- (void)invalidate;

@end
