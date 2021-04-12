//
//  MTARKGestureHelper.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/8.
//

#import "MTARKGestureHelper.h"

@interface MTARKGestureHelper ()

@property (nonatomic, strong)SCNHitTestResult *removeHitResult;

@property (nonatomic, strong)ARHitTestResult *hitTestResult;

@property (nonatomic, strong)SCNNode *movedNode;

@property (nonatomic, strong)NSMutableArray *gestureArray;

@end

@implementation MTARKGestureHelper

#pragma mark - Set Gesture Recognizers

- (void)addGesture {
    
    //点击新增 或者 删除
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addObject:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.sceneView addGestureRecognizer:tapGesture];
    
    //移动
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveObject:)];
    [panGesture setMaximumNumberOfTouches:1];
    [panGesture setMinimumNumberOfTouches:1];
    [self.sceneView addGestureRecognizer:panGesture];
    
    //缩放
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleObject:)];
    [self.sceneView addGestureRecognizer:pinchGesture];
    
    [self.gestureArray addObject:tapGesture];
    [self.gestureArray addObject:panGesture];
    [self.gestureArray addObject:pinchGesture];
}

#pragma mark - GestureRecognizer

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


#pragma mark - Handle Gesture Recognizers

- (void)addObject: (UITapGestureRecognizer *)recognizer {
    
    [self insertOrRemove:recognizer];
}

-(void)moveObject:(UIPanGestureRecognizer *)recognizer {
    
    [self moveAndDragARObject:recognizer];
}

- (void)scaleObject: (UIPinchGestureRecognizer *)recognizer {
    
    [self scaleARObject:recognizer];
}

#pragma mark - Check Existing ARObject To Insert Or Remove

- (void)insertOrRemove:(UITapGestureRecognizer *) recognizer {
    
    CGPoint holdPoint = [recognizer locationInView:self.sceneView];
    NSArray<SCNHitTestResult *> *result = [self.sceneView hitTest:holdPoint
                                                          options:@{SCNHitTestBoundingBoxOnlyKey: @YES, SCNHitTestFirstFoundOnlyKey: @YES}];
    if (result.count == 0) {
        [self insertARObject:recognizer];
    } else {
        //捕捉到已经存在的AR对象，可以进行删除
        self.removeHitResult = [result firstObject];
        NSLog(@"可以删除选中的对象");
    }
}

#pragma mark - Insert AR Object

- (void)insertARObject:(UITapGestureRecognizer *)recognizer {
    
    CGPoint tapPoint = [recognizer locationInView:self.sceneView];
    NSArray<ARHitTestResult *> *result = [self.sceneView hitTest:tapPoint types:ARHitTestResultTypeExistingPlaneUsingExtent];
    
//    ARHitTestResultTypeExistingPlaneUsingExtent
    
//    ARRaycastQuery *query = [self.sceneView raycastQueryFromPoint:tapPoint allowingTarget:nil alignment:ARRaycastTargetAlignmentAny];
    
    if (result.count == 0) {
        NSLog(@"NO OBJ");
        return;
    }
    ARHitTestResult *hitResult = [result firstObject];
    
//    SCNScene *scene = [SCNScene sceneNamed:@"Models.scnassets/cup/cup.scn"];
    SCNScene *scene = [SCNScene sceneNamed:@"Models.scnassets/vase/vase.scn"];
//    SCNScene *scene = self.sceneView.scene;
    //[SCNScene sceneNamed:self.sceneName];
    
    SCNNode *node = [scene.rootNode clone];
    
    float insertionYOffset = 0.01;
    node.position = SCNVector3Make(
                                   hitResult.worldTransform.columns[3].x,
                                   hitResult.worldTransform.columns[3].y + insertionYOffset,
                                   hitResult.worldTransform.columns[3].z
                                   );
    [self.sceneNodes addObject:node];
    [self.sceneView.scene.rootNode addChildNode:node];
}

#pragma mark - Remove AR object

- (void)removeARObject:(id)sender {
    
    [[self.removeHitResult.node parentNode] removeFromParentNode];
//    self.removeButton.hidden = YES;
}

#pragma mark - Move/Drag AR Object

-(void)moveAndDragARObject:(UIPanGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint tapPoint = [recognizer locationInView:self.sceneView];
        NSArray <SCNHitTestResult *> *result = [self.sceneView hitTest:tapPoint options:nil];
        NSArray <ARHitTestResult *> *hitResults = [self.sceneView hitTest:tapPoint types:ARHitTestResultTypeFeaturePoint];
        
        if ([result count] == 0) {
            return;
        }
        SCNHitTestResult *hitResult = [result firstObject];
        self.movedNode = [[hitResult node] parentNode];
        self.hitTestResult = [hitResults firstObject];
    }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (self.movedNode) {
            CGPoint tapPoint = [recognizer locationInView:self.sceneView];
            NSArray <ARHitTestResult *> *hitResults = [self.sceneView hitTest:tapPoint types:ARHitTestResultTypeFeaturePoint];
            ARHitTestResult *result = [hitResults lastObject];
            
            [SCNTransaction begin];
            
            SCNMatrix4 initialMatrix = SCNMatrix4FromMat4(self.hitTestResult.worldTransform);
            SCNVector3 initialVector = SCNVector3Make(initialMatrix.m41, initialMatrix.m42, initialMatrix.m43);
            
            SCNMatrix4 matrix = SCNMatrix4FromMat4(result.worldTransform);
            SCNVector3 vector = SCNVector3Make(matrix.m41, matrix.m42, matrix.m43);
            
            CGFloat dx= vector.x - initialVector.x;
            CGFloat dy= vector.y - initialVector.y;
            CGFloat dz= vector.z - initialVector.z;
            
            SCNVector3 newPositionVector = SCNVector3Make(self.movedNode.position.x+dx, self.movedNode.position.y+dy, self.movedNode.position.z+dz);
            
            [self.movedNode setPosition:newPositionVector];
            
            [SCNTransaction commit];
            
            self.hitTestResult = result;
        }
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.movedNode = nil;
        self.hitTestResult = nil;
    }
}

#pragma mark - Scale AR Object

- (void)scaleARObject:(UIPinchGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint tapPoint = [recognizer locationOfTouch:1 inView:self.sceneView];
        NSArray <SCNHitTestResult *> *result = [self.sceneView hitTest:tapPoint options:nil];
        if ([result count] == 0) {
            tapPoint = [recognizer locationOfTouch:0 inView:self.sceneView];
            result = [self.sceneView hitTest:tapPoint options:nil];
            if ([result count] == 0) {
                return;
            }
        }
        
        SCNHitTestResult *hitResult = [result firstObject];
        self.movedNode = [[hitResult node] parentNode];
    }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (self.movedNode) {
            CGFloat pinchScaleX = recognizer.scale * self.movedNode.scale.x;
            CGFloat pinchScaleY = recognizer.scale * self.movedNode.scale.y;
            CGFloat pinchScaleZ = recognizer.scale * self.movedNode.scale.z;
            [self.movedNode setScale:SCNVector3Make(pinchScaleX, pinchScaleY, pinchScaleZ)];
        }
        recognizer.scale = 1;
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.movedNode = nil;
    }
}

#pragma mark - lazy loading

-(NSMutableArray *)gestureArray{
    if (!_gestureArray) {
        _gestureArray = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _gestureArray;
}

-(void)removeGesture{
    
    for (UIGestureRecognizer *gesture in self.gestureArray) {
        [self.sceneView removeGestureRecognizer:gesture];
    }
}

@end
