
//
//  BluetoothLe.m
//  bleDemo
//
//  Created by wurz on 15/4/8.
//  Copyright (c) 2015年 wurz. All rights reserved.
//

#import "BluetoothLe.h"
#import "Utils.h"
#define BleServicesData                 @"FFF0"

#define BleNotifyCharacteristicsReceive @"FFF1"
#define BleDataCharacteristicsSend      @"FFF2"

#define BleDataLengthMax                120

@interface BluetoothLe()
{
    
    CBCentralManager *_centeralManager;          //蓝牙管理类
    
    NSUInteger  _totalSendGroup;                     //已经发送的包数
    NSUInteger  _hasSendGroup;                   //已经发送的包数
    
}

@end


@implementation BluetoothLe

-(id)initWithDelegate:(id<BluetoothLeDelegate>)delegate
{
    self = [super init];
    if (self != nil) {
        
        _delegate = delegate;
        _centeralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
        _isScanning = NO;    //不是扫描状态
        
    }
    
    return self;
}

//蓝牙单例
+(BluetoothLe *)shareBandConnectionWithDelegate:(id<BluetoothLeDelegate>)delegate
{
    static BluetoothLe *shareBandConnectionInstance = nil;
    if(shareBandConnectionInstance == nil && delegate == nil)
        return nil;
    
    static dispatch_once_t predicate;
    //该函数接收一个dispatch_once用于检查该代码块是否已经被调度,可不用使用@synchronized进行解决同步问题
    dispatch_once(&predicate, ^{
        if (shareBandConnectionInstance == nil) {
            shareBandConnectionInstance = [[self alloc] initWithDelegate:delegate];
        }
    });
    
    return shareBandConnectionInstance;

}

//开始扫描
-(BOOL)startScan
{
    if (_centeralManager.state != CBCentralManagerStatePoweredOn) {
        return NO;
    }
    
    [_centeralManager scanForPeripheralsWithServices:nil options:nil];
    _isScanning = YES;
    return YES;
}

//停止扫描
-(void)stopScan
{
    [_centeralManager stopScan];
    _isScanning = NO;
}

//连接设备
-(void)connect:(CBPeripheral *)peripheral
{
    [_centeralManager connectPeripheral:peripheral options:nil];
}

//断开连接
-(void)disconnect:(CBPeripheral *)peripheral
{
    NSLog(@"send disconnect");
    [_centeralManager cancelPeripheralConnection:peripheral];
}

//写数据
-(void)write:(CBPeripheral *)peripheral value:(NSData *)data
{
    CBService * service = [self getService:BleServicesData fromPeripheral:peripheral];
    CBCharacteristic  * charact = [self getCharacteristic:BleDataCharacteristicsSend fromService:service];
    NSMutableData *temp= [[NSMutableData alloc] initWithCapacity:0];
    
    NSUInteger nGroup = (data.length+BleDataLengthMax-1)/BleDataLengthMax;
    
    _hasSendGroup = 0;
    _totalSendGroup = nGroup;
    
    for (NSUInteger i=0; i<nGroup; i++)
    {
        [temp setLength:0];
        if (i == (nGroup-1)) {
            [temp appendBytes:(data.bytes+i*BleDataLengthMax) length:data.length%BleDataLengthMax ];
        }
        else{
            [temp appendBytes:(data.bytes+i*BleDataLengthMax) length:BleDataLengthMax];
        }
        
        [peripheral writeValue:temp forCharacteristic:charact type:CBCharacteristicWriteWithResponse];
    }
}

//读取rssi
-(void)readRssi:(CBPeripheral *)peripheral
{
    [peripheral readRSSI];
}


//获取服务
-(CBService *)getService:(NSString *)serviceID fromPeripheral:(CBPeripheral *)peripheral
{
    CBUUID *uuid = [CBUUID UUIDWithString:serviceID];
    
    for (NSUInteger i=0; i<peripheral.services.count; i++) {
        CBService *service = [peripheral.services objectAtIndex:i];
        if ([service.UUID isEqual:uuid]) {
            return service;
        }
    }
    
    return nil;
}


//获取特征值
-(CBCharacteristic *)getCharacteristic:(NSString *)characteristicID fromService:(CBService *)service
{
    CBUUID *uuid = [CBUUID UUIDWithString:characteristicID];
    
    for (NSUInteger i=0; i<service.characteristics.count; i++) {
        CBCharacteristic *characteristic = [service.characteristics objectAtIndex:i];
        if ([characteristic.UUID isEqual:uuid]) {
            return characteristic;
        }
    }
    
    return nil;
}

#pragma mark - CBCentralManager代理函数

//本地蓝牙设备状态更新代理
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            _loaclState = BleLocalStatePowerOff;
            NSLog(@"power off");
            break;
        case CBCentralManagerStatePoweredOn:
            _loaclState = BleLocalStatePowerOn;
            break;
        default:
            _loaclState = BleLocalStateUnsupported;
            break;
    }
    if([self.delegate respondsToSelector:@selector(ble:didLocalState:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate ble:self didLocalState:_loaclState];
        });
    }
}

//扫描信息代理
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    NSData *data = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
    //非宏佳产品不返回
    if ( ![@"4C4E54" isEqualToString:[Utils convertDataToHexStr:data length:3]]) {
        return;
    }
    
    if([self.delegate respondsToSelector:@selector(ble:didScan:advertisementData:rssi:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate ble:self didScan:peripheral advertisementData:advertisementData rssi:RSSI];
        });
    }
}

//外围蓝牙设备连接代理
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"HlBluetooth  连接ok");
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

//外围蓝牙设备断开代理
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"centralManager:didDisconnectPeripheral:error:");
    NSLog(@"error = %@",error);
    if([self.delegate respondsToSelector:@selector(ble:didDisconnect:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate ble:self didDisconnect:peripheral];
        });
    }
    
}

//连接外围设备失败代理
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if([self.delegate respondsToSelector:@selector(ble:didConnect:result:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate ble:self didConnect:peripheral result:NO];
        });
    }
}

#pragma mark - CBPeripheral代理函数
//搜索服务
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (!error) {
        int count = (int)peripheral.services.count;
        
        for (int i=0; i<count; i++) {
            CBService *service = [peripheral.services objectAtIndex:i];
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
    
}

//扫描特征值
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (!error) {
//        int count = (int)service.characteristics.count;
//        
//        for(int i=0; i < count; i++) {
//            CBCharacteristic *c = [service.characteristics objectAtIndex:i];
//            if ([c.UUID.UUIDString isEqualToString:BleNotifyCharacteristicsReceive]){
//                NSLog(@"%d",c.isNotifying);
//            }
//        }
        
        CBService *s = [peripheral.services objectAtIndex:(peripheral.services.count-1)];
        if([service.UUID isEqual:s.UUID]) {
            
            //获取HlBleServicesNotify服务
            CBService *ser = [self getService:BleServicesData fromPeripheral:peripheral];
            //获取HlBleNotifyCharacteristicsReceive特征值
            CBCharacteristic *characteristic = [self getCharacteristic:BleNotifyCharacteristicsReceive fromService:ser];
            
            //打开通知
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        
        }

    }
}

//通知状态更改
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (!error) {
        
        if ([characteristic.UUID.UUIDString isEqualToString:BleNotifyCharacteristicsReceive]) {
            
            //通知已打开
            if (characteristic.isNotifying) {
                NSLog(@"通知已打开");
                if([self.delegate respondsToSelector:@selector(ble:didConnect:result:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate ble:self didConnect:peripheral result:YES];
                    });
                }
            }
            else{
                [self disconnect:peripheral];
            }
            
        }
    }
    
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"%@有数据", characteristic.UUID.UUIDString);
    
    if ([characteristic.UUID.UUIDString isEqualToString:BleNotifyCharacteristicsReceive]) {
        if ([self.delegate respondsToSelector:@selector(ble:didReceiveData:data:)]) {
            [self.delegate ble:self didReceiveData:peripheral data:characteristic.value];
        }
    }
    
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (!error) {
        _hasSendGroup++;
        if (_hasSendGroup == _totalSendGroup) {
            if ([self.delegate respondsToSelector:@selector(ble:didWriteData:result:)]) {
                [self.delegate ble:self didWriteData:peripheral result:YES];
            }
        }
    }
    else{
        if ([self.delegate respondsToSelector:@selector(ble:didWriteData:result:)]) {
            [self.delegate ble:self didWriteData:peripheral result:NO];
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
    if (!error) {
        if ([self.delegate respondsToSelector:@selector(ble:didUpdateRssi:rssi:)]) {
            [self.delegate ble:self didUpdateRssi:peripheral rssi:RSSI];
        }
    }
}


@end
