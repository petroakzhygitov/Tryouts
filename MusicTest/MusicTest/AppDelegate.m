//
//  AppDelegate.m
//  MusicTest
//
//  Created by Petro Akzhygitov on 12/01/16.
//  Copyright © 2016 Petro Akzhygitov. All rights reserved.
//

#import "AppDelegate.h"
#import "SubmitPollViewController.h"
#import "PAKMusicTestService.h"

@interface AppDelegate ()

@property(nonatomic) PAKMusicTestService *service;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.service = [[PAKMusicTestService alloc] init];

    SubmitPollViewController *submitPollViewController = (SubmitPollViewController *) self.window.rootViewController;
    submitPollViewController.service = self.service;

    return YES;
}

@end
