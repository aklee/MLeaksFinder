//
//  MessageViewController.m
//  GtSdkDemo
//
//  Created by ak on 2020/03/20.
//  Copyright © 2019 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()
@property (nonatomic, weak) IBOutlet UITextField *messageTextField;
@property (nonatomic, weak) IBOutlet UIButton *ensureSendBtn;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"发送上行消息";
    self.ensureSendBtn.layer.cornerRadius = 6;
    self.messageTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.messageTextField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
}

- (IBAction)ensureSendMessage:(id)sender {
    NSString *content = _messageTextField.text;
    NSString *msgId = [GeTuiSdk sendMessage:[content dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@", msgId);
}

@end
