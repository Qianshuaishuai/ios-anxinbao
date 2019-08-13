//
//  AppDelegate.h
//  EVNEstorePlatform
//
//  Created by developer on 2016/12/30.
//  Copyright © 2016年 郭大扬. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *appLanguage = @"appLanguage";

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong, nonatomic) NSMutableDictionary* data;
@property (strong, nonatomic) UIViewController *vc;
typedef void(^MSG_CALLBACK_FUNC)(NSDictionary *);

#pragma mark - 页面跳转及入口跳转方法
- (void)dealEnterToDCFTabbar:(NSString *)toWhere;
-(void)saveLoginState:(NSDictionary*)params;
-(void)logout;
-(void)restart;
-(void)toLogin;
@property(strong, nonatomic) NSString* userType;
-(void)getDataFullUrl:(NSString*)URL param:(NSMutableDictionary*)dict callback:(MSG_CALLBACK_FUNC)callback;
-(void)getData:(NSString*)url param:(NSMutableDictionary*)dict callback:(MSG_CALLBACK_FUNC)callback;
@end
static NSString *HOST=@"http://nicecaresmart.com/main/";


/************************************************************************
 * 作者: 郭大扬

 ************************************************************************/
