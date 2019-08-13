//
//  ResetPwdViewController.m
//  anxinbao
//
//  Created by 郭大扬 on 2018/8/18.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import "ResetPwdViewController.h"

@interface ResetPwdViewController ()<UITextFieldDelegate>{
    IBOutlet UITextField *rePasswordTxt;
    IBOutlet UITextField *passwordTxt;
    IBOutlet UIButton *nextBtn;
}

@end

@implementation ResetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    nextBtn.layer.cornerRadius=4;
    [nextBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    self.title=ASLocalizedString(@"重置密码");
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    // Do any additional setup after loading the view.
    passwordTxt.returnKeyType = UIReturnKeyNext;
    rePasswordTxt.returnKeyType = UIReturnKeyDone;
    rePasswordTxt.delegate = passwordTxt.delegate=self;
    self.passwordbg.layer.cornerRadius=4.0;
    self.repasswordbg.layer.cornerRadius=4.0;
    [passwordTxt setSecureTextEntry:YES];
    [rePasswordTxt setSecureTextEntry:YES];
    self.view.backgroundColor=BGCOLOR;
    passwordTxt.placeholder=ASLocalizedString(@"请输入密码");
    rePasswordTxt.placeholder=ASLocalizedString(@"请再次输入密码");
    [nextBtn setTitle:ASLocalizedString(@"确定") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [passwordTxt resignFirstResponder];
    [rePasswordTxt resignFirstResponder];
}

-(void)done{
    if(passwordTxt.text.length==0){
        [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"请输入密码")];
        return;
    }
    if(rePasswordTxt.text.length==0){
        [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"请再次输入密码")];
        return;
    }
    if(![rePasswordTxt.text isEqualToString:passwordTxt.text]){
        [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"两次输入密码不一致")];
        return;
    }
    [self reset];
}

-(void)reset{
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    params[@"password"]=passwordTxt.text;
    //params[@"password2"]=_repassword.text;
    [self.appDel getData:@"forget_set_password" param:params callback:^(NSDictionary* dict){
        if(dict==nil){
            [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"请求失败")];
            return;
        }
        int i=[[dict objectForKey:@"code"] intValue];
        if(i==1){
            [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"重设密码成功")];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else if(i==10){
            [self.navigationController popViewControllerAnimated:NO];
        }else{
            [[ZFToast shareClient] popUpToastWithMessage:dict[@"msg"]];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField==passwordTxt){
        [rePasswordTxt becomeFirstResponder];
    }else{
        [self done];
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
