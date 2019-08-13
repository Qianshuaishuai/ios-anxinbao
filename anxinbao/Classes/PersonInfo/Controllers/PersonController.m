//
//  PersonController.m
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/3.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonController.h"
#import "HelpHeaderFile.h"
#import "BaseInfoController.h"
#import "SquareViewController.h"
#import "RecommendViewController.h"
#import "Utils.h"
#import <UIImageView+WebCache.h>
#import "BabyCentralManager.h"
#import "ZFToast.h"

#define slide_width 26
#define popup_width 317

@interface PersonController ()
{
    BaseInfoController *infoVC;
    SquareViewController *sqareVC;
    RecommendViewController *recommendVC;
    UIScrollView *mainScrollView;
    UIView *navView;
    UIImageView *sliderLabel;
    UIButton *nearbyBtn;
    UIButton *squareBtn;
    UIButton *recommendBtn;
    UILabel* identifier;
    UILabel* room_num, *bed_num, *elec;
    UIImageView* sex;
    UIImageView* avatar, *battery;
    BabyCentralManager* cb;
    bool isScan;
    int count;
    NSString* sn;
    boolean_t isBluetooth;
}
@property (nonatomic, strong) UIButton *setting;
@property (nonatomic , assign) NSInteger currentIndex;

@end

@implementation PersonController

-(BaseInfoController *)infoVC{
    if (infoVC==nil) {
        infoVC = [[BaseInfoController alloc]init];
        infoVC.pid=self.pid;
        infoVC.navigationController = self.navigationController;
    }
    return infoVC;
}
-(SquareViewController *)sqareVC{
    if (sqareVC==nil) {
        sqareVC = [[SquareViewController alloc]init];
        sqareVC.pid=_pid;
        sqareVC.navigationController = self.navigationController;
        
    }
    return sqareVC;
}
-(RecommendViewController *)recommendVC{
    if (recommendVC==nil) {
        recommendVC = [[RecommendViewController alloc]init];
        recommendVC.pid=self.pid;
        recommendVC.navigationController = self.navigationController;
    }
    return recommendVC;
}
-(void)initUI{
    count=([self.appDel.userType isEqualToString:@"nurse"]||[self.appDel.userType isEqualToString:@"family"])?2:3;
    navView = [[UIView alloc]initWithFrame:CGRectMake(0, 125, MainScreenWidth, 52)];
    nearbyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nearbyBtn setTitleColor:ThemeColor forState:UIControlStateSelected];
    [nearbyBtn setTitleColor:RGBACOLOR(164, 174, 174, 1) forState:UIControlStateNormal];
    
    nearbyBtn.frame = CGRectMake(0, 0, MainScreenWidth/count, 45);
    nearbyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [nearbyBtn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [nearbyBtn setTitle:ASLocalizedString(@"基本信息")forState:UIControlStateNormal];
    nearbyBtn.tag = 1;
    nearbyBtn.selected = YES;
    [navView addSubview:nearbyBtn];
    
    squareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    squareBtn.frame = CGRectMake(nearbyBtn.frame.origin.x+nearbyBtn.frame.size.width, nearbyBtn.frame.origin.y, MainScreenWidth/count, 45);
    [squareBtn setTitleColor:ThemeColor forState:UIControlStateSelected];
    [squareBtn setTitleColor:RGBACOLOR(164, 174, 174, 1) forState:UIControlStateNormal];
    
    squareBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [squareBtn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [squareBtn setTitle:ASLocalizedString(@"记录")forState:UIControlStateNormal];
    squareBtn.tag = 2;
    [navView addSubview:squareBtn];
    
    
    recommendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recommendBtn.frame = CGRectMake(squareBtn.frame.origin.x+squareBtn.frame.size.width, squareBtn.frame.origin.y, MainScreenWidth/count, nearbyBtn.frame.size.height);
    [recommendBtn setTitleColor:RGBACOLOR(164, 174, 174, 1) forState:UIControlStateNormal];
    [recommendBtn setTitleColor:ThemeColor forState:UIControlStateSelected];
    
    recommendBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [recommendBtn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [recommendBtn setTitle:ASLocalizedString(@"统计")forState:UIControlStateNormal];
    recommendBtn.tag = 3;
    [navView addSubview:recommendBtn];
    
    sliderLabel = [[UIImageView alloc]initWithFrame:CGRectMake((MainScreenWidth/3-count-slide_width)/2, 42, slide_width, 2.5)];
    [sliderLabel setImage:[UIImage imageNamed:@"underline"]];
    [navView addSubview:sliderLabel];
    
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.backgroundColor = [UIColorFromRGB(0xeeeeee) CGColor];
    CGFloat borderSize = 1.0;
    //指定邊線位置在view的下方
    bottomLayer.frame = CGRectMake(0, CGRectGetMaxY(navView.bounds)-1, navView.bounds.size.width, borderSize);
    [navView.layer addSublayer:bottomLayer];    //self.navigationItem.titleView = navView;
    
    [self.view addSubview:navView];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    cb=[[BabyCentralManager alloc] init];
    [center addObserver:self selector:@selector(poweron:) name:BabyNotificationAtCentralManagerEnable object:nil];
    [center addObserver:self selector:@selector(findBluetooth:) name:BabyNotificationAtDidDiscoverPeripheral object:nil];
    [center addObserver:self selector:@selector(updateState:) name:BabyNotificationAtCentralManagerDidUpdateState object:nil];
    [self.infoVC setData:nil isOnline:0];
}

-(void)poweron:(NSNotification*)data{
    //[self scanPeri];
}

-(void)findBluetooth:(NSNotification *)data{
    NSDictionary* d= data.object;
    NSDictionary* advertisementData=d[@"advertisementData"];
    NSData* byteData=advertisementData[@"kCBAdvDataManufacturerData"];
    Byte* testByte = (Byte *)[byteData bytes];
    if(byteData.length!=16||[advertisementData[@"kCBAdvDataIsConnectable"] intValue]!=0||testByte[0]!=0x4c||testByte[1]!=0x4e||testByte[2]!=0x54){
        return;
    }
    sn=[Utils convertDataToHexStr:byteData length:6];
    if(isScan){
        [self bind:false];
    }
}

-(void)updateState:(NSNotification*)data{
    NSDictionary* d= data.object;
    CBCentralManager* central=d[@"central"];
    if(central.state == CBManagerStatePoweredOff){
        isBluetooth=FALSE;
    }else if(central.state == CBManagerStatePoweredOn){
        isBluetooth=true;
    }
}

-(void)bind:(boolean_t)isForce{
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    params[@"people_id"]=_pid;
    params[@"device_imei"]=sn;
    [cb cancelScan];
    isScan=false;
    if(isForce){
        params[@"is_must_bind"]=@"1";
    }
    [self.appDel getData:@"bind_data_sensor" param:params callback:^(NSDictionary* dict){
        if(dict==nil){
            return;
        }
        int i=[[dict objectForKey:@"code"] intValue];
        if(i==1){
            [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"绑定成功")];
        }else if(i==10){
            [self.navigationController popViewControllerAnimated:YES];
        }else if(i==50){
            [self showPopup];
        }
    }];
}

-(void)setMainSrollView{
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 177, MainScreenWidth, self.view.frame.size.height-177)];
    mainScrollView.delegate = self;
    mainScrollView.pagingEnabled = YES;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainScrollView];
    
    NSArray *views = @[self.infoVC.view,self.sqareVC.view,self.recommendVC.view];
    for (NSInteger i = 0; i<count; i++) {
        //把三个vc的view依次贴到mainScrollView上面
        UIView *pageView = [[UIView alloc]initWithFrame:CGRectMake(MainScreenWidth*i, 0, mainScrollView.frame.size.width, mainScrollView.frame.size.height)];
        [pageView addSubview:views[i]];
        UIView* view=views[i];
        CGRect f=view.frame;
        f.size.height=pageView.frame.size.height;
        view.frame=f;
        [mainScrollView addSubview:pageView];
    }
    mainScrollView.contentSize = CGSizeMake(MainScreenWidth*(count), 0);
    //滚动到_currentIndex对应的tab
    [mainScrollView setContentOffset:CGPointMake((mainScrollView.frame.size.width)*_currentIndex, 0) animated:YES];
    NSArray *gestureArray = self.navigationController.view.gestureRecognizers;
    
    for (UIGestureRecognizer *gestureRecognizer in gestureArray) {
        if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            [mainScrollView.panGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
        }
    }
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
            NSDictionary* people=[data objectForKey:@"people"];
            NSDictionary* detail=[data objectForKey:@"detail"];
            NSString* name=people[@"name"];
            NSString* savatar=people[@"avatar"];
            NSString* ssex=people[@"sex"];
            self.navigationItem.title = name;
            [avatar sd_setImageWithURL:[NSURL URLWithString:savatar] placeholderImage:[UIImage imageNamed:@"avatarBig"] options:SDWebImageHighPriority];
            identifier.text=people[@"identifier"];
            room_num.text=people[@"room_num"];
            bed_num.text=people[@"bed_num"];
            int is_bind=[people[@"is_bind"] intValue];
            if(is_bind==0){
                [self.setting setImage:[UIImage imageNamed:@"unbind"] forState:UIControlStateNormal];
            }else{
                [self.setting setImage:[UIImage imageNamed:@"bind"] forState:UIControlStateNormal];
            }
            
            if(detail[@"electricity"]!=[NSNull null]){
                //elec.text=[NSString stringWithFormat:@"%ld", [detail[@"electricity"] longValue]];
            }
            if([ssex isEqualToString:@"M"]){
                [sex setImage:[UIImage imageNamed:@"sexboy"]];
            }else{
                [sex setImage:[UIImage imageNamed:@"sexgirl"]];
            }
            int isOnline=[data[@"is_online"] intValue];
            bool isLowBattery=isOnline==1&&[detail[@"is_lower_electricity"] intValue]>0;
            if(isLowBattery){
                battery.hidden=NO;
            }else{
                battery.hidden=YES;
            }
            [self.infoVC setData:detail isOnline:isOnline];
        }else if(i==10){
            [self.infoVC stopTimer];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.infoVC stopTimer];
    [self.setting removeFromSuperview];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.setting];
    [self.infoVC startTimer];
}

-(void)closePopup{
    UIWindow *window = [UIApplication sharedApplication].windows[0];//[UIWindow alloc] initWithFrame:(CGRect) {{0.f, 0.f}, [[UIScreen mainScreen] bounds].size}];
    UIView* v = [window viewWithTag:20];
    [v removeFromSuperview];
}

-(void)showPopup{
    NSString* title=ASLocalizedString(@"温馨提示");
    NSString* text=ASLocalizedString(@"该传感器已经被使用中，是否继续绑定操作？");
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
    UILabel* t=[Utils addLabelCenter:text For:popup withFrame:CGRectMake(20, 60, popup_width-40, 40) withColor:0x555555 withSize:15];
    t.numberOfLines=0;
    t.lineBreakMode=NSLineBreakByWordWrapping;
    UIView* line=[[UIView alloc] initWithFrame:CGRectMake(0, popup.frame.size.height-50, popup.frame.size.width, 1)];
    line.backgroundColor=UIColorFromRGB(0xd8d8d8);
    [popup addSubview:line];
    UIButton* ok=[UIButton buttonWithType:UIButtonTypeCustom];
    ok.frame=CGRectMake(0, popup.frame.size.height-50+15, popup_width/2, 20);
    [ok setTitle:ASLocalizedString(@"继续")forState:UIControlStateNormal];
    ok.titleLabel.font=[UIFont systemFontOfSize:20.5];
    [ok setTitleColor:ThemeColor forState:UIControlStateNormal];
    [popup addSubview:ok];
    UIButton* cancel=[UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame=CGRectMake(popup_width/2, popup.frame.size.height-50+15, popup_width/2, 20);
    [cancel setTitle:ASLocalizedString(@"取消")forState:UIControlStateNormal];
    cancel.titleLabel.font=[UIFont systemFontOfSize:20.5];
    [cancel setTitleColor:ThemeColor forState:UIControlStateNormal];
    [popup addSubview:cancel];
    UIView *line1=[[UIView alloc] initWithFrame:CGRectMake(popup_width/2,popup.frame.size.height-50,1,50)];
    line1.backgroundColor=UIColorFromRGB(0xdddddd);
    [popup addSubview:line1];
    UIButton* b=[UIButton buttonWithType:UIButtonTypeCustom];
    b.frame=CGRectMake(x+popup_width-41, y-20-41, 41, 41);
    [b setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:b];
    //objc_setAssociatedObject(b, @"myBtn", block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [ok addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [cancel addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
}

-(void)confirm{
    [self bind:true];
    [self closePopup];
}

-(UIButton *)buttonWithTag:(NSInteger )tag{
    if (tag==1) {
        return nearbyBtn;
    }else if (tag==2){
        return squareBtn;
    }else if (tag==3){
        return recommendBtn;
    }else{
        return nil;
    }
}
-(void)sliderAction:(UIButton *)sender{
    if (self.currentIndex==sender.tag) {
        return;
    }
    [self sliderAnimationWithTag:sender.tag];
    [UIView animateWithDuration:0.3 animations:^{
        mainScrollView.contentOffset = CGPointMake(MainScreenWidth*(sender.tag-1), 0);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)sliderAnimationWithTag:(NSInteger)tag{
    self.currentIndex = tag;
    nearbyBtn.selected = NO;
    squareBtn.selected = NO;
    recommendBtn.selected = NO;
    UIButton *sender = [self buttonWithTag:tag];
    sender.selected = YES;
    //动画
    [UIView animateWithDuration:0.3 animations:^{
        sliderLabel.frame = CGRectMake(sender.frame.origin.x-(slide_width-MainScreenWidth/count)/2, sliderLabel.frame.origin.y, sliderLabel.frame.size.width, sliderLabel.frame.size.height);
        
    } completion:^(BOOL finished) {
        nearbyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        squareBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        recommendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        sender.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }];
}
-(void)sliderWithTag:(NSInteger)tag{
    self.currentIndex = tag;
    nearbyBtn.selected = NO;
    squareBtn.selected = NO;
    recommendBtn.selected = NO;
    UIButton *sender = [self buttonWithTag:tag];
    sender.selected = YES;
    //动画
    sliderLabel.frame = CGRectMake(sender.frame.origin.x-(slide_width-MainScreenWidth/count)/2, sliderLabel.frame.origin.y, sliderLabel.frame.size.width, sliderLabel.frame.size.height);
    nearbyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    squareBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    recommendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:16];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //实时计算当前位置,实现和titleView上的按钮的联动
    CGFloat contentOffSetX = scrollView.contentOffset.x;
    CGFloat X = contentOffSetX/count;// * (3*MainScreenWidth/3)/MainScreenWidth/3;
    CGRect frame = sliderLabel.frame;
    frame.origin.x = X+((MainScreenWidth/count)-slide_width)/2;
    sliderLabel.frame = frame;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat contentOffSetX = scrollView.contentOffset.x;
    int index_ = contentOffSetX/MainScreenWidth;
    [self sliderWithTag:index_+1];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getData];
    self.navigationItem.title = @"";
    UIButton *setting = [UIButton buttonWithType:UIButtonTypeCustom];
    setting.frame = CGRectMake(MainScreenWidth-42, 12, 22, 22);
    //[setting setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    self.setting=setting;
    [setting addTarget:self action:@selector(goSetting) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* header=[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 125)];
    header.backgroundColor=UIColorFromRGB(0x2facae);
    avatar=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatarBig"]];
    avatar.frame=CGRectMake(35, 29, 74, 74);
    avatar.layer.cornerRadius=37;
    avatar.contentMode=UIViewContentModeScaleAspectFill;
    avatar.clipsToBounds=YES;
    [header addSubview:avatar];
    [self.view addSubview:header];
    UILabel* numberTitle=[[UILabel alloc] initWithFrame:CGRectMake(149, 23, 100, 30)];
    numberTitle.textColor=UIColorFromRGB(0xadd8d9);
    numberTitle.font=[UIFont systemFontOfSize:15];
    numberTitle.text=ASLocalizedString(@"编号");
    UILabel* roomTitle=[[UILabel alloc] initWithFrame:CGRectMake(149, 51, 100, 30)];
    roomTitle.textColor=UIColorFromRGB(0xadd8d9);
    roomTitle.font=[UIFont systemFontOfSize:15];
    roomTitle.text=ASLocalizedString(@"房间");
    UILabel* bedTitle=[[UILabel alloc] initWithFrame:CGRectMake(149, 79, 100, 30)];
    bedTitle.textColor=UIColorFromRGB(0xadd8d9);
    bedTitle.font=[UIFont systemFontOfSize:15];
    bedTitle.text=ASLocalizedString(@"床位");
    [header addSubview:numberTitle];
    [header addSubview:roomTitle];
    [header addSubview:bedTitle];
    identifier=[Utils addLabel:@"" For:header withFrame:CGRectMake(195, 23, 100, 30) withColor:0xffffff withSize:15];
    room_num=[Utils addLabel:@"" For:header withFrame:CGRectMake(195, 51, 100, 30) withColor:0xffffff withSize:15];
    bed_num=[Utils addLabel:@"" For:header withFrame:CGRectMake(195, 79, 100, 30) withColor:0xffffff withSize:15];
    /*elec=[Utils addLabel:@"" For:header withFrame:CGRectMake(MainScreenWidth-110, 40, 100, 30) withColor:0xffffff withSize:30];
    elec.textAlignment=NSTextAlignmentCenter;
    UILabel* l1=[Utils addLabel:ASLocalizedString(@"感应器电量")For:header withFrame:CGRectMake(MainScreenWidth-110, 75, 100, 15) withColor:0xadd8d9 withSize:15];
    l1.textAlignment=NSTextAlignmentCenter;*/
    
    UIImage* img=[UIImage imageNamed:@"battery"];
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth-80, 60, 50, 50)];
    [header addSubview:imgView];
    imgView.image=img;
    imgView.hidden=YES;
    battery=imgView;
    sex=[Utils addImage:@"sexgirl" For:header withFrame:CGRectMake(91, 78, 22, 22)];
    
    [self initUI];
    [self setMainSrollView];
    //设置默认
    [self sliderWithTag:self.currentIndex+1];
}

-(void)goSetting{
    if(!isBluetooth){
        [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"手机蓝牙未开启，请开启手机蓝牙再进行配置操作")];
        return;
    }
    if(isScan){
        return;
    }
    isScan=true;
    [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"开始扫描，请耐心等待……")];
    [cb scanPeripherals];
    [self performSelector:@selector(stopScan) withObject:nil afterDelay:15];
}

-(void)stopScan{
    isScan=false;
    [cb cancelScan];
    [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"没有发现蓝牙信号")];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
