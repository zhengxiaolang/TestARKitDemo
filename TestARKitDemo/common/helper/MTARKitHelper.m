//
//  MTARKitHelper.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/7.
//

#import "MTARKitHelper.h"

@implementation MTARKitHelper

+(ARSCNView *)createSCNView{
    ARSCNView *scnView = [[ARSCNView alloc] init];
    return scnView;
}

+(ARSession *)createSession{
    ARSession *session = [[ARSession alloc] init];
    return session;
}

+(ARWorldTrackingConfiguration *)createWorldTrackingConfig{
    ARWorldTrackingConfiguration *config = [[ARWorldTrackingConfiguration alloc] init];
    return config;
}

+(ARFaceTrackingConfiguration *)createFaceTrackingConfig{
    ARFaceTrackingConfiguration *config = [[ARFaceTrackingConfiguration alloc] init];
    return config;
}

@end
