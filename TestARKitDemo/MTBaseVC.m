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
@end
