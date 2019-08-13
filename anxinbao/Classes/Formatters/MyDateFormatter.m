//
//  MyDateFormatter.m
//  anxinbao
//
//  Created by 郭大扬 on 2018/10/5.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import "MyDateFormatter.h"

@implementation MyDateFormatter{
    NSArray* dates;
}

- (id)initWithDate:(NSArray*)array;
{
    self = [super init];
    if (self)
    {
        dates=array;
    }
    return self;
}

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    if(value==-1||value>=dates.count){
        return @"";
    }
    
    return dates[(int)value];
}

@end
