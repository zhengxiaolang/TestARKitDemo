//
//  MTFaceDetectionVC.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/7.
//

#import "MTFaceDetectionVC.h"
#import "MTARKitHelper.h"
#import "MTFaceDetectionHelper.h"

@interface MTFaceDetectionVC ()<ARSCNViewDelegate>

@property(nonatomic,strong)ARSCNView *scnView;

@property(nonatomic,strong)ARSession *session;

@property(nonatomic,strong)ARFaceTrackingConfiguration *config;

@property(nonatomic,strong)UILabel *resultLabel;

@property(nonatomic,assign)MTFaceDetectionType faceDetectionType;

@property(nonatomic,strong)ARWorldTrackingConfiguration *worldConfig;

@property(nonatomic,strong)UIButton *switchBtn;

@property(nonatomic,strong)UIButton *restBtn;
@end

@implementation MTFaceDetectionVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.session runWithConfiguration:self.config];
    
//    [self.session runWithConfiguration:self.worldConfig];
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
    self.resultLabel.text = @"人脸识别";
}

-(void)createView{
    [self.view addSubview:self.scnView];
    
    [self.view addSubview:self.backBtn];
    
    [self.view addSubview:self.resultLabel];
    
    [self.view addSubview:self.switchBtn];
    [self.view addSubview:self.restBtn];
}


-(void)layoutSubView{
    
    self.resultLabel.frame = CGRectMake(MT_SCREEN_WIDTH - 160, 44, 150, 40);
}

-(void)actionAfterViewDidLoad{
    
//    self.faceDetectionType = arc4random()%7;
    
    self.resultLabel.text = [NSString stringWithFormat:@"识别:%@",[MTFaceDetectionHelper getLocatonNameWithTypeWithType:self.faceDetectionType]];
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

-(ARWorldTrackingConfiguration *)worldConfig{
    if (_worldConfig) {
        _worldConfig = [MTARKitHelper createWorldTrackingConfig];
        _worldConfig.lightEstimationEnabled = YES;
    }
    return _worldConfig;
}

-(UIButton *)switchBtn{
    if (!_switchBtn) {
        _switchBtn = [[UIButton alloc] init];
        _switchBtn.frame = CGRectMake(100, 44, 100, 40);
        [_switchBtn setTitle:@"切换部位" forState:UIControlStateNormal];
        [_switchBtn addTarget:self action:@selector(switchLocation) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchBtn;
}

-(UIButton *)restBtn{
    if (!_restBtn) {
        _restBtn = [[UIButton alloc] init];
        _restBtn.frame = CGRectMake(200, 44, 60, 40);
        [_restBtn setTitle:@"reset" forState:UIControlStateNormal];
        [_restBtn addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    }
    return _restBtn;
}
#pragma mark - ARSCNViewDelegate
- (void)renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    
    if (!anchor || ![anchor isKindOfClass:[ARFaceAnchor class]]) return;

    ARFaceAnchor *faceAnchor = (ARFaceAnchor *)anchor;
    
    BOOL isDetected = NO;
    
    switch (self.faceDetectionType) {
        case MTFaceDetectionTypeOpenMouth:
            isDetected = [MTFaceDetectionHelper isOpenMouthWithFaceAnchor:faceAnchor];
            break;
            
        case MTFaceDetectionTypeBlinkEyes:
            isDetected = [MTFaceDetectionHelper isBlinkEyesWithFaceAnchor:faceAnchor];
            break;
            
        case MTFaceDetectionTypeTurnLeft:
            isDetected = [MTFaceDetectionHelper isTurnLeftWithFaceAnchor:faceAnchor];
            break;
            
        case MTFaceDetectionTypeTurnRight:
            isDetected = [MTFaceDetectionHelper isTurnRightWithFaceAnchor:faceAnchor];
            break;
        case MTFaceDetectionTypeRiseHead:
            isDetected = [MTFaceDetectionHelper isRiseHeadWithFaceAnchor:faceAnchor];
            break;
        case MTFaceDetectionTypeBowHead:
            isDetected = [MTFaceDetectionHelper isBowHeadWithFaceAnchor:faceAnchor];
            
            break;
        case MTFaceDetectionTypeFrownBled:
            isDetected = [MTFaceDetectionHelper isFrownBledWithFaceAnchor:faceAnchor];
            
            break;
        default:
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *result = isDetected?@"成功":@"失败";
        UIColor *textColor = isDetected?[UIColor greenColor]:[UIColor redColor];
        self.resultLabel.text = [NSString stringWithFormat:@"%@%@",[MTFaceDetectionHelper getLocatonNameWithTypeWithType:self.faceDetectionType],result];
        
        self.resultLabel.textColor = textColor;
        
    });
    
    if (isDetected) {
        [self.session pause];
    }
}

-(void)switchLocation{
    
    self.faceDetectionType = arc4random()%7;
    
    self.resultLabel.text = [NSString stringWithFormat:@"识别:%@",[MTFaceDetectionHelper getLocatonNameWithTypeWithType:self.faceDetectionType]];
}

-(void)reset{
    [self.session runWithConfiguration:self.config];
}
@end
