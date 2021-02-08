//
//  AppDelegate.h
//  Demo
//
//  Created by CoLcY on 11-12-29.
//  Copyright (c) 2011年 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PushKit/PushKit.h>                         // VOIP支持需要导入PushKit库,实现 PKPushRegistryDelegate
#import <UserNotifications/UserNotifications.h>     // iOS10 通知头文件
#import <GTSDK/GeTuiSdk.h>
@class TabBarController, HomeViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, PKPushRegistryDelegate, UNUserNotificationCenterDelegate, GeTuiSdkDelegate>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) TabBarController *tabbarController;
@property (nonatomic, weak) HomeViewController *homePage;
@end
