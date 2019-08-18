//
//  LoginViewController.h
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/6.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *accountWrap;
@property (strong, nonatomic) IBOutlet UIView *passwordWrap;
@property (strong, nonatomic) IBOutlet UITextField *account;
@property (strong, nonatomic) IBOutlet UIButton *login;
@property (strong, nonatomic) IBOutlet UIButton *forgetPwd;
@property (strong, nonatomic) IBOutlet UIButton *gegister;
@property (strong, nonatomic) IBOutlet UITextField *password;

@end
