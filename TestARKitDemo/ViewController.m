//
//  ViewController.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/6.
//

#import "ViewController.h"

#import "MTRouter.h"

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
        _textArry = [[NSArray alloc] initWithObjects:@"新增3D模型",@"捕捉平地",@"脸部识别", nil];
    }
    return _textArry;
}

#pragma mark - business action

-(void)clickBtn:(UIButton *)btn{
    NSLog(@"%ld",btn.tag);
    
    switch (btn.tag) {
        case 0:
            [MTRouter gotoAdd3DVC];
            break;
            
        case 1:
            [MTRouter gotoCatchTheFlatVC];
            break;
            
        case 2:
            [MTRouter gotoFaceDetectionVC];
            break;
        default:
            break;
    }
}

@end
