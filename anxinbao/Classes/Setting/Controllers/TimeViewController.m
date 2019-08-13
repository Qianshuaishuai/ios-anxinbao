//
//  TimeViewController.m
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/8.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import "TimeViewController.h"
#import "TimeItem.h"
#import "HelpHeaderFile.h"
#import "TimeModel.h"
#import "UIImageView+WebCache.h"
#import "ZFToast.h"

@interface TimeViewController (){
    CGFloat cellHeight;
    NSMutableArray* list;//空数组，有意义
    UIButton* rightBtn;
    int page;
    bool editMode,isLoading,isEnd;
}

@property (nonatomic, strong) UITableView *listView;

@end

@implementation TimeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:rightBtn];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [rightBtn removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    list=[NSMutableArray array];
    isLoading=isEnd=editMode=NO;
    page=1;
    [self.view addSubview:self.listView];
    self.title=ASLocalizedString(@"报警时间设置");
    cellHeight=86;
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(MainScreenWidth - 55, 7, 60, 30);
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    rightBtn.titleLabel.text=ASLocalizedString(@"编辑");
    [rightBtn setTitle:ASLocalizedString(@"编辑")forState:UIControlStateNormal];
    //[CATransaction begin];
    //[CATransaction setDisableActions:YES];
    [self.navigationController.navigationBar addSubview:rightBtn];
    //[CATransaction commit];
    [rightBtn addTarget:self action:@selector(switchState) forControlEvents:UIControlEventTouchUpInside];
    //dataArray = @[@"",ASLocalizedString(@"报警时间设置"),ASLocalizedString(@"修改密码"),ASLocalizedString(@"网络设置")];
    [self getData];
}

-(void)switchState{
    editMode=!editMode;
    if(editMode){
        [rightBtn setTitle:ASLocalizedString(@"保存")forState:UIControlStateNormal];
    }else{
        [self submit];
        [rightBtn setTitle:ASLocalizedString(@"编辑")forState:UIControlStateNormal];
    }
    [_listView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) submit{
    if(isLoading){
        return;
    }
    isLoading=YES;
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    NSMutableDictionary *times=[[NSMutableDictionary alloc] init];
    for(int i=0;i<list.count;++i){
        TimeModel* t=list[i];
        NSString* pid=[NSString stringWithFormat:@"%ld", t.pid];
        times[pid]=[NSString stringWithFormat:@"%ld",t.count];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:times options:kNilOptions error:nil];// OC对象 -> JSON数据 [数据传输只能以进制流方式传输,所以传输给我们的是进制流,但是本质是JSON数据
    
    NSString* stimes=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    params[@"times"]=stimes;
    [self.appDel getData:@"set_warn_time" param:params callback:^(NSDictionary* dict){
        isLoading=NO;
        if(dict==nil){
            return;
        }
        int i=[[dict objectForKey:@"code"] intValue];
        if(i==1){
            
        }else if(i==10){
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        }else{
            [[[ZFToast alloc] init] popUpToastWithMessage:dict[@"msg"]];
            page=1;
            isEnd=YES;
            [self getData];
        }
    }];
}

-(void) getData{
    if(isLoading){
        return;
    }
    isLoading=YES;
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    params[@"page"]=[NSString stringWithFormat:@"%d", page];
    [self.appDel getData:@"people_delayed_warn" param:params callback:^(NSDictionary* dict){
        isLoading=NO;
        if(dict==nil){
            return;
        }
        int i=[[dict objectForKey:@"code"] intValue];
        if(i==1){
            NSDictionary* data0=[dict objectForKey:@"data"];
            NSArray* data=data0[@"list"];
            if(page==1){
                [list removeAllObjects];
            }
            for(int i=0;i<data.count;++i){
                NSDictionary *dict=data[i];
                TimeModel *t=[[TimeModel alloc] init];
                t.name=dict[@"name"];
                t.room=dict[@"room_num"];
                t.bed=dict[@"bed_num"];
                t.count=[dict[@"warn_delayed"] intValue];
                t.count=t.count-t.count%10;
                t.pid=[dict[@"id"] intValue];
                t.avatar=dict[@"avatar"];
                [list addObject:t];
            }
            [_listView reloadData];
        }else if(i==11){
            isEnd=YES;
        }else if(i==10){
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect f=self.listView.frame;
    f.size.height=self.view.frame.size.height;//-self.navigationController.navigationBar.frame.size.height;//-self.tabBarController.tabBar.frame.size.height
    self.listView.frame=f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reUseID = @"musicCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reUseID];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reUseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        TimeItem* r=[[TimeItem alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 60)];
        CGRect rect=r.frame;
        rect.size.width=MainScreenWidth;
        r.frame=rect;
        r.tag=12;
        r.avatar.layer.cornerRadius=r.avatar.bounds.size.width/2;;
        r.avatar.clipsToBounds=YES;
        [cell.contentView addSubview:r];
    }
    TimeItem *r = (TimeItem *)[cell.contentView viewWithTag:12];
    TimeModel *m=[list objectAtIndex:indexPath.row];
    [r.name setText:m.name];
    [r.room setText:m.room];
    [r.number setText:m.bed];
    [r.avatar sd_setImageWithURL:[NSURL URLWithString:m.avatar] placeholderImage:[UIImage imageNamed:@"avatar"] options:SDWebImageHighPriority];
    if(editMode){
        r.edit.hidden=NO;
        r.time.hidden=YES;
        [r.count setText:[NSString stringWithFormat:@"%ld", m.count]];
        r.minus.tag=indexPath.row;
        r.plus.tag=indexPath.row;
        [r.minus addTarget:self action:@selector(minus:) forControlEvents:UIControlEventTouchUpInside];
        [r.plus addTarget:self action:@selector(plus:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        r.time.hidden=NO;
        r.edit.hidden=YES;
        [r.timeText setText:[NSString stringWithFormat:@"%ld", m.count]];
    }
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.listView.contentOffset.y <= -120) {
        //[UIView animateWithDuration:5 animations:^{
        //NSLog(ASLocalizedString(@"下拉刷新"));
        //}];
    }
    
    if ((self.listView.contentSize.height - self.listView.contentOffset.y) <= self.listView.frame.size.height) { //同上
        //[UIView animateWithDuration:5 animations:^{
        if(!isEnd&&!isLoading){
            //NSLog(ASLocalizedString(@"上拉加载更多"));
            ++page;
            [self getData];
        }
        //}];
    }
}

-(void)minus:(UIButton*)btn{
    NSInteger row=btn.tag;
    TimeModel* m=[list objectAtIndex:row];
    if(m.count>0){
        m.count-=10;
    }
    [_listView reloadData];
}

-(void)plus:(UIButton*)btn{
    NSInteger row=btn.tag;
    TimeModel* m=[list objectAtIndex:row];
    if(m.count<60){
        m.count+=10;
    }
    [_listView reloadData];
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
    //[self.listView reloadData];
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
