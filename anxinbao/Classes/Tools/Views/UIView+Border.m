//
//  UIButton+Border.m
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/24.
//  Copyright © 2018年 郭大扬. All rights reserved.
//
#import "UIView+Border.h"

@implementation UIView (Border)
-(void)addTopBorderWithColor:(UIColor*)color andWidth:(CGFloat) borderWidth {
    CALayer* border = [CALayer layer]; border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(0, 0, self.frame.size.width, borderWidth);
    [self.layer addSublayer:border];
    
}
-(void)addBottomBorderWithColor:(UIColor*)color andWidth:(CGFloat) borderWidth {
    CALayer* border = [CALayer layer]; border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, borderWidth);
    [self.layer addSublayer:border];    
}
-(void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer* border = [CALayer layer]; border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(0, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}
-(void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer* border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(self.frame.size.width - borderWidth, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}
-(void)addBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth{
    [self addTopBorderWithColor:color andWidth:borderWidth];
    [self addBottomBorderWithColor:color andWidth:borderWidth];
    [self addLeftBorderWithColor:color andWidth:borderWidth];
    [self addRightBorderWithColor:color andWidth:borderWidth];
}
@end
