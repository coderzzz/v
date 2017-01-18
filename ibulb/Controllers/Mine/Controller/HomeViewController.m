//
//  HomeViewController.m
//  ibulb
//
//  Created by Interest on 16/1/7.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "HomeViewController.h"
#import "ZZBluetoothManger.h"
#import "RealName.h"
#import <CoreData/CoreData.h>
#import "CoreData+MagicalRecord.h"
#import "TopBtnCell.h"
//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
@interface HomeViewController ()<PaletteDelegate>
{
    
//    CBCentralManager *manager;
//    
//
//    NSMutableArray *discoverPeripherals;
//    
//    CBPeripheral *currentPeripheral;
//    
//    CBCharacteristic *currentCharacteristic;
    
    NSMutableArray *buttonArray;
//    
//    NSMutableData  *currentData;
//    
//    NSMutableArray *currentList;
    
    int     selectIndex;
    
    int     lastValue;

    
    NSMutableArray *deviceList;
    
    ZZCircularSlider *slidertop;
    
    ZZCircularSlider *sliderbuttom;
    
    Palette  *palette;
}
@property (nonatomic, strong) NSMutableArray *dataSource;


@end

@implementation HomeViewController


#pragma mark viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    deviceList = [NSMutableArray array];

    selectIndex = 0;
    buttonArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeName:) name:@"DidChangeNameNotifi" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addPeripheral:) name:@"DidAddNotifi" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deletePeripheral:) name:@"DidDelNotifi" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(disConnectPeripheral:) name:@"DidDlePeripheral" object:nil];
    
    [self setUpUi];
    
    
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
        NSArray *saveList = [RealName MR_findAll];
        
        if (saveList.count>0) {
         
            for (RealName *model in saveList) {
                
                DataModel *data = [[DataModel alloc]init];
                
                data.uuid = model.udid;
                
                data.realName = model.name;
                
                [self.dataSource addObject:data];
                
            }
            
            [self.collectionview reloadData];
            
            [self parseData];
            
        }
        
    });

}

- (void)parseData{
    
    NSMutableArray *ary = self.dataSource;
    
    for (DataModel *data in ary) {
        
        [[ZZBluetoothManger shareInstance]retrieveConnectWithIdentifier:data.uuid  block:^(BOOL isSuccess, DataModel *model) {
            
            if (isSuccess) {
                
//                [deviceList addObject:model];
                
                for (DataModel *temp in self.dataSource) {
                    
                    if ([temp.uuid isEqualToString:model.uuid]) {
                        
                        temp.cbPeripheral = model.cbPeripheral;
                        
                        temp.cbCharacteristcs = model.cbCharacteristcs;
                        
                        temp.deviceData = model.deviceData;
                    }
                    
                }

                [self updateUiWihtModel:self.dataSource[selectIndex]];

                self.allbtn.selected = self.lightOnbtn.selected;
                
            }
        }];
    }
    
}


- (void)changeName:(NSNotification *)notifi{
    
    RealName *model = notifi.object;
 
    for (DataModel *data in self.dataSource) {
        
        if ([data.uuid isEqualToString:model.udid]) {
            
            data.realName = model.name;
            
            [self.collectionview reloadData];
        }
        
    }
    
    
}
- (void)addPeripheral:(NSNotification *)notifi{
    
    DataModel *model = notifi.object;
    
    if (model) {
        
        [self.dataSource addObject:model];
        
        if (selectIndex<self.dataSource.count) {
            
            [self updateUiWihtModel:self.dataSource[selectIndex]];
        }
        
        [self.collectionview reloadData];
    }
    
}

- (void)deletePeripheral:(NSNotification *)notifi{
    
    RealName *model = notifi.object;
    
    DataModel *deleObject;
    
    for (DataModel *data in self.dataSource) {
        
        if ([data.uuid isEqualToString:model.udid]) {
            
            deleObject = data;
        }
        
    }
    if (deleObject) {
        
        selectIndex = 0;
        
        [self.dataSource removeObject:deleObject];
        
        if (self.dataSource.count>0) {
            
            [self updateUiWihtModel:self.dataSource[selectIndex]];
            
            self.allbtn.selected = self.lightOnbtn.selected;
        }
        
        [self.collectionview reloadData];
    }
    


}


- (void)disConnectPeripheral:(NSNotification *)notifi{
    
    NSString *uuid = notifi.object;
    
    DataModel *disConnetObject;
    
    for (DataModel *data in self.dataSource) {
        
        if ([data.uuid isEqualToString:uuid]) {
            
            disConnetObject = data;
        }
        
    }
   
    if (disConnetObject) {
        
        [self showHudWithString:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"test7", nil),disConnetObject.realName]];
        
        disConnetObject.cbCharacteristcs = nil;
        
        disConnetObject.cbPeripheral = nil;
        
        self.allbtn.selected = NO;
        
        [self changeSubviewsUserInterface:NO];
        //
        [self.lightOnbtn setSelected:NO];
        
        self.allbtn.userInteractionEnabled = NO;
        
        self.lightOnbtn.userInteractionEnabled = NO;
        
    }
    
    
}

//- (void)didreloadUi{
//    
//    if (self.dataSource.count>0) {
//        
//        selectIndex = 0;
//        
//        [self reloadUi];
//    }
//
//}
//- (void)reloadUi{
//    
//    [self reloadUiWithArray:deviceList];
//}
//
//- (void)reloadUiWithArray:(NSMutableArray *)ary{
//    
//    if (ary.count>0) {
//        
//        [self.dataSource removeAllObjects];
//        
//        NSArray *saveList = [RealName MR_findAll];
//        
//        NSMutableArray *temp = [NSMutableArray array];
//        
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        
//        for (RealName *model in saveList) {
//            
//            [temp addObject:model.udid];
//            
//            [dic setObject:model.name forKey:model.udid];
//        }
//        
//        for (DataModel *data in ary) {
//            
//            for (NSString *str in temp) {
//                
//                if ([data.cbPeripheral.identifier.UUIDString isEqualToString:str]) {
//                    
//                    data.realName = dic[str];
//                    
//                    [self.dataSource addObject:data];
//                }
//                
//            }
//            
//        }
//        
//        if (self.dataSource.count>0) {
//            
////            if (selectIndex == 999) {
////                
////                selectIndex = 0;
////            }
//            
//            [self updateUiWihtModel:self.dataSource[selectIndex]];
//        }
//        
//        [self.collectionview reloadData];
//        
//    }
//    
//}

- (void)setUpUi{
    
    
    UINib *nib = [UINib nibWithNibName:@"TopBtnCell" bundle:nil];
    
    [self.collectionview registerNib:nib forCellWithReuseIdentifier:@"TopCell"];
    
    sliderbuttom = [[ZZCircularSlider alloc]initWithFrame:CGRectMake((ScreenWidth-220)/2, 290, 220, 100)
                                                             usingMax:100 usingMin:0
                                                           withTarget:self
                                                           sliderMode:ZZCircularSliderModeaButtom
                                                        usingSelector:@selector(test:)];
    
    
    [self.view addSubview:sliderbuttom];
    
    
    slidertop = [[ZZCircularSlider alloc]initWithFrame:CGRectMake((ScreenWidth-220)/2, 168, 220, 100)
                                                                usingMax:100 usingMin:0
                                                              withTarget:self
                                                              sliderMode:ZZCircularSliderModeTop
                                                           usingSelector:@selector(testtop:)];
    
    
    [self.view addSubview:slidertop];
    
    CGFloat width = 40;
    
    CGFloat space = (ScreenWidth-5 * 40)/6;
    
    
    for (int i =0; i<5; i++) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i *width +(i +1)*space, ScreenHeight-49-100, width, width)];
        
        button.tag = i;
        
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(i *width +(i +1)*space, ScreenHeight-49-70, width, width)];
        
        lab.textColor = [UIColor whiteColor];
        
        lab.textAlignment = NSTextAlignmentCenter;
        
        
        
        if (i==4) {
            
            [button setImage:[UIImage imageNamed:@"night"] forState:UIControlStateNormal];
            
            [button setImage:[UIImage imageNamed:@"night-0"] forState:UIControlStateSelected];
            
        
        
        }
        else{
            
            [button setImage:[UIImage imageNamed:@"l1-0"] forState:UIControlStateNormal];
            
            [button setImage:[UIImage imageNamed:@"l"] forState:UIControlStateSelected];
            
            lab.text = [NSString stringWithFormat:@"F%d",i+1];
            
        
            
        }
        
         button.selected = NO;
        
        [button addTarget:self action:@selector(sendLightAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.view addSubview:button];
        
        [self.view addSubview:lab];
        
        [buttonArray addObject:button];

    }
    
    
    
    palette = [[Palette alloc]initWithFrame:CGRectMake((ScreenWidth-160)/2, 200, 160, 160)];
    
    palette.paletteDelegate = self;
    
    [self.view addSubview:palette];
    
}


#pragma mark palette delegate

- (void)changeColor:(NSMutableArray *)_colorList{
    
    NSString *string = [_colorList componentsJoinedByString:@","];
    
    if (self.dataSource.count>0) {
        
        DataModel *model = self.dataSource[selectIndex];
        
        [[ZZBluetoothManger shareInstance]writeValue:string commandType:CommandType_B11 model:model];
        
        [self turnOffLights];
    }
    
}

#pragma mark Command Action

- (IBAction)allOnAction:(UIButton *)sender {
    
    if (self.dataSource.count>0) {
        
        NSString *code = sender.selected?@"55":@"aa";
        
        for (DataModel *model in self.dataSource) {
            
            [[ZZBluetoothManger shareInstance]writeValue:code commandType:CommandType_B3 model:model];
            
        }

        sender.selected = !sender.selected;
        
        [self changeSubviewsUserInterface:sender.selected];
//        
        [self.lightOnbtn setSelected:sender.selected];
        
//        self.lightOnbtn.selected = NO;
        
//        [self reloadUi];
        
    }
    
}

- (void)changeSubviewsUserInterface:(BOOL)state{
    
    slidertop.userInteractionEnabled = state;
    
    sliderbuttom.userInteractionEnabled = state;
    
    palette.userInteractionEnabled = state;
    
    for (UIButton *btn in buttonArray) {
        
        btn.userInteractionEnabled = state;
    }
}

- (void)sendLightAction:(UIButton *)btn{
    
   
    if (self.dataSource.count>0) {
        
        
        NSInteger index;
        
        if (btn.tag == 4) {
            
            index = 4;
        }else{
            
            index = btn.tag+5;
        }
        
        for (UIButton *btn1 in buttonArray) {
            
            if (btn1 == btn) {
                
            }
            else{
                
                btn1.selected = NO;
            }
            
        }
        
        
        NSString *code = btn.selected?@"55":@"aa";
        
        NSLog(@"%@",code);
        
        btn.selected = !btn.selected;
        
        DataModel *model = self.dataSource[selectIndex];
        
        [[ZZBluetoothManger shareInstance]writeValue:code commandType:(CommandType)index model:model];

    }
 
}

- (void)test:(ZZCircularSlider *)slider{
    
    if (self.dataSource.count>0) {
    
       NSString *str = [ [NSString alloc] initWithFormat:@"%x",slider.currentValue];
        
       if (str.length ==1) str = [NSString stringWithFormat:@"0%@",str];
       
        NSLog(@"----------------------%d",slider.currentValue);
        
        
       DataModel *model = self.dataSource[selectIndex];
        
       [[ZZBluetoothManger shareInstance]writeValue:str commandType:CommandType_B10 model:model];
        
        [self turnOffLights];
        
    }
}

- (void)testtop:(ZZCircularSlider *)slider{
    
  
    if (self.dataSource.count>0) {
        
        NSString *str = [ [NSString alloc] initWithFormat:@"%x",slider.currentValue];
        
        if (str.length ==1) str = [NSString stringWithFormat:@"0%@",str];

        DataModel *model = self.dataSource[selectIndex];
        
        [[ZZBluetoothManger shareInstance]writeValue:str commandType:CommandType_B9 model:model];
        
        [self turnOffLights];
    }
  
}

- (void)turnOffLights{
    
    for (UIButton *butn in buttonArray) {
        
        butn.selected = NO;
    }
    
}

- (IBAction)oneOn:(UIButton *)sender {
    
    if (self.dataSource.count>0) {
        
        NSString *code = sender.selected?@"55":@"aa";
        
        sender.selected = !sender.selected;
        
        self.allbtn.selected = sender.selected;
        
        [self changeSubviewsUserInterface:self.allbtn.selected];
        
        DataModel *model = self.dataSource[selectIndex];
        
        [[ZZBluetoothManger shareInstance]writeValue:code commandType:CommandType_B3 model:model];
    }
}

#pragma mark UpdateUI

- (void)updateUiWihtModel:(DataModel *)model{
    
    if (model.deviceData) {
        
        [self upadateLightWihArray:model.deviceData];
        
        [self updateSliderWithArray:model.deviceData];
        
        [self updatePaletteWithArray:model.deviceData];
    }

}

- (void)updateSliderWithArray:(NSMutableArray *)ary{
    
    
    NSString *str = ary[9];
    
    unsigned long num1 = strtoul([str UTF8String],0,16);

    [slidertop updateSliderWithValue:num1];
    
    
    NSString *str1 = ary[10];
    
    unsigned long num2= strtoul([str1 UTF8String],0,16);
    
    [sliderbuttom updateSliderWithValue:num2];
    
}

- (void)updatePaletteWithArray:(NSMutableArray *)ary{
    
    
    NSString *str = ary[2];
    
    if ([str isEqualToString:@"01"]) {
        
        palette.imageView.image= [UIImage imageNamed:@"中心圆-0"];
        
  
    }
    else{
        
        palette.imageView.image= [UIImage imageNamed:@"中心圆"];
        
        palette.handel.hidden = YES;
        
 
    }
}

- (void)upadateLightWihArray:(NSMutableArray *)ary{
    
    self.allbtn.userInteractionEnabled = YES;
    
    self.lightOnbtn.userInteractionEnabled = YES;
    
    NSString *str = ary[3];
    
    if ([str isEqualToString:@"aa"]) {
        
        self.lightOnbtn.selected = YES;
       
        [self changeSubviewsUserInterface:YES];
        
        NSString *statue = ary[2];
        
        if (![statue isEqualToString:@"01"]) {
            
            palette.userInteractionEnabled = NO;
        }
        
        
//        sliderbuttom.userInteractionEnabled = YES;
//        slidertop.userInteractionEnabled = YES;
//        palette.userInteractionEnabled = YES;
       
    }
    else{
//      
//        slidertop.userInteractionEnabled = NO;
//        sliderbuttom.userInteractionEnabled = NO;
//        palette.userInteractionEnabled= NO;
        
        [self changeSubviewsUserInterface:NO];
        
        self.lightOnbtn.selected = NO;
    }
    
    
    
    for (int i = 0; i<buttonArray.count; i++) {
        
        
        UIButton *button = buttonArray[i];
        
        NSString *statue;
        
        if (button.tag ==4) {
            
            statue = ary[4];
        }
        else{
            
            statue = ary[i+5];
        }
        
        if ([statue isEqualToString:@"aa"]) {
    
            
            button.selected = YES;
        }
        else{
            
            button.selected = NO;
        }
    }
    
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return  self.dataSource.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DataModel *model = self.dataSource[indexPath.row];
    
    TopBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TopCell" forIndexPath:indexPath];
    
    cell.lab.text  = model.realName;
    
    if (selectIndex == indexPath.row) {
        
        
        cell.imgv.image = [UIImage imageNamed:@"l"];
    }
    else{
        
        cell.imgv.image = [UIImage imageNamed:@"l1-0"];
    }
    
 
    
    return cell;
    

}



#pragma mark UICollectionViewDelegate



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (selectIndex !=indexPath.row) {
     
        DataModel *model = self.dataSource[indexPath.row];
        
        if (model.cbPeripheral) {
         
            selectIndex = indexPath.row;
            
            [self.collectionview reloadData];
            
            [self updateUiWihtModel:model];
            
            self.allbtn.selected = self.lightOnbtn.selected;
            
        }
    }
    
    
    
    if (indexPath.row < self.dataSource.count) {
        
        DataModel *model = self.dataSource[indexPath.row];
        
        if (model.cbPeripheral == nil) {
            
            
            [[ZZBluetoothManger shareInstance]retrieveConnectWithIdentifier:model.uuid  block:^(BOOL isSuccess, DataModel *model) {
                
                if (isSuccess) {
                    
                    //                [deviceList addObject:model];
                    
                    for (DataModel *temp in self.dataSource) {
                        
                        if ([temp.uuid isEqualToString:model.uuid]) {
                            
                            temp.cbPeripheral = model.cbPeripheral;
                            
                            temp.cbCharacteristcs = model.cbCharacteristcs;
                            
                            temp.deviceData = model.deviceData;
                        }
                        
                    }
                    
                    [self updateUiWihtModel:self.dataSource[selectIndex]];
                    
                    self.allbtn.selected = self.lightOnbtn.selected;
                    
                }
            }];
            
        }
    }
    
    
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    return CGSizeMake(80, 60);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}

#pragma mark getter


- (NSMutableArray *)dataSource{

    if (_dataSource == nil) {
        
        _dataSource = [NSMutableArray array];

    }
    
    return _dataSource;
}


@end
