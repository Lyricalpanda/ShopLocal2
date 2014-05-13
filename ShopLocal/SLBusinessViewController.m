//
//  SLBusinessViewController.m
//  ShopLocal
//
//  Created by Eric Harmon on 3/3/13.
//  Copyright (c) 2013 Eric Harmon. All rights reserved.
//

#import "SLBusinessViewController.h"
#import "Item.h"
#import "SLParser.h"
#import "ItemRowCell.h"
#import "SLItemViewController.h"
#import "AFNetworking.h"

@interface SLBusinessViewController ()
{
    IBOutlet UILabel *phoneNumber;
    IBOutlet UILabel *hours;
    IBOutlet UITableView *businessTableView;
    IBOutlet UIImageView *businessWebImageView;
    IBOutlet UITextView *addressTextView;
    IBOutlet UIView *businessView;
    IBOutlet UIButton *directionsButton;   

    SLEngine *sharedEngine;
    NSMutableArray *items;
    Item *selectedItem;
}

@end

@implementation SLBusinessViewController

@synthesize business = _business;

- (void)viewDidLoad
{
    sharedEngine = [SLEngine sharedEngine];
    [directionsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    businessTableView.backgroundColor = [UIColor clearColor];

    addressTextView.text = [NSString stringWithFormat:@"%@",[_business address]];
    hours.text = [NSString stringWithFormat:@"Business Hours: %@",_business.hours];
    //Subbed out
    phoneNumber.text = [NSString stringWithFormat:@"Phone 919-521-9284"];
    
    items = [[NSMutableArray alloc] init];
    
    [businessWebImageView setImageWithURL:[NSURL URLWithString:_business.url]];
    
    self.navigationItem.title = _business.name;
    
    AFHTTPSessionManager *manager = [SLEngine sharedEngine];

    [manager GET:[NSString stringWithFormat:@"/api/businesses/%d/items",_business.businessId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {        
        [self parseItems:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Boo!");
    }];
    
//    MKNetworkOperation *_op = [sharedEngine getItemsForBusiness:_business];
//    __weak MKNetworkOperation *op=_op;
//    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
//     {
//         [self parseItems:[[op responseString] JSONValue]];
//     }errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//         NSLog(@"Error: %@", error.description);
//         NSLog(@"Did not download file");
//     }];

//    [sharedEngine enqueueOperation:op];
    
    [super viewDidLoad];
}

#pragma mark - API Parsing Method

- (void) parseItems:(NSArray *) json
{
    [items removeAllObjects];
    for (int i = 0; i < [json count]; i++)
    {
        Item *item = [SLParser parseItem:[json objectAtIndex:i]];
        [items addObject:item];
    }
    
    [businessTableView reloadData];
}

#pragma mark - Open Directions Method

- (IBAction)directionsToBusiness
{
    [_business openMapsWithDirections];
}

#pragma mark - Table View Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    ItemRowCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        
        UINib *quoteCellNib = [UINib nibWithNibName:@"ItemCell" bundle:nil];
        [quoteCellNib instantiateWithOwner:self options:nil];
    }
    
    // Configure the cell...
    Item *currentItem = [items objectAtIndex:indexPath.row];
    NSString *ImageURL = currentItem.url;
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    cell.itemImage.image = [UIImage imageWithData:imageData];
    [cell.itemImage setImageWithURL:[NSURL URLWithString:currentItem.url]];
    cell.itemName.text = currentItem.name;
    
    cell.itemPrice.text = [NSString stringWithFormat:@"$%.2f",currentItem.price];
    cell.greyOverlay.image = [UIImage imageNamed:@"product_title_bg.png"];
    
    UIImage* backgroundImage;
    UIImage* selectedBackgroundImage;
    UIImageView *backgroundImageView  =[[UIImageView alloc] initWithFrame: cell.frame];
    UIImageView *selectedBackgroundImageView  =[[UIImageView alloc] initWithFrame: cell.frame];
    backgroundImage = [[UIImage imageNamed:@"product_square.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 99, 21, 99)];
    selectedBackgroundImage = [[UIImage imageNamed:@"product_square.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 99, 21, 99)];
    cell.backgroundColor = [UIColor clearColor];
    
    backgroundImageView.image = backgroundImage;
    selectedBackgroundImageView.image=selectedBackgroundImage;
    cell.selectedBackgroundView = selectedBackgroundImageView;
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    cell.backgroundView = backgroundImageView;
    
    cell.itemName.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:22.0];
    cell.itemPrice.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:16.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedItem = [items objectAtIndex:indexPath.row];    
    [self performSegueWithIdentifier:@"itemSegue" sender:self];    
}

#pragma mark - Segue Delegate Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"itemSegue"]) {
        SLItemViewController *vc = [segue destinationViewController];
        [vc setItem:selectedItem];
    }    
}


@end
