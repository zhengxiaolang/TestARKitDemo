//
//  MTARBaseVC.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/9.
//

#import "MTARBaseVC.h"

@interface MTARBaseVC ()<ARSCNViewDelegate>

@end

@implementation MTARBaseVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startSession];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self pauseSession];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)initData{
    self.scnView.session = self.session;
}

-(void)createView{
    [self.view addSubview:self.scnView];
    
    [self.view addSubview:self.backBtn];
}
#pragma mark - lazy loading
-(ARSCNView *)scnView{
    if (!_scnView) {
        _scnView = [MTARKitHelper createSCNView];
        _scnView.frame = self.view.bounds;
        _scnView.delegate = self;
    }
    
    return _scnView;
}

-(ARSession *)session{
    if (!_session) {
        _session = [MTARKitHelper createSession];
        
    }
    return _session;
}

-(ARFaceTrackingConfiguration *)config{
    if (!_config) {
        _config = [MTARKitHelper createFaceTrackingConfig];
        //自适应灯光
        _config.lightEstimationEnabled = YES;
    }
    return _config;
}

#pragma mark - ARSCNViewDelegate
- (void)renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    
}

#pragma mark - session method

-(void)startSession{
    [self.session runWithConfiguration:self.config options:ARSessionRunOptionResetTracking|ARSessionRunOptionRemoveExistingAnchors];
}

-(void)pauseSession{
    [self.session pause];
}

@end
