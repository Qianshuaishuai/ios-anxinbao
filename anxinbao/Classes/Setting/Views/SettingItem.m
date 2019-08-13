//
//  SettingItem.m
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/6.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import "SettingItem.h"
#import "HelpHeaderFile.h"

@implementation SettingItem
{
    CGRect myframe;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"settingItem" owner:self options:nil] lastObject];
    if (self) {
        myframe=self.frame = frame;
    }
    self.backgroundColor=UIColorFromRGB(0xffffff);
    return self;
}

-(void)drawRect:(CGRect)rect
{
    self.frame=myframe;//关键点在这里
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.frame=self.bounds;
    self.backgroundColor=UIColorFromRGB(0xf0f0f0);
    //self = [[[NSBundle mainBundle] loadNibNamed:@"recordXib" owner:self options:nil] lastObject];
    return self;
}

@end
