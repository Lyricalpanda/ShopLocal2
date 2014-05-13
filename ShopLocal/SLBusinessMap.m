//
//  SLBusinessMap.m
//  ShopLocal
//
//  Created by Eric Harmon on 3/3/13.
//  Copyright (c) 2013 Eric Harmon. All rights reserved.
//

#import "SLBusinessMap.h"
#import "BusinessRowCell.h"
#import "SLParser.h"
#import "SLBusinessAnnotation.h"
#import "SLAppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "SLBusinessViewController.h"
#import "AFNetworking.h"

//Constants for distance calculations
#define METERS_PER_MILE 1609.344
#define RADIUS 1

@interface SLBusinessMap ()
{
    IBOutlet UIBarButtonItem *barButton;
    IBOutlet UITableView *businessTableView;
    IBOutlet MKMapView *businessMapView;
    IBOutlet UISegmentedControl *segmentedControl;
    CLLocationManager* locationManager;
    MKCoordinateRegion previousRegion;
    int selectedCategory;
    BOOL isMapShowing;
    SLEngine *sharedEngine;
    Business *selectedBusiness;
    NSMutableArray *businesses;
    NSMutableArray *filteredBusinesses;    
}

@end

@implementation SLBusinessMap

- (void)viewDidLoad
{
    isMapShowing=NO;
    businessMapView.hidden=YES;
    businessMapView.showsUserLocation=YES;
    selectedCategory = 0;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    
    [businessTableView setBackgroundColor:[UIColor clearColor]];
    businesses = [[NSMutableArray alloc] init];
    filteredBusinesses = [[NSMutableArray alloc] init];
           
    [segmentedControl setBackgroundImage:[UIImage imageNamed:@"top-blue-bar.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmentedControl setDividerImage:[UIImage imageNamed:@"divider.png"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    AFHTTPSessionManager *manager = [SLEngine sharedEngine];
    
    [manager GET:@"/api/businesses/" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self parseBusinesses:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Boo!");
    }];
    
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    SLAppDelegate *mainDelegate = (SLAppDelegate *)[[UIApplication sharedApplication]delegate];
    locationManager = mainDelegate.locationManager;
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager setDistanceFilter:10];
    [locationManager startUpdatingLocation];
}

#pragma mark - API Parsing Method

- (void) parseBusinesses:(NSArray *) json
{
    [businesses removeAllObjects];
    
    for (int i = 0; i < [json count]; i++)
    {
        Business *result = [SLParser parseBusiness:[json objectAtIndex:i]];
        [businesses addObject:result];
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    businesses = [NSMutableArray arrayWithArray:[businesses sortedArrayUsingDescriptors:sortDescriptors]];
    filteredBusinesses = businesses;
    
    [self calculateDistances:locationManager.location];
    [self plotBusinesses];
    [businessTableView reloadData];
    [self setDefaultMap];
}

#pragma mark - Map Toggle

-(IBAction)toggleViews
{
    if (isMapShowing)
    {
        barButton.title=@"Map";
        businessMapView.hidden = YES;
        businessTableView.hidden = NO;
        isMapShowing=NO;
    }
    else
    {
        barButton.title=@"List";
        isMapShowing=YES;
        businessMapView.hidden=NO;
        businessTableView.hidden=YES;
    }
}

#pragma mark - MKMap Methods

/*
 Plot each of the filtered businesses on the map.
 */

- (void)plotBusinesses
{
    for (id<MKAnnotation> annotation in businessMapView.annotations) {
        if (!MKMapRectContainsPoint(businessMapView.visibleMapRect, MKMapPointForCoordinate(annotation.coordinate)))
            [businessMapView removeAnnotation:annotation];
    }
    
    for (int i =0; i < [filteredBusinesses count]; i++)
    {
        Business *business = [filteredBusinesses objectAtIndex:i];
        SLBusinessAnnotation *annotation = [[SLBusinessAnnotation alloc] initWithBusiness:business];
        
        NSUInteger result = [businessMapView.annotations indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[SLBusinessAnnotation class]]) {
            SLBusinessAnnotation *ba = (SLBusinessAnnotation*) obj;
                return [ba.name isEqualToString:annotation.name];
            } else
                return false;
        }];
        
        if (result == NSNotFound) {
            [businessMapView addAnnotation:annotation];
        }
    }
}

/*
 This is called to center the map. There was a bug being experienced which is why this is called right after setDefaultMap. Setting the region twice seemed to fix the issue.
 */

- (void) centerMap:(id)sender
{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate, RADIUS*15*METERS_PER_MILE, RADIUS*15*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [businessMapView regionThatFits:viewRegion];
    
    [businessMapView setRegion:adjustedRegion animated:YES];
}

/*
  This sets up the map's range to plot the businesses. Defaults to centering on the user's location. 
 */

- (void) setDefaultMap
{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate, RADIUS*15*METERS_PER_MILE, RADIUS*15*METERS_PER_MILE);;
    MKCoordinateRegion adjustedRegion = [businessMapView regionThatFits:viewRegion];
    [businessMapView setRegion:adjustedRegion animated:YES];
    [businessMapView setCenterCoordinate:locationManager.location.coordinate];
    
    [self centerMap:self];
}

/*
  Removes all of the annotations on the map. Used when selecting a different category of businesses.
 */

- (void) clearMap
{
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:10];
    for (id annotation in businessMapView.annotations)
        if (annotation != businessMapView.userLocation)
            [toRemove addObject:annotation];
    [businessMapView removeAnnotations:toRemove];
}

#pragma mark MKMap Delegate Methods

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    previousRegion = mapView.region;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"BusinessAnnotation.h";
    if ([annotation isKindOfClass:[SLBusinessAnnotation class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [businessMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil)
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        else
            [annotationView setAnnotation:annotation];
        
        [annotationView setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
        [annotationView setEnabled:YES];
        [annotationView setCanShowCallout:YES];
        
        return annotationView;
    }
    return nil;
}

#pragma mark - Table View Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [filteredBusinesses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BusinessCell";
    BusinessRowCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {        
        UINib *quoteCellNib = [UINib nibWithNibName:@"BusinessCell" bundle:nil];
        [quoteCellNib instantiateWithOwner:self options:nil];
    }
    
    // Configure the cell...
    Business *currentBusiness = [filteredBusinesses objectAtIndex:indexPath.row];
    [cell.businessImage setImageWithURL:[NSURL URLWithString:currentBusiness.url]];

    cell.distance.text = [NSString stringWithFormat:@"%.2f mi",currentBusiness.distance ];
    cell.businessName.text = currentBusiness.name;    
    cell.greyOverlay.image = [UIImage imageNamed:@"product_title_bg.png"];
    
    UIImage* backgroundImage;
    UIImage* selectedBackgroundImage;
    UIImageView *backgroundImageView  =[[UIImageView alloc] initWithFrame: cell.frame];
    UIImageView *selectedBackgroundImageView  =[[UIImageView alloc] initWithFrame: cell.frame];
    
    backgroundImage = [[UIImage imageNamed:@"product_square.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10,99,21,99)];
    selectedBackgroundImage = [[UIImage imageNamed:@"product_square.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 99, 21, 99)];
    cell.backgroundColor = [UIColor clearColor];
    backgroundImageView.image = backgroundImage;
    selectedBackgroundImageView.image=selectedBackgroundImage;
    cell.selectedBackgroundView = selectedBackgroundImageView;
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    cell.backgroundView = backgroundImageView;    
    cell.businessName.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:22.0];
    cell.distance.font = [UIFont fontWithName:@"ProximnaNova-Semibold" size:16.0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 200;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedBusiness = [filteredBusinesses objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"businessSegue" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"businessSegue"]) {
        // Get reference to the destination view controller
        SLBusinessViewController *vc = [segue destinationViewController];
        [vc setBusiness:selectedBusiness];
    }
}

#pragma mark - UISegmentedControl Method

- (IBAction)segmentedControlIndexChanged
{
    int selected = segmentedControl.selectedSegmentIndex;
    
    switch(selected)
    {
        case 0:
            selectedCategory=0;
            break;
        case 1:
            selectedCategory=1;
            break;
        case 2:
            selectedCategory=4;
            break;
        case 3:
            selectedCategory=3;
            break;
    }
    
    if (selectedCategory == 0)
        filteredBusinesses = businesses;
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category = %d",selectedCategory];
        filteredBusinesses = [NSMutableArray arrayWithArray:[businesses filteredArrayUsingPredicate:predicate]];
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance"
                                                     ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        filteredBusinesses = [NSMutableArray arrayWithArray:[filteredBusinesses sortedArrayUsingDescriptors:sortDescriptors]];
    }
    
    [businessTableView reloadData];
    [self clearMap];
    [self plotBusinesses];
}

#pragma mark - CLLocationManager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self calculateDistances:newLocation];
}

/*
 Helper method for didUpdateToLocation that updates the distance to each business.
 */
- (void) calculateDistances:(CLLocation *)loc
{
    for (int i=0; i< [businesses count]; i++)
    {
        Business *currentBusiness = [businesses objectAtIndex:i];
        CLLocation *businessLoc = [[CLLocation alloc] initWithLatitude:currentBusiness.latitude longitude:currentBusiness.longitude];
        CLLocationDistance distance = [loc distanceFromLocation:businessLoc] * 0.000621371;
        currentBusiness.distance=distance;
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    businesses = [NSMutableArray arrayWithArray:[businesses sortedArrayUsingDescriptors:sortDescriptors]];
    
    [self setDefaultMap];
    [businessTableView reloadData];
    filteredBusinesses = [NSMutableArray arrayWithArray:[filteredBusinesses sortedArrayUsingDescriptors:sortDescriptors]];
}


@end
