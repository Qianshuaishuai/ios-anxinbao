//
//  SettingViewController.m
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/6.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import "SettingViewController.h"
#import "HelpHeaderFile.h"
#import "SettingItem.h"
#import "WifiConnViewController.h"
#import "ResetViewController.h"
#import "MusicViewController.h"
#import "TimeViewController.h"
#import "UIImageView+WebCache.h"
#import "LanguageViewController.h"

@interface SettingViewController (){
    CGFloat cellHeight;
    NSArray *dataArray;
}

@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=UIColorFromRGB(0xf0f0f0);
    [self.view addSubview:self.listView];
    //self.listView.delegate = self;
    cellHeight=60;
    dataArray = @[ASLocalizedString(@"报警音乐设置"),ASLocalizedString(@"修改密码"),ASLocalizedString(@"网络设置"),ASLocalizedString(@"语言设置")];//ASLocalizedString(@"报警时间设置"),
    [self getData];
    UIButton* btn=[[UIButton alloc] initWithFrame:CGRectMake(20, 450, MainScreenWidth-40, 40)];
    btn.backgroundColor=ThemeColor;
    [btn setTitle:ASLocalizedString(@"退出登录")forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self setTitle:ASLocalizedString(@"设置")];
}

-(void)logout{
    [self.appDel logout];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect r=[[UIApplication sharedApplication] statusBarFrame];
    CGRect f=self.listView.frame;
    f.size.height=self.tabBarController.tabBar.frame.origin.y-self.navigationController.navigationBar.frame.size.height-100-r.size.height;//-self.tabBarController.tabBar.frame.size.height
    self.listView.frame=f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reUseID = @"contentCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reUseID];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reUseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        SettingItem* r=[[SettingItem alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 60)];
        CGRect rect=r.frame;
        rect.size.width=MainScreenWidth;
        r.frame=rect;
        r.tag=12;
        [cell addSubview:r];
        [cell layoutIfNeeded];
    }
    SettingItem *r = (SettingItem *)[cell viewWithTag:12];
    [r.title setText:dataArray[indexPath.row]];
    
    return cell;
}

-(void) getData{
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    [self.appDel getData:@"user_info" param:params callback:^(NSDictionary* dict){
        if(dict==nil){
            return;
        }
        int i=[[dict objectForKey:@"code"] intValue];
        if(i==1){
            NSDictionary* data=[dict objectForKey:@"data"];
            NSDictionary* people=[data objectForKey:@"user"];
            if(people[@"home_name"]!=[NSNull null]){
                NSString* home_name=people[@"home_name"];
                self.homename.text=home_name;
            }
            if(people[@"name"]!=[NSNull null]){
                NSString* sname=people[@"name"];
                self.name.text=sname;
            }
            self.avatar.clipsToBounds=YES;
            if(people[@"avatar"]!=[NSNull null]){
                NSString* savatar=people[@"avatar"];
                [self.avatar sd_setImageWithURL:[NSURL URLWithString:savatar] placeholderImage:[UIImage imageNamed:@"settingavatar"] options:SDWebImageHighPriority];
            }
        }else if(i==10){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController* c=nil;
    if(indexPath.row==2){
        c=[[WifiConnViewController alloc] init];
    }else if(indexPath.row==1){
        c=[[ResetViewController alloc] init];
    }else if(indexPath.row==0){
        c=[[MusicViewController alloc] init];
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    else if(indexPath.row==1){
        c=[[TimeViewController alloc] init];
    }else{
        c=[[LanguageViewController alloc] init];
    }
    if(c==nil){
        return;
    }
    [self.navigationController pushViewController:c animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)listView
{
    if (!_listView)
    {
        //CGRect r1 = [self.navigationController.navigationBar frame];
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, MainScreenWidth, self.view.frame.size.height)];
        _listView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _listView.bounces = NO;
        //_listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //[_collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];  // KVO 添加监听者,用于导航栏偏移改变透明度
        _listView.separatorColor = (UIColorFromRGB(0xe8e8e8));
        if ([_listView respondsToSelector:@selector(setLayoutMargins:)]) {
            _listView.layoutMargins = UIEdgeInsetsMake(0, 20, 0, 0);
        }
    }
    return _listView;
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
