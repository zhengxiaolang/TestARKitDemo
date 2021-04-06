//
//  MTAdd3DModelVC.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/6.
//

#import "MTAdd3DModelVC.h"

@interface MTAdd3DModelVC ()<ARSCNViewDelegate>

@property(nonatomic,strong)ARSCNView *scnView;

@property(nonatomic,strong)ARSession *session;

@property(nonatomic,strong)ARWorldTrackingConfiguration *config;

@property(nonatomic,assign)SCNVector3 *startVec;

@property(nonatomic,assign)SCNVector3 *endVec;

@property(nonatomic,strong)SCNNode *planeNode;

@end

@implementation MTAdd3DModelVC


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
        //2.设置追踪方向（追踪平面，后面会用到）
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
    
}

- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    
}

#pragma mark - business action

/// 新增3D模型
-(void)add3DModel{
    SCNScene *scene = scene = [SCNScene sceneNamed:@"Models.scnassets/vase/vase.scn"];
    
    //2.获取花瓶节点（一个场景会有多个节点，此处我们只写，花瓶节点则默认是场景子节点的第一个）
    //所有的场景有且只有一个根节点，其他所有节点都是根节点的子节点
    SCNNode *shipNode = scene.rootNode.childNodes[0];
    
    //椅子比较大，可以可以调整Z轴的位置让它离摄像头远一点，，然后再往下一点（椅子太高我们坐不上去）就可以看得全局一点
    shipNode.position = SCNVector3Make(0, -1, -1);//x/y/z/坐标相对于世界原点，也就是相机位置
    
    //3.将花瓶节点添加到当前屏幕中
    [self.scnView.scene.rootNode addChildNode:shipNode];
}

///点击屏幕 新增模型
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self add3DModel];
}

@end
