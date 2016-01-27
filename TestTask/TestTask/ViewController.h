//
//  ViewController.h
//  TestTask
//
//  Created by Petro Akzhygitov on 14/01/16.
//  Copyright © 2016 Petro Akzhygitov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class ACEPersons;

@interface ViewController : UIViewController <MKMapViewDelegate>

@property(weak, nonatomic) IBOutlet MKMapView *mapView;

@property(nonatomic) ACEPersons *persons;

@end

