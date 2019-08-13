//
//  MusicViewController.m
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/7.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import "LanguageViewController.h"
#import "HelpHeaderFile.h"
#import "MusicItem.h"

@interface LanguageViewController (){
    CGFloat cellHeight;
    NSInteger row;
    NSArray*                                                                         list;
}

@property (nonatomic, strong) UITableView *listView;

@end

@implementation LanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.listView];
    self.title=ASLocalizedString(@"语言设置");
    cellHeight=60;
    row=0;
    list=[[NSArray alloc] initWithObjects:@"繁體中文", @"English", @"简体中文", nil];
    
    NSString* lang=[[NSUserDefaults standardUserDefaults] objectForKey:appLanguage];
    if([lang isEqualToString:@"zh-Hant"]){
        row=0;
    }else if([lang isEqualToString:@"en"]){
        row=1;
    }else{
        row=2;
    }

    //dataArray = @[@"",ASLocalizedString(@"报警时间设置"),ASLocalizedString(@"修改密码"),ASLocalizedString(@"网络设置")];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect f=self.listView.frame;
    f.size.height=self.view.frame.size.height;//-self.navigationController.navigationBar.frame.size.height;//-self.tabBarController.tabBar.frame.size.height
    self.listView.frame=f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reUseID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reUseID];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reUseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        MusicItem* r=[[MusicItem alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 60)];
        CGRect rect=r.frame;
        rect.size.width=MainScreenWidth;
        r.frame=rect;
        r.tag=12;
        [cell.contentView addSubview:r];
    }
    MusicItem *r = (MusicItem *)[cell.contentView viewWithTag:12];
    [r.title setText:list[indexPath.row]];
    if(indexPath.row==row){
        [r.icon setImage:[UIImage imageNamed:@"checkbox"]];
    }else{
        [r.icon setImage:[UIImage imageNamed:@"uncheck"]];
    }
    
    return cell;
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
    row=indexPath.row;
    if(row==0){
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hant" forKey:appLanguage];
    }else if(row==1){
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:appLanguage];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:appLanguage];
    }
    [self.listView reloadData];
    [self.appDel restart];
}

- (UITableView *)listView
{
    if (!_listView)
    {
        //CGRect r1 = [self.navigationController.navigationBar frame];
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, self.view.frame.size.height)];
        _listView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        //_listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //[_collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];  // KVO 添加监听者,用于导航栏偏移改变透明度
        self.listView.separatorColor = (UIColorFromRGB(0xe8e8e8));
        if ([self.listView respondsToSelector:@selector(setLayoutMargins:)]) {
            self.listView.layoutMargins = UIEdgeInsetsMake(0, 20, 0, 0);
        }
    }
    return _listView;
}

@end
