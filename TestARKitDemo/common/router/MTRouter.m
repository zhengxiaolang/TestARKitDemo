//
//  MTRouter.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/7.
//

#import "MTRouter.h"
#import "AppDelegate.h"

#import "SceneDelegate.h"

#import "MTAdd3DModelVC.h"
#import "MTCatchTheFlatVC.h"
#import "MTFaceDetectionVC.h"
#import "MTFaceAddMaskVC.h"

#import "MTVitualAndRealOcclusionVC.h"
#import "MTScan3DObjectVC.h"

@implementation MTRouter

+(void)gotoAdd3DVC{
    MTAdd3DModelVC *vc = [[MTAdd3DModelVC alloc] init];
    [MTRouter presentVC:vc];
}

+(void)gotoCatchTheFlatVC{
    MTCatchTheFlatVC *vc = [[MTCatchTheFlatVC alloc] init];
    [MTRouter presentVC:vc];
}

+(void)gotoFaceDetectionVC{
    MTFaceDetectionVC *vc = [[MTFaceDetectionVC alloc] init];
    [MTRouter presentVC:vc];
}

+(void)gotoFaceAddMaskVC{
    MTFaceAddMaskVC *vc = [[MTFaceAddMaskVC alloc] init];
    [MTRouter presentVC:vc];
}

+(void)gotoScan3DVC{
    MTScan3DObjectVC *vc = [[MTScan3DObjectVC alloc] init];
    [MTRouter presentVC:vc];
}

+(void)gotoVitualAndRealOcclusionVC{
    MTVitualAndRealOcclusionVC *vc = [[MTVitualAndRealOcclusionVC alloc] init];
    [MTRouter presentVC:vc];
}

+(void)presentVC:(UIViewController *)vc{
    
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [[MTRouter getRootVC] presentViewController:vc animated:YES completion:nil];
}

+(UIWindow *)getRootWindow{

    NSArray *array =[[[UIApplication sharedApplication] connectedScenes] allObjects];
    UIWindowScene *windowScene = (UIWindowScene *)array[0];
    SceneDelegate *delegate =(SceneDelegate *)windowScene.delegate;
    
    return delegate.window;
}

+(UIViewController *)getRootVC{
    return [self getRootWindow].rootViewController;
}

@end
