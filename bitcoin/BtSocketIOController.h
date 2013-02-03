//
//  BtSocketIOController.h
//  bitcoin
//
//  Created by Kevin Greene on 2/3/13.
//  Copyright (c) 2013 Kevin Greene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketIO.h"

@interface BtSocketIOController : NSObject <SocketIODelegate> {
 @private
  SocketIO *_socket;
}

- (id)init;

@end
