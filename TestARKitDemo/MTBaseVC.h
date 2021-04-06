//
//  MTBaseVC.h
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/6.
//

#import <UIKit/UIKit.h>

#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTBaseVC : UIViewController


@property(nonatomic,strong)UIButton *backBtn;

/// 初始化事件
-(void)initData;

/// 添加视图
-(void)createView;

/// 视图布局
-(void)layoutSubView;

/// 添加事件
-(void)addEvent;

/// 进入VC后触发的事件
-(void)actionAfterViewDidLoad;


#pragma mark - back action
-(void)gotoBack;

@end

NS_ASSUME_NONNULL_END
