//
//  TabBarController.h
//  GtSdkDemo
//
//  Created by ak on 2020/03/20.
//  Copyright © 2019 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HomeViewController;
@class AdvanceViewController;
@class InfoViewController;

@interface TabBarController : UITabBarController

@property (nonatomic, strong) HomeViewController *homePage;
@property (nonatomic, strong) AdvanceViewController *advancedFCVC;
@property (nonatomic, strong) InfoViewController *appInfoVC;

@end

NS_ASSUME_NONNULL_END
