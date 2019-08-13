//
//  IntAxisValueFormatter.h
//  ChartsDemo
//  Copyright © 2016 dcg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "anxinbao-Bridging-Header.h"

@interface IntAxisValueFormatter : NSObject <IChartAxisValueFormatter>
@property (strong, nonatomic) NSString *unit;
@end
