//
//  MTFaceDetectionHelper.h
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/7.
//

#import <Foundation/Foundation.h>

#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>

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

@interface MTFaceDetectionHelper : NSObject

//张嘴
+(BOOL)isOpenMouthWithFaceAnchor:(ARAnchor *)anchor;

//眨眼
+(BOOL)isBlinkEyesWithFaceAnchor:(ARAnchor *)anchor;

//向左转头
+(BOOL)isTurnLeftWithFaceAnchor:(ARAnchor *)anchor;

//向右转头
+(BOOL)isTurnRightWithFaceAnchor:(ARAnchor *)anchor;

//抬头
+(BOOL)isRiseHeadWithFaceAnchor:(ARAnchor *)anchor;

//低头
+(BOOL)isBowHeadWithFaceAnchor:(ARAnchor *)anchor;

//动眉毛
+(BOOL)isFrownBledWithFaceAnchor:(ARAnchor *)anchorD;


/// 获取面部位置表检测值
/// @param faceAnchor 面部
/// @param shapeLocation 面部位置
+(CGFloat)getFaceDetectionValueFromFaceAnchor:(ARFaceAnchor *)faceAnchor forShapeLocationKey:(NSString *)shapeLocation;


/// 根据脸部识别枚举类型获取中文名称
/// @param faceDetectionType 脸部检测部位
+(NSString *)getLocatonNameWithTypeWithType:(MTFaceDetectionType)faceDetectionType;

@end

NS_ASSUME_NONNULL_END
