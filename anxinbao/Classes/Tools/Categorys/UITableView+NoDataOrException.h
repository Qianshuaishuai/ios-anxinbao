//
//  UITableView+NoDataOrException.h
//  EVNEstorePlatform
//
//  Created by developer on 2017/2/9.
//  Copyright © 2017年 郭大扬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (NoDataOrException)

/**
 * 网络异常及无数据展示图
 * @param displayView 要展示的视图
 * @param rowCount 0
 */
- (void)tableViewDisplayView:(UIView *)displayView andWithRowCount:(NSUInteger)rowCount;

@end
/************************************************************************
 * 作者: 郭大扬

 ************************************************************************/
