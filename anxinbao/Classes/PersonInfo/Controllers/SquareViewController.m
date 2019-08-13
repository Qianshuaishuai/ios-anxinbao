


/*!
 */

#import "SquareViewController.h"
#import "HelpHeaderFile.h"
#import "RecordItem.h"
#import "AFNetworking.h"
#import "DetailViewController.h"
#import "Utils.h"

@interface SquareViewController (){
    CGFloat cellHeight;
    UIView* emptyView;
    bool isLoading,isEnd;
    int page;
    NSMutableArray* list;
}

@property UIScrollView* contentView;
@property (nonatomic, strong) UITableView *listView;
@end

@implementation SquareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.listView];
    cellHeight=60;
    page=1;
    list=[[NSMutableArray alloc] init];
    [self getData];
    UIImage* empty=[UIImage imageNamed:@"empty"];
    emptyView=[[UIView alloc] initWithFrame:CGRectMake((MainScreenWidth-empty.size.width)/2, 70, empty.size.width,MainScreenHeight)];
    UIImageView *emptyImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, empty.size.width,empty.size.height)];
    emptyImageView.image=empty;
    [Utils addLabelCenter:ASLocalizedString(@"暂无数据")For:emptyView withFrame:CGRectMake(0,empty.size.height+50,empty.size.width,50) withColor:0x888888 withSize:17.5];
    [emptyView addSubview:emptyImageView];
    [self.view addSubview:emptyView];
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
    if([type isEqualToString:@"urine"]){
        [r.title setText:ASLocalizedString(@"尿量报警")];
        r.icon.image=[UIImage imageNamed:@"peered"];
    }else if([type isEqualToString:@"inactivity"]){
        [r.title setText:ASLocalizedString(@"静止报警")];
        r.icon.image=[UIImage imageNamed:@"sleepico"];
    }else if([type isEqualToString:@"fall"]){
        [r.title setText:ASLocalizedString(@"跌倒报警")];
        r.icon.image=[UIImage imageNamed:@"fall"];
    }else{
        [r.title setText:ASLocalizedString(@"紧急报警")];
        r.icon.image=[UIImage imageNamed:@"warn"];
    }
    NSString* date=item[@"create_time"];
    NSRange range = [date rangeOfString:@" "];
    NSString* time=@"";
    if (range.location != NSNotFound) {
        time=[date substringFromIndex:range.location+1];
        date=[date substringToIndex:range.location];
    }
    r.day.text=date;
    r.time.text=time;
    
    return cell;
}

-(void) getData{
    if(isLoading){
        return;
    }
    isLoading=YES;
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    params[@"id"]=_pid;
    params[@"page"]=[NSNumber numberWithInt:page];
    [self.appDel getData:@"record_list" param:params callback:^(NSDictionary* dict){
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
            [self.navigationController popViewControllerAnimated:NO];
        }
    }];    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.listView.contentOffset.y <= -120) {
        //[UIView animateWithDuration:5 animations:^{
        NSLog(ASLocalizedString(@"下拉刷新"));
        //}];
    }
    
    if ((self.listView.contentSize.height - self.listView.contentOffset.y) <= self.listView.frame.size.height) { //同上
        //[UIView animateWithDuration:5 animations:^{
        if(!isEnd&&!isLoading){
            NSLog(ASLocalizedString(@"上拉加载更多"));
            ++page;
            [self getData];
        }
        //}];
    }
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect r=_listView.frame;
    CGRect r1=[[UIApplication sharedApplication] statusBarFrame];
    r.size.height=self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-r1.size.height;
    _listView.frame=r;
}

- (UITableView *)listView
{
    if (!_listView)
    {
        //CGRect r1 = [self.navigationController.navigationBar frame];
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, self.view.frame.size.height)];
        _listView.backgroundColor = RGBACOLOR(255, 255, 255, 1);
        
        _listView.delegate = self;
        _listView.dataSource = self;
        //_listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

        //[_collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];  // KVO 添加监听者,用于导航栏偏移改变透明度
        self.listView.separatorColor = (UIColorFromRGB(0xe8e8e8));
        if ([self.listView respondsToSelector:@selector(setLayoutMargins:)]) {
            self.listView.layoutMargins = UIEdgeInsetsMake(0, 20, 0, 0);
        }
    }
    return _listView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    NSLog(@"%s dealloc",object_getClassName(self));
}

@end
