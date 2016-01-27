#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol Optional;

@interface ACEPersonBirthDeathPlace : JSONModel
#pragma mark Properties

@property(nonatomic, copy) NSString <Optional> *Date;
@property(nonatomic, copy) NSString <Optional> *Name;
@property(nonatomic) CLLocationDegrees Latitude;
@property(nonatomic) CLLocationDegrees Longitude;


@end