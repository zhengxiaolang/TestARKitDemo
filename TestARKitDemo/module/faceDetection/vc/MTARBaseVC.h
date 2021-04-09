//
//  MTARBaseVC.h
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/9.
//

#import "MTBaseVC.h"

#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

#import "MTARKitHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface MTARBaseVC : MTBaseVC

@property(nonatomic,strong)ARSCNView *scnView;

@property(nonatomic,strong)ARSession *session;

@property(nonatomic,strong,nonnull)ARConfiguration *config;

-(void)startSession;

-(void)pauseSession;

@end

NS_ASSUME_NONNULL_END
