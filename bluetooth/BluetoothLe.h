//
//  BluetoothLe.h
//  bleDemo
//
//  Created by wurz on 15/4/8.
//  Copyright (c) 2015年 wurz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "NSString+Hex.h"
#import "NSData+String.h"

typedef NS_ENUM(NSInteger, BleLocalState) {
    BleLocalStatePowerOff,         //本地蓝牙已关闭
    BleLocalStatePowerOn,          //本地蓝牙已开启
    BleLocalStateUnsupported,     //本地不支持蓝牙
};

@class BluetoothLe;

@protocol BluetoothLeDelegate <NSObject>
@optional

//本地状态;调用shareBandConnectionWithDelegate：之后，仅在本地状态为开启时，其他函数方可使用
-(void)ble:(BluetoothLe *)ble didLocalState:(BleLocalState)state;

//扫描的回调函数
-(void)ble:(BluetoothLe *)ble didScan:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData rssi:(NSNumber *)rssi;

//连接回调
-(void)ble:(BluetoothLe *)ble didConnect:(CBPeripheral *)peripheral result:(BOOL)isSuccess;

//断开回调
-(void)ble:(BluetoothLe *)ble didDisconnect:(CBPeripheral *)peripheral;

//写数据回调
-(void)ble:(BluetoothLe *)ble didWriteData:(CBPeripheral *)peripheral result:(BOOL)bResult;

//蓝牙接收数据回调
-(void)ble:(BluetoothLe *)ble didReceiveData:(CBPeripheral *)peripheral data:(NSData *)data;

//rssi更新
-(void)ble:(BluetoothLe *)ble didUpdateRssi:(CBPeripheral *)peripheral rssi:(NSNumber *)rssi;

@end

@interface BluetoothLe : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

//蓝牙代理
@property (nonatomic, weak) id<BluetoothLeDelegate>delegate;

@property (readonly) BOOL isScanning;//是否正在扫描

@property(readonly) BleLocalState loaclState; //蓝牙本地状态

//蓝牙单例
+(BluetoothLe *)shareBandConnectionWithDelegate:(id<BluetoothLeDelegate>)delegate;

//开始扫描
-(BOOL)startScan;

//停止扫描
-(void)stopScan;

//连接设备
-(void)connect:(CBPeripheral *)peripheral;

//断开连接
-(void)disconnect:(CBPeripheral *)peripheral;

//写数据
-(void)write:(CBPeripheral *)peripheral value:(NSData *)data;

//读取rssi
-(void)readRssi:(CBPeripheral *)peripheral;


@end
