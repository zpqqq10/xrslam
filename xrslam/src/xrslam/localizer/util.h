#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


class UTIL{
public: 
cv::Mat cvMatFromUIImage(UIImage *image);
UIImage *UIImageFromCVMat(cv::Mat &cvMat);
void saveImage(UIImage *image);
void printInte(int n);
};