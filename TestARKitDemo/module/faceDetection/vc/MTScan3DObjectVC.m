//
//  MTScan3DObjectVC.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/9.
//

#import "MTScan3DObjectVC.h"
//#import <RealityKit/RealityKit-Swift.h>

API_AVAILABLE(ios(13.0))
@interface MTScan3DObjectVC ()<ARSessionDelegate>

//@property(nonatomic,strong)ARView *arView;

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

-(void)createView{
//    [self.view addSubview:self.arView];
    [self.view addSubview:self.backBtn];
}
-(void)actionAfterViewDidLoad{
    
}
#pragma mark - overrie session method

-(void)startSession{
    [self.session runWithConfiguration:self.config];
}

-(void)pauseSession{
    [self.session pause];
}

#pragma mark - lazy loading

//-(ARView *)arView API_AVAILABLE(ios(13.0)){
//    if (!_arView) {
//        _arView = [[ARView alloc] initWithFrame:self.view.bounds];
//    }
//    return _arView;
//}
#pragma mark - init Data

-(void)setUpConfig{
    ARWorldTrackingConfiguration *config = [[ARWorldTrackingConfiguration alloc] init];
    config.planeDetection = ARPlaneDetectionHorizontal;
    if (@available(iOS 12.0, *)) {
        config.environmentTexturing = AREnvironmentTexturingAutomatic;
        
    } else {
        // Fallback on earlier versions
    }
    
    if (@available(iOS 14.0, *)) {
        config.frameSemantics = ARFrameSemanticSceneDepth;
    } else {
        // Fallback on earlier versions
    }
    
    self.config = config;
}

-(void)setUPSession{
    
//    self.arView.session = self.session;
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
