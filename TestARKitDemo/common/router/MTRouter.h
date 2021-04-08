//
//  MTRouter.h
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/7.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTRouter : NSObject

/// 新增3D模型
+(void)gotoAdd3DVC;

/// 捕捉平面
+(void)gotoCatchTheFlatVC;

/// 进入脸部识别界面
+(void)gotoFaceDetectionVC;


/// 脸部新增面具
+(void)gotoFaceAddMaskVC;

/// 获取root window
+(UIWindow *)getRootWindow;

+(UIViewController *)getRootVC;

@end

NS_ASSUME_NONNULL_END
