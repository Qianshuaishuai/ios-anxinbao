//
//  FindPwdViewController.m
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/7.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import "FindPwdViewController.h"
#import "HelpHeaderFile.h"
#import "ResetPwdViewController.h"

@interface FindPwdViewController (){
    Boolean getCodeEnable;
}

@property(nonatomic,strong)NSTimer *timer; // timer
@property(nonatomic,assign)int countDown; // 倒数计时用
//@property(nonatomic,strong)NSDate *beforeDate; // 上次进入后台时间
@end
static int const tick = 60;
@implementation FindPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=ASLocalizedString(@"忘记密码");
    self.nextBtn.layer.cornerRadius=25;
    self.codebg.layer.cornerRadius=25;
    self.phonebg.layer.cornerRadius=25;
    self.getCode.layer.cornerRadius=12;
    self.getCode.backgroundColor=UIColorFromRGB(0x0B99F4);
    self.nextBtn.backgroundColor=UIColorFromRGB(0x0B99F4);
    self.view.backgroundColor=BGCOLOR;
    [self.nextBtn addTarget:self action:@selector(resetPwd) forControlEvents:UIControlEventTouchUpInside];

    [self.getCode addTarget:self action:@selector(getPhoneCode) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    // Do any additional setup after loading the view.
    self.phone.returnKeyType = UIReturnKeyNext;
    self.code.returnKeyType = UIReturnKeyDone;
    self.phone.delegate=self.code.delegate=self;
    self.code.placeholder=ASLocalizedString(@"请输入验证码");
    self.phone.placeholder=ASLocalizedString(@"请输入账户号码");
    getCodeEnable=YES;
    [self.nextBtn setTitle:ASLocalizedString(@"下一步") forState:UIControlStateNormal];
    [_getCode setTitle:ASLocalizedString(@"获取验证码") forState:UIControlStateNormal];
    //推荐-->创建方式2
    _timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

/**
 *  开始倒计时
 */
-(void)startCountDown {
    _countDown = tick; // 重置计时
    _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES]; // 需要加入手动RunLoop，需要注意的是在NSTimer工作期间self是被强引用的
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes]; //使用NSRunLoopCommonModes才能保证RunLoop切换模式时，NSTimer能正常工作。
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // Check for non-numeric characters
    return YES;
}

-(void)timerFired:(NSTimer *)timer {
    if (_countDown == 0) {
        [self stopTimer];
        getCodeEnable=YES;
        _getCode.titleLabel.text = ASLocalizedString(@"获取验证码");
        [self.getCode setTitle:ASLocalizedString(@"获取验证码")forState:UIControlStateNormal];
        self.getCode.backgroundColor=UIColorFromRGB(0x0B99F4);
        [self.getCode setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    }else{
        _countDown -=1;
        NSString *t=[NSString stringWithFormat:@"%ds...", self.countDown];
        _getCode.titleLabel.text = t;
        [self.getCode setTitle:t forState:UIControlStateNormal];
    }
}


- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
    }
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.phone resignFirstResponder];
    [self.code resignFirstResponder];
}

-(void)getPhoneCode{
    if(_phone.text.length==0){
        [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"请输入邮箱")];
        return;
    }
    if(getCodeEnable){
        [self sendCode];
        getCodeEnable=NO;
        [self startCountDown];
        NSString *t=[NSString stringWithFormat:@"%ds...", self.countDown];
        _getCode.titleLabel.text = t;
        [self.getCode setTitle:t forState:UIControlStateNormal];
        self.getCode.backgroundColor=UIColorFromRGB(0xe5e5e5);
        [self.getCode setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    }
    //F8C75B
}

-(void)sendCode{
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    params[@"email"]=_phone.text;
    //params[@"device_imei"]=sn;
    [self.appDel getDataFullUrl:@"http://nicecaresmart.com/email/send" param:params callback:^(NSDictionary* dict){
        if(dict==nil){
            return;
        }
        int i=[[dict objectForKey:@"code"] intValue];
        if(i==1){
            [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"发送验证码成功")];
        }else if(i==10){
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        }else{
            [[ZFToast shareClient] popUpToastWithMessage:dict[@"msg"]];
        }
    }];
}

-(void)checkCode{
    if(_code.text.length==0){
        [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"请输入验证码")];
        return;
    }
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    params[@"code"]=_code.text;
    //params[@"password2"]=_repassword.text;
    [self.appDel getData:@"check_code" param:params callback:^(NSDictionary* dict){
        if(dict==nil){
            [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"请求失败")];
            return;
        }
        int i=[[dict objectForKey:@"code"] intValue];
        if(i==1){
            ResetPwdViewController* c=[[ResetPwdViewController alloc] init];
            //[self.navigationController popViewControllerAnimated:NO];
            [self.navigationController pushViewController:c animated:YES];
        }else if(i==10){
            [self.navigationController popViewControllerAnimated:NO];
        }else{
            [[ZFToast shareClient] popUpToastWithMessage:dict[@"msg"]];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField==self.phone){
        [self.code becomeFirstResponder];
    }else{
        [self resetPwd];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resetPwd{
    [self checkCode];
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
