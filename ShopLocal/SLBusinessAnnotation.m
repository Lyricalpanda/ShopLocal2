//
//  BusinessAnnotation.m
//  ShopLocal
//
//  Created by Eric Harmon on 3/3/13.
//  Copyright (c) 2013 Eric Harmon. All rights reserved.
//

#import "SLBusinessAnnotation.h"

@implementation SLBusinessAnnotation
@synthesize business = _business;
@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address andCoordinate:(CLLocationCoordinate2D)coordinate
{
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
    }
    return self;
}

- (id)initWithBusiness:(Business*)business
{
    if ((self = [super init])) {
        _business = business;
        _name = _business.name;
        _address = _business.address1;;
        _coordinate.latitude = [[NSNumber numberWithFloat:_business.latitude] doubleValue];
        _coordinate.longitude = [[NSNumber numberWithFloat:_business.longitude] doubleValue];
    }
    return self;
}

- (NSString *)title
{
    return _name;
}

- (NSString *)subtitle
{
    return _address;
}

@end
