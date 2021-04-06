//
//  ViewController.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/6.
//

#import "ViewController.h"

#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

#import "MTCatchTheFlatVC.h"
#import "MTAdd3DModelVC.h"

@interface ViewController ()

@property(nonatomic,strong)NSArray *textArry;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)createView{
    
    for (NSInteger i = 0; i < self.textArry.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100 + i * 70, self.view.frame.size.width, 50)];
        btn.tag = i;
        
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn addTarget: self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:self.textArry[i] forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
}
#pragma mark - lazy loading

-(NSArray *)textArry{
    if (!_textArry) {
        _textArry = [[NSArray alloc] initWithObjects:@"新增3D模型",@"捕捉平地",@"随着相机旋转", nil];
    }
    return _textArry;
}

#pragma mark - business action

-(void)clickBtn:(UIButton *)btn{
    NSLog(@"%ld",btn.tag);
    
    switch (btn.tag) {
        case 0:
            [self gotoAdd3DVC];
            break;
            
        case 1:
            [self gotoCatchTheFlatVC];
            break;
            
        case 2:
            
            break;
        default:
            break;
    }
}

-(void)gotoAdd3DVC{
    MTAdd3DModelVC *vc = [[MTAdd3DModelVC alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)gotoCatchTheFlatVC{
    MTCatchTheFlatVC *vc = [[MTCatchTheFlatVC alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}
@end
