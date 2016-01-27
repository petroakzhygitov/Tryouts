#pragma once


#include <opencv2/core/core.hpp>
#include <opencv2/objdetect/objdetect.hpp>

#import "SkinRemover.hpp"

class EyesOpenCloseDetector {
public:
    typedef enum Eye_ {
        Undefined = 0,
        Open,
        Closed
    } Eye;

    struct Eyes {
        Eye leftEye;
        Eye rightEye;

        Eyes(Eye leftEye_ = Undefined, Eye rightEye_ = Undefined)
                : leftEye(leftEye_), rightEye(rightEye_) {
        }
    };

    EyesOpenCloseDetector(cv::CascadeClassifier faceCascade);

    virtual ~EyesOpenCloseDetector() {
    };

    void getEyes(cv::Mat &frame, Eyes *eyes);

protected:
    cv::CascadeClassifier _faceCascade;
    SkinRemover _skinRemover;

    cv::Mat _grayFrame;

    // Members needed for optimization with Accelerate Framework
    void PreprocessToGray_optimized(cv::Mat &frame);

    cv::Mat _accBuffer1;
    cv::Mat _accBuffer2;
};
