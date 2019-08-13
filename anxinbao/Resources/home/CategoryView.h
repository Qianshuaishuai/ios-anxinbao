//
//  UIView+Category.h
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/1.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryView :UIView
@property (weak, nonatomic) IBOutlet UIView *titleBar;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIImageView *bg;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *chooseTip;
@property (strong, nonatomic) IBOutlet UIButton *btn;

@end
