//
//  UIImage+MT.h
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (MT)

//帧转化成图片
+(UIImage *)convert:(CVPixelBufferRef)pixelBuffer;

@end

NS_ASSUME_NONNULL_END
