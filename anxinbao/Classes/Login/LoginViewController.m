//
//  LoginViewController.m
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/6.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import "LoginViewController.h"
#import "HelpHeaderFile.h"
#import "AppDelegate.h"
#import "FindPwdViewController.h"
#import "RegisterViewController.h"
#import "EVNNavigationController.h"
#import "AFNetworking.h"
#import "ZFToast.h"
#import "CategoryView.h"
#import "DropDown.h"
#import "Utils.h"

@interface LoginViewController (){
    AppDelegate *appDel;
    IBOutlet UILabel *forgettip;
    CategoryView* cv;
    DropDown *dropdown;
}
@property(nonatomic) UIReturnKeyType returnKeyType;                       // default is UIReturnKeyDefault (See note under UIReturnKeyType enum)
@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.accountWrap.layer.cornerRadius=25;
    self.passwordWrap.layer.cornerRadius=25;
    self.login.layer.cornerRadius=25;
    self.gegister.layer.cornerRadius=25;
    self.gegister.backgroundColor=UIColorFromRGB(0xf0f0f0);
    [self.gegister.layer setBorderColor:[UIColor colorWithRed:11.0/255 green:153.0/255 blue:244.0/255 alpha:1.0].CGColor];
    [self.gegister.layer setBorderWidth:1.0];
    self.account.placeholder=ASLocalizedString(@"请输入账户号码");
    self.password.placeholder=ASLocalizedString(@"请输入账户密码");
    [self.account setValue:UIColorFromRGB(0xd8d8d8) forKeyPath:@"_placeholderLabel.textColor"];   //修改
    [self.password setValue:UIColorFromRGB(0xd8d8d8) forKeyPath:@"_placeholderLabel.textColor"];   //修改
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    self.view.backgroundColor=UIColorFromRGB(0xf0f0f0);
    [self.login addTarget:self action:@selector(loginin) forControlEvents:UIControlEventTouchUpInside];
    [self.gegister addTarget:self action:@selector(goRegister) forControlEvents:UIControlEventTouchUpInside];
    //将触摸事件添加到当前view
    self.account.returnKeyType = UIReturnKeyNext;
    self.password.returnKeyType = UIReturnKeyDone;
    self.account.delegate=self;
    self.password.delegate=self;
    [self.forgetPwd addTarget:self action:@selector(goForget) forControlEvents:UIControlEventTouchUpInside];
    [forgettip setText:ASLocalizedString(@"忘记密码")];
    [self.login setTitle:ASLocalizedString(@"登录") forState:UIControlStateNormal];
    [self.gegister setTitle:ASLocalizedString(@"注册") forState:UIControlStateNormal];
//    UIButton* bg=[UIButton buttonWithType:UIButtonTypeCustom];
//    bg.frame=CGRectMake(MainScreenWidth-120, 50, 100, 23.5);
//    [bg setBackgroundImage:[Utils getResizingImage:[UIImage imageNamed:@"dropdown"]] forState:UIControlStateNormal];
//    [self.view addSubview:bg];
//    UILabel* title=[[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth-120, 50, 80, 23.5)];
//    title.font=[UIFont systemFontOfSize:14];
//    title.textColor=UIColorFromRGB(0x999999);
//    title.textAlignment=NSTextAlignmentCenter;
//    [title setText:@"English"];
//    [self.view addSubview:title];
//    [bg addTarget:self action:@selector(showDropDown) forControlEvents:UIControlEventTouchUpInside];
//    NSArray *arr=[NSArray arrayWithObjects:@"繁體中文",@"English",@"简体中文",nil];
//    dropdown=[[DropDown alloc] initWithFrame:CGRectMake(bg.frame.origin.x-2, bg.frame.origin.y+bg.frame.size.height, bg.frame.size.width, 80) withStringArray:arr];
//    dropdown.delegate=self;
//    dropdown.hidden=YES;
//    [self.view addSubview:dropdown];
//    NSString* lang=[[NSUserDefaults standardUserDefaults] objectForKey:appLanguage];
//    if([lang isEqualToString:@"zh-Hant"]){
//        title.text=@"繁體中文";
//        [dropdown selectIndex:0];
//    }else if([lang isEqualToString:@"en"]){
//        title.text=@"English";
//        [dropdown selectIndex:1];
//    }else{
//        title.text=@"简体中文";
//        [dropdown selectIndex:2];
//    }
}

-(void)showDropDown{
    if(dropdown.hidden){
        dropdown.hidden=NO;
    }else{
        dropdown.hidden=YES;
    }
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.account resignFirstResponder];
    [self.password resignFirstResponder];
}

-(void)selectItem:(int)index{
    dropdown.hidden=YES;
    int row=index;
    if(row==0){
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hant" forKey:appLanguage];
    }else if(row==1){
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:appLanguage];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:appLanguage];
    }
    [self.appDel toLogin];
}

-(void)goForget{
    EVNNavigationController *nav = [[EVNNavigationController alloc] init];
    FindPwdViewController *c=[[FindPwdViewController alloc] init];
    [self.navigationController pushViewController:c animated:YES];
    //[appDel dealEnterToDCFTabbar:ASLocalizedString(@"忘记密码")];
}

-(void)goRegister{
    EVNNavigationController *nav = [[EVNNavigationController alloc] init];
    RegisterViewController *c=[[RegisterViewController alloc] init];
    [self.navigationController pushViewController:c animated:YES];
    //[appDel dealEnterToDCFTabbar:ASLocalizedString(@"忘记密码")];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField==self.account){
        [self.password becomeFirstResponder];
    }else{
        [self loginin];
    }
    return YES;
}

-(void)loginin{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *URL=[NSString stringWithFormat:@"%@login",HOST];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"email":self.account.text,@"password":self.password.text};
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //responseObject
        NSDictionary *JSON = responseObject;
        if([[JSON objectForKey:@"code"] longValue]==1){
            [appDel saveLoginState:JSON];
            [appDel dealEnterToDCFTabbar:@"home"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"用户名或密码不对")];
        }
        NSLog(ASLocalizedString(@"这里打印请求成功要做的事"));
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(ASLocalizedString(@"这里打印请求失败要做的事"));
    }];
        
    //[appDel dealEnterToDCFTabbar:ASLocalizedString(@"首页")];
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
