#import <Foundation/Foundation.h>
#import "EyesOpenCloseDetector.hpp"

@class PAKEyeBlinkDetector;

#pragma mark typedef

typedef NS_ENUM(NSUInteger, PAKBlinkDetectorEyeState) {
    PAKBlinkDetectorEyeStateUndefined = 0,
    PAKBlinkDetectorEyeStateOpen,
    PAKBlinkDetectorEyeStateClosed
};

typedef NS_ENUM(NSUInteger, PAKBlinkDetectorEye) {
    PAKBlinkDetectorEyeLeft,
    PAKBlinkDetectorEyeRight
};

#pragma mark Protocol

@protocol PAKBlinkDetectorDelegate

- (void)eyeBlinkDetector:(PAKEyeBlinkDetector *)eyeBlinkDetector didDetectBlinkOfEye:(PAKBlinkDetectorEye)eye;

- (void)eyeBlinkDetector:(PAKEyeBlinkDetector *)eyeBlinkDetector didUpdateEyeState:(PAKBlinkDetectorEyeState)state forEye:(PAKBlinkDetectorEye)eye;

@end


@interface PAKEyeBlinkDetector : NSObject
#pragma mark Properties

@property(nonatomic, weak) id <PAKBlinkDetectorDelegate> delegate;
@property(nonatomic) cv::CascadeClassifier faceCascade;

#pragma mark Methods

- (instancetype)initWithFaceCascade:(cv::CascadeClassifier)faceCascade delegate:(id <PAKBlinkDetectorDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (void)processImage:(cv::Mat &)mat;

@end