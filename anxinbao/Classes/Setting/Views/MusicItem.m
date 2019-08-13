//
//  MusicItem.m
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/7.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import "MusicItem.h"
#import "HelpHeaderFile.h"

@interface MusicItem ()
{
    CGRect myframe;
}
@end

@implementation MusicItem


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"MusicItem" owner:self options:nil] lastObject];
    if (self) {
        myframe=self.frame = frame;
    }
    self.backgroundColor=UIColorFromRGB(0xffffff);
    return self;
}

-(void)drawRect:(CGRect)rect
{
    self.frame=myframe;//关键点在这里
    [super drawRect:rect];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.frame=self.bounds;
    self.backgroundColor=UIColorFromRGB(0xf0f0f0);
    //self = [[[NSBundle mainBundle] loadNibNamed:@"recordXib" owner:self options:nil] lastObject];
    return self;
}

@end
