//
//  MTARKitHelper.h
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/7.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

///脸部动作识别
typedef enum{
    MTFaceDetectionTypeOpenMouth = 0,//张嘴
    MTFaceDetectionTypeBlinkEyes = 1,//眨眼
    MTFaceDetectionTypeTurnLeft = 2,//向左转
    MTFaceDetectionTypeTurnRight = 3,//向右转
    MTFaceDetectionTypeRiseHead = 4,//抬头
    MTFaceDetectionTypeBowHead = 5,//低头
    MTFaceDetectionTypeFrownBled = 6 //动眉毛
} MTFaceDetectionType;

//脸部表情识别
typedef enum{
    MTFacialExpressionTypeSmile = 0,//微笑
    MTFacialExpressionTypeLaugh = 1,//大笑
    MTFacialExpressionTypeCry = 2,//不开心:皱眉
    MTFacialExpressionTypeShock = 3,//惊吓
    MTFacialExpressionTypeSTongueOut = 4,//吐舌头
} MTFacialExpressionType;

NS_ASSUME_NONNULL_BEGIN

@interface MTARKitHelper : NSObject

+(ARSCNView *)createSCNView;

+(ARSession *)createSession;

+(ARWorldTrackingConfiguration *)createWorldTrackingConfig;

+(ARFaceTrackingConfiguration *)createFaceTrackingConfig;

@end

NS_ASSUME_NONNULL_END
