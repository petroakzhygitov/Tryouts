//
//  AppDelegate.m
//  TestTask
//
//  Created by Petro Akzhygitov on 14/01/16.
//  Copyright © 2016 Petro Akzhygitov. All rights reserved.
//

#import "AppDelegate.h"
#import "JSONModel.h"
#import "ACEPerson.h"
#import "ViewController.h"
#import "ACEPersons.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (ACEPersons *)_readPersonsFromJSON {
    NSString *resourcePath = [NSBundle bundleForClass:[self class]].resourcePath;
    NSString *dataPath = [resourcePath stringByAppendingPathComponent:@"AncestryCodingExercise.json"];

    NSData *data = [NSData dataWithContentsOfFile:dataPath];

    NSError *error;
    ACEPersons *persons = [[ACEPersons alloc] initWithData:data error:&error];

    if (error) {
        NSLog(@"Unable to parse data! Error: %@", error);
        return nil;
    }

    return persons;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    ViewController *viewController = (ViewController *) self.window.rootViewController;
    viewController.persons = [self _readPersonsFromJSON];

    return YES;
}

@end
