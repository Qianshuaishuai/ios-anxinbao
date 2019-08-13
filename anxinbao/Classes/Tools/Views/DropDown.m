//
//  DropDown.m
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/24.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import "DropDown.h"
#import "HelpHeaderFile.h"
#import "Utils.h"
#import "UIView+Border.h"

@implementation DropDown{
    int index;
}

- (instancetype)initWithFrame:(CGRect)frame withStringArray:(NSArray *)stringArray
{
    index=1;
    self = [super initWithFrame:frame];
    CGFloat w=frame.size.width;
    self.backgroundColor=UIColorFromRGB(0xffffff);
    [self addBorderWithColor:UIColorFromRGB(0xd8d8d8) andWidth:0.5];
    for(int i=0;i<stringArray.count;++i){
        NSString* title=stringArray[i];
        CGRect f=CGRectMake(0, i*25, w, 25);
        UIColor* c=UIColorFromRGB(0x888888);
        if(i==0){
            c=ThemeColor;
        }
        UIButton* btn=[Utils addButtonCenter:title For:self withFrame:f withImage:nil withDefineColor:c withSize:13];
        btn.tag=i+1;
        [btn setBackgroundImage:[Utils createImageWithColor:UIColorFromRGB(0xf0f0f0)] forState:UIControlStateHighlighted];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)selectItem:(UIButton*)btn{
    int i=(int)btn.tag;
    if(index!=i){
        [btn setTitleColor:ThemeColor forState:UIControlStateNormal];
        UIButton* b=(UIButton*)[self viewWithTag:index];
        [b setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
        index=i;
    }
    if([self.delegate respondsToSelector:@selector(selectItem:)]){
        [self.delegate selectItem:i-1];
    }
}

-(void)selectIndex:(int)i{
    UIButton* btn=[self viewWithTag:i+1];
    if(index!=i+1){
        [btn setTitleColor:ThemeColor forState:UIControlStateNormal];
        UIButton* b=(UIButton*)[self viewWithTag:index];
        [b setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
        index=i;
    }
}

@end
