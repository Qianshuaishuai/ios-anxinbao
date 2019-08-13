//
//  MyDateFormatter.h
//  anxinbao
//
//  Created by 郭大扬 on 2018/10/5.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "anxinbao-Bridging-Header.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyDateFormatter : NSObject <IChartAxisValueFormatter>
- (id)initWithDate:(NSArray*)array;
@end

NS_ASSUME_NONNULL_END
