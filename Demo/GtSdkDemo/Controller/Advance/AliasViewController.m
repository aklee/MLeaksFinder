//
//  AliasViewController.m
//  GtSdkDemo
//
//  Created by ak on 2020/03/20.
//  Copyright © 2019 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

#import "AliasViewController.h"

@interface AliasViewController ()
@property (nonatomic, weak) IBOutlet UITextField *aliasTextField;
@property (nonatomic, weak) IBOutlet UIButton *ensureBindBtn;
@end

@implementation AliasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定别名";
    self.ensureBindBtn.layer.cornerRadius = 6;
    self.aliasTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.aliasTextField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
}

- (IBAction)bindAliasClick:(id)sender {
    if (F_IsStringValue_GtEmpty(_aliasTextField.text)) {
        [Utils AlertControllerWithTitle:@"alias不能为空" andMessage:@""];
        return;
    }
    [GeTuiSdk bindAlias:self.aliasTextField.text andSequenceNum:[NSString stringWithFormat:@"%@-sign", self.aliasTextField.text]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
