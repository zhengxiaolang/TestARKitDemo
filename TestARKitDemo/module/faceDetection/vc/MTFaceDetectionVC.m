//
//  MTFaceDetectionVC.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/7.
//

#import "MTFaceDetectionVC.h"
#import "MTARKitHelper.h"

@interface MTFaceDetectionVC ()<ARSCNViewDelegate>

@property(nonatomic,strong)ARSCNView *scnView;

@property(nonatomic,strong)ARSession *session;

@property(nonatomic,strong)ARFaceTrackingConfiguration *config;

@property(nonatomic,strong)UILabel *typeLabel;

@property(nonatomic,strong)UILabel *reaultLabel;

@property(nonatomic,assign)MTFaceDetectionType faceDetectionType;

@property(nonatomic,strong)ARWorldTrackingConfiguration *worldConfig;
@end

@implementation MTFaceDetectionVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.session runWithConfiguration:self.config];
    
    [self.session runWithConfiguration:self.worldConfig];
//    [self.session runWithConfiguration:self.config options:ARSessionRunOptionResetTracking|ARSessionRunOptionRemoveExistingAnchors];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.session pause];
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
    
    [self.view addSubview:self.typeLabel];
    [self.view addSubview:self.reaultLabel];
}


-(void)actionAfterViewDidLoad{
    
    
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

-(ARWorldTrackingConfiguration *)worldConfig{
    if (_worldConfig) {
        _worldConfig = [MTARKitHelper createWorldTrackingConfig];
        _worldConfig.lightEstimationEnabled = YES;
    }
    return _worldConfig;
}
#pragma mark - ARSCNViewDelegate
- (void)renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    
//    if (!anchor || ![anchor isKindOfClass:[ARFaceAnchor class]]) return;
//
//    ARFaceAnchor *faceAnchor = (ARFaceAnchor *)anchor;
    
    
    
}
@end
