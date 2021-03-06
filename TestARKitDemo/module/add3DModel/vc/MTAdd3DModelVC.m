//
//  MTAdd3DModelVC.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/6.
//

#import "MTAdd3DModelVC.h"
#import "MTAlertHelper.h"
#import "MTRouter.h"

@interface MTAdd3DModelVC ()<ARSCNViewDelegate>

@property(nonatomic,strong)ARSCNView *scnView;

@property(nonatomic,strong)ARSession *session;

@property(nonatomic,strong)ARWorldTrackingConfiguration *config;

@property(nonatomic,strong)SCNNode *lightNode;
@property(nonatomic,strong)SCNNode *cupNode;
@property(nonatomic,assign)BOOL isMoving;

@end

@implementation MTAdd3DModelVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.session runWithConfiguration:self.config];
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
    
    self.gestureHelper.sceneView = self.scnView;
    self.gestureHelper.sceneNodes = self.sceneNodes;
    
//    self.scnView.showsStatistics = YES;
//    self.scnView.debugOptions = ARSCNDebugOptionShowFeaturePoints;
    
}

-(void)createView{
    [self.view addSubview:self.scnView];
    [self.view addSubview:self.backBtn];
}


-(void)actionAfterViewDidLoad{
    
    [self.gestureHelper addGesture];
    
//    SCNScene *scene = [SCNScene sceneNamed:@"Models.scnassets/vase/vase.scn"];
//    SCNNode *node = scene.rootNode.childNodes[0];
//    node.position = SCNVector3Make(0, -0.3,-0.5);
//    node.name=@"vase";
//    [self.scnView.scene.rootNode addChildNode:node];
}

#pragma mark - lazy loading

-(MTARKGestureHelper *)gestureHelper{
    if (!_gestureHelper) {
        _gestureHelper = [[MTARKGestureHelper alloc] init];
    }
    return _gestureHelper;
}

-(ARSCNView *)scnView{
    if (!_scnView) {
        _scnView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
        _scnView.scene = [SCNScene new];
        _scnView.autoenablesDefaultLighting  = YES;
        _scnView.delegate = self;
    }
    
    return _scnView;
}

-(ARSession *)session{
    if (!_session) {
        _session = [[ARSession alloc] init];
//        _session.delegate = self
    }
    return _session;
}

-(ARWorldTrackingConfiguration *)config{
    if (!_config) {
        _config = [[ARWorldTrackingConfiguration alloc] init];
        _config.planeDetection = ARPlaneDetectionHorizontal;
        _config.lightEstimationEnabled = YES;
    }
    return _config;
}

#pragma mark - ascn delegate

//- (nullable SCNNode *)renderer:(id <SCNSceneRenderer>)renderer nodeForAnchor:(ARAnchor *)anchor{
//
//}

- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    
    //???????????????????????????
    if (![anchor isKindOfClass:[ARPlaneAnchor class]]) {
        [MTAlertHelper showText:@"??????????????????" withDuration:2 inVC:self];
        return;
    }else
    
    NSLog(@"????????????????????????add node");
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [MTRouter getCurrentVC];
        [MTAlertHelper showText:@"???????????????,????????????" withDuration:2 inVC:[MTRouter getCurrentVC]];
    });
    
}

- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    
}

#pragma mark - business action

/// ??????3D??????
-(void)add3DModel{
    SCNScene *scene = [SCNScene sceneNamed:@"Models.scnassets/vase/vase.scn"];
    SCNNode *node = scene.rootNode.childNodes[0];
    
    //??????????????????????????????????????????Z???????????????????????????????????????
//    shipNode.position = SCNVector3Make(0, -1, -1);//x/y/z/???????????????????????????????????????????????????
    
    //3.???????????????????????????????????????
    [self.scnView.scene.rootNode addChildNode:node];
}

/////???????????? ????????????
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self add3DModel];
//}

@end
