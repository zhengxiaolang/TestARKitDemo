//
//  MTAlertHelper.h
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTAlertHelper : NSObject

+(void)showText:(NSString *)text withDuration:(int)duration inVC:(UIViewController *)parentVC;

@end

NS_ASSUME_NONNULL_END
