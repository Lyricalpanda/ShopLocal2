//
//  SLItemViewController.m
//  ShopLocal
//
//  Created by Eric Harmon on 3/3/13.
//  Copyright (c) 2013 Eric Harmon. All rights reserved.
//

#import "SLItemViewController.h"

@interface SLItemViewController ()
{
    IBOutlet UIImageView *itemWebViewImage;
    IBOutlet UILabel *itemName;
    IBOutlet UILabel *itemPrice;
    IBOutlet UILabel *itemAvailability;
}

@end

@implementation SLItemViewController

@synthesize item;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];

    itemPrice.text = [NSString stringWithFormat:@"Price: %.2f",item.price];
    itemName.text = item.name;
    
    if (item.quantity > 0)
        itemAvailability.text = @"Available!";
    else
        itemAvailability.text = @"Out of Stock!";
    
    self.navigationController.title = item.name;    
    [super viewDidLoad];
    [itemWebViewImage setImageWithURL:[NSURL URLWithString:item.url]];
}

@end
