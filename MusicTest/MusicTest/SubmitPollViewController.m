//
//  SubmitPollViewController.m
//  MusicTest
//
//  Created by Petro Akzhygitov on 12/01/16.
//  Copyright © 2016 Petro Akzhygitov. All rights reserved.
//

#import "SubmitPollViewController.h"
#import "ReflectionView.h"
#import "RACSignal.h"
#import "RACSignal+Operations.h"
#import "PollResultsViewController.h"

#pragma mark const
NSString *const kTypeYourNameString = @"Type your name here";
NSString *const kUserNameString = @"Username";

NSString *const kPollResultsViewControllerSegueIdentifier = @"PollResultsViewControllerSegueIdentifier";


@interface SubmitPollViewController ()

@property(nonatomic, copy) NSString *userName;
@property(nonatomic) PAKPollSelectionType selectionType;

@end


@implementation SubmitPollViewController

#pragma mark Override
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];

    if ([[segue identifier] isEqualToString:kPollResultsViewControllerSegueIdentifier]) {
        PollResultsViewController *pollResultsViewController = [segue destinationViewController];
        pollResultsViewController.service = self.service;
        pollResultsViewController.userName = self.userName;
        pollResultsViewController.selectionType = self.selectionType;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    ReflectionView *buttonsView = self.buttonsView;
    buttonsView.dynamic = YES;
    buttonsView.reflectionScale = 1;
    buttonsView.reflectionAlpha = .5;
    buttonsView.reflectionGap = 0;

    self.basButton.exclusiveTouch = YES;
    self.electricButton.exclusiveTouch = YES;
    self.guitarButton.exclusiveTouch = YES;
    self.banjoButton.exclusiveTouch = YES;

    self.userNameTextField.text = kTypeYourNameString;
}

#pragma mark IBAction
- (IBAction)buttonPressed:(id)sender {
    PAKPollSelectionType selectionType = (PAKPollSelectionType) ((UIButton *) sender).tag;
    NSString *userName = self.userNameTextField.text;

    if (userName.length == 0 || [userName isEqualToString:kTypeYourNameString]) {
        userName = kUserNameString;
    }

    self.userName = userName;
    self.selectionType = selectionType;

    [[[self.service submitPollWithUserName:userName selectionType:selectionType] deliverOnMainThread] subscribeError:^(NSError *error) {
        NSLog(@"Error occurred: %@", error);

    }                                                                                                      completed:^() {
        [self performSegueWithIdentifier:kPollResultsViewControllerSegueIdentifier sender:self];
    }];
}

@end
