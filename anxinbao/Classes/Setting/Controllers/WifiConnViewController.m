//
//  WifiConnViewController.m
//  anxinbao
//
//  Created by 郭大扬 on 2018/4/6.
//  Copyright © 2018年 郭大扬. All rights reserved.
//

#import "WifiConnViewController.h"
#import "HelpHeaderFile.h"
#import "DeviceItem.h"
#import "Utils.h"
#import "BabyCentralManager.h"
#define BleServicesData                 @"FFF0"
#import "BluetoothLe.h"
#define BleNotifyCharacteristicsReceive @"FFF1"
#define BleDataCharacteristicsSend      @"FFF2"
#import "HJBleScanData.h"

#define BleDataLengthMax                20
@interface WifiConnViewController (){
    CGFloat cellHeight;
    NSString* wifiName;
    bool rememberPwd;
    BluetoothLe *_ble;
    int index;
    int state;
    UITextField* wifi;
    UITextField* pwd;
    UITextField* place;
    boolean_t isScan;
    NSString *sn;
    NSMutableArray* array;
    CBPeripheral* peri;
    Boolean isSuccess;
    NSUInteger  _totalSendGroup;                     //已经发送的包数
    NSUInteger  _hasSendGroup;                   //已经发送的包数
}
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UIView *popup;

@end

@implementation WifiConnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    cellHeight=60;
    self.title=ASLocalizedString(@"网络设置");
    array=[[NSMutableArray alloc] init];
    [self.view  addSubview:self.listView];
    rememberPwd=YES;
    id info=[Utils fetchSSIDInfo];
    wifiName = info[@"SSID"];
    //NSString *str2 = info[@"BSSID"];
    //NSString *str3 = [[ NSString alloc] initWithData:info[@"SSIDDATA"] encoding:NSUTF8StringEncoding];
    // Do any additional setup after loading the view.
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    _ble = [BluetoothLe shareBandConnectionWithDelegate:self];
    _ble.delegate = self;
    if (_ble.loaclState == BleLocalStatePowerOn) {
        [self scanPeri];
    }
    else{
        
    }
    state=0;
}

#pragma mark -- BluetoothLeDegelete
-(void)ble:(BluetoothLe *)ble didLocalState:(BleLocalState)state
{
    if (state != BleLocalStatePowerOn) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self hideLoadingIndicatorView];
        [self stopScan];
        [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"手机蓝牙未开启，请开启手机蓝牙再进行配置操作")];
        //[self.delegate handleBleViewShowMessage:@"蓝牙已关闭"];
    }else{
        [self scanPeri];
    }
    [self.popup.superview removeFromSuperview];
}

-(void)ble:(BluetoothLe *)ble didDisconnect:(CBPeripheral *)peripheral
{
    [self hideLoadingIndicatorView];
    if(!isSuccess){
        [self.popup.superview removeFromSuperview];
    }
    //[[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"手机蓝牙未开启，请开启手机蓝牙再进行配置操作")];
}

-(void)ble:(BluetoothLe *)ble didWriteData:(CBPeripheral *)peripheral result:(BOOL)bResult
{
    if (bResult) {
        NSLog(@"发送成功");
        //[MBProgressHUD showSuccess:@"发送成功" toView:self.view duration:1.0];
    }
    else{
        NSLog(@"发送失败");
        //[MBProgressHUD showError:@"发送失败" toView:self.view duration:1.0];
    }
}

-(void)ble:(BluetoothLe *)ble didReceiveData:(CBPeripheral *)peripheral data:(NSData *)data
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSDate* now = [NSDate date];
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"HH:mm:ss";
    NSString* dateString = [NSString stringWithFormat:@"时间:%@",[fmt stringFromDate:now]];
    [dict setValue:dateString forKey:@"time"];
    [dict setValue:@"接收:" forKey:@"title"];
    //    [dict setValue:[NSString hexToString:data space:NO] forKey:@"context"];
    NSString* s=[NSString utf8ToUnicode:data];
    [dict setValue:s forKey:@"context"];
    if([s isEqualToString:@"AP SET OK"]){
        if(state!=2){
            return;
        }
        state=3;
        [self write:peri value:@"IP=18.136.203.154"];
        //[self hideLoadingIndicatorView];
    }else if([s isEqualToString:@"AP SET failed"]){
        [self hideLoadingIndicatorView];
        [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"Wifi设置失败")];
        [self disconnect:peri];
        //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeout:) object:nil];
    }else if([s isEqualToString:@"IP SET OK!"]){
        [self write:peri value:@"PORT=6058"];
    }
    else if([s isEqualToString:@"SERVER SET OK"]){
        if(state!=3){
            return;
        }
        [self disconnect:peri];;
        isSuccess=true;
        sn=array[index][@"sn"];
        [array removeObjectAtIndex:index];
        [self.listView reloadData];
        
        [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"Wifi设置成功")];
        [self.popup.superview removeFromSuperview];
        [self showPlace];
        state=4;
        //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeout:) object:nil];        //[self showPlace];
    }
    
    NSLog(@"接收到消息：%@", s);

}

-(void)timeout{
    [self hideLoadingIndicatorView];
    [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"Wifi设置失败")];
    [self disconnect:peri];;
    [self showPlace];
    state=4;
}


-(void)updateState:(NSNotification*)data{
    NSDictionary* d= data.object;
    CBCentralManager* central=d[@"central"];
    if(central.state == CBManagerStatePoweredOff){
        [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"手机蓝牙未开启，请开启手机蓝牙再进行配置操作")];
    }
}

-(void)scanIn{
    isScan=true;
    [_ble startScan];
    //[m scanPeripherals];
    //[self performSelector:@selector(stopScan) withObject:nil afterDelay:15];
}
-(void)scanPeri{
    if(isScan){
        return;
    }
    [self scanIn];
    // 开始动画
    //[searchGif startAnimating];
}

-(void)stopScan{
    isScan=false;
    [_ble stopScan];
    //[m cancelScan];
}

-(void)connectFail:(NSNotification*)data{
    [self hideLoadingIndicatorView];
    [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"连接失败")];
}

-(CBCharacteristic*)findCharacteristic:(CBPeripheral*)peri{
    if(peri==nil){
        return nil;
    }
    for(int i=0;i<peri.services.count;++i){
        CBService* c= peri.services[i];
        NSLog(@"%@",c.UUID.UUIDString);
        if([c.UUID.UUIDString isEqualToString:BleServicesData]){
            for(int i=0;i<c.characteristics.count;++i){
                CBCharacteristic* b=c.characteristics[i];
                if([b.UUID.UUIDString isEqualToString:BleDataCharacteristicsSend]){
                    return b;
                }
            }
        }
        
    }
    return nil;
}

-(CBCharacteristic*)findNotifyCharacteristic:(CBPeripheral*)peri{
    if(peri==nil){
        return nil;
    }
    for(int i=0;i<peri.services.count;++i){
        CBService* c= peri.services[i];
        NSLog(@"%@",c.UUID.UUIDString);
        if([c.UUID.UUIDString isEqualToString:BleServicesData]){
            for(int i=0;i<c.characteristics.count;++i){
                CBCharacteristic* b=c.characteristics[i];
                if([b.UUID.UUIDString isEqualToString:BleNotifyCharacteristicsReceive]){
                    return b;
                }
            }
        }
    }
    return nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopScan];
    if(peri==nil){
        return;
    }
    [_ble disconnect:peri];
}

-(int)rssiToLevel:(int)rssi{
    int level=1;
    if(rssi>=-55){
        level=5;
    }else if(rssi>=-67){
        level=4;
    }else if(rssi>=-75){
        level=3;
    }else if(rssi>=-84){
        level=2;
    }
    return level;
}

-(void)disconnect:(CBPeripheral *)peripheral{
    [_ble disconnect:peri];
}
//连接超时
-(void)connectTimeOut:(HJBleScanData *)hjBle
{
    [_ble disconnect:peri];
    [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"连接失败")];
}



-(void)ble:(BluetoothLe *)ble didScan:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData rssi:(NSNumber *)rssi
{
    //没有名字的不显示
    if (peripheral.name == nil || [peripheral.name isEqualToString:@""]){
        return ;
    }
    
    BOOL isAdd = YES;
    for (int i=0; i<array.count; i++) {
        CBPeripheral* peripheral = array[i][@"peri"];
        
        //uuid相同，则更新
        if ([peripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString] ) {
            //return;
        }
    }
    
    
    //添加数据
    if (isAdd) {
        NSData* bytes=advertisementData[@"kCBAdvDataManufacturerData"];
        NSString* sn=[Utils convertDataToHexStr:bytes length:7];
        NSLog(@"%@", sn);
        if(![sn isEqualToString:@"4C4E5432343161"]){//@"010203"]){
            return;
        }
        NSString *mid=[Utils convertDataToHexStr:bytes length:MIN(11,(int)bytes.length)];
        if(mid==nil||advertisementData[@"kCBAdvDataLocalName"]==nil){
            return;
        }
        for(int i=0;i<array.count;++i){
            NSDictionary* d=array[i];
            if([d[@"sn"] isEqualToString:mid]){
                return;
            }
        }
        NSString* s=[[NSString alloc] initWithData:[bytes subdataWithRange:NSMakeRange(0, 7)] encoding:NSUTF8StringEncoding];
        NSString* sid=[Utils convertDataToHexStr:[bytes subdataWithRange:NSMakeRange(7, 4)] length:4];
        NSString* n=[NSString stringWithFormat:@"%@%@",s,sid];
        NSDictionary *scanData = @{@"peri":peripheral,@"name":n,@"sn":mid};//peripheral.name
        
        
        [array addObject:scanData];
    }
    
    [self.listView reloadData];
}

-(void) ble:(BluetoothLe *)ble didConnect:(CBPeripheral *)peripheral result:(BOOL)isSuccess
{
    //取消超时
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectTimeOut:) object:peripheral];

    
    if (!isSuccess) {
        [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"连接失败")];
        [self hideLoadingIndicatorView];
    }
    else{
        [self sendData:@0];

    }
}


//写数据
-(void)write:(CBPeripheral *)peripheral value:(NSString *)s
{
    [_ble write:peripheral value:[NSData unicodeToUtf8:s]];
    return;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)closePopup1{
    [self disconnect:peri];;
    [self hideLoadingIndicatorView];
}

-(void)showPopup{
    UIView* popup=[Utils showPopup];
    UIButton* b=[popup viewWithTag:12];
    [b addTarget:self action:@selector(closePopup1) forControlEvents:UIControlEventTouchUpInside];
    CGRect r=popup.frame;
    r.size.height=180;
    popup.frame=r;
    popup.backgroundColor=[UIColor whiteColor];
    [Utils addLabel:ASLocalizedString(@"请输入Wifi名称") For:popup withFrame:CGRectMake(20, 30, popup.frame.size.width-40, 17) withColor:0x222222 withSize:17];
    UIView* inputbg=[[UIView alloc] initWithFrame:CGRectMake(20, 55, popup.frame.size.width-50, 50)];
    inputbg.backgroundColor=UIColorFromRGB(0xf0f0f0);
    UITextField* t=[[UITextField alloc] initWithFrame:CGRectMake(30, 55, popup.frame.size.width-70, 50)];
    t.returnKeyType=UIReturnKeyDone;
    t.delegate=self;
    wifiName=[[NSUserDefaults standardUserDefaults] objectForKey:@"ssid"];
    if(wifiName!=nil){
        t.text=wifiName;
    }
    t.backgroundColor=nil;
    wifi=t;
    //t.borderStyle=
    [popup addSubview:inputbg];
    [popup addSubview:t];
    UIView* line=[[UIView alloc] initWithFrame:CGRectMake(0, popup.frame.size.height-50, popup.frame.size.width, 1)];
    //[UIButton ]
    line.backgroundColor=UIColorFromRGB(0xd8d8d8);
    [popup addSubview:line];
    UIButton* ok=[UIButton buttonWithType:UIButtonTypeCustom];
    ok.frame=CGRectMake(0, popup.frame.size.height-50+15, popup.frame.size.width, 20);
    [ok setTitle:ASLocalizedString(@"确定")forState:UIControlStateNormal];
    ok.titleLabel.font=[UIFont systemFontOfSize:20.5];
    [ok setTitleColor:ThemeColor forState:UIControlStateNormal];
    [popup addSubview:ok];
    [ok addTarget:self action:@selector(sendWifiName) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //将触摸事件添加到当前view
    [popup.superview addGestureRecognizer:tapGestureRecognizer];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    self.popup=popup;
    state=1;
    //[self connect]
}

-(void)showPlace{
    UIView* popup=[Utils showPopup];
    UIButton* b=[popup viewWithTag:12];
    [b addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
    CGRect r=popup.frame;
    r.size.height=180;
    popup.frame=r;
    popup.backgroundColor=[UIColor whiteColor];
    [Utils addLabel:ASLocalizedString(@"请输入位置") For:popup withFrame:CGRectMake(20, 30, popup.frame.size.width-40, 17) withColor:0x222222 withSize:17];
    UIView* inputbg=[[UIView alloc] initWithFrame:CGRectMake(20, 55, popup.frame.size.width-50, 50)];
    inputbg.backgroundColor=UIColorFromRGB(0xf0f0f0);
    UITextField* t=[[UITextField alloc] initWithFrame:CGRectMake(30, 55, popup.frame.size.width-70, 50)];
    t.returnKeyType=UIReturnKeyDone;
    t.delegate=self;
    t.backgroundColor=nil;
    place=t;
    //t.borderStyle=
    [popup addSubview:inputbg];
    [popup addSubview:t];
    UIView* line=[[UIView alloc] initWithFrame:CGRectMake(0, popup.frame.size.height-50, popup.frame.size.width, 1)];
    //[UIButton ]
    line.backgroundColor=UIColorFromRGB(0xd8d8d8);
    [popup addSubview:line];
    UIButton* ok=[UIButton buttonWithType:UIButtonTypeCustom];
    ok.frame=CGRectMake(0, popup.frame.size.height-50+15, popup.frame.size.width, 20);
    [ok setTitle:ASLocalizedString(@"确定")forState:UIControlStateNormal];
    ok.titleLabel.font=[UIFont systemFontOfSize:20.5];
    [ok setTitleColor:ThemeColor forState:UIControlStateNormal];
    [popup addSubview:ok];
    [ok addTarget:self action:@selector(setPlace) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //将触摸事件添加到当前view
    [popup.superview addGestureRecognizer:tapGestureRecognizer];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    self.popup=popup;
    //[self connect]
}

-(void)showPwd{
    UIView* popup=[Utils showPopup];
    CGRect r=popup.frame;
    r.size.height=200;
    popup.frame=r;
    popup.backgroundColor=[UIColor whiteColor];
    UIButton* b=[popup viewWithTag:12];
    [b addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
    [Utils addLabel:ASLocalizedString(@"请输入Wifi密码") For:popup withFrame:CGRectMake(20, 30, popup.frame.size.width-40, 17) withColor:0x222222 withSize:17];
    UIView* inputbg=[[UIView alloc] initWithFrame:CGRectMake(20, 55, popup.frame.size.width-50, 50)];
    inputbg.backgroundColor=UIColorFromRGB(0xf0f0f0);
    UITextField* t=[[UITextField alloc] initWithFrame:CGRectMake(30, 55, popup.frame.size.width-70, 50)];
    [t setSecureTextEntry:YES];
    t.returnKeyType=UIReturnKeyDefault;
    t.delegate=self;
    t.backgroundColor=nil;
    NSString *pwd=[[NSUserDefaults standardUserDefaults] objectForKey:wifiName];
    if(pwd!=nil){
        t.text=pwd;
    }
    //t.borderStyle=
    [popup addSubview:inputbg];
    [popup addSubview:t];
    UIView* line=[[UIView alloc] initWithFrame:CGRectMake(0, popup.frame.size.height-50, popup.frame.size.width, 1)];
    //[UIButton ]
    UIButton* check=[Utils addButton:@"" For:popup withFrame:CGRectMake(20, 125, 15, 15) withImage:@"checkboxs" withDefineColor:ThemeColor withSize:10];
    check.tag=23;
    //[Utils addImage:<#(NSString *)#> For:<#(UIView *)#> withFrame:<#(CGRect)#>]
    //[Utils addButton:@"" For:popup withFrame:CGRectMake(20, 125, 120, 15) withImage:@"" withDefineColor:<#(UIColor *)#> withSize:<#(CGFloat)#>]
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(20, 120, 120, 24);
    [btn addTarget:self action:@selector(checkPwd:) forControlEvents:UIControlEventTouchUpInside];
    [popup addSubview:btn];
    [Utils addLabel:ASLocalizedString(@"记住密码")For:popup withFrame:CGRectMake(40, 125, 200, 15) withColor:0x999999 withSize:14];
    line.backgroundColor=UIColorFromRGB(0xd8d8d8);
    [popup addSubview:line];
    UIButton* ok=[UIButton buttonWithType:UIButtonTypeCustom];
    ok.frame=CGRectMake(0, popup.frame.size.height-50+15, popup.frame.size.width, 20);
    [ok setTitle:ASLocalizedString(@"立即连接")forState:UIControlStateNormal];
    ok.titleLabel.font=[UIFont systemFontOfSize:20.5];
    [ok setTitleColor:ThemeColor forState:UIControlStateNormal];
    [popup addSubview:ok];
    [ok addTarget:self action:@selector(connect) forControlEvents:UIControlEventTouchUpInside];
    self.password=t;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //将触摸事件添加到当前view
    [popup.superview addGestureRecognizer:tapGestureRecognizer];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    self.popup=popup;
    state=2;
    //[self connect]
}

-(void)checkPwd:(UIButton*)btn{
    UIButton* c=(UIButton*)[btn.superview viewWithTag:23];
    rememberPwd=!rememberPwd;
    if(rememberPwd){
        [c setImage:[UIImage imageNamed:@"checkboxs"] forState:UIControlStateNormal];
    }else{
        [c setImage:[UIImage imageNamed:@"unchecks"] forState:UIControlStateNormal];
    }
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [wifi resignFirstResponder];
    [place resignFirstResponder];
    [self.password resignFirstResponder];
}

-(void)sendWifiName{
    if(wifi.text.length==0){
        return;
    }
    wifiName=wifi.text;
    [[NSUserDefaults standardUserDefaults] setObject:wifi.text forKey:@"ssid"];
    [wifi resignFirstResponder];
    [self.popup.superview removeFromSuperview];
    [self write:peri value:[NSString stringWithFormat:@"SD=%@", wifi.text]];
    [self showPwd];
}

-(void)connect{
    if(self.password.text.length==0){
        return;
    }
    if(rememberPwd){
        [[NSUserDefaults standardUserDefaults] setObject:self.password.text forKey:wifiName];
    }
    [self.password resignFirstResponder];
    [self.popup.superview removeFromSuperview];
    [self write:peri value:[NSString stringWithFormat:@"SC=%@", self.password.text]];
    [self showLoadingIndicatorView];
    //[self performSelector:@selector(timeout) withObject:nil afterDelay:10];
}

-(void)setPlace{
    if(place.text.length==0){
        return;
    }
    [place resignFirstResponder];
    [self.popup.superview removeFromSuperview];
    [self setPlaceIn];
}

-(void)setPlaceIn{
    [self showLoadingIndicatorView];
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    params[@"place"]=place.text;
    params[@"device_gateway"]=sn;
    [self.appDel getData:@"device_place" param:params callback:^(NSDictionary* dict){
        [self hideLoadingIndicatorView];
        if(dict==nil){
            return;
        }
        int i=[[dict objectForKey:@"code"] intValue];
        if(i==1){
            [[ZFToast shareClient] popUpToastWithMessage:ASLocalizedString(@"位置设置成功")];
        }else if(i==11){
        }else if(i==10){
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [wifi resignFirstResponder];
    [place resignFirstResponder];
    [self.password resignFirstResponder];
    return YES;
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
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reUseID = @"contentCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reUseID];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reUseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        DeviceItem* r=[[DeviceItem alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 60)];
        CGRect rect=r.frame;
        rect.size.width=MainScreenWidth;
        r.frame=rect;
        r.tag=12;
        [cell addSubview:r];
        [cell layoutIfNeeded];
    }
    DeviceItem *r = (DeviceItem *)[cell viewWithTag:12];
    NSDictionary* d=array[indexPath.row];
    NSString* sn=d[@"name"];
    [r.title setText:sn];//[NSString stringWithFormat:@"eDiaper Scanner %@",[sn substringFromIndex:14]]];
    
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

-(void)sendData:(NSNumber*)i{
    NSArray *datas=@[@"CLOSE ALL CONNECTS", @"DEL AP INFO", @"DEL SERVER INFO"];
    //[self showLoadingIndicatorView];
    [self write:peri value:datas[[i integerValue]]];
    int l=[i intValue]+1;
    if(l==datas.count){
        [self hideLoadingIndicatorView];
        [self showPopup];
        return;
    }
    [self performSelector:@selector(sendData:) withObject:[NSNumber numberWithInt:l] afterDelay:0.2f];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    index=(int)indexPath.row;
    peri=array[index][@"peri"];
    [self showLoadingIndicatorView];
    [_ble connect:peri];
    isSuccess=false;
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
