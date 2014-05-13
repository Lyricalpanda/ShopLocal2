//
//  Business.m
//  ShopLocal
//
//  Created by Eric Harmon on 3/3/13.
//  Copyright (c) 2013 Eric Harmon. All rights reserved.
//

#import "Business.h"
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>

@implementation Business

@synthesize businessId;
@synthesize name;
@synthesize address1;
@synthesize address2;
@synthesize city;
@synthesize state;
@synthesize zip;
@synthesize latitude;
@synthesize longitude;
@synthesize category;
@synthesize pickup;
@synthesize delivery;
@synthesize url;
@synthesize distance;
@synthesize hours;
@synthesize phoneNumber;

#pragma mark Maps Methods

-(void)openMapsWithDirections{
    Class itemClass = [MKMapItem class];
    self.state = @"NC";
    
    if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.latitude, self.longitude) addressDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:self.state,kABPersonAddressStateKey, self.city, kABPersonAddressCityKey, self.address1, kABPersonAddressStreetKey, nil]]];
        toLocation.name = @"Destination";
        [toLocation setName: [NSString stringWithFormat:@"%@",self.name]];
        [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
                       launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                                                 forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
    }
    
    
}

#pragma mark Address Methods

-(NSString *)address
{
    if ([self.address2 length] !=0){
        return [NSString stringWithFormat:@"%@\n%@\n%@, %@  %d",self.address1, self.address2, self.city, self.state, self.zip];
    }
    else     {
        return [NSString stringWithFormat:@"%@\n%@, %@  %d",self.address1,self.city, self.state, self.zip];
    }
}
@end
