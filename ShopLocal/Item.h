//
//  Item.h
//  ShopLocal
//
//  Created by Eric Harmon on 3/3/13.
//  Copyright (c) 2013 Eric Harmon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property int businessId;
@property int itemId;
@property int category;
@property int quantity;
@property float price;
@property NSString *name;
@property NSString *url;

@end
