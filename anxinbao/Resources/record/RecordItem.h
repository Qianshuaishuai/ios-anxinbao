//
//  RecordItem.h
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/5.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#ifndef RecordItem_h
#define RecordItem_h
@interface RecordItem :UIView
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
#endif /* RecordItem_h */
