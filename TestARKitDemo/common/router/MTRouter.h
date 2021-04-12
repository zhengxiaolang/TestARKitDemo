//
//  MTRouter.h
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/7.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// <#Description#>
@interface MTRouter : NSObject

/// 新增3D模型
+(void)gotoAdd3DVC;

/// 捕捉平面
+(void)gotoCatchTheFlatVC;

/// 进入脸部识别界面
+(void)gotoFaceDetectionVC;


/// 脸部新增面具
+(void)gotoFaceAddMaskVC;


/// 扫描3D模型
+(void)gotoScan3DVC;

/// 虚实遮挡
+(void)gotoVitualAndRealOcclusionVC;


/// 封闭成适配器
+(void)gotoARAdapterVC;

/// 获取root window
+(UIWindow *)getRootWindow;

+(UIViewController *)getRootVC;

+(void)presentVC:(UIViewController *)vc;

+(UIViewController *)getCurrentVC;

@end

NS_ASSUME_NONNULL_END
