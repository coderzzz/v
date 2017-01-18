//
//  ZZBluetoothManger.h
//  ibulb
//
//  Created by Interest on 16/1/20.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "DataModel.h"
typedef enum _CommandType{
    
    CommandType_B3= 3,
    CommandType_B4= 4,
    CommandType_F1= 5,
    CommandType_F2= 6,
    CommandType_F3= 7,
    CommandType_F4= 8,
    CommandType_B9= 9,
    CommandType_B10= 10,
    CommandType_B11= 11,
    CommandType_B12= 12,
    CommandType_B13= 13,
    
}CommandType;

typedef void (^ScanResultBlock)(NSMutableArray *ary);

typedef void (^ConnectPeripheralResultBlock)(BOOL isSuccess,NSError *error,DataModel *model);

typedef void (^RetrieveConnectResultBlock)(BOOL isSuccess,DataModel *model);

@interface ZZBluetoothManger : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>


@property (nonatomic,strong) CBCentralManager *manager;

@property (nonatomic,assign) BOOL  powerOn;

@property (strong,nonatomic) NSMutableArray *discoverPeripherals;

@property (strong,nonatomic) NSMutableArray *lightList;

@property (nonatomic, copy) ConnectPeripheralResultBlock connectPeripheralResultBlock;

@property (nonatomic, copy) RetrieveConnectResultBlock retrieveConnectResultBlock;

+(id)shareInstance;


/**
 *  开始扫描
 */
-(void)startScanWithBlock:(ScanResultBlock)block;

/**
 *  连接
 */
-(void)startconnectWithPeripheral:(CBPeripheral *)peripheral block:(ConnectPeripheralResultBlock)resultBlock;

/**
 *  取消连接
 */
-(void)cancelConnectWithPeripheral:(CBPeripheral *)peripheral;


- (void)retrieveConnectWithIdentifier:(NSString *)identifier  block:(RetrieveConnectResultBlock)resultBlock;

/**
 *  向设备写数据
 */
-(void)writeValue:(NSString *)value commandType:(CommandType)commandType model:(DataModel *)model;


@end
