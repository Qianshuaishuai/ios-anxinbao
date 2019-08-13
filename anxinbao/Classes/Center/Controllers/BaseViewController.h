//
//  BaseViewController.h
//  EVNEstorePlatform
//
//  Created by developer on 2016/12/30.
//  Copyright © 2016年 郭大扬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

/**
 这个类作为所有NavigationController的父类
 */

@interface BaseViewController : UIViewController

-(void)backAction;
@property (nonatomic, strong) UIBarButtonItem *backBtn;
@property AppDelegate *appDel;

- (void)showLoadingIndicatorView;
- (void)showLoadingIndicatorViewWithStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle;
- (void)hideLoadingIndicatorView;

@end

/************************************************************************
 * 作者: 郭大扬

 ************************************************************************/
