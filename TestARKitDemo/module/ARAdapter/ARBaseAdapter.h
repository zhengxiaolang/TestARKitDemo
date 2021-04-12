//
//  ARBaseAdapter.h
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/12.
//

#import <Foundation/Foundation.h>
#import "MTARKitHelper.h"

#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

#import "MTAlertHelper.h"
#import "MTRouter.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARBaseAdapter : NSObject<YHARAdapterProtocol>

@property(nonatomic,weak)ARSCNView *scnView;

@property(nonatomic,weak)ARSession *session;

@property(nonatomic,strong)ARConfiguration *config;

-(void)connectWithView:(ARSCNView *)scnView withSession:(ARSession *)session;

-(void)buildConfig;

-(void)initData;

-(void)removeChildrenNodes;

@end

NS_ASSUME_NONNULL_END
