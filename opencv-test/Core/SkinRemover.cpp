//
// Created by Petro Akzhygitov on 22/01/16.
// Copyright (c) 2016 Petro Akzhygitov. All rights reserved.
//

#include "SkinRemover.hpp"


int Y_MIN = 0;
int Y_MAX = 255;
int Cr_MIN = 143;
int Cr_MAX = 193;
int Cb_MIN = 77;
int Cb_MAX = 127;


SkinRemover::SkinRemover() {

}

cv::Mat SkinRemover::removeSkin(cv::Mat &image) {
    cv::Mat skin;
    // first convert our RGB image to YCrCb
    cv::cvtColor(image, skin, cv::COLOR_BGR2YCrCb);

    // filter the image in YCrCb color space
    cv::inRange(skin, cv::Scalar(Y_MIN, Cr_MIN, Cb_MIN), cv::Scalar(Y_MAX, Cr_MAX, Cb_MAX), skin);

    return cv::Scalar::all(255) - skin;;
}
