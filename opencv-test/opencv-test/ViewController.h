//
//  ViewController.h
//  opencv-test
//
//  Created by Petro Akzhygitov on 22/01/16.
//  Copyright © 2016 Petro Akzhygitov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/highgui/ios.h>
#import "PAKEyeBlinkDetector.h"

@class PAKEyeBlinkDetector;

@interface ViewController : UIViewController <CvVideoCameraDelegate, PAKBlinkDetectorDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *leftEyeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightEyeLabel;

@end

