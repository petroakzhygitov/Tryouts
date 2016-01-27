//
//  SubmitPollViewController.h
//  MusicTest
//
//  Created by Petro Akzhygitov on 12/01/16.
//  Copyright © 2016 Petro Akzhygitov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAKMusicTestService.h"

@class ReflectionView;
@class PAKMusicTestService;

@interface SubmitPollViewController : UIViewController

@property (weak, nonatomic) IBOutlet ReflectionView *buttonsView;

@property (weak, nonatomic) IBOutlet UIButton *basButton;
@property (weak, nonatomic) IBOutlet UIButton *electricButton;
@property (weak, nonatomic) IBOutlet UIButton *guitarButton;
@property (weak, nonatomic) IBOutlet UIButton *banjoButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (nonatomic) PAKMusicTestService *service;

@end

