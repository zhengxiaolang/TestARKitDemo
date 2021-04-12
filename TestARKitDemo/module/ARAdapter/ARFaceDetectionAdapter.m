//
//  ARFaceDetectionAdapter.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/12.
//

#import "ARFaceDetectionAdapter.h"
#import "MTFaceDetectionHelper.h"

@interface ARFaceDetectionAdapter()<ARSCNViewDelegate>

@property(nonatomic,strong)UILabel *resultLabel;

@property(nonatomic,assign)MTFaceDetectionType faceDetectionType;

@property(nonatomic,strong)UIButton *switchBtn;

@property(nonatomic,strong)UIButton *restBtn;

@end

@implementation ARFaceDetectionAdapter


-(void)initData{
    self.scnView.delegate = self;
    
    [self.scnView addSubview:self.resultLabel];
    [self.scnView addSubview:self.switchBtn];
    [self.scnView addSubview:self.restBtn];
    
    self.resultLabel.text = [NSString stringWithFormat:@"识别:%@",[MTFaceDetectionHelper getLocatonNameWithTypeWithType:self.faceDetectionType]];
}

-(void)buildConfig{
    
    ARFaceTrackingConfiguration *config = [MTARKitHelper createFaceTrackingConfig];
    config.lightEstimationEnabled = YES;
    self.config = config;
}

-(void)startSession{
    [self.session runWithConfiguration:self.config options:ARSessionRunOptionResetTracking|ARSessionRunOptionRemoveExistingAnchors];
}

-(void)resetSession{
    [self.session runWithConfiguration:self.config options:ARSessionRunOptionResetTracking|ARSessionRunOptionRemoveExistingAnchors];
}

#pragma mark - lazy loading

-(UILabel *)resultLabel{
    if (!_resultLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 160, 44, 150, 40)];
        label.textColor = [UIColor redColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentRight;
        _resultLabel = label;
    }
    return _resultLabel;
}


-(UIButton *)switchBtn{
    if (!_switchBtn) {
        _switchBtn = [[UIButton alloc] init];
        _switchBtn.frame = CGRectMake(130, 44, 100, 40);
        [_switchBtn setTitle:@"切换部位" forState:UIControlStateNormal];
        [_switchBtn addTarget:self action:@selector(switchLocation) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchBtn;
}

-(UIButton *)restBtn{
    if (!_restBtn) {
        _restBtn = [[UIButton alloc] init];
        _restBtn.frame = CGRectMake(220, 44, 60, 40);
        [_restBtn setTitle:@"reset" forState:UIControlStateNormal];
        [_restBtn addTarget:self action:@selector(resetSession) forControlEvents:UIControlEventTouchUpInside];
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
        NSString *result = isDetected?@"成功":@"检测中";
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

-(void)dealloc{
    self.scnView.delegate = nil;
    [self.resultLabel removeFromSuperview];
    self.resultLabel = nil;
    [self.restBtn removeFromSuperview];
    self.restBtn = nil;
    [self.switchBtn removeFromSuperview];
    self.switchBtn = nil;
}

@end
