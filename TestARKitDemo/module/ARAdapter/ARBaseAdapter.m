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
    [self.scnView.scene.rootNode.childNodes makeObjectsPerformSelector:@selector(removeFromParentNode)];
}
@end
