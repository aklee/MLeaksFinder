//
//  Utils.m
//  GtSdkDemo
//
//  Created by ak on 2020/03/20.
//  Copyright © 2019 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (void)AlertControllerWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController  dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:sureAction];
    if ([[[UIApplication sharedApplication] delegate] isKindOfClass:[AppDelegate class]]) {
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegate.homePage presentViewController:alertController animated:YES completion:nil];
    }
}

+ (BOOL)PushModel {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"OffPushMode"];
}
+ (void)SetPushModel:(BOOL)mode {
    [[NSUserDefaults standardUserDefaults] setBool:mode forKey:@"OffPushMode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString *)getHexStringForData:(NSData *)data {
    NSUInteger len = [data length];
    char *chars = (char *) [data bytes];
    NSMutableString *hexString = [[NSMutableString alloc] init];
    for (NSUInteger i = 0; i < len; i++) {
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
    }
    return hexString;
}

/// 时间转字符串
+ (NSString *)formateTime:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:date];
    return dateTime;
}

@end
