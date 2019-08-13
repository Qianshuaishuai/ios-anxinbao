//
//  DetailControllerViewController.m
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/6.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import "DetailViewController.h"
#import "HelpHeaderFile.h"
#import "UITextView+ZWPlaceHolder.h"

@interface DetailViewController (){
    CGFloat cellHeight;
    NSArray *dataArray;
    NSString* typestr;
    NSString* tipstr;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=ASLocalizedString(@"记录详情");
    self.view.backgroundColor=UIColorFromRGB(0xf0f0f0);
    // Do any additional setup after loading the view from its nib.
    
    self.remark.placeholder=ASLocalizedString(@"请输入备注内容，可留空");
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    self.submit.layer.cornerRadius=5.0f;
    [self.submit addTarget:self action:@selector(submitNote) forControlEvents:UIControlEventTouchDown];
    [self.submit setTitle:ASLocalizedString(@"提交") forState:UIControlStateNormal];
    //self.remark.returnKeyType = UIReturnKeyDone;
    //self.remark.delegate=self;
    self.remark.contentInset=UIEdgeInsetsMake(0,0, 50, 0);
    NSString* type=self.type;
    self.info.lineBreakMode = NSLineBreakByWordWrapping;
    self.info.numberOfLines = 0;
    [self.view addSubview:self.listView];

    if([type isEqualToString:@"urine"]){
        [self.titleLabel setText:ASLocalizedString(@"尿量报警")];
        self.icon.image=[UIImage imageNamed:@"peered"];
        tipstr=self.info.text=ASLocalizedString(@"尿量达到报警值，请及时处理");
    }else if([type isEqualToString:@"inactivity"]){
        [self.titleLabel setText:ASLocalizedString(@"静止报警")];
        self.icon.image=[UIImage imageNamed:@"sleepico"];
        tipstr=self.info.text=ASLocalizedString(@"用户静止时间超过设定的翻身报警延时限值，请及时处理");
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:tipstr];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:8];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [tipstr length])];
        [self.info setAttributedText:attributedString1];
        [self.info sizeToFit];
        self.listView.frame=CGRectMake(30, 180, MainScreenWidth-30, self.view.frame.size.height-400);
    }else if([type isEqualToString:@"fall"]){
        [self.titleLabel setText:ASLocalizedString(@"跌倒报警")];
        self.icon.image=[UIImage imageNamed:@"fall"];
        tipstr=self.info.text=ASLocalizedString(@"用户跌倒，请及时处理");
    }else{
        [self.titleLabel setText:ASLocalizedString(@"紧急报警")];
        self.icon.image=[UIImage imageNamed:@"warn"];
        tipstr=self.info.text=ASLocalizedString(@"发生紧急情况，请及时处理");
    }
    //CGRect r=self.listView.frame;
    //r.origin.y=CGRectGetMaxY(self.info.frame)+30;
    //self.listView.frame=r;
    typestr=self.titleLabel.text;
    [self getData];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowWithNotification:) name:UIKeyboardWillShowNotification object:nil];
    //self.remark.delegate=self;
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyBoardWillShowWithNotification:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = -100;//(textView.frame.origin.y+textView.frame.size.height+INTERVAL_KEYBOARD) - (self.view.frame.size.height - kbHeight);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    //将视图上移计算好的偏移
    //if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            //self.view.frame = CGRectMake(0.0f, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    //}

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}


- (void)keyboardWillHide:(NSNotification *)notification
{
    
    NSLog(@"hide");
    // 键盘动画时间
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    //self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [UIView animateWithDuration:duration animations:^{
    }];
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self submitNote];
    return YES;
}

- (UITableView *)listView
{
    if (!_listView)
    {
        //CGRect r1 = [self.navigationController.navigationBar frame];
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(30, 150, MainScreenWidth-30, self.view.frame.size.height-370)];
        //_listView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _listView.bounces = NO;
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //[_collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];  // KVO 添加监听者,用于导航栏偏移改变透明度
        //_listView.separatorColor = (UIColorFromRGB(0xe8e8e8));
        if ([_listView respondsToSelector:@selector(setLayoutMargins:)]) {
            _listView.layoutMargins = UIEdgeInsetsMake(0, 20, 0, 0);
        }
    }
    return _listView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel* content=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.listView.frame.size.width, 0)];
    content.textColor=UIColorFromRGB(0x333333);
    content.numberOfLines = 0;
    content.font=[UIFont systemFontOfSize:15];
    content.tag=3;
    NSDictionary* d=dataArray[indexPath.row];
    content.text=d[@"note"];
    [content sizeToFit];
    return content.frame.size.height+50;
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
    //DetailViewController* c=[[DetailViewController alloc] init];
    //NSDictionary* item=dataArray[indexPath.row];
    //c.pid=item[@"id"];
    //c.type=item[@"type"];
    //[self.navigationController pushViewController:c animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reUseID = @"contentCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reUseID];
    UILabel* date,*name,*content;
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reUseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //RecordItem* r=[[RecordItem alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 60)];
        //CGRect rect=r.frame;
        //rect.size.width=MainScreenWidth;
        //r.frame=rect;
        //r.tag=12;
        UIView* v=cell;//[[UIView alloc] initWithFrame:CGRectMake(0, 0, _listView.frame.size.width, 50)];
        //[cell addSubview:v];
        //v.backgroundColor=UIColorFromRGB(0xffeeeeee);
        name=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        name.font=[UIFont systemFontOfSize:15];
        name.textColor=UIColorFromRGB(0x333333);
        name.tag=1;
        [v addSubview:name];
        date=[[UILabel alloc] initWithFrame:CGRectMake(_listView.frame.size.width-140, 0, 120, 30)];
        date.textAlignment=NSTextAlignmentRight;
        date.textColor=UIColorFromRGB(0x333333);
        date.font=[UIFont systemFontOfSize:15];
        date.tag=2;
        [v addSubview:date];
        content=[[UILabel alloc] initWithFrame:CGRectMake(0, 30, _listView.frame.size.width, 0)];
        content.textColor=UIColorFromRGB(0x333333);
        content.numberOfLines = 0;
        content.font=[UIFont systemFontOfSize:15];
        content.tag=3;
        [v addSubview:content];
    }else{
        name=[cell viewWithTag:1];
        date=[cell viewWithTag:2];
        content=[cell viewWithTag:3];
        content.frame=CGRectMake(0, 30, _listView.frame.size.width, 0);
    }
    NSDictionary* d=dataArray[indexPath.row];
    content.text=d[@"note"];
    [content sizeToFit];
    name.text=d[@"handle_name"];
    long time=[d[@"create_time"] longLongValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    //[formatter setDateStyle:NSDateFormatterFullStyle];//直接输出的话是机器码
    
    //或者是手动设置样式
    [formatter setDateFormat:@"yyyyMMdd HH:mm"];
    NSTimeInterval timeInterval = time;//获取需要转换的timeinterval
    NSDate *d1 = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSString *ymd = [formatter stringFromDate:d1];
    date.text=ymd;
    return cell;
}

-(void) getData{
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    params[@"id"]=_pid;
    [self.appDel getData:@"record_detail" param:params callback:^(NSDictionary* dict){
        if(dict==nil){
            return;
        }
        int i=[[dict objectForKey:@"code"] intValue];
        if(i==1){
            NSDictionary* data1=[dict objectForKey:@"data"];
            NSDictionary* data=[data1 objectForKey:@"detail"];
            long time=[data[@"create_time"] longValue];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            
            //[formatter setDateStyle:NSDateFormatterFullStyle];//直接输出的话是机器码
            
            //或者是手动设置样式
            [formatter setDateFormat:@"yyyyMMdd"];
            NSTimeInterval timeInterval = time;//获取需要转换的timeinterval
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];

            NSString *ymd = [formatter stringFromDate:date];
            [formatter setDateFormat:@"HH:mm"];
            NSString *md = [formatter stringFromDate:date];
            self.day.text=ymd;
            self.time.text=md;
            [self.titleLabel setText:[NSString stringWithFormat:@"%@\n%@", data[@"old_name"], typestr]];
            if(data[@"alarm_place"]!=[NSNull null]){
                NSString* s=[NSString stringWithFormat:@"%@\n%@%@", tipstr, ASLocalizedString(@"位置："), data[@"alarm_place"]];
                NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:s];
                NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle1 setLineSpacing:8];
                [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [s length])];
                [self.info setAttributedText:attributedString1];
                [self.info sizeToFit];
                //[self.info setText:];
                //self.info.lines
            }else{
                [self.info setText:tipstr];
            }
           // CGRect r=self.listView.frame;
            //r.origin.y=CGRectGetMaxY(self.info.frame)+30;
            //self.listView.frame=r;
            [self.listView updateConstraints];
           dataArray=data1[@"note_list"];
            [self.listView reloadData];
        }else if(i==11){
        }else if(i==10){
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        }
    }];
}

-(void) submitNote{
    //[self.remark resignFirstResponder];
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    params[@"id"]=_pid;
    params[@"note"]=self.remark.text;
    [self.appDel getData:@"sub_note" param:params callback:^(NSDictionary* dict){
        if(dict==nil){
            return;
        }
        int i=[[dict objectForKey:@"code"] intValue];
        if(i==1){
            self.remark.text=@"";
            [self getData];
        }else{
            [[ZFToast shareClient] popUpToastWithMessage:dict[@"msg"]];
        }
    }];
}
-(void)hideRemark{
    [self.remarkWrap setHidden:YES];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.remark resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
