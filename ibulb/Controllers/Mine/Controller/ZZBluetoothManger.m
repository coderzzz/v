//
//  ZZBluetoothManger.m
//  ibulb
//
//  Created by Interest on 16/1/20.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "ZZBluetoothManger.h"
#import "RealName.h"
#import <CoreData/CoreData.h>
#import "CoreData+MagicalRecord.h"
@implementation ZZBluetoothManger
{
    
    NSUInteger currentIndex;
    
   
}

+(id)shareInstance{
    
    
    static dispatch_once_t once;
    
    static ZZBluetoothManger *blue = nil;
    
    dispatch_once(&once, ^{
        
        blue = [[self alloc]init];
        
    });
    
    
    return blue;
    
}

-(id)init{
    
    self = [super init];
    
    if (self) {
        
        _manager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
        
        //持有发现的设备
        _discoverPeripherals = [[NSMutableArray alloc]init];
        
        
        _lightList = [NSMutableArray array];
    }
    
    return self;
}


/**
 *  开始扫描
 */
-(void)startScanWithBlock:(ScanResultBlock)block{
    
    if (self.powerOn) {
    
        [_discoverPeripherals removeAllObjects];
        
        [_manager scanForPeripheralsWithServices:nil options:nil];
        
        double delayInSeconds = 10.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            if (block) block(_lightList);

            [_manager stopScan];
        
        

           });

    }
    
    else{
        
        
    
    }
    
}



/**
 *  连接
 */
-(void)startconnectWithPeripheral:(CBPeripheral *)peripheral block:(ConnectPeripheralResultBlock)resultBlock{
    
    
    [_manager connectPeripheral:peripheral options:nil];
    
    _connectPeripheralResultBlock =[resultBlock copy];
    
    
}



- (void)retrieveConnectWithIdentifier:(NSString *)identifier  block:(RetrieveConnectResultBlock)resultBlock{
    
    NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:identifier];
    
    CBPeripheral *peripheral = [[_manager retrievePeripheralsWithIdentifiers:@[uuid]] firstObject];
    
    if (peripheral) {
    
        [_discoverPeripherals addObject:peripheral];
        
        [self startconnectWithPeripheral:peripheral block:^(BOOL isSuccess, NSError *error, DataModel *model) {
            
            if (resultBlock) {
                
                
                resultBlock(isSuccess,model);
                
            }
        }];
    }
    
}




/**
 *  取消连接
 */
-(void)cancelConnectWithPeripheral:(CBPeripheral *)peripheral{
    
    [_manager cancelPeripheralConnection:peripheral];
    
   
}


/**
 *  向设备写数据
 */
-(void)writeValue:(NSString *)value commandType:(CommandType)commandType model:(DataModel *)model{
    

    
    
    if (model && model.deviceData.count ==15) {
        
        
        [model.deviceData replaceObjectAtIndex:0 withObject:@"57"];
        
        
        if (commandType == CommandType_B11) {
            
            NSArray *ary = [value componentsSeparatedByString:@","];
            
            [model.deviceData replaceObjectAtIndex:11 withObject:ary[0]];
            [model.deviceData replaceObjectAtIndex:12 withObject:ary[1]];
            [model.deviceData replaceObjectAtIndex:13 withObject:ary[2]];
        }
        else{
            
            [model.deviceData replaceObjectAtIndex:commandType withObject:value];
            
        }
        
        
        if (commandType == CommandType_B9 || commandType == CommandType_B10 || commandType == CommandType_B11) {
            
            [model.deviceData replaceObjectAtIndex:4 withObject:@"55"];
            [model.deviceData replaceObjectAtIndex:5 withObject:@"55"];
            [model.deviceData replaceObjectAtIndex:6 withObject:@"55"];
            [model.deviceData replaceObjectAtIndex:7 withObject:@"55"];
            [model.deviceData replaceObjectAtIndex:8 withObject:@"55"];

            
        }
        
        if (commandType == CommandType_B4) {
            
            [model.deviceData replaceObjectAtIndex:5 withObject:@"55"];
            [model.deviceData replaceObjectAtIndex:6 withObject:@"55"];
            [model.deviceData replaceObjectAtIndex:7 withObject:@"55"];
            [model.deviceData replaceObjectAtIndex:8 withObject:@"55"];
        }
        
        if (commandType == CommandType_F1) {
            
            [model.deviceData replaceObjectAtIndex:4 withObject:@"55"];
            [model.deviceData replaceObjectAtIndex:6 withObject:@"55"];
            [model.deviceData replaceObjectAtIndex:7 withObject:@"55"];
            [model.deviceData replaceObjectAtIndex:8 withObject:@"55"];
        }
        
        
        if (commandType == CommandType_F2) {
            
            [model.deviceData replaceObjectAtIndex:5 withObject:@"55"];
            [model.deviceData replaceObjectAtIndex:4 withObject:@"55"];
            [model.deviceData replaceObjectAtIndex:7 withObject:@"55"];
            [model.deviceData replaceObjectAtIndex:8 withObject:@"55"];
        }
        
        if (commandType == CommandType_F3) {
            
            [model.deviceData replaceObjectAtIndex:5 withObject:@"55"];
            [model.deviceData replaceObjectAtIndex:6 withObject:@"55"];
            [model.deviceData replaceObjectAtIndex:4 withObject:@"55"];
            [model.deviceData replaceObjectAtIndex:8 withObject:@"55"];
        }
        
        if (commandType == CommandType_F4) {
            
            [model.deviceData replaceObjectAtIndex:5 withObject:@"55"];
            [model.deviceData replaceObjectAtIndex:6 withObject:@"55"];
            [model.deviceData replaceObjectAtIndex:7 withObject:@"55"];
            [model.deviceData replaceObjectAtIndex:4 withObject:@"55"];
        }
        
        
        [model.deviceData removeLastObject];

        [model.deviceData addObject:[self getNumWithArray:model.deviceData]];
        
        NSString *str = @"";
        
        for (int i=0; i<15; i++) {
            
            str = [str stringByAppendingString:model.deviceData[i]];
            
        }
        
        
        
        NSData* data = [self hexToBytesWith:str];
        
        NSLog(@"data %@",data);
        
        [self writeCharacteristic:model.cbPeripheral characteristic:model.cbCharacteristcs value:data];
        
    }
    
}




#pragma mark CBCentralManagerDelegate

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            
            self.powerOn = NO;
      
            break;
        case CBCentralManagerStateResetting:
            
            self.powerOn = NO;

            break;
        case CBCentralManagerStateUnsupported:
            
            self.powerOn = NO;
        
            break;
        case CBCentralManagerStateUnauthorized:
            
            self.powerOn = NO;
 
            break;
        case CBCentralManagerStatePoweredOff:
            
            self.powerOn = NO;
            
            break;
        case CBCentralManagerStatePoweredOn:
      
            
            self.powerOn = YES;
      
           
            
            break;
        default:
            break;
    }
    
}

//扫描到设备会进入方法
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    
    NSLog(@"扫描到设备 %@",peripheral.name);
    
    [_discoverPeripherals addObject:peripheral];
    
    [self startconnectWithPeripheral:peripheral block:^(BOOL isSuccess, NSError *error, DataModel *model) {
        
        if (isSuccess && model) {
            
            [_lightList addObject:model]; 
        }
        
    }];

}
#pragma mark Peripheral


//连接到Peripherals-失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
   
    if (self.connectPeripheralResultBlock) {
        
        self.connectPeripheralResultBlock(NO,error,nil);
        
    }
}

//Peripherals断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
     NSLog(@"断开设备 %@",peripheral.name);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DidDlePeripheral" object:[peripheral.identifier UUIDString]];
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSArray *saveList = [RealName MR_findAll];
        
        if (saveList.count>0) {
            
            for (RealName *model in saveList) {
                
                if ([peripheral.identifier.UUIDString isEqualToString:model.udid]) {
                    
                    [_manager connectPeripheral:peripheral options:nil];
           
                }
                
            }

            
        }
        
    });
    
//    int index = 333;
//    
//    for (int i = 0; i < _lightList.count; i++) {
//        
//        DataModel *model = _lightList[i];
//        
//        if ([model.cbPeripheral isEqual:peripheral]) {
//            
//            index = i;
//            
//            break;
//        }
//
//    }
//    
//    if (index != 333) {
//        
////        [_lightList removeObjectAtIndex:index];
//        
//        [self startconnectWithPeripheral:peripheral block:^(BOOL isSuccess, NSError *error, DataModel *model) {
//            
//            if (isSuccess && model) {
//                
////                [_lightList addObject:model];
//            }
//            
//        }];
//        
//    }
    

}
//连接到Peripherals-成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
  
    
    [peripheral setDelegate:self];

    [peripheral discoverServices:nil];

}


#pragma mark Services andCharacteristics

//扫描到Services
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{

    if (error)
    {
            return;
    }
    
    for (CBService *service in peripheral.services) {
               [peripheral discoverCharacteristics:nil forService:service];
    }
    
}

//扫描到Characteristics
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{


    for (CBCharacteristic *characteristic in service.characteristics)
    
    {

        Byte dataArr[3];
        
        dataArr[0]=0x82; dataArr[1]=0x03; dataArr[2]=0x85;
        
        
        NSData * myData = [NSData dataWithBytes:dataArr length:3];
        
        [self writeCharacteristic:peripheral characteristic:characteristic value:myData];

    }

}


//获取的charateristic的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{

//    
//    unsigned char data[characteristic.value.length];
//    [characteristic.value getBytes:&data];
    
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",characteristic.value];
    
    if (dataStr.length>10) {
        
         NSLog(@"获取 设备 %@ 的数据 %@ 成功",peripheral.name,dataStr);

        dataStr =[dataStr substringWithRange:NSMakeRange(1, dataStr.length-2)];
        
        NSArray *ary = [dataStr componentsSeparatedByString:@" "];
        
        if (ary.count ==4) {
            
            NSMutableArray *test = [NSMutableArray array];
            
            for (NSString *str in ary) {
                
                
                int i =0;
                
                while (i<=str.length-2) {
                    
                    NSString *temp = [str substringWithRange:NSMakeRange(i, 2)];
                    
                    i = i+2;
                    
                    [test addObject:temp];
                }
                
            }
            
           NSMutableArray *_currentList = [NSMutableArray arrayWithArray:test];
            
            if (_currentList.count>0) {
                
                if (self.connectPeripheralResultBlock) {
                    
                    DataModel *model = [[DataModel alloc]init];
                    
                    model.cbPeripheral = peripheral;
                    
                    model.cbCharacteristcs = characteristic;
                    
                    model.deviceData = _currentList;
                    
                    model.realName  = peripheral.name;
                    
                    model.uuid = peripheral.identifier.UUIDString;
                    
                    self.connectPeripheralResultBlock(YES,nil,model);
                    
                }
                
            }
            
        }
        
    }

}

#pragma mark wirte data

//写数据
-(void)writeCharacteristic:(CBPeripheral *)peripheral
            characteristic:(CBCharacteristic *)characteristic
                     value:(NSData *)value{
    
    
    
    
    if(characteristic.properties & CBCharacteristicPropertyWrite){
        
        
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        
        [peripheral writeValue:value forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];

        
    }else{
        
    }

}

-(NSData*) hexToBytesWith:(NSString *)str{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

- (NSString *)getNumWithArray:(NSMutableArray *)ary{
    
    unsigned long num = 0;
    
    
    
    for (int i = 0; i<ary.count; i++) {
        
        NSString *str = ary[i];
        
        unsigned long num1 = strtoul([str UTF8String],0,16);
        
        num = num + num1;
        
        
        
    }
    NSString *result = [NSString stringWithFormat:@"%0lx",num];
    
    result = [result substringFromIndex:1];
    
    
    
    return result;
}


////搜索到Characteristic的Descriptors
//-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
//    
//    //打印出Characteristic和他的Descriptors
//    //    NSLog(@"characteristic uuid:%@",characteristic.UUID);
//    //    for (CBDescriptor *d in characteristic.descriptors) {
//    //        NSLog(@"Descriptor uuid:%@",d.UUID);
//    //    }
//    
//}
////获取到Descriptors的值
//-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error{
//    //打印出DescriptorsUUID 和value
//    //这个descriptor都是对于characteristic的描述，一般都是字符串，所以这里我们转换成字符串去解析
//    
//    
//    
//    NSLog(@"characteristic uuid:%@  value:%@",[NSString stringWithFormat:@"%@",descriptor.UUID],descriptor.value);
//}
//
////- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
////    if (error==nil) {
////        //调用下面的方法后 会调用到代理的- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
////        [peripheral readValueForCharacteristic:characteristic];
////    }
////}
//
////设置通知
//-(void)notifyCharacteristic:(CBPeripheral *)peripheral
//             characteristic:(CBCharacteristic *)characteristic{
//    //设置通知，数据通知会进入：didUpdateValueForCharacteristic方法
//    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//    
//}
//
//////取消通知
////-(void)cancelNotifyCharacteristic:(CBPeripheral *)peripheral
////                   characteristic:(CBCharacteristic *)characteristic{
////
////    [peripheral setNotifyValue:NO forCharacteristic:characteristic];
////}
//
////停止扫描并断开连接
//-(void)disconnectPeripheral:(CBCentralManager *)centralManager
//                 peripheral:(CBPeripheral *)peripheral{
//    //停止扫描
//    [centralManager stopScan];
//    //断开连接
//    [centralManager cancelPeripheralConnection:peripheral];
//}



@end
