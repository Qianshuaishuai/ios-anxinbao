
/*!

 */

#import "BaseInfoController.h"
#import "HelpHeaderFile.h"
#import "Utils.h"
#import "EVNHelper.h"

@interface BaseInfoController() {
    UILabel* min1,*ml,*min0,*unfall;
    UIView* emptyView, *dataView;
    UIImageView* green,*yg,*yellow,*orange,*red,*purple,*sleepicon,*unfallicon,*fallicon;
}
@property UIScrollView* contentView;

@property UILabel* temper;

@property UILabel* gesture;

@property UILabel* amount;

@property UILabel* staticTime;

@property UILabel* min;

@property UILabel* fall;

@property UILabel* call;
@property(nonatomic,strong)NSTimer *timer; // timer
@end

@implementation BaseInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, self.view.frame.size.height)];
    emptyView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, self.view.frame.size.height)];
    dataView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, self.view.frame.size.height)];
    [self.view addSubview:emptyView];
    [self.view addSubview:dataView];
    CGFloat x=(MainScreenWidth-344.5)/2;
    
    [Utils addImage:@"grid" For:self.contentView withFrame:CGRectMake(x, 32.5, 344.5, 252)];
    
    UILabel* temper=[Utils addLabelCenter:@"/" For:dataView withFrame:CGRectMake(x, 60, 100, 28) withDefineColor:ThemeColor withSize:28];
    
    //温度为空
    [Utils addLabelCenter:@"/" For:emptyView withFrame:CGRectMake(x, 60, 100, 28) withDefineColor:ThemeColor withSize:28];

    [Utils addLabelCenter:ASLocalizedString(@"周边温度")For:self.contentView withFrame:CGRectMake(x, 113, 100, 14) withDefineColor:RGBACOLOR(153, 153, 153, 1) withSize:14];
    self.temper=temper;
    
    //睡姿为空
    [Utils addLabelCenter:@"/" For:emptyView withFrame:CGRectMake(MainScreenWidth/2-30, 35, 70, 75) withDefineColor:ThemeColor withSize:28];

    UILabel* gesture=[Utils addLabelCenter:@"/" For:dataView withFrame:CGRectMake(MainScreenWidth/2-13, 35, 70, 75) withDefineColor:ThemeColor withSize:20];
    [Utils addLabelCenter:ASLocalizedString(@"睡姿")For:self.contentView withFrame:CGRectMake(MainScreenWidth/2-60, 113, 120, 18) withDefineColor:RGBACOLOR(153, 153, 153, 1) withSize:14];
    sleepicon=[Utils addImage:@"sleepright" For:dataView withFrame:CGRectMake(MainScreenWidth/2-48, 60, 29, 29)];

    self.gesture=gesture;
    
    //静止为空
    [Utils addLabelCenter:@"/" For:emptyView withFrame:CGRectMake(MainScreenWidth-x-100, 60, 100, 28) withDefineColor:ThemeColor withSize:28];
    
    UILabel* staticTime=[Utils addLabel:@"/" For:dataView withFrame:CGRectMake(MainScreenWidth-x-80, 60, 100, 28) withDefineColor:ThemeColor withSize:28];
    self.staticTime=staticTime;
    CGSize s=[EVNHelper adjustWithFont:staticTime.font WithText:staticTime.text WithSize:CGSizeMake(100, 28)];
    self.min=[Utils addLabel:@"min" For:dataView withFrame:CGRectMake(staticTime.frame.origin.x+s.width, 72, 100, 14) withDefineColor:ThemeColor withSize:14];
    [Utils addLabelCenter:ASLocalizedString(@"静止时间")For:self.contentView withFrame:CGRectMake(MainScreenWidth-x-100, 113, 100, 18) withDefineColor:RGBACOLOR(153, 153, 153, 1) withSize:14];
    
    //尿量显示
    //尿量为空
    [Utils addLabelCenter:@"/" For:emptyView withFrame:CGRectMake(x, 185, 100, 28) withDefineColor:ThemeColor withSize:28];

    UILabel* amount=[Utils addLabel:@"/" For:dataView withFrame:CGRectMake(x+25, 185, 100, 28) withDefineColor:ThemeColor withSize:28];
    CGSize s1=[EVNHelper adjustWithFont:amount.font WithText:amount.text WithSize:CGSizeMake(100, 28)];
    ml=[Utils addLabel:@"ml" For:dataView withFrame:CGRectMake(amount.frame.origin.x+s1.width, amount.frame.origin.y+12, 100, 14) withDefineColor:ThemeColor withSize:14];
    [Utils addLabelCenter:ASLocalizedString(@"尿量")For:self.contentView withFrame:CGRectMake(x, amount.frame.origin.y+53, 100, 30) withDefineColor:RGBACOLOR(153, 153, 153, 1) withSize:14];
    self.amount=amount;
    
    //跌倒时间
    //跌倒为空
    [Utils addLabel:@"/" For:emptyView withFrame:CGRectMake(MainScreenWidth/2-3, 187, 50, 25) withDefineColor:ThemeColor withSize:28];
    unfall=[Utils addLabel:@"/" For:dataView withFrame:CGRectMake(MainScreenWidth/2-3, 187, 50, 25) withColor:0xd8d8d8 withSize:25];
    CGSize s2=[EVNHelper adjustWithFont:unfall.font WithText:unfall.text WithSize:CGSizeMake(100, 28)];
    min0=[Utils addLabel:@"min" For:dataView withFrame:CGRectMake(unfall.frame.origin.x+s2.width, unfall.frame.origin.y+5, 100, 20) withColor:0xd8d8d8 withSize:14];
    unfallicon=[Utils addImage:@"unfallbig" For:dataView withFrame:CGRectMake(MainScreenWidth/2-36, unfall.frame.origin.y-4, 29, 29)];
    UILabel* fall=[Utils addLabel:@"/" For:dataView withFrame:CGRectMake(MainScreenWidth/2-3, 187, 50, 25) withDefineColor:ThemeColor withSize:25];
    s2=[EVNHelper adjustWithFont:fall.font WithText:fall.text WithSize:CGSizeMake(100, 28)];
    min1=[Utils addLabel:@"min" For:dataView withFrame:CGRectMake(fall.frame.origin.x+s2.width, fall.frame.origin.y+5, 100, 20) withDefineColor:ThemeColor withSize:14];
    fallicon=[Utils addImage:@"fallbig" For:dataView withFrame:CGRectMake(MainScreenWidth/2-36, fall.frame.origin.y-4, 29, 29)];
    [Utils addLabelCenter:ASLocalizedString(@"跌倒\n持续时间")For:self.contentView withFrame:CGRectMake(MainScreenWidth/2-50, fall.frame.origin.y+50, 100, 35) withDefineColor:RGBACOLOR(153, 153, 153, 1) withSize:14];
    self.fall=fall;
    
    //紧急呼唤持续时间
    UILabel* sosTime=[Utils addLabelCenter:@"/" For:dataView withFrame:CGRectMake(MainScreenWidth-x-100, 185, 100, 28) withDefineColor:ThemeColor withSize:28];
    [Utils addLabelCenter:ASLocalizedString(@"紧急呼唤\n持续时间")For:self.contentView withFrame:CGRectMake(MainScreenWidth-x-100, sosTime.frame.origin.y+42, 100, 35) withDefineColor:RGBACOLOR(153, 153, 153, 1) withSize:14].hidden=YES;
    self.call=sosTime;
    sosTime.hidden=YES;

    UILabel* l=[Utils addLabel:ASLocalizedString(@"尿湿")For:self.contentView withFrame:CGRectMake(21, 350, 60, 50) withDefineColor:RGBACOLOR(85, 85, 85, 1) withSize:16];
    l.numberOfLines=0;
    l.textAlignment=NSTextAlignmentCenter;
    l.lineBreakMode = NSLineBreakByWordWrapping;
    
    UIImageView* progress=[Utils addImage:@"progress" For:self.contentView withFrame:CGRectMake(81, 373, MainScreenWidth-81-35, 4)];

    green=[Utils addImage:@"peegreenbig" For:self.contentView withFrame:CGRectMake(68, 337, 27, 36)];

    int count=5;
    yg=[Utils addImage:@"peeygbig" For:self.contentView withFrame:CGRectMake(68+progress.frame.size.width/count, 337, 27, 36)];

    yellow=[Utils addImage:@"peeyellowbig" For:self.contentView withFrame:CGRectMake(68+progress.frame.size.width/count*2, 337, 27, 36)];

    orange=[Utils addImage:@"peeorangebig" For:self.contentView withFrame:CGRectMake(68+progress.frame.size.width/count*3, 337, 27, 36)];

    red=[Utils addImage:@"peeredbig" For:self.contentView withFrame:CGRectMake(68+progress.frame.size.width/count*4, 337, 27, 36)];

    purple=[Utils addImage:@"peepurplebig" For:self.contentView withFrame:CGRectMake(68+progress.frame.size.width-2, 337, 27, 36)];

    self.contentView.contentSize=CGSizeMake(MainScreenWidth, 400);;
    
    [self.view addSubview:_contentView];
    green.hidden=YES;
    yg.hidden=YES;
    yellow.hidden=YES;
    orange.hidden=YES;
    red.hidden=YES;
    purple.hidden=YES;
    dataView.hidden=YES;
}

-(void)timerFired:(NSTimer *)timer {
    [self getData];
}

-(void)startTimer{
    _timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

-(void) getData{
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    params[@"id"]=_pid;
    [self.appDel getData:@"old_people_basic" param:params callback:^(NSDictionary* dict){
        if(dict==nil){
            return;
        }
        int i=[[dict objectForKey:@"code"] intValue];
        if(i==1){
            NSDictionary* data=[dict objectForKey:@"data"];
            int isOnline=[data[@"is_online"] intValue];
            NSDictionary* detail=[data objectForKey:@"detail"];
            [self setData:detail isOnline:isOnline];
        }else if(i==10){
            [self.navigationController popToRootViewControllerAnimated:YES];
            [self stopTimer];
        }
    }];
    
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
    }
}
-(void)setData:(NSDictionary*)data isOnline:(int)isOnline{
    green.hidden=YES;
    yg.hidden=YES;
    yellow.hidden=YES;
    orange.hidden=YES;
    red.hidden=YES;
    purple.hidden=YES;
    if(isOnline!=1){
        emptyView.hidden=NO;
        dataView.hidden=YES;
        if(isOnline==2){
            self.view.backgroundColor=UIColorFromRGB(0xeeeeee);
        }else{
            self.view.backgroundColor=UIColorFromRGB(0xffffff);
            
        }
        return;
    }
    self.view.backgroundColor=UIColorFromRGB(0xffffff);
    emptyView.hidden=YES;
    dataView.hidden=NO;
 
    CGFloat x=(MainScreenWidth-344.5)/2;
    if(data[@"diaper_temperature"]!=[NSNull null]&&![data[@"diaper_temperature"] isKindOfClass:[NSNumber class]]){
        [self.temper setText:[NSString stringWithFormat:@"%@°", data[@"diaper_temperature"]]];
    }
    if(data[@"diaper_capacity"]!=[NSNull null]){
        [self.amount setText:[NSString stringWithFormat:@"%d", [data[@"diaper_capacity"] intValue]]];
        CGSize s1=[EVNHelper adjustWithFont:self.amount.font WithText:self.amount.text WithSize:CGSizeMake(100, 28)];
        CGRect r=self.amount.frame;
        r.origin.x=(MainScreenWidth-344.5)/2+25-(s1.width-40)/2;
        self.amount.frame=r;
        ml.frame=CGRectMake(self.amount.frame.origin.x+s1.width, self.amount.frame.origin.y+12, 100, 14);
    }
    if(data[@"sleep_type_num"]!=[NSNull null]){
        int st=[data[@"sleep_type_num"] intValue];
        NSArray* imgs=@[@"stand",@"stand",@"sleepup",@"sleepdown",@"sleepright",@"sleepleft"];
        if(st<7&&st>0){
            [sleepicon setImage:[UIImage imageNamed:imgs[st-1]]];
        }
    }
    if(data[@"sleep_type"]!=[NSNull null]){
        NSString* ges=[[data[@"sleep_type"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
        NSString *trimmedString = [ges stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self.gesture setText:trimmedString];
    }else{
        self.gesture.hidden=YES;
        sleepicon.hidden=YES;
    }
    if(data[@"sleep_time"]!=[NSNull null]){
        NSString* time1=data[@"sleep_time"];
        
        NSString *time=[NSString stringWithFormat:@"%d", [time1 intValue]];
        [self.staticTime setText:time];
        CGSize s=[EVNHelper adjustWithFont:self.staticTime.font WithText:time WithSize:CGSizeMake(100, 28)];
        CGRect r=self.staticTime.frame;
        r.origin.x=MainScreenWidth-x-80-(s.width-40)/2;
        self.staticTime.frame=r;
        self.min.frame=CGRectMake(self.staticTime.frame.origin.x+s.width, 72, 100, 14);
    }
    int f=[data[@"fall_time"] intValue];
    if(f>0){//}&&[data[@"fall_time"] longValue]!=0){
        NSString *time=[NSString stringWithFormat:@"%d", f];
        [self.fall setText:time];
        CGSize s2=[EVNHelper adjustWithFont:self.fall.font WithText:self.fall.text WithSize:CGSizeMake(50, 28)];
        CGRect r=self.fall.frame;
        r.origin.x=MainScreenWidth/2-3-(s2.width-30)/2;
        self.fall.frame=r;
        min1.frame=CGRectMake(self.fall.frame.origin.x+s2.width,self.fall.frame.origin.y+5, 100, 20);
        unfallicon.hidden=unfall.hidden=min0.hidden=YES;
    }else{
        self.fall.hidden=fallicon.hidden=min1.hidden=YES;
        unfallicon.hidden=unfall.hidden=min0.hidden=NO;
    }
    if(data[@"call_time"]!=[NSNull null]){
        [self.call setText:data[@"call_time"]];
    }
    if(data[@"diaper_type"]!=[NSNull null]){
        NSString* type=data[@"diaper_type"];
        if([type isEqualToString:@"green"]){
            green.hidden=NO;
        }else if([type isEqualToString:@"olivine"]){
            yg.hidden=NO;
        }else if([type isEqualToString:@"yellow"]){
            yellow.hidden=NO;
        }else if([type isEqualToString:@"red"]){
            red.hidden=NO;
        }else if([type isEqualToString:@"orange"]){
            orange.hidden=NO;
        }else if([type isEqualToString:@"purple"]){
            purple.hidden=NO;
        }
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect r=_contentView.frame;
    CGRect r1=[[UIApplication sharedApplication] statusBarFrame];
    r.size.height=self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-r1.size.height;
    _contentView.frame=r;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
