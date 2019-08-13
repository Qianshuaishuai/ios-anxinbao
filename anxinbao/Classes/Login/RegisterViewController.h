//
//  FindPwdViewController.h
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/7.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *codebg;
@property (strong, nonatomic) IBOutlet UIButton *getCode;
@property (strong, nonatomic) IBOutlet UITextField *code;
@property (strong, nonatomic) IBOutlet UIView *phonebg;
@property (strong, nonatomic) IBOutlet UITextField *phone;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;

@end
