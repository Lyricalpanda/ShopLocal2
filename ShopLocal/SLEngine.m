//
//  SLEngine.m
//  ShopLocal
//
//  Created by Eric Harmon on 1/31/13.
//  Copyright (c) 2013 Eric Harmon. All rights reserved.
//

#import "SLEngine.h"
#import "SLAppDelegate.h"
#import "constants.h"
#import "AFNetworking.h"

@implementation SLEngine

+ (id) sharedEngine
{
    static AFHTTPSessionManager *sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:kBaseURL];
        sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    return sessionManager;
}


@end
