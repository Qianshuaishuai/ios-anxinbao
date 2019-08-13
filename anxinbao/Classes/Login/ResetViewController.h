//
//  ResetViewController.h
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/9.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import "BaseViewController.h"

@interface ResetViewController : BaseViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIView *passwordbg;
@property (strong, nonatomic) IBOutlet UIView *repwdbg;
@property (strong, nonatomic) IBOutlet UITextField *repassword;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;

@end
