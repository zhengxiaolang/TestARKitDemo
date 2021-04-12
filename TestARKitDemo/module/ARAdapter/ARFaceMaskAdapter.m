//
//  ARFaceMaskAdapter.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/12.
//

#import "ARFaceMaskAdapter.h"

@interface ARFaceMaskAdapter()

@property(nonatomic,strong)SCNNode *faceNode;

@end

@implementation ARFaceMaskAdapter

- (SCNNode *)faceNode {
    if (!_faceNode) {
        
        id<MTLDevice> device = self.scnView.device;
        ARSCNFaceGeometry *geometry = [ARSCNFaceGeometry faceGeometryWithDevice:device fillMesh:NO];
        SCNMaterial *material = geometry.firstMaterial;
        material.fillMode = SCNFillModeFill;
//        material.fillMode = SCNFillModeLines;
        material.diffuse.contents = [UIImage imageNamed:@"face_green"];
        _faceNode = [SCNNode nodeWithGeometry:geometry];
//        _faceNode.name = @"textureMask";
    }
    
    return _faceNode;
}


#pragma mark - ARSCNViewDelegate
- (void)renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    
    if (!anchor || ![anchor isKindOfClass:[ARFaceAnchor class]]) return;
    ARFaceAnchor *faceAnchor = (ARFaceAnchor *)anchor;
//    ARBodyAnchor ARCamera
    [node addChildNode:self.faceNode];
    
//    faceAnchor.rightEyeTransform;

    ARSCNFaceGeometry *faceGeometry = (ARSCNFaceGeometry *)self.faceNode.geometry;
    if (faceGeometry && [faceGeometry isKindOfClass:[ARSCNFaceGeometry class]]) {
        [faceGeometry updateFromFaceGeometry:faceAnchor.geometry];
    }
}


-(void)initData{
    self.scnView.delegate = self;
}

-(void)buildConfig{
    
    ARFaceTrackingConfiguration *config = [MTARKitHelper createFaceTrackingConfig];
    config.lightEstimationEnabled = YES;
    self.config = config;
}

-(void)startSession{
    [self.session runWithConfiguration:self.config options:ARSessionRunOptionResetTracking|ARSessionRunOptionRemoveExistingAnchors];
}

-(void)resetSession{
    [self.session runWithConfiguration:self.config options:ARSessionRunOptionResetTracking|ARSessionRunOptionRemoveExistingAnchors];
}

-(void)dealloc{
    
    self.scnView.delegate = nil;
    self.session.delegate = nil;
    [self removeChildrenNodes];
}
@end
