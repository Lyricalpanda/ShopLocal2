//
//  SLBusinessViewController.h
//  ShopLocal
//
//  Created by Eric Harmon on 3/3/13.
//  Copyright (c) 2013 Eric Harmon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"
#import "SLEngine.h"
#import "Item.h"

@interface SLBusinessViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) Business *business;
-(IBAction)directionsToBusiness;

@end
