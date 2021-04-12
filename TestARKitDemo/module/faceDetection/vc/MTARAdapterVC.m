//
//  MTARAdapterVC.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/12.
//

#import "MTARAdapterVC.h"
#import "ARBaseAdapter.h"

#import "AR3DModelAdapter.h"
#import "ARPlanDetetionAdapter.h"
#import "ARFaceMaskAdapter.h"

@interface MTARAdapterVC ()

@property(nonatomic,strong)ARSCNView *scnView;

@property(nonatomic,strong)ARSession *session;

@property(nonatomic,strong)ARBaseAdapter *adapter;

@property(nonatomic,strong)UIButton *switchBtn;

@end

@implementation MTARAdapterVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.adapter startSession];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.adapter resetSession];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)initData{
    self.scnView.session = self.session;
    
    [self init3DModel];
}

-(void)createView{
    [self.view addSubview:self.scnView];
    
    [self.view addSubview:self.backBtn];
    
    [self.view addSubview:self.switchBtn];
}

#pragma mark - lazy loading

-(UIButton *)switchBtn{
    if (!_switchBtn) {
        _switchBtn = [[UIButton alloc] init];
        _switchBtn.frame = CGRectMake(120, 44, 80, 40);
        [_switchBtn setTitle:@"切换模式" forState:UIControlStateNormal];
        [_switchBtn addTarget:self action:@selector(switchMode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchBtn;
}

-(ARSCNView *)scnView{
    if (!_scnView) {
        _scnView = [MTARKitHelper createSCNView];
        _scnView.frame = self.view.bounds;
//        _scnView.delegate = self;
    }
    
    return _scnView;
}

-(ARSession *)session{
    if (!_session) {
        _session = [MTARKitHelper createSession];
        
    }
    return _session;
}

#pragma mark - bussiness action

-(void)switchMode{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"切换模式"
                                 message:nil
                                 preferredStyle: (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet];
    
    UIAlertAction *threeDAction = [UIAlertAction actionWithTitle:@"add 3d model"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          
        [self init3DModel];
                                                      }];
    
    UIAlertAction *planAction = [UIAlertAction actionWithTitle:@"平面检测"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
        [self initPlanDetetion];
                                                       }];
    
    UIAlertAction *faceMaskAction = [UIAlertAction actionWithTitle:@"新增面具"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
        [self initFaceMask];
                                                       }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                         }];
    [alert addAction:threeDAction];
    
    [alert addAction:planAction];
    
    [alert addAction:faceMaskAction];
    
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)connetViewAndSession{
    [self.adapter connectWithView:self.scnView withSession:self.session];
}

-(void)init3DModel{
    self.adapter = [AR3DModelAdapter new];
    [self connetViewAndSession];
}

-(void)initPlanDetetion{
    self.adapter = [ARPlanDetetionAdapter new];
    [self connetViewAndSession];
}

-(void)initFaceDetetion{
    self.adapter = [ARFaceMaskAdapter new];
    [self connetViewAndSession];
}

-(void)initFaceMask{
    self.adapter = [ARFaceMaskAdapter new];
    [self connetViewAndSession];
}

-(void)init3DScan{
    
}

-(void)initOcclusion{
    
}

@end
