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
    MTFaceDetectionTypeTurnLeft = 2,//向左转头
    MTFaceDetectionTypeTurnRight = 3,//向右转头
    MTFaceDetectionTypeRiseHead = 4,//抬头
    MTFaceDetectionTypeBowHead = 5,//低头
    MTFaceDetectionTypeFrownBled = 6 //动眉毛
} MTFaceDetectionType;

//脸部表情识别
typedef enum{
    MTFacialExpressionTypeSmile = 0,//微笑：笑的幅度小
    MTFacialExpressionTypeLaugh = 1,//大笑：笑得幅度大
    MTFacialExpressionTypeCry = 2,//哭泣:皱眉+张嘴 or 嘴角下扬
    MTFacialExpressionTypeShock = 3,//惊吓:张嘴 + 睁大眼睛
    MTFacialExpressionTypeSTongueOut = 4,//张嘴 + 伸舌头
} MTFacialExpressionType;

NS_ASSUME_NONNULL_BEGIN

@interface MTARKitHelper : NSObject

+(ARSCNView *)createSCNView;

+(ARSession *)createSession;

+(ARWorldTrackingConfiguration *)createWorldTrackingConfig;

+(ARFaceTrackingConfiguration *)createFaceTrackingConfig;

@end

NS_ASSUME_NONNULL_END
