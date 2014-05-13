//
//  SLBusinessMap.h
//  ShopLocal
//
//  Created by Eric Harmon on 3/3/13.
//  Copyright (c) 2013 Eric Harmon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SLEngine.h"
#import "Business.h"

@interface SLBusinessMap : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>

- (IBAction)toggleViews;
- (IBAction)segmentedControlIndexChanged;

@end
