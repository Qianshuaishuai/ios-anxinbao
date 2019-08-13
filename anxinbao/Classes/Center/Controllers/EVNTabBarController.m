//
//  EVNTabBarController.m
//  EVNEstorePlatform
//
//  Created by developer on 2016/12/30.
//  Copyright © 2016年 郭大扬. All rights reserved.
//

#import "EVNTabBarController.h"
#import "HelpHeaderFile.h"
#import "Utils.h"
#import "SettingViewController.h"

@interface EVNTabBarController ()

@property (nonatomic, strong) UIButton *centerBtn;

@end

@implementation EVNTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initCutomBar];

    self.view.backgroundColor = [UIColor clearColor];//UIColor colorWithPatternImage:[UIImage imageNamed:@"tapbar_top_line"]]; // tab_background

    [self.tabBar setShadowImage:[Utils createImageWithColor:UIColorFromRGB(0xeeeeee)]];
    [self.tabBar setBackgroundImage:[Utils createImageWithColor:[UIColor clearColor]]];
    // 设置tabbar背景颜色
    [[UITabBar appearance] setBackgroundColor:UIColorFromRGB(0xf5f5f5)]; // 设置tabbar背景颜色
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];    // 设置tabbar背景颜色
    [[UITabBar appearance] setTintColor:UIColorFromRGB(0x37acad)];   // 选中状态时候的字体颜色及背景
    //[[UITabBar appearance] set]
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    // 如果需要自定义图片就需要设置以下几行
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : TabBarUnSelectColor} forState:UIControlStateNormal]; // UITabBarItem未选中状态的颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0x37acad)} forState:UIControlStateSelected]; // UITabBarItem选中状态的颜色

// KVO tabbar hidden
    //[self.tabBar addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}
//改变tabbar高度
/*- (void)viewWillLayoutSubviews{
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 49;
    tabFrame.origin.y = self.view.frame.size.height - 49;
    self.tabBar.frame = tabFrame;
}*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initCutomBar
{
    self.delegate = self;

#pragma mark: 首页storyboard

    UIStoryboard *hostSB = [UIStoryboard storyboardWithName:@"Host" bundle:nil];
    UINavigationController *hostNaviVC = [hostSB instantiateViewControllerWithIdentifier:@"hostNavigationC"];
    [self setChildViewController:hostNaviVC  selectedImage:@"listhigh" unSelectedImage:@"list" title:ASLocalizedString(@"列表")];
    hostNaviVC.tabBarItem.tag = 0;

#pragma mark: 关注storyboard
    UIStoryboard *settingSB = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
    UINavigationController *settingVC = [settingSB instantiateViewControllerWithIdentifier:@"settingNavigationC"];
    [self setChildViewController:settingVC selectedImage:@"settinghigh1" unSelectedImage:@"setting1" title:ASLocalizedString(@"设置")];
    settingVC.tabBarItem.tag = 1;
    hostNaviVC.tabBarItem.imageInsets=settingVC.tabBarItem.imageInsets=UIEdgeInsetsMake(0, 0, 0, 0);

    self.viewControllers = @[hostNaviVC, settingVC];
}


- (void)setChildViewController:(UIViewController *)viewController selectedImage:(NSString *)selectedImage unSelectedImage:(NSString *)unSelectedImage title:(NSString *)title
{
    UIImage *mineCenterSelectImg = [UIImage imageNamed:selectedImage];
    UIImage *mineCenterUnSelectImg = [UIImage imageNamed:unSelectedImage];
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:mineCenterUnSelectImg selectedImage:mineCenterSelectImg];
}

- (UIImage *)scaleImage:(UIImage *)image
{
    return [UIImage imageWithCGImage:image.CGImage scale:2 orientation:image.imageOrientation];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - tabbar的代理方法，
#pragma mark: 每次单击item的时候，如果需要切换则返回yes，否则no
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

#pragma mark: 只要上面的shouldSelectViewController返回yes，下一步就执行该方法
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //    int index = (int)tabBarController.selectedIndex;
    _centerBtn.selected = (self.selectedIndex == 2) ? YES : NO;

}

#pragma mark: Create a custom UIButton
- (void)addCenterButton:(UIImage*)buttonImage selectedImage:(UIImage*)selectedImage
{
    _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_centerBtn addTarget:self action:@selector(centerBtn:) forControlEvents:UIControlEventTouchUpInside];
    //_centerBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;

    //_centerBtn.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height); //  设定button大小为适应图片
    [_centerBtn setImage:buttonImage forState:UIControlStateNormal];
    [_centerBtn setImage:selectedImage forState:UIControlStateSelected];

    _centerBtn.adjustsImageWhenHighlighted = NO;
    CGPoint center = self.tabBar.center;
    center.y = center.y + 20;//- buttonImage.size.height/2;
    _centerBtn.center = center;
    [self.view addSubview:_centerBtn];
}

- (void)centerBtn:(UIButton *)sender
{
    [self setSelectedIndex:2];
    sender.selected = YES;
}

// KVO tabbar hidden
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([object isEqual:self.tabBar] && [keyPath isEqualToString:@"hidden"])
    {
        _centerBtn.hidden = self.tabBar.hidden; // synchronization view state

        if ([object isFinished])
        {
            @try {
                [object removeObserver:self forKeyPath:@"hidden" context:nil]; // remove Observer
            }
            @catch (NSException * __unused exception) {}
        }
    }
}


@end
