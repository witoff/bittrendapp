//
//  BtBitstampApiController.h
//  bittrends
//
//  Created by Kevin Greene on 2/2/13.
//  Copyright (c) 2014 Kevin Greene & Rob Witoff. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BtBitstampApiDelegate<NSObject>
- (void)bitstampDataDidChangeTo:(NSDictionary *)data;
@end

@interface BtBitstampApiController : NSObject
- (id)initWithDelegate:(id<BtBitstampApiDelegate>)delegate;
@end
