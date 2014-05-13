//
//  SLParser.h
//  ShopLocal
//
//  Created by Eric Harmon on 3/3/13.
//  Copyright (c) 2013 Eric Harmon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Business.h"
#import "Item.h"

@interface SLParser : NSObject 

+ (Business *) parseBusiness:(NSString *)JSON;
+ (Item *) parseItem:(NSString *) JSON;

@end
