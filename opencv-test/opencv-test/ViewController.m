//
//  ViewController.m
//  opencv-test
//
//  Created by Petro Akzhygitov on 22/01/16.
//  Copyright © 2016 Petro Akzhygitov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic) CvVideoCamera *videoCamera;
@property(nonatomic) BOOL isCapturing;

@property(nonatomic) PAKEyeBlinkDetector *blinkDetector;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
    self.videoCamera.delegate = self;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;

    self.isCapturing = NO;

    // Load Cascade Classisier
    NSString *filename = [[NSBundle mainBundle] pathForResource:@"lbpcascade_frontalface" ofType:@"xml"];

    cv::CascadeClassifier faceCascade = cv::CascadeClassifier();
    faceCascade.load([filename UTF8String]);

    // Create blink detector
    self.blinkDetector = [[PAKEyeBlinkDetector alloc] initWithFaceCascade:faceCascade delegate:self];
}

- (NSString *)eyeLabelTextWithEyeState:(PAKBlinkDetectorEyeState)state {
    switch (state) {
        case PAKBlinkDetectorEyeStateUndefined:
            return @"";

        case PAKBlinkDetectorEyeStateOpen:
            return @"Open";

        case PAKBlinkDetectorEyeStateClosed:
            return @"Closed";
    }

    return @"";
}

- (void)startCapture {
    [self.videoCamera start];
    self.isCapturing = YES;
}

- (void)stopCapture {
    [self.videoCamera stop];
    self.isCapturing = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (!self.isCapturing) {
        [self startCapture];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    if (self.isCapturing) {
        [self stopCapture];
    }
}

- (void)dealloc {
    self.videoCamera.delegate = nil;
}

#pragma mark Delegate - CvVideoCameraDelegate

- (void)processImage:(cv::Mat &)image {
    [self.blinkDetector processImage:image];
//    UIImage *image1 = MatToUIImage(eyesMat);
//
//    dispatch_async(dispatch_get_main_queue(), ^(void) {
//        self.eyesImageView.image = image1;
//    });
}

#pragma mark Delegate - PAKBlinkDetectorDelegate

- (void)eyeBlinkDetector:(PAKEyeBlinkDetector *)eyeBlinkDetector didDetectBlinkOfEye:(PAKBlinkDetectorEye)eye {
    NSLog(@"Got blink!");
}

- (void)eyeBlinkDetector:(PAKEyeBlinkDetector *)eyeBlinkDetector didUpdateEyeState:(PAKBlinkDetectorEyeState)state forEye:(PAKBlinkDetectorEye)eye {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        switch (eye) {
            case PAKBlinkDetectorEyeLeft:
                self.leftEyeLabel.text = [self eyeLabelTextWithEyeState:state];

                break;
            case PAKBlinkDetectorEyeRight:
                self.rightEyeLabel.text = [self eyeLabelTextWithEyeState:state];

                break;
        }
    });
}


@end
