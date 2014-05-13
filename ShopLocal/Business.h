//
//  Business.h
//  ShopLocal
//
//  Created by Eric Harmon on 3/3/13.
//  Copyright (c) 2013 Eric Harmon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject

@property int businessId;
@property int zip;
@property int category;
@property float distance;
@property float latitude;
@property float longitude;
@property NSString *name;
@property NSString *address1;
@property NSString *address2;
@property NSString *city;
@property NSString *state;
@property NSString *url;
@property NSString *phoneNumber;
@property NSString *hours;
//Not currently implemented
@property BOOL pickup;
@property BOOL delivery;

-(void)openMapsWithDirections;
-(NSString *)address;

@end
