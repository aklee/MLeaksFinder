//
//  AliasUnbindViewController.m
//  GtSdkDemo
//
//  Created by ak on 2020/03/20.
//  Copyright © 2019 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

#import "AliasUnbindViewController.h"

@interface AliasUnbindViewController ()
@property (nonatomic, weak) IBOutlet UITextField *unbindAliasTextField;
@property (nonatomic, weak) IBOutlet UIButton *ensureUnBindAliasBtn;

@end

@implementation AliasUnbindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"解绑别名";
    self.ensureUnBindAliasBtn.layer.cornerRadius = 6;
    self.unbindAliasTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.unbindAliasTextField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
}

- (IBAction)ensureUnBindAliasBtn:(id)sender {
    if (F_IsStringValue_GtEmpty(self.unbindAliasTextField.text)) {
        [Utils AlertControllerWithTitle:@"alias不能为空" andMessage:@""];
        return;
    }
    [GeTuiSdk unbindAlias:self.unbindAliasTextField.text andSequenceNum:[NSString stringWithFormat:@"%@-sign", self.unbindAliasTextField.text] andIsSelf:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
