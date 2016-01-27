#import "PAKEyeBlinkDetector.h"


@interface PAKEyeBlinkDetector ()

@property(nonatomic) EyesOpenCloseDetector *eyesOpenCloseDetector;

@end


@implementation PAKEyeBlinkDetector

#pragma mark Initializer

- (instancetype)initWithFaceCascade:(cv::CascadeClassifier)faceCascade delegate:(id <PAKBlinkDetectorDelegate>)delegate {
    self = [super init];
    if (self) {
        _faceCascade = faceCascade;
        _delegate = delegate;

        _eyesOpenCloseDetector = new EyesOpenCloseDetector(faceCascade);
    }

    return self;
}

- (instancetype)init {
    return [self initWithFaceCascade:cv::CascadeClassifier::CascadeClassifier() delegate:nil];
}

#pragma mark Private

- (PAKBlinkDetectorEyeState)_eyeStateWithEye:(EyesOpenCloseDetector::Eye)eye {
    switch (eye) {
        case EyesOpenCloseDetector::Undefined:
            return PAKBlinkDetectorEyeStateUndefined;

        case EyesOpenCloseDetector::Open:
            return PAKBlinkDetectorEyeStateOpen;

        case EyesOpenCloseDetector::Closed:
            return PAKBlinkDetectorEyeStateClosed;
    }

    return PAKBlinkDetectorEyeStateUndefined;
}

#pragma mark Override

- (void)setFaceCascade:(cv::CascadeClassifier)faceCascade {
    _faceCascade = faceCascade;

    _eyesOpenCloseDetector = new EyesOpenCloseDetector(faceCascade);
}

#pragma mark Public

- (void)processImage:(cv::Mat &)mat {
    EyesOpenCloseDetector::Eyes eyes;

    _eyesOpenCloseDetector->getEyes(mat, &eyes);

    if (self.delegate) {
        [self.delegate eyeBlinkDetector:self didUpdateEyeState:[self _eyeStateWithEye:eyes.leftEye] forEye:PAKBlinkDetectorEyeLeft];
        [self.delegate eyeBlinkDetector:self didUpdateEyeState:[self _eyeStateWithEye:eyes.rightEye] forEye:PAKBlinkDetectorEyeRight];
    }
}

@end