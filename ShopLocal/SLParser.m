//
//  SLParser.m
//  ShopLocal
//
//  Created by Eric Harmon on 3/3/13.
//  Copyright (c) 2013 Eric Harmon. All rights reserved.
//

#import "SLParser.h"
#import "Business.h"
#import "Item.h"

@implementation SLParser

+(Business *) parseBusiness:(NSString *)JSON
{
    Business *result = [[Business alloc] init];
    result.name = [JSON valueForKey:@"name"];
    result.address1 = [JSON valueForKey:@"address_line1"];
    result.address2 = [JSON valueForKey:@"address_line2"];
    result.city = [JSON valueForKey:@"city"];
    result.latitude = [[JSON valueForKey:@"latitude"] floatValue];
    result.longitude = [[JSON valueForKey:@"longitude"] floatValue];
    result.state = [JSON valueForKey:@"state"];
    result.url = [JSON valueForKey:@"logo_url"];
    result.phoneNumber = [JSON valueForKey:@"phone"];
    result.hours = [JSON valueForKey:@"hours"];
    result.state = @"NC";
    result.zip = [[JSON valueForKey:@"zip"] intValue];
    result.category = [[JSON valueForKey:@"category"] intValue];
    result.businessId = [[JSON valueForKey:@"id"] intValue];
    return result;
}

+ (Item *) parseItem:(NSString *)JSON
{
    Item *item = [[Item alloc] init];    
    item.name = [JSON valueForKey:@"name"];
    item.itemId = [[JSON valueForKey:@"id"] intValue];
    item.businessId = [[JSON valueForKey:@"business_id"] intValue];
    item.category = [[JSON valueForKey:@"category"] intValue];
    item.quantity = [[JSON valueForKey:@"quantity"] intValue];
    item.price = [[JSON valueForKey:@"price"] floatValue];
    item.url = [JSON valueForKey:@"image_url"];
    return item;
}

@end
