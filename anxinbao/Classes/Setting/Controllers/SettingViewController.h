//
//  SettingViewController.h
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/6.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EVNNavigationController.h"

@interface SettingViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *listView;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *homename;
@property (strong, nonatomic) IBOutlet UILabel *name;

@end
