//
//  SLAppDelegate.h
//  ShopLocal
//
//  Created by Harmon, Eric on 5/13/14.
//  Copyright (c) 2014 ShopLocal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SLEngine.h"
#import "AFNetworking.h"

@interface SLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) AFHTTPSessionManager *sharedEngine;
@property (strong, nonatomic) UIWindow *window;

@end
