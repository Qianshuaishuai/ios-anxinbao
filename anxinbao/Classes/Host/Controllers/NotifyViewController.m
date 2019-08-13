//
//  NotifyViewController.m
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/6.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import "NotifyViewController.h"
#import "HelpHeaderFile.h"
#import "RecordItem.h"
#import "DetailViewController.h"
#import "Utils.h"

@interface NotifyViewController (){
    CGFloat cellHeight;
    bool isLoading,isEnd;
    int page;
    UIView* emptyView;
    NSMutableArray *list;
    NSString* typestr;
}
@property (nonatomic, strong) UITableView *listView;

@end

@implementation NotifyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    list=[[NSMutableArray alloc] init];
    cellHeight=60;
    isLoading=NO;
    isEnd=NO;
    self.title=ASLocalizedString(@"待处理事项");
    page=1;
    [self.view  addSubview:self.listView];
    [self getData];
    // Do any additional setup after loading the view.
    UIImage* empty=[UIImage imageNamed:@"empty"];
    emptyView=[[UIView alloc] initWithFrame:CGRectMake((MainScreenWidth-empty.size.width)/2, 115, empty.size.width,MainScreenHeight)];
    UIImageView *emptyImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, empty.size.width,empty.size.height)];
    emptyImageView.image=empty;
    [Utils addLabelCenter:ASLocalizedString(@"暂无数据")For:emptyView withFrame:CGRectMake(0,empty.size.height+50,empty.size.width,50) withColor:0x888888 withSize:17.5];
    [emptyView addSubview:emptyImageView];
    [self.view addSubview:emptyView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void) getData{
    if(isLoading){
        return;
    }
    isLoading=YES;
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    params[@"page"]=[NSString stringWithFormat:@"%d", page];
    [self.appDel getData:@"wait_dispose_list" param:params callback:^(NSDictionary* dict){
        isLoading=NO;
        if(dict==nil){
            return;
        }
        int i=[[dict objectForKey:@"code"] intValue];
        if(i==1){
            NSArray* data=[dict objectForKey:@"data"];
            if(page==1){
                [list removeAllObjects];
            }
            [list addObjectsFromArray:data];
            [_listView reloadData];
            emptyView.hidden=YES;
            _listView.hidden=NO;
        }else if(i==11){
            isEnd=YES;
            if(page==1){
                _listView.hidden=YES;
                emptyView.hidden=NO;
            }
         }else if(i==10){
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reUseID = @"contentCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reUseID];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reUseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RecordItem* r=[[RecordItem alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 60)];
        CGRect rect=r.frame;
        rect.size.width=MainScreenWidth;
        r.frame=rect;
        r.tag=12;
        [cell addSubview:r];
        [cell layoutIfNeeded];
    }
    RecordItem *r = (RecordItem *)[cell viewWithTag:12];
    NSDictionary* item=list[indexPath.row];
    NSString* type=item[@"type"];
    NSString* date=item[@"create_time"];
    NSRange range = [date rangeOfString:@" "];
    NSString* time=@"";
    if (range.location != NSNotFound) {
        time=[date substringFromIndex:range.location+1];
        date=[date substringToIndex:range.location];
    }
    if([type isEqualToString:@"urine"]){
        typestr=ASLocalizedString(@"尿量报警");
        r.icon.image=[UIImage imageNamed:@"peered"];
    }else if([type isEqualToString:@"inactivity"]){
        typestr=ASLocalizedString(@"静止报警");
        r.icon.image=[UIImage imageNamed:@"sleepico"];
    }else if([type isEqualToString:@"fall"]){
        typestr=ASLocalizedString(@"跌倒报警");
        r.icon.image=[UIImage imageNamed:@"fall"];
    }else{
        typestr=ASLocalizedString(@"紧急报警");
        r.icon.image=[UIImage imageNamed:@"warn"];
    }
    r.title.numberOfLines=0;
    r.title.text=[NSString stringWithFormat:@"%@\n%@", item[@"old_name"], typestr];
    r.day.text=date;
    r.time.text=time;

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
    DetailViewController* c=[[DetailViewController alloc] init];
    NSDictionary* item=list[indexPath.row];
    c.pid=item[@"id"];
    c.type=item[@"type"];
    [self.navigationController pushViewController:c animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.listView.contentOffset.y <= -120) {
        //[UIView animateWithDuration:5 animations:^{
        ///NSLog(ASLocalizedString(@"下拉刷新"));
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
