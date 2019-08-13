//
//  TimeItem.h
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/8.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeItem : UIView
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *room;
@property (strong, nonatomic) IBOutlet UILabel *number;
@property (strong, nonatomic) IBOutlet UIButton *plus;
@property (strong, nonatomic) IBOutlet UILabel *timeText;
@property (strong, nonatomic) IBOutlet UIButton *minus;
@property (strong, nonatomic) IBOutlet UILabel *count;
@property (strong, nonatomic) IBOutlet UIView *edit;
@property (strong, nonatomic) IBOutlet UIView *time;

@end
