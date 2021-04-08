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
    
    CGFloat jawLeft = [self getFaceDetectionValueFromFaceAnchor:faceAnchor forShapeLocationKey:ARBlendShapeLocationJawLeft];
    
//    NSLog(@"脸颊向外:%lf",cheekPuff);
    NSLog(@"下颌向左运动:%lf",jawLeft);
    CGFloat cheekPuffDefaultValue = 0.02;
    CGFloat jawRightDefaultValue = 0.04;
    if (cheekPuff > cheekPuffDefaultValue &&
        jawLeft > jawRightDefaultValue) {
        NSLog(@"检测到脸颊向左");
        return YES;
    }
    return NO;
}

//向右转头 脸颊向外 + 下颌向右运动
+(BOOL)isTurnRightWithFaceAnchor:(ARAnchor *)anchor{
    
    ARFaceAnchor *faceAnchor = (ARFaceAnchor *)anchor;
    
    CGFloat cheekPuff = [self getFaceDetectionValueFromFaceAnchor:faceAnchor forShapeLocationKey:ARBlendShapeLocationCheekPuff];
    
    CGFloat jawRight = [self getFaceDetectionValueFromFaceAnchor:faceAnchor forShapeLocationKey:ARBlendShapeLocationJawRight];
    
//    NSLog(@"脸颊向外:%lf",cheekPuff);
    NSLog(@"下颌向右运动:%lf",jawRight);
    CGFloat cheekPuffDefaultValue = 0.02;
    CGFloat jawRightDefaultValue = 0.04;
    if (cheekPuff > cheekPuffDefaultValue &&
        jawRight > jawRightDefaultValue) {
        NSLog(@"检测到脸颊向右");
        return YES;
    }
    return NO;
}

//抬头 下颌向前运动 + 鼻孔抬高 +
+(BOOL)isRiseHeadWithFaceAnchor:(ARAnchor *)anchor{
    
    ARFaceAnchor *faceAnchor = (ARFaceAnchor *)anchor;
    
    CGFloat value = [self getFaceDetectionValueFromFaceAnchor:faceAnchor forShapeLocationKey:ARBlendShapeLocationMouthShrugUpper];
    
    //左鼻孔
    CGFloat noseSneerLeft = [self getFaceDetectionValueFromFaceAnchor:faceAnchor forShapeLocationKey:ARBlendShapeLocationNoseSneerLeft];
    //右鼻孔
    CGFloat noseSneerRight = [self getFaceDetectionValueFromFaceAnchor:faceAnchor forShapeLocationKey:ARBlendShapeLocationNoseSneerRight];
    //下颌向前运动
    CGFloat jawForward = [self getFaceDetectionValueFromFaceAnchor:faceAnchor forShapeLocationKey:ARBlendShapeLocationJawForward];
    
    NSLog(@"下颌向外运动：%lf,左鼻孔：%lf,右鼻孔：%lf",jawForward,noseSneerLeft,noseSneerRight);
    
    CGFloat jawForwardDefault = 0.065;
    
    if (0.065 >jawForward > 0.045
        && noseSneerLeft > 0.14
        && noseSneerRight > 0.14) {
        
        NSLog(@"检测到抬头");
        return YES;
    }
    
    return NO;
}

//低头 上嘴唇向下
+(BOOL)isBowHeadWithFaceAnchor:(ARAnchor *)anchor{
    
    ARFaceAnchor *faceAnchor = (ARFaceAnchor *)anchor;
    //左鼻孔
    CGFloat noseSneerLeft = [self getFaceDetectionValueFromFaceAnchor:faceAnchor forShapeLocationKey:ARBlendShapeLocationNoseSneerLeft];
    //右鼻孔
    CGFloat noseSneerRight = [self getFaceDetectionValueFromFaceAnchor:faceAnchor forShapeLocationKey:ARBlendShapeLocationNoseSneerRight];
    //下颌向前运动
    CGFloat jawForward = [self getFaceDetectionValueFromFaceAnchor:faceAnchor forShapeLocationKey:ARBlendShapeLocationJawForward];
    
    CGFloat eyeLookDownLeft = [self getFaceDetectionValueFromFaceAnchor:faceAnchor forShapeLocationKey:ARBlendShapeLocationEyeLookDownLeft];
    NSLog(@"下颌向外运动：%lf,左鼻孔：%lf,右鼻孔：%lf,眼睛向下看：%lf",jawForward,noseSneerLeft,noseSneerRight,eyeLookDownLeft);
    
    
    if (0.1 >jawForward > 0.07
        && noseSneerLeft < 0.07
        && noseSneerRight < 0.07
        && eyeLookDownLeft < 0.03) {
        
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

+(NSString *)getLocatonNameWithTypeWithType:(MTFaceDetectionType)faceDetectionType {
    
    switch (faceDetectionType) {
        case MTFaceDetectionTypeOpenMouth:
            return @"张嘴";
            break;
            
        case MTFaceDetectionTypeBlinkEyes:
            return @"眨眼";
            break;
            
        case MTFaceDetectionTypeTurnLeft:
            return @"头向左转";
            break;
            
        case MTFaceDetectionTypeTurnRight:
            return @"头向右转";
            break;
            
        case MTFaceDetectionTypeRiseHead:
            return @"抬头";
            break;
            
        case MTFaceDetectionTypeBowHead:
            return @"低头";
            break;
            
        case MTFaceDetectionTypeFrownBled:
            return @"挤眉毛";
            break;
            
        default:
            return @"未知";
            break;
    }
}
@end
