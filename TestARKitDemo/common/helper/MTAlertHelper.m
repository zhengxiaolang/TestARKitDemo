//
//  MTAlertHelper.m
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/12.
//

#import "MTAlertHelper.h"

@implementation MTAlertHelper

+(void)showText:(NSString *)text withDuration:(int)duration inVC:(UIViewController *)parentVC{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:text
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [parentVC presentViewController:alert animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
