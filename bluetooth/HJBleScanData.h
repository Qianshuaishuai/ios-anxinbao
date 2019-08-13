//
//  HJBle.h
//  bleDemo
//
//  Created by wurz on 15/4/14.
//  Copyright (c) 2015年 wurz. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface HJBleScanData : NSObject

@property(nonatomic,strong) CBPeripheral *peripheral;
@property(nonatomic,strong) NSDictionary *advertisementData;
@property(nonatomic,strong) NSNumber    *RSSI;


@end
