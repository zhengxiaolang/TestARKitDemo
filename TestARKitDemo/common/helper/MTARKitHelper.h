//
//  MTARKitHelper.h
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/7.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YHARAdapterProtocol <NSObject>

@optional

-(void)startSession;

-(void)pauseSession;

-(void)resetSession;


@end
@interface MTARKitHelper : NSObject

+(ARSCNView *)createSCNView;

+(ARSession *)createSession;

+(ARWorldTrackingConfiguration *)createWorldTrackingConfig;

+(ARFaceTrackingConfiguration *)createFaceTrackingConfig;

@end

NS_ASSUME_NONNULL_END
