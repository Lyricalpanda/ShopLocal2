//
//  BusinessAnnotation.h
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Business.h"

@interface SLBusinessAnnotation : NSObject <MKAnnotation>

@property Business *business;
@property NSString *name;
@property NSString *address;
@property CLLocationCoordinate2D coordinate;

- (id)initWithBusiness:(Business *)business;
- (id)initWithName:(NSString*)name address:(NSString*)address andCoordinate:(CLLocationCoordinate2D)coordinate;

@end