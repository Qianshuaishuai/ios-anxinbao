//
//  BaseViewController.m
//  EVNEstorePlatform
//
//  Created by developer on 2016/12/30.
//  Copyright © 2016年 郭大扬. All rights reserved.
//

#import "BaseViewController.h"
#import "HelpHeaderFile.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "DetailViewController.h";
#define popup_width 317

@interface BaseViewController (){
    bool isShowPopup;
    NSDictionary* data;
}
@property (nonatomic) UIActivityIndicatorView *spinner;
@property (nonatomic) UIView* dimmedView;
@end

@implementation BaseViewController
@synthesize appDel;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.navigationController.viewControllers.count==1){
        self.navigationItem.leftBarButtonItem=nil;
    }
    self.appDel.vc=self;
    //self.navigationController.interactivePopGestureRecognizer.delegate=nil;
    //self.navigationController.navigationBar.frame = CGRectMake(0, 0, MainScreenWidth, 200);
}


- (void)viewWillDisappear:(BOOL)animated
{
    if(self.navigationController.viewControllers.count==1){
        self.navigationItem.leftBarButtonItem=self.backBtn;
    }
    //self.navigationController.interactivePopGestureRecognizer.delegate=self.navigationController;
    //self.navigationController.navigationBar.frame = CGRectMake(0, 0, MainScreenWidth, 200);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // Do any additional setup after loading the view.
//    [self pushAndPopStyle];
    self.view.backgroundColor = [UIColor whiteColor];
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }

    self.navigationItem.hidesBackButton = true;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem.tintColor=UIColorFromRGB(0xffffff);
    self.backBtn=self.navigationItem.leftBarButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPopup:) name:@"msg" object:nil];
    if(appDel.data!=nil){
        [self showPopupIn:appDel.data];
    }
}


- (void)showLoadingIndicatorView
{
    [self showLoadingIndicatorViewWithStyle:UIActivityIndicatorViewStyleWhite];
}

CG_INLINE CGRect
CGRectSetOrigin(CGRect rect, CGPoint origin)
{
    rect.origin = origin;
    return rect;
}

- (void)showLoadingIndicatorViewWithStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    if (self.spinner != nil) {
        [self hideLoadingIndicatorView];
    }
    
    self.dimmedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)]; //self.view.frame.size.width, self.view.frame.size.height)];
    [self.dimmedView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    [self.view addSubview:self.dimmedView];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:activityIndicatorViewStyle];
    spinner.frame = CGRectSetOrigin(spinner.frame, CGPointMake(floorf(CGRectGetMidX(self.view.bounds) - CGRectGetMidX(spinner.bounds)), floorf(CGRectGetMidY(self.view.bounds) - CGRectGetMidY(spinner.bounds))));
    spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [spinner startAnimating];
    [self.view addSubview:spinner];
    self.spinner = spinner;
    
    [self.view setUserInteractionEnabled:NO];
}

- (void)hideLoadingIndicatorView
{
    //dispatch_async(dispatch_get_main_queue(), ^(void) {
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
    self.spinner = nil;
    
    [self.dimmedView removeFromSuperview];
    self.dimmedView = nil;
    
    [self.view setUserInteractionEnabled:YES];
    //});
}

-(void)confirm{
    DetailViewController* c=[[DetailViewController alloc] init];
    c.pid=data[@"id"];
    c.type=data[@"type"];
    [self.navigationController pushViewController:c animated:YES];
    [self closePopup];
}

///重写push方法 push的控制器隐藏tabbar
-(void)backAction{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)closePopup{
    UIWindow *window = [UIApplication sharedApplication].windows[0];//[UIWindow alloc] initWithFrame:(CGRect) {{0.f, 0.f}, [[UIScreen mainScreen] bounds].size}];
    UIView* v = [window viewWithTag:20];
    [v removeFromSuperview];
    isShowPopup=NO;
}
-(void)showPopupIn:(NSDictionary*)data{
    if(isShowPopup){
        [self closePopup];
    }
    isShowPopup=YES;
    NSString* title=data[@"title"];//[Utils typeTitle:data[@"type"]];
    NSString* text=data[@"text"];
    NSString* place=[NSString stringWithFormat:@"%@%@", ASLocalizedString(@"位置："), data[@"place"]];
    UIView* v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    v.backgroundColor=RGBACOLOR(0, 0, 0, 0.5);
    ///[self.view addSubview:v];
    UIWindow *window = [UIApplication sharedApplication].windows[0];//[UIWindow alloc] initWithFrame:(CGRect) {{0.f, 0.f}, [[UIScreen mainScreen] bounds].size}];
    window.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);//UIColor clearColor];
    window.windowLevel = UIWindowLevelNormal;
    window.alpha = 1.f;
    window.hidden = NO;
    v.tag=20;
    [window addSubview:v];
    CGFloat y=(MainScreenHeight-156.5)/2-30;
    CGFloat x=(MainScreenWidth-popup_width)/2;
    UIView* popup=[[UIView alloc] initWithFrame:CGRectMake(x, y, popup_width, 180)];
    popup.layer.cornerRadius=5;
    popup.backgroundColor=UIColorFromRGB(0xe7ebeb);
    [v addSubview:popup];
    
    [Utils addLabelCenter:title For:popup withFrame:CGRectMake(0, 20, popup_width, 25) withColor:0x222222 withSize:20];
    [Utils addLabelCenter:text For:popup withFrame:CGRectMake(0, 90, popup_width, 15) withColor:0x555555 withSize:15];
    [Utils addLabelCenter:place For:popup withFrame:CGRectMake(0, 60, popup_width, 15) withColor:0x555555 withSize:15];
    UIView* line=[[UIView alloc] initWithFrame:CGRectMake(0, popup.frame.size.height-50, popup.frame.size.width, 1)];
    line.backgroundColor=UIColorFromRGB(0xd8d8d8);
    [popup addSubview:line];
    UIButton* ok=[UIButton buttonWithType:UIButtonTypeCustom];
    ok.frame=CGRectMake(0, popup.frame.size.height-50+15, popup_width, 20);
    [ok setTitle:ASLocalizedString(@"查看详情")forState:UIControlStateNormal];
    ok.titleLabel.font=[UIFont systemFontOfSize:20.5];
    [ok setTitleColor:ThemeColor forState:UIControlStateNormal];
    [popup addSubview:ok];
    UIButton* b=[UIButton buttonWithType:UIButtonTypeCustom];
    b.frame=CGRectMake(x+popup_width-41, y-20-41, 41, 41);
    [b setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:b];
    //objc_setAssociatedObject(b, @"myBtn", block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [ok addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    appDel.data=nil;
}

-(void)showPopup:(NSNotification *)noti{
    
    if(self.appDel.vc==self){
        data=noti.object;
        [self showPopupIn:data];
    }
}
- (UIViewController *)topViewController {
   UIViewController *resultVC;
   resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
   while (resultVC.presentedViewController) {
       resultVC = [self _topViewController:resultVC.presentedViewController];
   }
   return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
   if ([vc isKindOfClass:[UINavigationController class]]) {
       return [self _topViewController:[(UINavigationController *)vc topViewController]];
   } else if ([vc isKindOfClass:[UITabBarController class]]) {
       return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
   } else {
       return vc;
   }
   return nil;
}
@end
