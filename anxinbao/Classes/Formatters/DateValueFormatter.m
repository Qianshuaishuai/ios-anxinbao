//
//  DateValueFormatter.m
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//


#import "DateValueFormatter.h"

@interface DateValueFormatter ()
{
    int min;
    int max;
    NSDate* d;
    NSString* type;
}
@end

@implementation DateValueFormatter

- (id)initWithDate:(NSDate*)start withType:(NSString*)type1 withMax:(int)max1
{
    self = [super init];
    if (self)
    {
        d=start;
        type=type1;
        max=max1;
    }
    return self;
}

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    if(value==-1||value==max+1){
        return @"";
    }
    NSString* v=@"";
    int i=value;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    
    if([type isEqualToString:@"m"]){
        [adcomps setMonth:i];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:d options:0];
        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekOfYearCalendarUnit fromDate:newdate]; //
        v=[NSString stringWithFormat:@"%ld", components.month];
    }else if([type isEqualToString:@"w"]){
        [adcomps setWeekOfYear:i];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:d options:0];
        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekOfYearCalendarUnit fromDate:newdate]; //
        v=[NSString stringWithFormat:@"%ld", components.weekOfYear];
    }else{
        [adcomps setDay:i];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:d options:0];
        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekOfYearCalendarUnit fromDate:newdate]; //
        v=[NSString stringWithFormat:@"%ld", components.day];
    }
    
    return v;
}

@end
