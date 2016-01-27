//
// Created by Petro Akzhygitov on 22/01/16.
// Copyright (c) 2016 Petro Akzhygitov. All rights reserved.
//

#ifndef OPENCV_TEST_SKINREMOVER_H
#define OPENCV_TEST_SKINREMOVER_H


#include <opencv2/core/core.hpp>

class SkinRemover {
public:
    SkinRemover();

    virtual ~SkinRemover() {
    };

    cv::Mat removeSkin(cv::Mat &image);
};


#endif //OPENCV_TEST_SKINREMOVER_H
