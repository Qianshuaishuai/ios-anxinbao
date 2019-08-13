//
//  UILabel+LabelHeightAndWidth.h
//  anxinbao
//
//  Created by 郭大扬 on 2018/10/14.
//  Copyright © 2018年 郭大扬. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UILabel (LabelHeightAndWidth)
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
