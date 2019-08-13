//
//  DateValueFormatter.h
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

#import <UIKit/UIKit.h>
#import "anxinbao-Bridging-Header.h"

@interface DateValueFormatter : NSObject <IChartAxisValueFormatter>
- (id)initWithDate:(NSDate*)start withType:(NSString*)type1 withMax:(int)max1;
@end
