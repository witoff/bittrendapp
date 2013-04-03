//
//  BtceApiController.m
//  litetrends
//
//  Created by Robert Witoff on 4/2/13.
//  Copyright (c) 2013 Kevin Greene. All rights reserved.
//

#import "BtceApiController.h"

@implementation BtceApiController

#define URL @"https://btc-e.com/api/2/ltc_usd/ticker"

- (id)initWithDelegate:(NSObject<BtceApiDelegate> *)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

-(void) poll {
    NSURL * url = [NSURL URLWithString:URL];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    NSURLConnection * connection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
    
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge]; }

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    NSError *error = nil;
    id object = [NSJSONSerialization
                 JSONObjectWithData:data
                 options:0
                 error:&error];
    
    NSDictionary *results = nil;
    if([object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *d = object;
        if ([d objectForKey:@"ticker"])
        {
            d = [d objectForKey:@"ticker"];
            results = d;
            NSLog(@"%@", results);
        }

    }
    [_delegate btceDataDidChangeTo:results];
}


@end
