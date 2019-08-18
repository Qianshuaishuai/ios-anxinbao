//
//  ResetViewController.m
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/9.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import "ResetViewController.h"
#import "HelpHeaderFile.h"
#import "ZFToast.h"

@interface ResetViewController (){
    
    IBOutlet UITextField *oldPasswordTxt;
}

@end

@implementation ResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=ASLocalizedString(@"修改密码");
    self.nextBtn.layer.cornerRadius=25;
    self.nextBtn.backgroundColor=UIColorFromRGB(0x0B99F4);
    self.view.backgroundColor=BGCOLOR;
    [self.nextBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    // Do any additional setup after loading the view.
    oldPasswordTxt.returnKeyType = self.password.returnKeyType = UIReturnKeyNext;
    self.repassword.returnKeyType = UIReturnKeyDone;
    oldPasswordTxt.delegate = self.password.delegate=self.repassword.delegate=self;
    self.passwordbg.layer.cornerRadius=25;
    self.repwdbg.layer.cornerRadius=25;
    self.oldpwdbg.layer.cornerRadius=25;
    [oldPasswordTxt setSecureTextEntry:YES];
    [_password setSecureTextEntry:YES];
    [_repassword setSecureTextEntry:YES];
    oldPasswordTxt.placeholder=ASLocalizedString(@"请输入原密码");
    self.password.placeholder=ASLocalizedString(@"请输入密码");
    self.repassword.placeholder=ASLocalizedString(@"请再次输入密码");//（6-20位）");
    [self.nextBtn setTitle:ASLocalizedString(@"下一步") forState:UIControlStateNormal];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.password resignFirstResponder];
    [self.repassword resignFirstResponder];
    [oldPasswordTxt resignFirstResponder];
}

-(void)done{
    if(_password.text.length==0){
        [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"请输入密码")];
        return;
    }
    if(oldPasswordTxt.text.length==0){
        [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"请输入原密码")];
        return;
    }
    if(_repassword.text.length==0){
        [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"请再次输入密码")];
        return;
    }
    if(![_repassword.text isEqualToString:_password.text]){
        [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"两次输入密码不匹配")];
        return;
    }
    [self reset];
}

-(void)reset{
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    params[@"old_password"]=oldPasswordTxt.text;
    params[@"password"]=_password.text;
    //params[@"password2"]=_repassword.text;
    [self.appDel getData:@"set_password" param:params callback:^(NSDictionary* dict){
        if(dict==nil){
            [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"请求失败")];
           return;
        }
        int i=[[dict objectForKey:@"code"] intValue];
        if(i==1){
            [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"修改密码成功")];
            [self.navigationController popViewControllerAnimated:YES];
        }else if(i==10){
            [self.navigationController popViewControllerAnimated:NO];
        }else{
            [[ZFToast shareClient] popUpToastWithMessage:dict[@"msg"]];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField==oldPasswordTxt){
        [self.password becomeFirstResponder];
    }else if(textField==self.password){
        [self.repassword becomeFirstResponder];
    }else{
        [self done];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
