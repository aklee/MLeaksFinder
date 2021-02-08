//
//  HomeViewController.m
//  GtSdkDemo
//
//  Created by ak on 2020/03/20.
//  Copyright © 2019 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

#import "HomeViewController.h"
@interface Test2: NSObject
@end

@implementation Test2
- (void)dealloc {
    NSLog(@"dealloc %@", self);
}
@end

@interface HomeViewController ()
@property (nonatomic, weak) IBOutlet UILabel *cidLabel;
@property (nonatomic, weak) IBOutlet UILabel *deviceTokenLabel;
@property (nonatomic, weak) IBOutlet UISwitch *sdkServiceSwitch;
@property (nonatomic, weak) IBOutlet UIButton *locationNotiBtn;
@property (nonatomic, weak) IBOutlet UIView *contentBGView;
@property (nonatomic, weak) IBOutlet UITextView *contentTextView;
@property (nonatomic, weak) IBOutlet UISwitch *pushSwitch;
@property (nonatomic, weak) IBOutlet UILabel *sdkStateLabel;

@property (nonatomic, copy) void (^bk)();
@property (nonatomic, copy) void (^bk2)();

@property (nonatomic, strong) Test2 *t2;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //akak test
//    __block HomeViewController *ss = self;// FBRetainCycleDetector 无法检测出__block修饰的循环引用
//    HomeViewController *ss = self; // 可以检测出rc
    __weak HomeViewController *ss = self; // 可以检测出rc
    self.bk = ^{
        NSLog(@"%@", ss);
    };
    self.bk();
    //TODO:akak  copy会不会掉self retain?
//    [self.bk copy];
    self.title = @"个推演示";
    self.locationNotiBtn.layer.cornerRadius = 8;
    self.contentBGView.layer.cornerRadius = 6;
    
    [self updatePushMode:Utils.PushModel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatusView) name:GTSdkStateNotification object:nil];
}

- (void)dealloc {
    NSLog(@"dealloc %@", self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateStatusView {
    SdkStatus status = [GeTuiSdk status];
    switch (status) {
        case SdkStatusStarted:
            [self.sdkStateLabel setText:@"已启动"];
            [self.cidLabel setText:[GeTuiSdk clientId]];
            [self.sdkServiceSwitch setOn:YES];
            break;
        case SdkStatusStarting:
            [self.sdkStateLabel setText:@"正在启动"];
            [self.sdkServiceSwitch setOn:NO];
            [self.cidLabel setText:@""];
            break;
        case SdkStatusOffline:
            [self.sdkStateLabel setText:@"已离线"];
            [self.sdkServiceSwitch setOn:YES];
            [self.cidLabel setText:@""];
            break;
        default:
            [self.sdkStateLabel setText:@"已停止"];
            [self.sdkServiceSwitch setOn:NO];
            [self.cidLabel setText:@""];
            break;
    }
}


- (void)updateDeviceToken:(NSString *)deviceToken {
    self.deviceTokenLabel.text = deviceToken;
}

- (void)updatePushMode:(BOOL)mode {
    [self.pushSwitch setOn:mode];
    [Utils SetPushModel:mode];
}

// MARK: Click Action

- (IBAction)pushLocation:(id)sender {
    [self pushLocalNotification:@"测试本地推送使用"];
}

- (IBAction)clearContentClick:(id)sender {
    //akak test
    HomeViewController *vc = [HomeViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
    [self.contentTextView setText:nil];
    [self.contentTextView scrollRangeToVisible:NSMakeRange([self.contentTextView.text length], 0)];
}

- (IBAction)sdkServiceSwitch:(id)sender {
    SdkStatus status = [GeTuiSdk status];
    if (_sdkServiceSwitch.on && status == SdkStatusStoped) {
        AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:delegate];
    } else {
        if ([GeTuiSdk status] == SdkStatusStarted || [GeTuiSdk status] == SdkStatusStarting) {
            // [ GTSDK ] 销毁SDK
            [GeTuiSdk destroy];
        }
    }
}

- (IBAction)pushModeSwitch:(id)sender {
    //akak
    Test2 *t = [Test2 new];
    self.t2 = t;
    __weak HomeViewController *ss = self;
    self.bk2 = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1), dispatch_get_main_queue(), ^{
            ss.t2 = nil;
        });
    };
    self.bk2();
    if ([GeTuiSdk status] == SdkStatusStarted) {
        [Utils SetPushModel:_pushSwitch.on];
        [GeTuiSdk setPushModeForOff:_pushSwitch.on];
    } else {
        [self logMsg:@"GeTuiSDK未启动"];
    }
}

- (void)logMsg:(NSString *)msg {
    NSLog(@"%@",msg);
    NSString *response = [NSString stringWithFormat:@"%@\n%@",self.contentTextView.text,msg];
    [self.contentTextView setText:response];
    [self.contentTextView scrollRangeToVisible:NSMakeRange([self.contentTextView.text length], 0)];
}


- (void)pushLocalNotification:(NSString *)title {
    // 创建本地通知时，清理之前所有的本地通知，注意：根据App具体的功能自行修改
    // 清理所有本地通知，程序启动时清理，注意：根据App具体功能需求自行修改，如果App内有其他本地通知，更加需要注意是否要清理所有通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSString *gmid = nil;
    UILocalNotification *localNotify = [[UILocalNotification alloc] init];
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:1];
    
    localNotify.fireDate = pushDate;
    localNotify.timeZone = [NSTimeZone defaultTimeZone];
    localNotify.repeatInterval = kCFCalendarUnitDay;
    localNotify.soundName = UILocalNotificationDefaultSoundName;
    localNotify.alertBody = [NSString stringWithFormat:@"Payload : %@, time : %@", title, [self formateTime:[NSDate date]]];
    localNotify.alertAction = NSLocalizedString(@"View Details", nil);
    NSArray *notifyArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    int count = (int) [notifyArray count];
    localNotify.applicationIconBadgeNumber = count + 1;
    // 备注：点击统计需要
    if (gmid != nil) {
        NSDictionary *userInfoDict = @{@"_gmid_":gmid};
        localNotify.userInfo = userInfoDict;
    }
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotify];
}

- (NSString *)formateTime:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:date];
    return dateTime;
}

@end
