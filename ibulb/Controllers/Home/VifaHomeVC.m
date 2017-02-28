//
//  VifaHomeVC.m
//  ibulb
//
//  Created by Interest on 2016/11/8.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "VifaHomeVC.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VifaTopCell.h"
#import "VifaMidCell.h"
#import "WiimuUPnP.h"
#import "Netconfig.h"
#import "AFHttp.h"
#import "UIImageView+WebCache.h"
#import "PlayVC.h"
#import "DDXMLElementAdditions.h"
@interface VifaHomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate,WiimuUPnPObserver,UIGestureRecognizerDelegate>
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UICollectionView *collectview;
@property (strong, nonatomic) IBOutlet UITableView *popTableview;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;


@end

@implementation VifaHomeVC
{
    BOOL playing;
    NSMutableArray *list;
    CGPoint startpoint;
    CGPoint currentpoint;
    UITapGestureRecognizer *tap;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self updateUI];
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.dataSource = [delegate.devices mutableCopy];
    
    [self.collectview reloadData];
    
    
    
    [[WiimuUPnP sharedInstance] addObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [[WiimuUPnP sharedInstance] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    list = [@[NSLocalizedString(@"SET UP NEW SPEAKER", nil),NSLocalizedString(@"GROUP ALL", nil),NSLocalizedString(@"PAUSE ALL", nil)]mutableCopy];
    self.popTableview.frame = CGRectMake(ScreenWidth-250-20, 0, 250, 185);
    self.popTableview.hidden = YES;
    self.popTableview.backgroundColor = BaseColor;
    self.popTableview.layer.masksToBounds = YES;
    self.popTableview.layer.cornerRadius = 5;
    self.popTableview.separatorColor = [UIColor colorWithRed:214/255.0 green:158/255.0 blue:100.0/255.0 alpha:1];
    self.popTableview.layer.borderColor =[UIColor colorWithRed:214/255.0 green:158/255.0 blue:100.0/255.0 alpha:1].CGColor;
    self.popTableview.layer.borderWidth = 1.f;
    [self.view addSubview:self.popTableview];
    

    UINib *nib = [UINib nibWithNibName:@"VifaTopCell" bundle:nil];
    [self.collectview registerNib:nib forCellWithReuseIdentifier:@"vitfaTop"];
    
    UINib *nib2 = [UINib nibWithNibName:@"VifaMidCell" bundle:nil];
    [self.collectview registerNib:nib2 forCellWithReuseIdentifier:@"midCell"];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"79"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeft)];
    self.navigationItem.leftBarButtonItem = item;
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"+"] style:UIBarButtonItemStylePlain target:self action:@selector(showgroup)];
    self.navigationItem.rightBarButtonItem = item2;
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    NSArray *itemsFromGenericQuery = [everything items];

    
    self.collectview.frame = CGRectMake(40, 0, ScreenWidth-80, ScreenHeight-64);
    UILongPressGestureRecognizer *ges = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpress:)];
    [self.collectview addGestureRecognizer:ges];
    
    
    
}

- (void)hidepop{
    
    if (!self.popTableview.isHidden) {
        self.popTableview.hidden = YES;
        [self.view removeGestureRecognizer:tap];
    }
    
}

- (void)longpress:(UILongPressGestureRecognizer *)longGesture {
    
    
    
    //判断手势状态
    
    NSIndexPath *indexPath = [self.collectview indexPathForItemAtPoint:[longGesture locationInView:self.collectview]];
    
    NSDictionary *dic = self.dataSource[indexPath.row];


    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            
            if (indexPath == nil || [dic[@"grouping"] boolValue]) {
                break;
            }
            startpoint =[longGesture locationInView:self.collectview];
            //在路径上则开始移动该路径上的cell
            [self.collectview beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程当中随时更新cell位置
            
            currentpoint=[longGesture locationInView:self.collectview];
            CGFloat distance =fabs(currentpoint.y - startpoint.y);
            if (distance > 30 ) {
                
                
            }
            else if (distance >25){
                
                UIAlertView *view = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"grouping", nil) message:NSLocalizedString(@"grouping？", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
                view.tag = indexPath.row;
                [view show];
            }
            else{
                
                [self.collectview updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectview]];
            }
            break;
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            [self.collectview endInteractiveMovement];
            break;
        default:
            [self.collectview cancelInteractiveMovement];
            break;
    }
}
- (void)showLeft{
    
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.ddmenu showLeftController:YES];
}

- (void)showgroup{
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidepop)];
    tap.delegate =self;
    [self.view addGestureRecognizer:tap];
    self.popTableview.hidden = NO;
}

- (void)updateUI{
    
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
    [UPnPDevice(infoDic[@"uuid"]) GetInfoEx:^(NSDictionary *result) {
        if([result[@"statuscode"] intValue] != 0)
        {
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //play state
            playing = [result[@"OutCurrentTransportState"] isEqualToString:@"PLAYING"];
            
            VifaTopCell *cell  =(VifaTopCell *)[self.collectview cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
            DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithXMLString:result[@"OutTrackMetaData"] options:0 error:nil];
            if (!xmlDoc)
            {
                return;
            }
            
            DDXMLElement *trackItem = [[xmlDoc rootElement] elementForName:@"item"];
           
            if([NSURL URLWithString:[[trackItem elementForName:@"upnp:albumArtURI"] stringValue]] != nil && playing)
            {
                NSString *uri =[[trackItem elementForName:@"upnp:albumArtURI"] stringValue];
                
                [cell.bgimgv sd_setImageWithURL:[NSURL URLWithString:uri]placeholderImage:[UIImage imageNamed:@"121"]];
                
                cell.btn.hidden = YES;
            
            }
            else{
                
//                cell.bgimgv = nil;
                cell.btn.hidden = NO;
            }
            if (playing) {
                
                [cell.playbtn setImage:[UIImage imageNamed:@"142"] forState:UIControlStateNormal];
            }else{
                cell.bgimgv.image = nil;
                [cell.playbtn setImage:[UIImage imageNamed:@"home_music"] forState:UIControlStateNormal];
            }
        });
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            NSString *title =[[trackItem elementForName:@"dc:title"] stringValue];
//            NSString *artist =[[trackItem elementForName:@"upnp:artist"] stringValue];
//            _titlelab.text = [NSString stringWithFormat:@"%@\n%@",title,artist];
//            
//        });

    }];
    
}

- (void)play{

    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
    
    if (playing) {
        
        [UPnPDevice(infoDic[@"uuid"]) sendPause:^(NSDictionary *result) {
            
            
        }];
    }
    else{
        
        [UPnPDevice(infoDic[@"uuid"]) sendPlay:^(NSDictionary *result) {
            
            
        }];
    }
    playing = !playing;

    
}
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    if ([touch.view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
        return NO;
    }
    return YES;
}
#pragma mark - WiimuUPnPObserver methods

- (void)UPnPDeviceEvent:(id<WiimuDeviceProtocol>)device event:(NSString *)event
{
    NSLog(@"%@",event);
    [self updateUI];
 
}
#pragma mark Uialert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        

        NSDictionary *infoDic = [self.dataSource firstObject];
        NSDictionary *dic = self.dataSource[alertView.tag];
        NSString *hexssid =[NSString stringWithFormat:@"%@",[self convertStringToHexStr:infoDic[@"ssid"]]];
        [[AFHttp shareInstanced]joinToMasterWithIP:dic[@"ip"] masterSSID:hexssid channel:infoDic[@"ch"] auth:infoDic[@"auth"] encry:infoDic[@"encry"] pwd:infoDic[@"pwd"] completionBlock:^(id obj) {
            NSLog(@"obj = %@",obj);
            
            NSMutableDictionary *gropdic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [gropdic setObject:@"1" forKey:@"grouping"];
            [self.dataSource replaceObjectAtIndex:alertView.tag withObject:gropdic];
            [self.collectview reloadData];
            
        } failureBlock:^(NSError *error, NSString *responseString) {
            
        }];
    }
}
#pragma mark UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
//    //取出源item数据
//    id objc = [_dataSource objectAtIndex:sourceIndexPath.item];
//    //从资源数组中移除该数据
//    [_dataSource removeObject:objc];
//    //将数据插入到资源数组中的目标位置上
//    [_dataSource insertObject:objc atIndex:destinationIndexPath.item];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return  self.dataSource.count;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.dataSource[indexPath.row];
    UIColor *color;
    
    
    NSString *type =[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"type%@",dic[@"uuid"]]];
    NSString *colorstr = [[NSUserDefaults standardUserDefaults]objectForKey:dic[@"uuid"]];
    if (colorstr.length>0) {
        
        color = [self colorWithHexString:colorstr];
    }
    else{
        
        color = [UIColor colorWithRed:151/225.0 green:181.0/255.0 blue:211/255.0 alpha:1];
        
    }
    if (indexPath.row == 0) {
        
        VifaTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"vitfaTop" forIndexPath:indexPath];
        [cell.playbtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
        cell.namelab.text = dic[@"name"];
        if ([type isEqualToString:@"1"]) {
            
            [cell.btn setImage:[UIImage imageNamed:@"44"] forState:UIControlStateNormal];
        }
        else{
            [cell.btn setImage:[UIImage imageNamed:@"157"] forState:UIControlStateNormal];
        }
   
        cell.donebtn.hidden = ![dic[@"grouping"] boolValue];
      
        cell.backgroundColor = color;
        return cell;
    }
    else{
        
        VifaMidCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"midCell" forIndexPath:indexPath];
        cell.namelab.text =dic[@"name"];
        cell.backgroundColor = color;
        cell.groupbtn.hidden = ![dic[@"grouping"] boolValue];
        if ([type isEqualToString:@"1"]) {
            
            
            cell.imgv.image = [UIImage imageNamed:@"44"];
        }
        else{
            cell.imgv.image = [UIImage imageNamed:@"157"];
        }
        return cell;
    }
    
}


#pragma mark UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{

    
    NSDictionary *dic = self.dataSource[indexPath.row];
    if (indexPath.row ==0 || [dic[@"grouping"] boolValue]) {
        
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0 && playing) {
        
        PlayVC *vc = [[PlayVC alloc]initWithHome:YES];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 0) {
        
        return CGSizeMake(([UIScreen mainScreen].bounds.size.width -80), 150);
    }
    return CGSizeMake([UIScreen mainScreen].bounds.size.width -80, 345);
}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}
#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = list[indexPath.row];
    
    return cell;
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.popTableview.hidden =YES;
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
    if (indexPath.row ==0) {
        
        Netconfig *vc = [[Netconfig alloc]init];
        vc.title = @"NETWORK CONFIGURATION";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 1) {
        
        [[AFHttp shareInstanced]joinGroupWithIP:infoDic[@"ip"] completionBlock:^(id obj) {
            
            
            NSMutableArray *temp = [NSMutableArray array];
            for (id dic in self.dataSource) {
                
                NSMutableDictionary *gropdic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)dic];
                [gropdic setObject:@"1" forKey:@"grouping"];
                [temp addObject:gropdic];
            }
            self.dataSource = [temp mutableCopy];
            [self.collectview reloadData];

          
        } failureBlock:^(NSError *error, NSString *responseString) {
            
        }];
    }else{
        
        [[AFHttp shareInstanced]exitGroupWithIP:infoDic[@"ip"] completionBlock:^(id obj) {
            
            NSMutableArray *temp = [NSMutableArray array];
            for (id dic in self.dataSource) {
                
                NSMutableDictionary *gropdic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)dic];
                [gropdic setObject:@"0" forKey:@"grouping"];
                [temp addObject:gropdic];
            }
            self.dataSource = [temp mutableCopy];
            [self.collectview reloadData];
   
            
        } failureBlock:^(NSError *error, NSString *responseString) {
            
        }];
    }
}

@end
