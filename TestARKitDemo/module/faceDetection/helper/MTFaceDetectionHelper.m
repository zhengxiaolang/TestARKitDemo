//
//  MTFaceDetectionHelper.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/7.
//

#import "MTFaceDetectionHelper.h"

@implementation MTFaceDetectionHelper

//张嘴 判断
+(BOOL)isOpenMouthWithFaceAnchor:(ARAnchor *)anchor{
    
    if (!anchor || ![anchor isKindOfClass:[ARFaceAnchor class]]) return NO;
    
    ARFaceAnchor *faceAnchor = (ARFaceAnchor *)anchor;
    
    CGFloat value = [self getFaceDetectionValueFromFaceAnchor:faceAnchor forShapeLocationKey:ARBlendShapeLocationJawOpen];
    
//    ARBlendShapeLocationMouthFunnel 稍张嘴并双唇张开
    
//    ARBlendShapeLocationJawOpen 张嘴时下巴向下
    
    NSLog(@"jawOpen = %f", value);
    CGFloat defaultValue = 0.3;
    if (value > defaultValue) {
        NSLog(@"检测到张嘴");
        return YES;
    }
    return NO;
}

//眨眼 判断左眼 + 右眼
+(BOOL)isBlinkEyesWithFaceAnchor:(ARAnchor *)anchor{
    
    ARFaceAnchor *faceAnchor = (ARFaceAnchor *)anchor;
    
    CGFloat blinkLeft = [self getFaceDetectionValueFromFaceAnchor:faceAnchor forShapeLocationKey:ARBlendShapeLocationEyeBlinkLeft];
    
    CGFloat blinkRight = [self getFaceDetectionValueFromFaceAnchor:faceAnchor forShapeLocationKey:ARBlendShapeLocationEyeBlinkRight];
    
    NSLog(@"blinkLeft = %f, blinkRight = %f", blinkLeft,blinkRight);
    
    CGFloat defaultValue = 0.3;
    if (blinkLeft > defaultValue && blinkRight > defaultValue) {
        NSLog(@"检测到眨眼");
        return YES;
    }
    
    return NO;
}

//向左转头
+(BOOL)isTurnLeftWithFaceAnchor:(ARAnchor *)anchor{
    
    ARFaceAnchor *faceAnchor = (ARFaceAnchor *)anchor;
    
    CGFloat cheekPuff = [self getFaceDetectionValueFromFaceAnchor:faceAnchor forShapeLocationKey:ARBlendShapeLocationCheekPuff];
    
    CGFloat defaultValue = 0.3;
    if (cheekPuff > defaultValue) {
        NSLog(@"检测到脸颊向外");
        return YES;
    }
    return NO;
}

//向右转头
+(BOOL)isurnRightWithFaceAnchor:(ARAnchor *)anchor{
    
    ARFaceAnchor *faceAnchor = (ARFaceAnchor *)anchor;
    
    CGFloat cheekPuff = [self getFaceDetectionValueFromFaceAnchor:faceAnchor forShapeLocationKey:ARBlendShapeLocationCheekPuff];
    
    CGFloat defaultValue = 0.3;
    if (cheekPuff > defaultValue) {
        NSLog(@"检测到脸颊向外");
        return YES;
    }
    return NO;
}

//抬头 上嘴唇向上
+(BOOL)isRiseHeadWithFaceAnchor:(ARAnchor *)anchor{
    
    ARFaceAnchor *faceAnchor = (ARFaceAnchor *)anchor;
    
    CGFloat value = [self getFaceDetectionValueFromFaceAnchor:faceAnchor forShapeLocationKey:ARBlendShapeLocationMouthShrugUpper];
    
    CGFloat defaultValue = 0.3;
    if (value > defaultValue) {
        NSLog(@"检测到抬头");
        return YES;
    }
    return NO;
}

//低头 上嘴唇向下
+(BOOL)isBowHeadWithFaceAnchor:(ARAnchor *)anchor{
    
    ARFaceAnchor *faceAnchor = (ARFaceAnchor *)anchor;
    
    CGFloat value = [self getFaceDetectionValueFromFaceAnchor:faceAnchor forShapeLocationKey:ARBlendShapeLocationMouthShrugLower];
    
    CGFloat defaultValue = 0.3;
    if (value > defaultValue) {
        NSLog(@"检测到低头");
        return YES;
    }
    return NO;
}

//动眉毛
+(BOOL)isFrownBledWithFaceAnchor:(ARAnchor *)anchor{
    
    ARFaceAnchor *faceAnchor = (ARFaceAnchor *)anchor;
    
    CGFloat browInnerUp = [self getFaceDetectionValueFromFaceAnchor:faceAnchor forShapeLocationKey:ARBlendShapeLocationBrowInnerUp];
    CGFloat browValue = 0.5;//临界值
    if (browInnerUp > browValue) {
        NSLog(@"检测到眉毛动了");
        return YES;
    }
    return NO;
}

+(CGFloat)getFaceDetectionValueFromFaceAnchor:(ARFaceAnchor *)faceAnchor forShapeLocationKey:(NSString *)shapeLocation{
    NSDictionary *blendShips = faceAnchor.blendShapes;
    return [blendShips[shapeLocation] floatValue];
}


//表情组合
//CGFloat leftSmile = [blendShips[ARBlendShapeLocationMouthSmileLeft] floatValue];
//CGFloat rightSmile = [blendShips[ARBlendShapeLocationMouthSmileRight] floatValue];

@end
