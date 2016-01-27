#import <JSONModel/JSONModel.h>
#import "ACEPersonBirthDeathPlace.h"


@implementation ACEPersonBirthDeathPlace
#pragma mark Override

- (void)setLatitudeWithNSString:(NSString *)latitudeString {
    self.Latitude = [latitudeString floatValue];

    if ([latitudeString rangeOfString:@"S"].location != NSNotFound) {
        self.Latitude *= -1;
    }
}

- (void)setLongitudeWithNSString:(NSString *)LongitudeString {
    self.Longitude = [LongitudeString floatValue];

    if ([LongitudeString rangeOfString:@"W"].location != NSNotFound) {
        self.Longitude *= -1;
    }
}


@end