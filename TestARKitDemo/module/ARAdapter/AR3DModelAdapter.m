//
//  AR3DModelAdapter.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/12.
//

#import "AR3DModelAdapter.h"
#import "MTARKGestureHelper.h"

@interface AR3DModelAdapter()

@property(nonatomic,strong)MTARKGestureHelper *gestureHelper;

@end

@implementation AR3DModelAdapter

#pragma mark - lazy loading

-(MTARKGestureHelper *)gestureHelper{
    if (!_gestureHelper) {
        _gestureHelper = [[MTARKGestureHelper alloc] init];
    }
    return _gestureHelper;
}

#pragma mark - ascn delegate

//- (nullable SCNNode *)renderer:(id <SCNSceneRenderer>)renderer nodeForAnchor:(ARAnchor *)anchor{
//
//}

- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    
    //判断是否检测出平面
    if (![anchor isKindOfClass:[ARPlaneAnchor class]]) {
        [MTAlertHelper showText:@"未检测到平面" withDuration:2 inVC:[MTRouter getCurrentVC]];
        return;
    }else
    
    NSLog(@"检测到平面，可以add node");
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [MTRouter getCurrentVC];
        [MTAlertHelper showText:@"检测到平面,点击添加" withDuration:2 inVC:[MTRouter getCurrentVC]];
    });
    
}

- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    
}

#pragma mark - ovewride

-(void)buildConfig{
    
    ARWorldTrackingConfiguration *config = [[ARWorldTrackingConfiguration alloc] init];
    config.planeDetection = ARPlaneDetectionHorizontal;
    config.lightEstimationEnabled = YES;
    
    self.config = config;
}

-(void)initData{
    self.scnView.delegate = self;
    self.gestureHelper.sceneView = self.scnView;
    
    [self.gestureHelper addGesture];
}

-(void)dealloc{
    [self.gestureHelper removeGesture];
    self.scnView.delegate = nil;
    self.session.delegate = nil;
    [self removeChildrenNodes];
}
@end
