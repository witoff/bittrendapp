//
//  BtceApiController.h
//  litetrends
//
//  Created by Robert Witoff on 4/2/13.
//  Copyright (c) 2013 Kevin Greene. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BtceApiDelegate

- (void)btceDataDidChangeTo:(NSDictionary*)data;

@end

@interface BtceApiController : NSObject<NSURLConnectionDelegate> {
@private
    NSObject<BtceApiDelegate> *_delegate;
}

- (id)initWithDelegate:(NSObject *)delegate;

-(void) poll;

@end
