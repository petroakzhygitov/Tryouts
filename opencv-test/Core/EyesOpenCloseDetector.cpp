#include "EyesOpenCloseDetector.hpp"
#include "Processing.hpp"

#include "findEyeCenter.h"
#include "constants.h"

#define LEFT_PUPIL 0
#define RIGHT_PUPIL 1

using namespace cv;
using namespace std;

EyesOpenCloseDetector::EyesOpenCloseDetector(cv::CascadeClassifier faceCascade) {
    _faceCascade = faceCascade;
    _skinRemover = SkinRemover::SkinRemover();
}

static bool FaceSizeComparer(const cv::Rect &r1, const cv::Rect &r2) {
    return r1.area() > r2.area();
}

void EyesOpenCloseDetector::PreprocessToGray_optimized(Mat &frame) {
    _grayFrame.create(frame.size(), CV_8UC1);
    _accBuffer1.create(frame.size(), frame.type());
    _accBuffer2.create(frame.size(), CV_8UC1);

    cvtColor_Accelerate(frame, _grayFrame, _accBuffer1, _accBuffer2);
    equalizeHist_Accelerate(_grayFrame, _grayFrame);
}

void findPupils(cv::Mat frame_gray, cv::Rect face, cv::Rect *eyes) {
    cv::Mat faceROI = frame_gray(face);

    // Find eye regions and draw them
    int eye_region_width = face.width * (kEyePercentWidth / 100.0);
    int eye_region_height = face.width * (kEyePercentHeight / 100.0);
    int eye_region_top = face.height * (kEyePercentTop / 100.0);

    cv::Rect leftEyeRegion(face.width * (kEyePercentSide / 100.0),
            eye_region_top, eye_region_width, eye_region_height);
    cv::Rect rightEyeRegion(face.width - eye_region_width - face.width * (kEyePercentSide / 100.0),
            eye_region_top, eye_region_width, eye_region_height);

    // Find Eye Centers
    cv::Point leftPupil = findEyeCenter(faceROI, leftEyeRegion, "Left Eye");
    cv::Point rightPupil = findEyeCenter(faceROI, rightEyeRegion, "Right Eye");

    leftEyeRegion.width = leftPupil.x;
    leftEyeRegion.height /= 2;

    rightEyeRegion.width = rightPupil.x;
    rightEyeRegion.height /= 2;

    // change eye centers to face coordinates
    rightPupil.x += rightEyeRegion.x;
    rightPupil.y += rightEyeRegion.y;
    leftPupil.x += leftEyeRegion.x;
    leftPupil.y += leftEyeRegion.y;

    eyes[LEFT_PUPIL] = cv::Rect(leftPupil, cv::Size(leftEyeRegion.width, leftEyeRegion.height));
    eyes[RIGHT_PUPIL] = cv::Rect(rightPupil, cv::Size(rightEyeRegion.width, rightEyeRegion.height));
}

void EyesOpenCloseDetector::getEyes(cv::Mat &frame, Eyes *eyes) {
    // Prepare eyes structure
    eyes->leftEye = Undefined;
    eyes->rightEye = Undefined;

    // Make gray and optimize frame
    PreprocessToGray_optimized(frame);

    // Detect faces
    std::vector<cv::Rect> faces;
    _faceCascade.detectMultiScale(_grayFrame, faces, 1.1,
            2, 0, cv::Size(100, 100));

    if (faces.size() == 0) return;

    // Sort faces by size in descending order
    sort(faces.begin(), faces.end(), FaceSizeComparer);

    // Detect eyes for the first face only
    cv::Rect face = faces[0];

    // Find pupils
    cv::Rect pupils[2];
    findPupils(_grayFrame, face, pupils);

    // Detect open or close eye for each eye
    for (int i = 0; i < 2; i++) {
        cv::Rect pupil = pupils[i];

        // Debug
//        circle(frame, cv::Point(face.x + pupil.x, face.y + pupil.y), pupil.width, 123, pupil.width);

        // Define eye area
        Mat eyeArea = frame(cv::Rect(cv::Point(face.x + pupil.x - pupil.width * .5, face.y + pupil.y - pupil.height * .5),
                cv::Size(pupil.width, pupil.height)));

        // Remove skin from pupil area
        Mat removedSkinEyeArea = _skinRemover.removeSkin(eyeArea);

        // Super simple outside of pupil noise removal
        circle(removedSkinEyeArea, cv::Point(pupil.width * .5, pupil.height * .5), pupil.width, Scalar(0, 0, 0), pupil.width);

        long whitePixelsInPupil = 0;

        // Find white pixels in eye area
        for (int y = 0; y < removedSkinEyeArea.rows; y++) {
            for (int x = 0; x < removedSkinEyeArea.cols; x++) {
                Vec3b color = removedSkinEyeArea.at<Vec3b>(cv::Point(x, y));

//                if (color.val[0] + color.val[1] + color.val[2] > 0) {
                //if ((color.val[0] == 255 && color.val[1] == 255 && color.val[2] == 255)) {
                if ((color.val[0] >= 128 && color.val[1] >= 128 && color.val[2] >= 128)) {
                    whitePixelsInPupil++;
                }
            }
        }

        Eye eye;

        double eyeSize = pupil.width * M_PI;
//        if (whitePixelsInPupil >= eyeSize) {
//            eye = Undefined;
//            return;
//        }

        float threshold = 0.10;
        if (whitePixelsInPupil <= eyeSize * threshold) {
            eye = Closed;
        } else {
            eye = Open;
        }

        printf("Eye size: %.0f\n", eyeSize);
        printf("White pixels: %ld\n", whitePixelsInPupil);

        if (i == LEFT_PUPIL) {
            eyes->leftEye = eye;

        } else if (i == RIGHT_PUPIL) {
            eyes->rightEye = eye;
        }
    }
}