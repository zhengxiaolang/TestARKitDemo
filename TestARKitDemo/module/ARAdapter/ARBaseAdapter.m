//
//  ARBaseAdapter.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/12.
//

#import "ARBaseAdapter.h"

@interface ARBaseAdapter()

@end

@implementation ARBaseAdapter

-(void)connectWithView:(ARSCNView *)scnView withSession:(ARSession *)session{
    self.scnView = scnView;
    self.session = session;
    
    [self buildConfig];
    
    [self initData];
    
    [self resetSession];
}

-(void)startSession{
    [self.session runWithConfiguration:self.config];
}

-(void)pauseSession{
    [self.session pause];
}

-(void)resetSession{
    [self.session runWithConfiguration:self.config];
}

-(void)buildConfig{
    
}

-(void)initData{
    
}

-(void)removeChildrenNodes{
    
    NSArray *nodes = self.scnView.scene.rootNode.childNodes;
    //默认结构有3个child，添加后为
    for (NSInteger i = 3; i < nodes.count; i++) {

        if (i > 2) {
            SCNNode *node = nodes[i];
            [node removeFromParentNode];
        }
    }
    NSLog(@"children 共%ld个:",nodes.count);
//    [nodes makeObjectsPerformSelector:@selector(removeFromParentNode)];
}
@end
