//
//  MTFaceDetectionHelper.h
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/7.
//

#import <Foundation/Foundation.h>

#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTFaceDetectionHelper : NSObject

//张嘴
+(BOOL)isOpenMouthWithFaceAnchor:(ARAnchor *)anchor;

//眨眼
+(BOOL)isBlinkEyesWithFaceAnchor:(ARAnchor *)anchor;

//向左转头
+(BOOL)isTurnLeftWithFaceAnchor:(ARAnchor *)anchor;

//向右转头
+(BOOL)isurnRightWithFaceAnchor:(ARAnchor *)anchor;

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

@end

NS_ASSUME_NONNULL_END
