//
//  MTFaceAddMaskVC.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/8.
//

#import "MTFaceAddMaskVC.h"

#import "MTARKitHelper.h"
#import "MTFaceDetectionHelper.h"

@interface MTFaceAddMaskVC ()<ARSCNViewDelegate>

@property(nonatomic,strong)ARSCNView *scnView;

@property(nonatomic,strong)ARSession *session;

@property(nonatomic,strong)ARFaceTrackingConfiguration *config;

@property(nonatomic,strong)UILabel *resultLabel;

@property(nonatomic,strong)SCNNode *faceNode;

@end

@implementation MTFaceAddMaskVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.session runWithConfiguration:self.config options:ARSessionRunOptionResetTracking|ARSessionRunOptionRemoveExistingAnchors];
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
    self.resultLabel.text = @"新增面具";
}

-(void)createView{
    [self.view addSubview:self.scnView];
    
    [self.view addSubview:self.backBtn];
    
    [self.view addSubview:self.resultLabel];
}

-(void)layoutSubView{
    
    self.resultLabel.frame = CGRectMake(MT_SCREEN_WIDTH - 160, 44, 150, 40);
}

-(void)actionAfterViewDidLoad{
}

#pragma mark - lazy loading

-(UILabel *)resultLabel{
    if (!_resultLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor redColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentRight;
        _resultLabel = label;
    }
    return _resultLabel;
}
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

- (SCNNode *)faceNode {
    if (!_faceNode) {
        
        id<MTLDevice> device = self.scnView.device;
        ARSCNFaceGeometry *geometry = [ARSCNFaceGeometry faceGeometryWithDevice:device fillMesh:NO];
        SCNMaterial *material = geometry.firstMaterial;
        material.fillMode = SCNFillModeFill;
//        material.fillMode = SCNFillModeLines;
        material.diffuse.contents = [UIImage imageNamed:@"face_green"];
        
//        material.lightingModelName = SCNLightingModelPhong;
//        material.lightingModelName = SCNLightingModelBlinn;
        
        _faceNode = [SCNNode nodeWithGeometry:geometry];
//        _faceNode.name = @"textureMask";
    }
    
    return _faceNode;
}
#pragma mark - ARSCNViewDelegate
- (void)renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    
    if (!anchor || ![anchor isKindOfClass:[ARFaceAnchor class]]) return;
    ARFaceAnchor *faceAnchor = (ARFaceAnchor *)anchor;
//    ARBodyAnchor ARCamera
    [node addChildNode:self.faceNode];
    
//    faceAnchor.rightEyeTransform;

    ARSCNFaceGeometry *faceGeometry = (ARSCNFaceGeometry *)self.faceNode.geometry;
    if (faceGeometry && [faceGeometry isKindOfClass:[ARSCNFaceGeometry class]]) {
        [faceGeometry updateFromFaceGeometry:faceAnchor.geometry];
    }
}

-(void)reset{
    
//    [self.session runWithConfiguration:self.config];
    [self.session runWithConfiguration:self.config options:ARSessionRunOptionResetTracking|ARSessionRunOptionRemoveExistingAnchors];
}

@end
