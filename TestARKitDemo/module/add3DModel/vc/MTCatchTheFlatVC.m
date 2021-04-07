//
//  MTCatchTheFlatVC.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/6.
//

#import "MTCatchTheFlatVC.h"
#import "MTRouter.h"

@interface MTCatchTheFlatVC ()<ARSCNViewDelegate,ARSessionDelegate>

@property(nonatomic,strong)ARSCNView *scnView;

@property(nonatomic,strong)ARSession *session;

@property(nonatomic,strong)ARWorldTrackingConfiguration *config;

@property(nonatomic,assign)SCNVector3 *startVec;

@property(nonatomic,assign)SCNVector3 *endVec;

@property(nonatomic,strong)SCNNode *planeNode;

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
    
    
}

#pragma mark - lazy loading

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
        //2.设置追踪方向（追踪平面，用于平面检测）
        _config.planeDetection = ARPlaneDetectionHorizontal;
        //3.自适应灯光（相机从暗到强光快速过渡效果会平缓一些）
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
        
        //添加一个3D平面模型，ARKit只有捕捉能力，锚点只是一个空间位置，要想更加清楚看到这个空间，我们需要给空间添加一个平地的3D模型来渲染他
        
        //1.获取捕捉到的平地锚点
        ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
        //2.创建一个3D物体模型    （系统捕捉到的平地是一个不规则大小的长方形，这里我们将其变成一个长方形，并且是否对平地做了一个缩放效果）
        //参数分别是长宽高和圆角
        SCNBox *plane = [SCNBox boxWithWidth:planeAnchor.extent.x*0.3 height:0 length:planeAnchor.extent.x*0.3 chamferRadius:0];
        //3.使用Material渲染3D模型（默认模型是白色的，我改成显眼的绿色）
        plane.firstMaterial.diffuse.contents = [UIColor greenColor];
        
        //4.创建一个基于3D物体模型的节点
        SCNNode *planeNode = [SCNNode nodeWithGeometry:plane];
        //5.设置节点的位置为捕捉到的平地的锚点的中心位置  SceneKit框架中节点的位置position是一个基于3D坐标系的矢量坐标SCNVector3Make
        planeNode.position =SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
        
        self.planeNode = planeNode;
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
    UIImage *image = [self convert:capturedImage];
    
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

- (UIImage *)convert:(CVPixelBufferRef)pixelBuffer {
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];

    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
        createCGImage:ciImage
             fromRect:CGRectMake(0, 0, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer))];

    UIImage *uiImage = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);

    return uiImage;
}
/// 新增3D模型
-(void)add3DModel{
    //1.使用场景加载scn文件（scn格式文件是一个基于3D建模的文件，使用3DMax软件可以创建，这里系统有一个默认的3D花瓶）--------
        SCNScene *scene = [SCNScene sceneNamed:@"Models.scnassets/vase/vase.scn"];
        //2.获取花瓶节点（一个场景会有多个节点，此处我们只写，飞机节点则默认是场景子节点的第一个）
        //所有的场景有且只有一个根节点，其他所有节点都是根节点的子节点
        
        SCNNode *shipNode = scene.rootNode.childNodes[0];
        
        self.planeNode = shipNode;
        
        //台灯比较大，适当缩放一下并且调整位置让其在屏幕中间
    
        SCNVector3 scale = SCNVector3Make(0.5, 0.5, 0.5);
        SCNVector3 position = SCNVector3Make(0, -15,-15);
    
        shipNode.scale = scale;
        shipNode.position = position;
        ;
        //一个台灯的3D建模不是一气呵成的，可能会有很多个子节点拼接，所以里面的子节点也要一起改，否则上面的修改会无效
        for (SCNNode *node in shipNode.childNodes) {
            node.scale = scale;
            node.position = position;
        }
        
        self.planeNode.position = SCNVector3Make(0, 0, -20);
        
        //3.绕相机旋转
        //绕相机旋转的关键点在于：在相机的位置创建一个空节点，然后将台灯添加到这个空节点，最后让这个空节点自身旋转，就可以实现台灯围绕相机旋转
        //1.为什么要在相机的位置创建一个空节点呢？因为你不可能让相机也旋转
        //2.为什么不直接让台灯旋转呢？ 这样的话只能实现台灯的自转，而不能实现公转
        SCNNode *node1 = [[SCNNode alloc] init];
        
        //空节点位置与相机节点位置一致
        node1.position = self.scnView.scene.rootNode.position;
        
        //将空节点添加到相机的根节点
        [self.scnView.scene.rootNode addChildNode:node1];
        
        
        // !!!将台灯节点作为空节点的子节点，如果不这样，那么你将看到的是台灯自己在转，而不是围着你转
        [node1 addChildNode:self.planeNode];
        
        
        //旋转核心动画
        CABasicAnimation *moonRotationAnimation = [CABasicAnimation animationWithKeyPath:@"rotation"];
        
        //旋转周期
        moonRotationAnimation.duration = 30;
        
        //围绕Y轴旋转360度  （不明白ARKit坐标系的可以看我们之前的文章）
        moonRotationAnimation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
        //无限旋转  重复次数为无穷大
        moonRotationAnimation.repeatCount = FLT_MAX;
        
        //开始旋转  ！！！：切记这里是让空节点旋转，而不是台灯节点。  理由同上
        [node1 addAnimation:moonRotationAnimation forKey:@"moon rotation around earth"];
}

///点击屏幕 新增模型
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self add3DModel];
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
