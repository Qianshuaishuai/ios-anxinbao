//
//  ManageController.m
//  EVNEstorePlatform
//
//  Created by developer on 2016/12/30.
//  Copyright © 2016年 郭大扬. All rights reserved.
//
#import "MJRefresh.h"
#import "ManageController.h"
#import "HelpHeaderFile.h"
#import "CategoryView.h"
#import "AFNetworking.h"
#import "PersonController.h"
#import "NotifyViewController.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "ZFToast.h"
#import <UIImageView+WebCache.h>
#import "DetailViewController.h"
#import "DropDown.h"
#import "BabyCentralManager.h"

#define popup_width 317

static NSString *ID = @"hostCollectionViewCell";

@interface ManageController ()
{
    CGFloat cellHeight;
    AppDelegate *appDel;
    NSMutableArray* list;
    int page;
    bool isEnd;
    bool isLoading;
    NSArray* arr;
    CategoryView *cv;
    NSString* type, *search;
    DropDown* dropdown;
    NSDictionary* data;
    UIScrollView* emptyView;
    bool isShowPopup;
    bool isScan;
    UIImageView *mail;
    BabyCentralManager* cb;
    NSMutableArray* imeis;
}
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UILabel *dot;
@property (nonatomic, strong) UIView *rightBtn;
@end

@implementation ManageController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.rightBtn];
    [self getDataFirst];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.rightBtn removeFromSuperview];
    //self.navigationController.interactivePopGestureRecognizer.delegate=self.navigationController;
    //self.navigationController.navigationBar.frame = CGRectMake(0, 0, MainScreenWidth, 200);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isLoading=false;
    isEnd=NO;
    page=1;
    search=type=@"";
    list=[[NSMutableArray alloc] init];
    appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 50)];
    view.backgroundColor=UIColorFromRGB(0xffffff);
    [self.view addSubview:view];
    self.searchField=[[UITextField alloc] initWithFrame:CGRectMake(15, 8, MainScreenWidth - 62.5, 35)];
    [view addSubview:self.searchField];
    self.searchField.backgroundColor=UIColorFromRGB(0xf0f0f0);
    self.searchField.layer.cornerRadius=16.0f;
    self.searchField.textColor=UIColorFromRGB(0x9A9A9A);
    self.searchField.placeholder = ASLocalizedString(@"请输入姓名");
    [self.searchField setValue:self.searchField.textColor forKeyPath:@"_placeholderLabel.textColor"];   //修改
    [self.searchField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    self.searchField.font = [UIFont systemFontOfSize:15.0];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 35)];
    UIImageView* img=[[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 30, 30)];//[UIButton buttonWithType:UIButtonTypeCustom];
    [img setImage:[UIImage imageNamed:@"del"]];
    self.searchField.clearButtonMode=UITextFieldViewModeWhileEditing;
    UITapGestureRecognizer *xImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(del)];
    img.userInteractionEnabled=YES;
    [img addGestureRecognizer:xImageViewTap];
    [rightView addSubview:img];
    //self.searchField.rightView=rightView;
    self.searchField.rightViewMode=UITextFieldViewModeWhileEditing;
    //[img addTarget:self action:@selector(del) forControlEvents:UIControlEventTouchUpInside];
    UIButton *search = [UIButton buttonWithType:UIButtonTypeCustom];
    search.frame = CGRectMake(MainScreenWidth - 37.5, 13.5, 19.5, 19.5);
    [search setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];       // 修改输入框右端图片Bookmark的图标
    [view addSubview:search];
    [search addTarget:self action:@selector(searchNames) forControlEvents:UIControlEventTouchDown];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(MainScreenWidth - 42, 10, 42, 40);
    mail = [[UIImageView alloc] init];
    [mail setImage:[UIImage imageNamed:@"mail"]];
    mail.frame = CGRectMake(0, 3, 20, 20);
    [rightBtn addTarget:self action:@selector(showNotify) forControlEvents:UIControlEventTouchDown];

    UILabel *dot=[[UILabel alloc] initWithFrame:CGRectMake(17, 0, 15, 12)];
    dot.backgroundColor=UIColorFromRGB(0xfc5c5f);
    dot.layer.cornerRadius=6;
    dot.clipsToBounds=YES;
    dot.textColor=UIColorFromRGB(0xffffff);
    dot.font=[UIFont systemFontOfSize:10];
    dot.textAlignment=NSTextAlignmentCenter;
    self.dot=dot;
    [rightBtn addSubview:mail];
    [rightBtn addSubview:dot];
    self.rightBtn=rightBtn;
    isShowPopup=false;
    
    //leftView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor=UIColorFromRGB(0xf0f0f0);
    self.searchField.leftView = leftView;
    self.searchField.leftViewMode = UITextFieldViewModeAlways;
    cv = [[CategoryView alloc] initWithFrame:CGRectMake(0, 50, MainScreenWidth, 45)];
    [self.view addSubview:cv];
    [cv.chooseTip setText:ASLocalizedString(@"筛选")];
    [cv.title setText:ASLocalizedString(@"全部")];
    arr=[NSArray arrayWithObjects:ASLocalizedString(@"全部"),ASLocalizedString(@"待处理"),ASLocalizedString(@"紧急"),ASLocalizedString(@"周边"),nil];
    dropdown=[[DropDown alloc] initWithFrame:CGRectMake(cv.bg.frame.origin.x-2, cv.frame.origin.y+cv.bg.frame.origin.y+cv.bg.frame.size.height, cv.bg.frame.size.width, 100) withStringArray:arr];
    dropdown.delegate=self;
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(cv.bg.frame.origin.x, cv.frame.origin.y+cv.bg.frame.origin.y, cv.bg.frame.size.width, cv.bg.frame.size.height);
    [btn addTarget:self action:@selector(showDropDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
   //cv.bg addo
    cellHeight = 86;
    [self.view addSubview:self.listView];
    //[self getData];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    page=1;
    UIImage* empty=[UIImage imageNamed:@"empty"];
    emptyView=[[UIScrollView alloc] initWithFrame:CGRectMake((MainScreenWidth-empty.size.width)/2, 95, empty.size.width,MainScreenHeight)];
    UIImageView *emptyImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,85, empty.size.width,empty.size.height)];
    emptyImageView.image=empty;
    [Utils addLabelCenter:ASLocalizedString(@"暂无数据") For:emptyView withFrame:CGRectMake(0,empty.size.height+135 ,empty.size.width,50) withColor:0x888888 withSize:17.5];
    [emptyView addSubview:emptyImageView];
    [self.view addSubview:emptyView];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    cb=[[BabyCentralManager alloc] init];
    [center addObserver:self selector:@selector(poweron:) name:BabyNotificationAtCentralManagerEnable object:nil];
    [center addObserver:self selector:@selector(findBluetooth:) name:BabyNotificationAtDidDiscoverPeripheral object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPopup:) name:@"msg" object:nil];
   [self setTitle:ASLocalizedString(@"列表")];
    /*self.listView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
    }];*/
    // Set the callback（Once you enter the refresh status，then call the action of target，that is call [self loadNewData]）
    self.listView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getDataFirst)];
    emptyView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getDataFirst)];
    //emptyView.hea
    // Enter the refresh status immediately
    //[self.tableView.header beginRefreshing];
    [self.view addSubview:dropdown];
    [dropdown setHidden:YES];
}

-(void)del{
    self.searchField.text=@"";
}

-(void)poweron:(NSNotification*)data{
    //[self scanPeri];
}

-(void)findBluetooth:(NSNotification *)data{
    NSDictionary* d= data.object;
    NSDictionary* advertisementData=d[@"advertisementData"];
    NSData* byteData=advertisementData[@"kCBAdvDataManufacturerData"];
    if(byteData.length!=16&&advertisementData[@"kCBAdvDataIsConnectable"]!=0){
        return;
    }
    NSString* sn=[Utils convertDataToHexStr:byteData length:6];
    [imeis addObject:sn];
}

-(void)scan{
    if(isScan){
        return;
    }
    [self showLoadingIndicatorView];
    isScan=true;
    [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"开始扫描，请耐心等待……")];
    [cb scanPeripherals];
    [self performSelector:@selector(stopScan) withObject:nil afterDelay:2];
}

-(void)stopScan{
    isScan=false;
    [cb cancelScan];
    [self getData:1];
}

- (void)showDropDown{
    dropdown.hidden=!dropdown.hidden;
}

-(void)selectItem:(int)index{
    arr=[NSArray arrayWithObjects:ASLocalizedString(@"全部"),ASLocalizedString(@"待处理"),ASLocalizedString(@"紧急"),ASLocalizedString(@"周边"),nil];
    NSString* text=arr[index];
    NSArray* types=[NSArray arrayWithObjects:@"wait",@"urgent",@"near",nil];
    if(index==0){
        type=@"";
    }else{
        type=types[index-1];
    }
    cv.title.text=text;
    dropdown.hidden=YES;
    [self getDataFirst];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.searchField resignFirstResponder];
    //[self searchNames];
}

-(void)setDotText:(NSString *)s
{
    self.dot.text=s;
    CGSize size = [self.dot.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.dot.font,NSFontAttributeName,nil]];
    self.dot.frame=CGRectMake(-size.width/2+20, 0, size.width+5, 12);
}

- (void) searchNames
{
    //[appDel dealEnterToDCFTabbar:ASLocalizedString(@"首页")];
    search=self.searchField.text;
    [self getDataFirst];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, cellHeight - 40, cellHeight - 40)];
        imageView.tag = 110;
        imageView.layer.cornerRadius = imageView.bounds.size.width/2;
        imageView.clipsToBounds = YES;
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:imageView];
        
        UIImageView *state1 = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth-116, 10, 27, 27)];
        state1.tag = 107;
        [cell.contentView addSubview:state1];
        
        UIImageView *state2 = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth-79, 10, 27, 27)];
        state2.tag = 108;
        [cell.contentView addSubview:state2];
        
        UIImageView *state3 = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth-42, 10, 27, 27)];
        state3.tag = 109;
        [cell.contentView addSubview:state3];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 12.5, 15, 150, 35)];
        titleLab.textColor = UIColorFromRGB(0x222222);
        titleLab.tag = 111;
        [cell.contentView addSubview:titleLab];
        titleLab.font = [UIFont systemFontOfSize:16];
        
        UILabel *numberLab = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 12.5, 40, 100, 35)];
        numberLab.textColor = UIColorFromRGB(0xb8b8b8);
        numberLab.tag = 112;
        [cell.contentView addSubview:numberLab];
        numberLab.font = [UIFont systemFontOfSize:14];
        
        UILabel *countLab = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 100, 40, 100, 35)];
        countLab.textColor = UIColorFromRGB(0xf4964e);
        countLab.tag = 113;
        [cell.contentView addSubview:countLab];
        countLab.font = [UIFont systemFontOfSize:14];
        
        UIImageView* battery=[[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth-50, 40, 30, 30)];
        [cell.contentView addSubview:battery];
        battery.image=[UIImage imageNamed:@"battery"];
        battery.tag=114;
    }
    
    NSDictionary* obj=[list objectAtIndex:indexPath.row];
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:110];
    [imageView sd_setImageWithURL:[NSURL URLWithString:obj[@"avatar"]] placeholderImage:[UIImage imageNamed:@"avatar"] options:SDWebImageHighPriority];
    /*UIImageView *state1 = (UIImageView *)[cell.contentView viewWithTag:107];
    state1.image = [UIImage imageNamed:@"wifigray"];
    UIImageView *state2 = (UIImageView *)[cell.contentView viewWithTag:108];
    state2.image = [UIImage imageNamed:@"peered"];
    UIImageView *state3 = (UIImageView *)[cell.contentView viewWithTag:109];
    state3.image = [UIImage imageNamed:@"fall"];*/

    UILabel *titleLab = (UILabel *)[cell.contentView viewWithTag:111];
    titleLab.text  = [obj objectForKey:@"name"];//dataArray[indexPath.row];
    UILabel *numberLab = (UILabel *)[cell.contentView viewWithTag:112];
    numberLab.text=[NSString stringWithFormat:@"%@ %@",ASLocalizedString(@"房间"), obj[@"room_num"]];
    [numberLab sizeToFit];
    CGRect r1=numberLab.frame;
    r1.size.height=35;
    numberLab.frame=r1;
    UILabel *countLab = (UILabel *)[cell.contentView viewWithTag:113];
    countLab.text=[NSString stringWithFormat:@"%@ %@",ASLocalizedString(@"床位"), obj[@"bed_num"]];
    CGRect r=countLab.frame;
    r.origin.x=CGRectGetMaxX(numberLab.frame)+15;
    countLab.frame=r;
    UIImageView *battery=(UIImageView*)[cell.contentView viewWithTag:114];
    int isOnline=[obj[@"is_online"] intValue];
    boolean_t is_lower_electricity=[obj[@"is_lower_electricity"] intValue]>0;
    int i=109;
    if(isOnline==1){
        NSDictionary *states=[obj objectForKey:@"last_state"];
        if((NSNull *)states!=[NSNull null]){
            for (NSString *key in states) {
                UIImageView *state1 = (UIImageView *)[cell.contentView viewWithTag:i];
                [state1 setHidden:NO];
                NSString* state=states[key];
                if((NSNull *)state==[NSNull null]){
                    continue;
                }
                --i;
                if([key isEqualToString:@"urine"]){
                    if(![state isKindOfClass:[NSString class]]){
                        ++i;
                    }
                    else if([state isEqualToString:@"green"]){
                        [state1 setImage:[UIImage imageNamed:@"peegreen"]];
                    }else if([state isEqualToString:@"yellow"]){
                        [state1 setImage:[UIImage imageNamed:@"peeyellow"]];
                    }else if([state isEqualToString:@"olivine"]){
                        [state1 setImage:[UIImage imageNamed:@"peeyg"]];
                    }else if([state isEqualToString:@"orange"]){
                        [state1 setImage:[UIImage imageNamed:@"peeorange"]];
                    }else if([state isEqualToString:@"red"]){
                        [state1 setImage:[UIImage imageNamed:@"peered"]];
                    }else if([state isEqualToString:@"purple"]){
                        [state1 setImage:[UIImage imageNamed:@"peepurple"]];
                    }else{
                        ++i;
                    }
                } else if([key isEqualToString:@"fall"]){
                    if([state isKindOfClass:[NSNumber class]]){
                        int s=[state intValue];
                        if(s==1){
                            [state1 setImage:[UIImage imageNamed:@"fall"]];
                        }else{
                            [state1 setImage:[UIImage imageNamed:@"unfall"]];
                        }
                    }
                    else{
                        if([state isEqualToString:@"1"]){
                            [state1 setImage:[UIImage imageNamed:@"fall"]];
                        }else{
                            [state1 setImage:[UIImage imageNamed:@"unfall"]];
                        }
                    }
                }else if([key isEqualToString:@"inactivity"]){
                    if([state isKindOfClass:[NSNumber class]]){
                        int s=[state intValue];
                        if(s==1){
                            [state1 setImage:[UIImage imageNamed:@"sleepico"]];
                        }else{
                            ++i;
                        }
                    }
                    else{
                        if([state isEqualToString:@"1"]){
                            [state1 setImage:[UIImage imageNamed:@"sleepico"]];
                        }else{
                            ++i;
                        }
                    }
                }else{
                    ++i;
                }
                //"urine","call","fall","sleep","turn";
                if(i<107){
                    break;
                }
            }
        }
        cell.backgroundColor=UIColorFromRGB(0xffffff);
        if(is_lower_electricity){
            battery.hidden=NO;
        }else{
            battery.hidden=YES;
        }
    }else{
        battery.hidden=YES;
        cell.backgroundColor=UIColorFromRGB(0xeeeeee);
    }
    for(;i>106;--i){
        UIImageView *state1 = (UIImageView *)[cell.contentView viewWithTag:i];
        [state1 setHidden:YES];
    }
    return cell;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect r=[[UIApplication sharedApplication] statusBarFrame];
    CGRect f=self.listView.frame;
    f.size.height=self.tabBarController.tabBar.frame.origin.y-self.navigationController.navigationBar.frame.size.height-95-r.size.height;//-self.tabBarController.tabBar.frame.size.height
    self.listView.frame=f;
}

-(void) getDataFirst{
    page=1;
    isEnd=false;
    if([type isEqualToString:@"near"]){
        imeis=[[NSMutableArray alloc] init];
        [self scan];
        return;
    }
    [self getData:1];
}

-(void) getData:(int)page{
    if(isLoading){
        return;
    }
    isLoading=YES;
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    params[@"type"]=type;
    params[@"search"]=search;
    if([type isEqualToString:@"near"]){
        params[@"device_imeis"]=[imeis componentsJoinedByString:@","];
    }
    [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];//@"1"
    [appDel getData:@"old_people_list" param:params callback:^(NSDictionary* dict){
        isLoading=NO;
        [self hideLoadingIndicatorView];
        [emptyView.mj_header endRefreshing];
        [self.listView.mj_header endRefreshing];
        if(dict==nil){
            return;
        }
        appDel.userType=dict[@"user_type"];
        int i=[[dict objectForKey:@"code"] intValue];
        if(i==1){
            NSDictionary* data=[dict objectForKey:@"data"];
            int msgCount=[data[@"msg_count"] intValue];
            if(msgCount>0){
                [self setDotText:[NSString stringWithFormat:@"%d", msgCount]];
                self.dot.hidden=NO;
                mail.image=[UIImage imageNamed:@"mail"];
            }else{
                self.dot.hidden=YES;
                mail.image=[UIImage imageNamed:@"whitealarm"];
            }
            NSArray* list1=[data objectForKey:@"list"];
            if(page==1){
                [list removeAllObjects];
            }
            [list addObjectsFromArray:list1];
            [_listView reloadData];
            _listView.hidden=NO;
            emptyView.hidden=YES;
        }else if(i==11){
            if(page==1){
                _listView.hidden=YES;
                emptyView.hidden=NO;
            }
            isEnd=YES;
        }else if(i==10){
            [self.navigationController popViewControllerAnimated:YES];
        }
        //_listView.hidden=YES;
        //emptyView.hidden=NO;
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



- (UITableView *)listView
{
    if (!_listView)
    {
        CGRect r2 = [self.tabBarController.tabBar frame];
        //CGRect r1 = [self.navigationController.navigationBar frame];
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 95, MainScreenWidth, r2.origin.y-95-64)];
        _listView.backgroundColor = RGBACOLOR(255, 255, 255, 1);
        
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _listView.separatorColor = (UIColorFromRGB(0xe8e8e8));
        if ([_listView respondsToSelector:@selector(setLayoutMargins:)]) {
            _listView.layoutMargins = UIEdgeInsetsMake(0, 20, 0, 0);
        }

        //[_collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];  // KVO 添加监听者,用于导航栏偏移改变透明度
    }
    return _listView;
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
            [self getData:page];
        }
        //}];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonController* c=[[PersonController alloc] init];
    c.pid=[list[indexPath.row] objectForKey:@"id"];
    [self.navigationController pushViewController:c animated:YES];
}

-(void)showNotify{
    NotifyViewController* c=[[NotifyViewController alloc] init];
    [self.navigationController pushViewController:c animated:YES];
}

#pragma mark: dealloc
- (void)dealloc
{
    // 移除监听
    //[_collectionView removeObserver:self forKeyPath:@"contentOffset"];
}


@end
