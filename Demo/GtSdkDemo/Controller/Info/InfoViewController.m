//
//  InfoViewController.m
//  GtSdkDemo
//
//  Created by ak on 2020/03/20.
//  Copyright © 2019 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()
@property (nonatomic, weak) IBOutlet UILabel *appNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *appidLabel;
@property (nonatomic, weak) IBOutlet UILabel *appkeyLabel;
@property (nonatomic, weak) IBOutlet UILabel *appsecretLabel;
@property (nonatomic, weak) IBOutlet UILabel *packageNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *sdkVersionLabel;
@property (nonatomic, weak) IBOutlet UILabel *deviceNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *iphoneSysVersionLabel;
@property (nonatomic, weak) IBOutlet UILabel *deviceModelLabel;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"应用信息";
    self.appidLabel.text = kGtAppId;
    self.appkeyLabel.text = kGtAppKey;
    self.appsecretLabel.text = kGtAppSecret;
    
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    self.appNameLabel.text = [dic objectForKey:@"CFBundleName"];
    self.deviceNameLabel.text = [[UIDevice currentDevice] systemName];
    self.iphoneSysVersionLabel.text = [[UIDevice currentDevice] systemVersion];
    self.deviceModelLabel.text = [[UIDevice currentDevice] model];
    self.packageNameLabel.text = [dic objectForKey:@"CFBundleIdentifier"];
    self.sdkVersionLabel.text = [GeTuiSdk version];
}

@end
