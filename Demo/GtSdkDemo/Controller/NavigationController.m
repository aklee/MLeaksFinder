//
//  NavigationController.m
//  GtSdkDemo
//
//  Created by ak on 2020/03/20.
//  Copyright © 2019 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

+ (void)initialize {
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.translucent = NO;
    bar.barTintColor = [UIColor colorWithRed:1.0/255.0 green:172.0/255.0 blue:243.0/255.0 alpha:1.0];
    [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *itemAttD = [NSMutableDictionary dictionary];
    itemAttD[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    itemAttD[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:itemAttD forState:UIControlStateNormal];
    
    NSMutableDictionary *itemDisAttD = [NSMutableDictionary dictionary];
    itemDisAttD[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    itemDisAttD[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:itemDisAttD forState:UIControlStateSelected];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count > 0) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"Artboard 2"] forState:UIControlStateNormal];
        button.size = CGSizeMake(80, 40);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



@end
