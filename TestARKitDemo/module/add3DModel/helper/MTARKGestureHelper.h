//
//  MTARKGestureHelper.h
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/8.
//

#import <Foundation/Foundation.h>

#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTARKGestureHelper : NSObject

@property(nonatomic,weak)ARSCNView *sceneView;

@property(nonatomic,weak)NSMutableArray<SCNNode *> *sceneNodes;

/// 新增手势
- (void)addGesture;

-(void)removeGesture;

@end

NS_ASSUME_NONNULL_END
