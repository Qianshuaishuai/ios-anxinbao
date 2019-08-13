//
//  TimeItem.m
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/8.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import "TimeItem.h"
#import "HelpHeaderFile.h"

@implementation TimeItem

{
    CGRect myframe;
    IBOutlet UILabel *delay;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"TimeItem" owner:self options:nil] lastObject];
    delay.text=ASLocalizedString(@"延时");
    if (self) {
        myframe=self.frame = frame;
    }
    //self.backgroundColor=UIColorFromRGB(0xffffff);
    return self;
}

-(void)drawRect:(CGRect)rect
{
    self.frame=myframe;//关键点在这里
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.frame=self.bounds;
    //self = [[[NSBundle mainBundle] loadNibNamed:@"recordXib" owner:self options:nil] lastObject];
    return self;
}
@end
