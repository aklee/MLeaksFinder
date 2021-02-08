//
//  HomeViewController.h
//  GtSdkDemo
//
//  Created by ak on 2020/03/20.
//  Copyright © 2019 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController

- (void)logMsg:(NSString *)message;
- (void)updateStatusView;
- (void)updateDeviceToken:(NSString *)deviceToken;
- (void)updatePushMode:(BOOL)mode;

@end

NS_ASSUME_NONNULL_END
