//
//  MTBaseVC.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/6.
//

#import "MTBaseVC.h"

@interface MTBaseVC ()

@end

@implementation MTBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUp];
}

-(void)setUp{
    [self initData];
    [self createView];
    [self layoutSubView];
    [self addEvent];
    [self actionAfterViewDidLoad];
}

-(void)initData{
    
}

-(void)createView{
    
}

-(void)layoutSubView{
    
}

-(void)addEvent{
    
}

-(void)actionAfterViewDidLoad{
    
}

#pragma mark - lazy loading

-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.frame = CGRectMake(0, 44, 60, 40);
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(gotoBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

-(void)gotoBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
