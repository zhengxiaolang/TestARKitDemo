//
//  MTAdd3DModelVC.h
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/6.
//

#import "MTBaseVC.h"
#import "MTARKGestureHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface MTAdd3DModelVC : MTBaseVC

@property (nonatomic, strong)NSMutableArray<SCNNode *> *sceneNodes;

@property(nonatomic,strong)MTARKGestureHelper *gestureHelper;

@end

NS_ASSUME_NONNULL_END
