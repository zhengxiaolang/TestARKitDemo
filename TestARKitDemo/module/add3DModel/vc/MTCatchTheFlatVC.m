//
//  MTCatchTheFlatVC.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/6.
//

#import "MTCatchTheFlatVC.h"
#import "MTRouter.h"
#import "UIImage+MT.h"
#import "MTARKGestureHelper.h"

@interface MTCatchTheFlatVC ()<ARSCNViewDelegate,ARSessionDelegate>

@property(nonatomic,strong)ARSCNView *scnView;

@property(nonatomic,strong)ARSession *session;

@property(nonatomic,strong)ARWorldTrackingConfiguration *config;

@property (nonatomic, strong)NSMutableArray<SCNNode *> *sceneNodes;

@property(nonatomic,strong)MTARKGestureHelper *gestureHelper;

@end

@implementation MTCatchTheFlatVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.session runWithConfiguration:self.config];
    
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
    [self.view addSubview:self.saveBtn];
}


-(void)actionAfterViewDidLoad{
    
    [self.gestureHelper addGesture];
}

#pragma mark - lazy loading

-(NSMutableArray<SCNNode *> *)sceneNodes{
    if (!_sceneNodes) {
        _sceneNodes = [[NSMutableArray<SCNNode *> alloc] init];
        
    }
    return _sceneNodes;
}

-(MTARKGestureHelper *)gestureHelper{
    if (!_gestureHelper) {
        _gestureHelper = [[MTARKGestureHelper alloc] init];
        _gestureHelper.sceneView = self.scnView;
        _gestureHelper.sceneNodes = self.sceneNodes;
    }
    return _gestureHelper;
}

-(ARSCNView *)scnView{
    if (!_scnView) {
        _scnView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
        _scnView.delegate = self;
    }
    
    return _scnView;
}

-(ARSession *)session{
    if (!_session) {
        _session = [[ARSession alloc] init];
        
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
    if ([anchor isMemberOfClass:[ARPlaneAnchor class]]) {
        NSLog(@"???????????????");
        
        //????????????3D???????????????ARKit????????????????????????????????????????????????????????????????????????????????????3D???????????????,?????????????????????
        
        //1.??????????????????????????????
        ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
        //2.????????????3D????????????
        //?????????????????????????????????
        SCNBox *plane = [SCNBox boxWithWidth:planeAnchor.extent.x*0.3 height:0 length:planeAnchor.extent.x*0.3 chamferRadius:0];
        //3.??????Material??????3D???????????????????????????????????????????????????????????????
        plane.firstMaterial.diffuse.contents = [UIColor greenColor];
        
        //4.??????????????????3D?????????????????????
        SCNNode *planeNode = [SCNNode nodeWithGeometry:plane];
        //5.??????????????????????????????????????????????????????????????????  SceneKit????????????????????????position???????????????3D????????????????????????SCNVector3Make
        planeNode.position =SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
        [node addChildNode:planeNode];
        
        
        //2.????????????????????????2s????????????????????????????????????3D??????
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //1.????????????????????????
            SCNScene *scene = [SCNScene sceneNamed:@"Models.scnassets/vase/vase.scn"];
            //2.?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
            //??????????????????????????????????????????????????????????????????????????????????????????
            SCNNode *vaseNode = scene.rootNode.childNodes[0];
            
            //4.??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
            vaseNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
            
            //5.???????????????????????????????????????
            //!!!???????????????????????????????????????????????????????????????????????????????????????AR??????????????????????????????????????????????????????????????????????????????????????????????????????
            [node addChildNode:vaseNode];
        });
    }
}

- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    
}

#pragma mark - business action

-(void)savePic{
    CVPixelBufferRef capturedImage = self.scnView.session.currentFrame.capturedImage;
    UIImage *image = [UIImage convert:capturedImage];
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    
    if (!error) {
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//        });
        
        NSLog(@"????????????");
    }else{
        
    }
}


#pragma mark -ARSessionDelegate

//????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
    NSLog(@"????????????");
    
}
- (void)session:(ARSession *)session didAddAnchors:(NSArray<ARAnchor*>*)anchors
{
    NSLog(@"????????????");
    
}


- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<ARAnchor*>*)anchors
{
    NSLog(@"????????????");
    
}


- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<ARAnchor*>*)anchors
{
    NSLog(@"????????????");
    
}

@end
