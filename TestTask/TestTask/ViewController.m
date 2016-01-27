//
//  ViewController.m
//  TestTask
//
//  Created by Petro Akzhygitov on 14/01/16.
//  Copyright © 2016 Petro Akzhygitov. All rights reserved.
//

#import "ViewController.h"
#import "ACEPerson.h"
#import "ACEPersonBirthDeathPlace.h"
#import "ACEPersons.h"
#import "JPSThumbnail.h"
#import "JPSThumbnailAnnotation.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"

@interface ViewController ()

@property(nonatomic, strong) NSMutableDictionary *annotations;
@property(nonatomic, strong) NSIndexPath *currentIndexPath;

@property(nonatomic, strong) NSTimer *timer;

@end


@implementation ViewController
#pragma mark Override

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView.delegate = self;

    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    [self _addAnnotationsForPersons];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self _cycleTroughAnnotations];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.timer invalidate];
}

#pragma mark Private
- (void)_addAnnotationsForPersons {
    self.annotations = [[NSMutableDictionary alloc] initWithCapacity:self.persons.Persons.count];

    for (ACEPerson *person in self.persons.Persons) {
        NSMutableArray *personsAnnotations = [[NSMutableArray alloc] init];

        JPSThumbnailAnnotation *birthPlaceAnnotation = [self _annotationForPlace:person.Birth isBirthPlace:YES withPerson:person];
        if (birthPlaceAnnotation) {
            [self.mapView addAnnotation:birthPlaceAnnotation];
            [personsAnnotations addObject:birthPlaceAnnotation];
        }

        JPSThumbnailAnnotation *deathPlaceAnnotation = [self _annotationForPlace:person.Death isBirthPlace:NO withPerson:person];
        if (deathPlaceAnnotation) {
            [self.mapView addAnnotation:deathPlaceAnnotation];
            [personsAnnotations addObject:deathPlaceAnnotation];
        }

        self.annotations[person.Name] = personsAnnotations;
    }
}

- (JPSThumbnailAnnotation *)_annotationForPlace:(ACEPersonBirthDeathPlace *)place isBirthPlace:(BOOL)isBirthPlace withPerson:(ACEPerson *)person {
    if (!place) return nil;

    JPSThumbnail *thumbnail = [[JPSThumbnail alloc] init];
    thumbnail.title = [NSString stringWithFormat:@"%@", person.Name];
    thumbnail.subtitle = [NSString stringWithFormat:@"%@ in %@ on %@", isBirthPlace ? @"Born" : @"Died", place.Name, place.Date];
    thumbnail.coordinate = CLLocationCoordinate2DMake(place.Latitude, place.Longitude);

    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:person.Portrait]
                          options:0
                         progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                thumbnail.image = image;
                            }
                        }];

    return [JPSThumbnailAnnotation annotationWithThumbnail:thumbnail];
}

- (void)_cycleTroughAnnotations {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                  target:self
                                                selector:@selector(_showNextAnnotation)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)_showNextAnnotation {
    MKPointAnnotation *annotation = [self _annotationForCurrentIndexPath];
    [self.mapView selectAnnotation:annotation animated:YES];

    [self _incrementCurrentIndexPath];
}

- (MKPointAnnotation *)_annotationForCurrentIndexPath {
    NSUInteger row = (NSUInteger) self.currentIndexPath.row;
    NSUInteger section = (NSUInteger) self.currentIndexPath.section;

    MKPointAnnotation *annotation = ((NSArray *) self.annotations.allValues[section])[row];
    return annotation;
}

- (void)_incrementCurrentIndexPath {
    NSUInteger row = (NSUInteger) self.currentIndexPath.row;
    NSUInteger section = (NSUInteger) self.currentIndexPath.section;

    if (((NSArray *) self.annotations.allValues[section]).count - 1 > row) {
        row++;

    } else if (self.annotations.count - 1 > section) {
        row = 0;
        section++;

    } else {
        row = 0;
        section = 0;
    }

    self.currentIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
}

#pragma mark MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject <JPSThumbnailAnnotationViewProtocol> *) view) didSelectAnnotationViewInMap:mapView];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject <JPSThumbnailAnnotationViewProtocol> *) view) didDeselectAnnotationViewInMap:mapView];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject <JPSThumbnailAnnotationProtocol> *) annotation) annotationViewInMap:mapView];
    }

    return nil;
}

@end
