#import "util.h"
#import <SceneKit/SceneKit.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

cv::Mat UTIL::cvMatFromUIImage(UIImage *image){
    BOOL hasAlpha = NO;
    CGImageRef imageRef = image.CGImage;
    CGImageAlphaInfo alphaInfo = (CGImageAlphaInfo)(CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask);
    if (alphaInfo == kCGImageAlphaPremultipliedLast ||
        alphaInfo == kCGImageAlphaPremultipliedFirst ||
        alphaInfo == kCGImageAlphaLast ||
        alphaInfo == kCGImageAlphaFirst ) 
    {
        hasAlpha = YES;
    }
    
    cv::Mat cvMat;
    CGBitmapInfo bitmapInfo;
    CGFloat cols = CGImageGetWidth(imageRef);
    CGFloat rows = CGImageGetHeight(imageRef);
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    size_t numberOfComponents = CGColorSpaceGetNumberOfComponents(colorSpace);
    if (numberOfComponents == 1){// check whether the UIImage is greyscale already
        cvMat = cv::Mat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
        bitmapInfo = kCGImageAlphaNone | kCGBitmapByteOrderDefault;
    }
    else {
        cvMat = cv::Mat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
        bitmapInfo = kCGBitmapByteOrder32Host;
        // kCGImageAlphaNone is not supported in CGBitmapContextCreate.
        // Since the original image here has no alpha info, use kCGImageAlphaNoneSkipLast
        // to create bitmap graphics contexts without alpha info.
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
    }
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    bitmapInfo                  // Bitmap info flags
                                                    );
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), imageRef);     // decode
    CGContextRelease(contextRef);
    
    return cvMat;    
}

UIImage *UTIL::UIImageFromCVMat(cv::Mat &cvMat){
    CGColorSpaceRef colorSpace;
    CGBitmapInfo bitmapInfo;
    size_t elemsize = cvMat.elemSize();
    if (elemsize == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
        bitmapInfo = kCGImageAlphaNone | kCGBitmapByteOrderDefault;
    }
    else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
        bitmapInfo = kCGBitmapByteOrder32Host;
        bitmapInfo |= (elemsize == 4) ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNone;
    }
    
    NSData *data = [NSData dataWithBytes:cvMat.data length:elemsize * cvMat.total()];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                 // width
                                        cvMat.rows,                 // height
                                        8,                          // bits per component
                                        8 * cvMat.elemSize(),       // bits per pixel
                                        cvMat.step[0],              // bytesPerRow
                                        colorSpace,                 // colorspace
                                        bitmapInfo,                 // bitmap info
                                        provider,                   // CGDataProviderRef
                                        NULL,                       // decode
                                        false,                      // should interpolate
                                        kCGRenderingIntentDefault   // intent
                                        );
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

void UTIL::saveImage(UIImage *image) {
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    NSLog(@"save image");
}
