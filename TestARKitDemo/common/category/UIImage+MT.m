//
//  UIImage+MT.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/7.
//

#import "UIImage+MT.h"

@implementation UIImage (MT)

+(UIImage *)convert:(CVPixelBufferRef)pixelBuffer{
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];

    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
        createCGImage:ciImage
             fromRect:CGRectMake(0, 0, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer))];

    UIImage *uiImage = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);

    return uiImage;
}

@end
