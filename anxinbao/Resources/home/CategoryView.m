//
//  Category.m
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/1.
//  Copyright © 2018年 郭大扬. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "CategoryView.h"
#import "HelpHeaderFile.h"
#import "Utils.h"

@implementation CategoryView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
    }
    //self.titleBar.backgroundColor=UIColorFromRGB(0xf0f0f0);
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [[NSBundle mainBundle] loadNibNamed:@"CategoryView" owner:self options:nil];
    self.contentView.frame = self.bounds;
    self.bg.image=[Utils getResizingImage:[UIImage imageNamed:@"dropdown"]];
    self.contentView.backgroundColor=UIColorFromRGB(0xf0f0f0);
    [self addSubview:self.contentView];
}

@end
