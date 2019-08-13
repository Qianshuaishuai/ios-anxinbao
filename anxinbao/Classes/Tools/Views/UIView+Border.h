//
//  UIButton+Border.h
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/24.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Border)
-(void)addBottomBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;
-(void)addLeftBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;
-(void)addRightBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;
-(void)addTopBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;
-(void)addBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;
@end
