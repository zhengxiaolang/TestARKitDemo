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
        NSLog(@"捕捉到平地");
        
        //添加一个3D平面模型，ARKit只有捕捉能力，锚点只是一个空间位置，给空间添加一个平地的3D模型来渲染,方便看得更清楚
        
        //1.获取捕捉到的平地锚点
        ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
        //2.创建一个3D物体模型
        //参数分别是长宽高和圆角
        SCNBox *plane = [SCNBox boxWithWidth:planeAnchor.extent.x*0.3 height:0 length:planeAnchor.extent.x*0.3 chamferRadius:0];
        //3.使用Material渲染3D模型（默认模型是白色的，我改成显眼的绿色）
        plane.firstMaterial.diffuse.contents = [UIColor greenColor];
        
        //4.创建一个基于3D物体模型的节点
        SCNNode *planeNode = [SCNNode nodeWithGeometry:plane];
        //5.设置节点的位置为捕捉到的平地的锚点的中心位置  SceneKit框架中节点的位置position是一个基于3D坐标系的矢量坐标SCNVector3Make
        planeNode.position =SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
        [node addChildNode:planeNode];
        
        
        //2.当捕捉到平地时，2s之后开始在平地上添加一个3D模型
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //1.创建一个花瓶场景
            SCNScene *scene = [SCNScene sceneNamed:@"Models.scnassets/vase/vase.scn"];
            //2.获取花瓶节点（一个场景会有多个节点，此处我们只写，花瓶节点则默认是场景子节点的第一个）
            //所有的场景有且只有一个根节点，其他所有节点都是根节点的子节点
            SCNNode *vaseNode = scene.rootNode.childNodes[0];
            
            //4.设置花瓶节点的位置为捕捉到的平地的位置，如果不设置，则默认为原点位置，也就是相机位置
            vaseNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
            
            //5.将花瓶节点添加到当前屏幕中
            //!!!此处一定要注意：花瓶节点是添加到代理捕捉到的节点中，而不是AR试图的根节点。因为捕捉到的平地锚点是一个本地坐标系，而不是世界坐标系
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
        
        NSLog(@"保存成功");
    }else{
        
    }
}


#pragma mark -ARSessionDelegate

//会话位置更新（监听相机的移动），此代理方法会调用非常频繁，只要相机移动就会调用，如果相机移动过快，会有一定的误差

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
