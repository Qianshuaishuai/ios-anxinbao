//
//  UIWindow+StartLaunch.m
//  EVNEstorePlatform
//
//  Created by developer on 2017/1/21.
//  Copyright © 2017年 郭大扬. All rights reserved.
//

#import "UIWindow+StartLaunch.h"

@implementation UIWindow (StartLaunch)

- (void)startLaunchForRootController:(UIViewController *)rootController
{
    self.rootViewController = rootController;
    [self makeKeyAndVisible];
}

@end
