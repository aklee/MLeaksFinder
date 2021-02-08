//
//  BadgeViewController.m
//  GtSdkDemo
//
//  Created by ak on 2020/03/20.
//  Copyright © 2019 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

#import "BadgeViewController.h"

@interface BadgeViewController ()
@property (nonatomic, weak) IBOutlet UITextField *badgeTextField;
@property (nonatomic, weak) IBOutlet UIButton *ensureSetBtn;
@end

@implementation BadgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"同步角标";
    self.ensureSetBtn.layer.cornerRadius = 6;
    self.badgeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.badgeTextField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
}

- (IBAction)ensureSetBadge:(id)sender {
    int badge = MAX(0, [self.badgeTextField.text intValue]);
    [GeTuiSdk setBadge:badge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
    [Utils AlertControllerWithTitle:@"设置成功" andMessage:@""];
}

@end
