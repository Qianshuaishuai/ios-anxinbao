//
//  AppDelegate.m
//  EVNEstorePlatform
//
//  Created by developer on 2016/12/30.
//  Copyright © 2016年 郭大扬. All rights reserved.
//

#import "AppDelegate.h"
#import "UIWindow+StartLaunch.h"
#import "EVNTabBarController.h"
#import "LoginViewController.h"
#import "EVNNavigationController.h"
#import "AFNetworking.h"
#import <UMCommon/UMCommon.h>           // 公共组件是所有友盟产品的基础组件，必选
#import <AVFoundation/AVFoundation.h>

#import <UMPush/UMessage.h>             // Push组件

#import <UserNotifications/UserNotifications.h>  // Push组件必须的系统库
//(@"[^"]*[\u4E00-\u9FA5]+[^"\n]*?")\s*

@interface AppDelegate ()
{
    EVNTabBarController *tabbar;
    UIStoryboard *mainSB;
    NSString* email;
    NSString* password;
    NSString* session_id;
    NSString* token;
    NSArray *array;
    AVAudioPlayer *player;
}

@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    [NSThread sleepForTimeInterval:3.0];//设置启动页面时间
    NSString *lan=[[NSUserDefaults standardUserDefaults] objectForKey:appLanguage];
    if(lan==nil){
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:appLanguage];
    }
    mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
     email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    session_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"];
    if(email!=nil&&password!=nil){
        [self relogin];
//        [self toLogin];
    }
    else{
        [self toLogin];
    }
    array = @[@"music1",@"music2",@"music3",@"music4",@"music5",@"music6"];
    //[self.window startLaunchForRootController:loginVC];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // Push组件基本功能配置
//    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
//    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
//    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
//    [UNUserNotificationCenter currentNotificationCenter].delegate=self;
//    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity     completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if (granted) {
//        }else{
//        }
//    }];
    //[UMessage s:UMENG_APPKEY launchOptions:launchOptions httpsEnable:YES];
    self.data=nil;
    //[self performSelector:@selector(testNotify) withObject:nil afterDelay:10];
    //[self showPopupTest];
    return YES;
}

-(void)restart{
    mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    tabbar = [[EVNTabBarController alloc] init];
    [self dealEnterToDCFTabbar:@"home"];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
//    [UMessage registerDeviceToken:deviceToken];

    NSLog(@"===didRegisterForRemoteNotificationsWithDeviceToken===");
    
    NSString* token=[[[[deviceToken description ] stringByReplacingOccurrencesOfString: @"<" withString:@"" ]
                  
                  stringByReplacingOccurrencesOfString: @">" withString:@""]
                 
                 stringByReplacingOccurrencesOfString: @" " withString:@""
                 
                 ];
    self->token=token;
    if(session_id!=nil&&token!=nil){
        [self postToken];
    }
    
    //NSLog(@"locError:%s};", NSUserDefaults.kUMessageUserDefaultKeyForParams);
    
}


-(void)postToken{
    NSMutableDictionary *m=[[NSMutableDictionary alloc] initWithDictionary:@{@"mobile_system":@"ios",@"token":token}];
    [self getData:@"save_token" param:m callback:^(NSDictionary *d) {
        if(d!=nil){
            if([[d objectForKey:@"code"] longValue]==1){
            }
        }
    }];
}

-(void)logout{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *URL=[NSString stringWithFormat:@"%@logout", HOST];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"session_id":session_id,@"lang":[self getLang]};
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //responseObject
        NSDictionary *JSON = responseObject;
        if([[JSON objectForKey:@"code"] longValue]==1){
        }else{
        }
        //NSLog(ASLocalizedString(@"这里打印请求成功要做的事"));
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(ASLocalizedString(@"这里打印请求失败要做的事"));
    }];
    email=password=nil;
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
    session_id=nil;
    [[NSUserDefaults standardUserDefaults] setObject:session_id forKey:@"session_id"];
    [self toLogin];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSDictionary *)userInfo
{
}


// 收到友盟的消息推送
/*-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler

{
    
    NSLog(@"===didReceiveRemoteNotification===");
    
    // 注意：当应用处在前台的时候，是不会弹出通知的，这个时候就需要自己进行处理弹出一个通知的UI
    
    if (application.applicationState == UIApplicationStateActive) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"title"] message:[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"]
                              
                                                       delegate:nil cancelButtonTitle:ASLocalizedString(@"确定")otherButtonTitles:nil];
        
        [alert show];
        
        
        return;
        
    }
    
    //如果是在后台挂起，用户点击进入是UIApplicationStateInactive这个状态
    
    else if (application.applicationState == UIApplicationStateInactive){
        
        //......
        
    }
    
    // 这个是友盟自带的前台弹出框
    
    [UMessage setAutoAlert:NO];
    
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        
        [UMessage didReceiveRemoteNotification:userInfo];
        
        
        
        completionHandler(UIBackgroundFetchResultNewData);
        
    }
}*/

//iOS10新增：处理前台收到通知的代理方法

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    NSLog(@"===willPresentNotification1===");
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        //应用处于前台时的远程推送接受
        
        //关闭U-Push自带的弹出框
        
        //[UMessage setAutoAlert:NO];
        
        //必须加这句代码
        
        //[UMessage didReceiveRemoteNotification:userInfo];
        [self handleMsg:userInfo];
        NSLog(@"===willPresentNotification2===");
    }else{
        
        //应用处于前台时的本地推送接受
        
        NSLog(@"===willPresentNotification3===");
        
    }
    
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    
    //completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    
}

-(void)handleMsg:(NSDictionary*)userInfo{
    if(userInfo==nil){
        return;
    }
    NSDictionary* aps=userInfo[@"aps"];
    NSString* text=aps[@"alert"];
    NSString* type=aps[@"warn_type"];
    NSString* rid=aps[@"record_id"];
    NSMutableDictionary* p=[[NSMutableDictionary alloc] init];
    p[@"text"]=aps[@"title"];
    p[@"title"]=text;//aps[@"title"];
    p[@"type"]=type;
    p[@"place"]=aps[@"alarm_place"];
    p[@"id"]=rid;
    self.data=p;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"msg" object:p];
    long music=[[[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"] integerValue];
    if([type isEqualToString:@"urine_purple"]||[type isEqualToString:@"fall"]){
        [self playWithUrl:music];
    }
}

-(void)testNotify{
    NSString* text=@"xxxx";
    NSString* type=@"dffdfd";
    NSString* rid=@"34";
    NSMutableDictionary* p=[[NSMutableDictionary alloc] init];
    p[@"text"]=@"34343";
    p[@"title"]=text;//aps[@"title"];
    p[@"type"]=type;
    p[@"place"]=@"dfsdfsdf";
    p[@"id"]=rid;
    self.data=p;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"msg" object:p];
    
}

-(void)showPopupTest{
    NSMutableDictionary* p=[[NSMutableDictionary alloc] init];
    p[@"text"]=@"试试吧";
    p[@"title"]=@"什么意思吗";
    p[@"type"]=@"urine_purple";
    p[@"place"]=@"未知地址";
    p[@"id"]=@3;
    self.data=p;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"msg" object:p];
}

-(void)playWithUrl:(long)row{
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:array[row] withExtension:@"mp3"];
    if(player.isPlaying){
        [player stop];
    }
    // 2.2.创建对应的播放器
    //player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
    player=[[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
    //player.delegate=self;
    // 2.4.准备播放
    player.volume=1.0;
    [player prepareToPlay];
    [player play];
}

//iOS10新增：处理后台点击通知的代理方法

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
#ifdef UM_Swift
        
        //[UMessageSwiftInterface didReceiveRemoteNotificationWithUserInfo:userInfo];
        
#else
        
        //应用处于后台时的远程推送接受
        
        //必须加这句代码
        
        NSLog(@"===didReceiveNotificationResponse===");
        
        
        [self handleMsg:userInfo];

        //[UMessage didReceiveRemoteNotification:userInfo];
        
#endif
        
    }else{
        
        //应用处于后台时的本地推送接受
        
    }
    
}
-(void)toLogin{
    session_id=nil;
    mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    tabbar = [[EVNTabBarController alloc] init];
    EVNNavigationController *nav=[[EVNNavigationController alloc] init];
    self.window.rootViewController=nav;
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [nav pushViewController:loginVC animated:YES];
}

-(void)saveLoginState:(NSDictionary*)data{
    NSDictionary* params=[data objectForKey:@"data"];
    email=[params objectForKey:@"email"];
    password=[params objectForKey:@"password"];
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
    session_id=[data objectForKey:@"session_id"];
    [[NSUserDefaults standardUserDefaults] setObject:session_id forKey:@"session_id"];
    if(token==nil){
        return;
    }
    [self postToken];
}

-(void)relogin{
    if(session_id==nil){
        [self toLogin];
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *URL=[NSString stringWithFormat:@"%@relogin", HOST];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"email":email,@"password":password,@"session_id":session_id,@"lang":[self getLang]};

    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //responseObject
        NSDictionary *JSON = responseObject;
        if([[JSON objectForKey:@"code"] longValue]==1){
            [self saveLoginState:JSON];
            [self dealEnterToDCFTabbar:@"home"];
        }else{
            [self toLogin];
        }
        //NSLog(ASLocalizedString(@"这里打印请求成功要做的事"));
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(ASLocalizedString(@"这里打印请求失败要做的事"));
        [self toLogin];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

-(void)getData:(NSString*)url param:(NSMutableDictionary*)dict callback:(MSG_CALLBACK_FUNC)callback{
    NSString *URL=[NSString stringWithFormat:@"%@%@", HOST, url];
    [self getDataFullUrl:URL param:dict callback:callback];
}

-(NSString*)getLang{
    NSString* lang=[[NSUserDefaults standardUserDefaults] objectForKey:appLanguage];
    if([lang isEqualToString:@"zh-Hant"]){
        return @"old_zh";
    }else if([lang isEqualToString:@"en"]){
        return @"English";
    }else{
        return @"zh";
    }
}
-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}


-(void)getDataFullUrl:(NSString*)URL param:(NSMutableDictionary*)dict
    callback:(MSG_CALLBACK_FUNC)callback{
    session_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"];
    if(session_id!=nil){
        [dict setObject:session_id forKey:@"session_id"];
    }
    [dict setObject:[self getLang] forKey:@"lang"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *JSON = responseObject;
        if([[JSON objectForKey:@"code"] longValue]==10){
            [self toLogin];
        }
        NSLog(@"response", [self convertToJsonData:JSON]);
        callback(JSON);
        if(JSON[@"session_id"]!=nil){
            session_id=JSON[@"session_id"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(ASLocalizedString(@"这里打印请求失败要做的事"));
        callback(nil);
        
    }];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 页面跳转及入口跳转方法
- (void)dealEnterToDCFTabbar:(NSString *)toWhere
{
    mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if ([toWhere isEqualToString:ASLocalizedString(@"忘记密码")])
    {
        UIViewController* c = [mainSB instantiateViewControllerWithIdentifier:@"forgetController"];
        [self.window startLaunchForRootController:c];
    }

    else if ([toWhere isEqualToString:@"home"])
    {
        if(tabbar == nil)
        {
            tabbar = [mainSB instantiateViewControllerWithIdentifier:@"tabBarController"];
        }
        [self.window startLaunchForRootController:tabbar];
        [tabbar setSelectedIndex:0];
    }
}


@end
