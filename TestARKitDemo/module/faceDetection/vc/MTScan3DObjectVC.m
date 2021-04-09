//
//  MTScan3DObjectVC.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/9.
//

#import "MTScan3DObjectVC.h"

@interface MTScan3DObjectVC ()<ARSessionDelegate>

@end

@implementation MTScan3DObjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)initData{
    [super initData];
    
    [self setUpConfig];
    [self setUPSession];
}

-(void)actionAfterViewDidLoad{
    
//    [self.scnView.session createReferenceObjectWithTransform:(simd_float4x4) center:<#(simd_float3)#> extent:<#(simd_float3)#> completionHandler:^(ARReferenceObject * _Nullable referenceObject, NSError * _Nullable error) {
//        
//    }];
}
#pragma mark - overrie session method

-(void)startSession{
    [self.session runWithConfiguration:self.config];
}

-(void)pauseSession{
    [self.session pause];
}

#pragma mark - init Data

-(void)setUpConfig{
    ARObjectScanningConfiguration *scanConfig = [[ARObjectScanningConfiguration alloc] init];
    scanConfig.planeDetection = ARPlaneDetectionHorizontal;
    
    self.config = scanConfig;
}

-(void)setUPSession{
    self.session.delegate = self;
}

#pragma mark - ascn delegate

//- (nullable SCNNode *)renderer:(id <SCNSceneRenderer>)renderer nodeForAnchor:(ARAnchor *)anchor{
//
//}

- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    
    NSLog(@"add node");
}

- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    NSLog(@"didUpdateNode");
}

#pragma mark - ASCNSessionDelegate

- (void)session:(ARSession *)session cameraDidChangeTrackingState:(ARCamera *)camera{
    
}

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
    NSLog(@"相机移动");
    
}
- (void)session:(ARSession *)session didAddAnchors:(NSArray<ARAnchor*>*)anchors
{
    NSLog(@"添加锚点");
    
}

- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<ARAnchor*>*)anchors
{
    NSLog(@"刷新锚点");
    
}

- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<ARAnchor*>*)anchors
{
    NSLog(@"移除锚点");
    
}

@end
