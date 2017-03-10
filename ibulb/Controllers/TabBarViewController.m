//
//  TabBarViewController.m
//  iwen
//
//  Created by Interest on 15/10/8.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "TabBarViewController.h"
#import "RoomVC.h"
#import "RadioVC.h"
#import "MusicVC.h"
#import "HomeVC.h"
#import "VifaHomeVC.h"
#import "BaseNavigationController.h"
#define BaseColor  [UIColor colorWithRed:254.0/255.0 green:251.0/255.0 blue:246.0/255.0 alpha:1]


//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (id)init{
    
    self = [super init];
    
    if(self){
        
//        [self.view setBackgroundColor:[UIColor whiteColor]];
       
        UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 49)];
        
        backview.backgroundColor = BaseColor;
        
        [self.tabBar insertSubview:backview atIndex:0];
        
        self.tabBar.opaque = YES;
        
//        [self.tabBar setBackgroundColor:[UIColor blackColor]];
        UITabBarItem *item1 = [[UITabBarItem alloc] init];
        item1.tag = 1;
        [item1 setImage:[UIImage imageNamed:@"Speakers"]];
        [item1 setSelectedImage:[[UIImage imageNamed:@"48"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
   
       
        
        UITabBarItem *item2 = [[UITabBarItem alloc] init];
        item2.tag = 2;
        [item2 setImage:[UIImage imageNamed:@"Music sources"]];
        [item2 setSelectedImage:[[UIImage imageNamed:@"593"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
      
       
        
        UITabBarItem *item3 = [[UITabBarItem alloc] init];
        item3.tag = 3;
        [item3 setImage:[UIImage imageNamed:@"Radio favorites"]];
        [item3 setSelectedImage:[[UIImage imageNamed:@"59"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
        
        UITabBarItem *item4 = [[UITabBarItem alloc] init];
        item4.tag = 4;
        [item4 setImage:[UIImage imageNamed:@"Page1"]];
        [item4 setSelectedImage:[[UIImage imageNamed:@"594"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
        
      
        VifaHomeVC *helpvc = [[VifaHomeVC alloc]initWithNibName:nil bundle:nil];
        helpvc.title = NSLocalizedString(@"VIFA HOME", nil);
        BaseNavigationController *helpnav = [[BaseNavigationController alloc]initWithRootViewController:helpvc];
        helpnav.tabBarItem =item1;
       
        
        
        MusicVC *homevc = [[MusicVC alloc]initWithNibName:nil bundle:nil];
        homevc.title =NSLocalizedString(@"MUSIC.BEDROOM", nil);;
        BaseNavigationController *homenav = [[BaseNavigationController alloc]initWithRootViewController:homevc];
        homenav.tabBarItem =item2;
        
        RadioVC *setvc = [[RadioVC alloc]initWithNibName:nil bundle:nil];
        setvc.title = NSLocalizedString(@"RADIO PRESETS", nil);
        BaseNavigationController *setnav = [[BaseNavigationController alloc]initWithRootViewController:setvc];
        setnav.tabBarItem =item3;
        
        RoomVC *roomvc = [[RoomVC alloc]initWithNibName:nil bundle:nil];
        roomvc.title =NSLocalizedString(@"ROOM", nil);
        BaseNavigationController *roomnav = [[BaseNavigationController alloc]initWithRootViewController:roomvc];
        roomnav.tabBarItem =item4;
        
        self.viewControllers = @[helpnav,homenav,setnav,roomnav];
        
        self.delegate = self;
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(loginSessionFailure)
//                                                     name:LOGIN_SESSION_FAILURE_NEED_LOGIN
//                                                   object:nil];
        
        return  self;
    }
    return  nil;
}

- (void)loadView
{
    [super loadView];
    //修改高度
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    CGFloat tabBarHeight = 49;
    self.tabBar.frame = CGRectMake(0, height-tabBarHeight, width, tabBarHeight);
    self.tabBar.clipsToBounds = YES;
    UIView *transitionView = [[self.view subviews] objectAtIndex:0];
//    transitionView.height = height-tabBarHeight;
    
    CGRect rect = transitionView.frame;
    
    rect.size.height =height-tabBarHeight;
    
    transitionView.frame = rect;
}



- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (UIInterfaceOrientationPortrait==interfaceOrientation);
}


- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        [super presentViewController:modalViewController animated:animated completion:NULL];
    }else{
        [super presentModalViewController:modalViewController animated:animated];
    }
}
@end
