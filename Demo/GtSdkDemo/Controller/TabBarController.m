//
//  TabBarController.m
//  GtSdkDemo
//
//  Created by ak on 2020/03/20.
//  Copyright © 2019 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

#import "TabBarController.h"
#import "HomeViewController.h"
#import "AdvanceViewController.h"
#import "InfoViewController.h"
#import "NavigationController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.homePage =  [[HomeViewController alloc] init];
    self.advancedFCVC = [[AdvanceViewController alloc] init];
    self.appInfoVC = [[InfoViewController alloc] init];
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.frame];
    bgView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    [self.tabBar insertSubview:bgView atIndex:0];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    
    NSMutableDictionary *selectattrs = [NSMutableDictionary dictionary];
    selectattrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    selectattrs[NSForegroundColorAttributeName] = [UIColor redColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    [self setUpChildVC:self.homePage title:@"首页" image:@"home" selectedImage:@"home_select"];
    [self setUpChildVC:self.advancedFCVC title:@"高级功能" image:@"advancedFC" selectedImage:@"advancedFC_sel"];
    [self setUpChildVC:self.appInfoVC title:@"应用信息" image:@"appInfo" selectedImage:@"appInfo_sel"];
}

- (void)setUpChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1.0/255.0 green:172.0/255.0 blue:243.0/255.0 alpha:1.0],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    NavigationController *navc = [[NavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:navc];
}

@end
