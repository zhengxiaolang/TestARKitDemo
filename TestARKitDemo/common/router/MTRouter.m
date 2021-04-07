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

@implementation MTRouter

+(void)gotoAdd3DVC{
    MTAdd3DModelVC *vc = [[MTAdd3DModelVC alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    UIWindow *window = [MTRouter getRootWindow];
    [window.rootViewController presentViewController:vc animated:YES completion:nil];
}

+(void)gotoCatchTheFlatVC{
    MTCatchTheFlatVC *vc = [[MTCatchTheFlatVC alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    UIWindow *window = [MTRouter getRootWindow];
    [window.rootViewController presentViewController:vc animated:YES completion:nil];
}

+(void)gotoFaceDetectionVC{
    MTFaceDetectionVC *vc = [[MTFaceDetectionVC alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    UIWindow *window = [MTRouter getRootWindow];
    [window.rootViewController presentViewController:vc animated:YES completion:nil];
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
