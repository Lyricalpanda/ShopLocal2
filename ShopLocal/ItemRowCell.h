//
//  ItemRowCell.h
//  ShopLocal
//
//  Created by Eric Harmon on 3/3/13.
//  Copyright (c) 2013 Eric Harmon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemRowCell : UITableViewCell

@property IBOutlet UIImageView *itemImage;
@property IBOutlet UILabel *itemName;
@property IBOutlet UIImageView *greyOverlay;
@property IBOutlet UILabel *itemPrice;

@end
