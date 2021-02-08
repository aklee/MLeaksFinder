//
//  AppDelegate.m
//  Demo
//
//  Created by CoLcY on 11-12-29.
//  Copyright (c) 2011年 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "TabBarController.h"
#import "HomeViewController.h"
#import "ApnsHelper.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tabbarController = [[TabBarController alloc] init];
    self.homePage = self.tabbarController.homePage;
    self.window.rootViewController = self.tabbarController;
    [self.window makeKeyAndVisible];
  
    NSString *msg = [NSString stringWithFormat:@"[ TestDemo ] %@", NSStringFromSelector(_cmd)];
    [self.homePage logMsg:msg];
    // [ GTSDK ]：是否允许APP后台运行
    //    [GeTuiSdk runBackgroundEnable:YES];
    
    // [ GTSDK ]：是否运行电子围栏Lbs功能和是否SDK主动请求用户定位
    //    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
    
    // [ GTSDK ]：自定义渠道
    //    [GeTuiSdk setChannelId:@"GT-Channel"];
    
    // [ GTSDK ]：使用APPID/APPKEY/APPSECRENT启动个推
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    
    // [ 参考代码，开发者注意根据实际需求自行修改 ] 注册远程通知
    [GeTuiSdk registerRemoteNotification: (UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge)];
    
    // [ 参考代码，开发者注意根据实际需求自行修改 ] 注册VOIP
    [self voipRegistration];
    
    return YES;
}

//MARK: - 远程通知(推送)回调

/// [ 系统回调 ] 远程通知注册成功回调，获取DeviceToken成功，同步给个推服务器
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // [ GTSDK ]：向个推服务器注册deviceToken
    // 2.5.2.0 之前版本需要调用：
    //[GeTuiSdk registerDeviceTokenData:deviceToken];
    
    NSString *token = [Utils getHexStringForData:deviceToken];
    [self.homePage updateDeviceToken:token];
    NSString *errorMsg = [NSString stringWithFormat:@"[ TestDemo ] [ DeviceToken(NSString) ]: %@\n\n", token];
    [self.homePage logMsg:errorMsg];
}

/// [ 系统回调:可选 ] 远程通知注册失败回调，获取DeviceToken失败，打印错误信息
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"[ TestDemo ] %@: %@", NSStringFromSelector(_cmd), error.localizedDescription];
    [self.homePage logMsg:msg];
}


//MARK: - VOIP 接入

/**
 * [ 参考代码，开发者注意根据实际需求自行修改 ] 注册VOIP服务
 *
 * 警告：以下为参考代码, 注意根据实际需要修改.
 *
 */
- (void)voipRegistration {
    PKPushRegistry *voipRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    voipRegistry.delegate = self;
    // Set the push type to VoIP
    voipRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
}

//MARK: PKPushRegistryDelegate

/// [ 系统回调 ] 系统返回VOIPToken，并提交个推服务器
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type {
    // [ GTSDK ]：（新版）向个推服务器注册 VoipToken
    [GeTuiSdk registerVoipTokenCredentials:credentials.token];
    NSString *msg = [NSString stringWithFormat:@"[ TestDemo ] [ VoipToken(NSData) ]: %@\n\n", credentials.token];
    [self.homePage logMsg:msg];
}

/**
 * [ 系统回调 ] 收到voip推送信息
 * 接收VOIP推送中的payload进行业务逻辑处理（一般在这里调起本地通知实现连续响铃、接收视频呼叫请求等操作），并执行个推VOIP回执统计
 */
- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type {
    //  [ GTSDK ]：个推VOIP回执统计
    [GeTuiSdk handleVoipNotification:payload.dictionaryPayload];
    
    // [ 测试代码 ] 接受VOIP推送中的payload内容进行具体业务逻辑处理
    NSString *msg = [NSString stringWithFormat:@"[ TestDemo ] [ Voip Payload ]: %@, %@", payload, payload.dictionaryPayload];
    [self.homePage logMsg:msg];
    // 语音播报
    NSString* payloadStr = [payload.dictionaryPayload objectForKey:@"payload"];
    [self playAudioTitle:payloadStr];
}

// 语音播报
- (void)playAudioTitle:(NSString*) aText {
    // 后台语音播报需要设置
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    
    AVSpeechSynthesizer * av = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance * utterance = [[AVSpeechUtterance alloc]initWithString:aText];
    AVSpeechSynthesisVoice * voiceType = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    utterance.voice = voiceType;
    utterance.rate = 0.5;
    [av speakUtterance:utterance];
}

//MARK: - APPLink 接入

/// [ 系统回调 ] APPLink回调
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler {
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *webUrl = userActivity.webpageURL;
        // [ GTSDK ]：处理个推APPLink回执统计
        // APPLink url 示例：https://link.gl.ink/getui?n=payload&p=mid， 其中 n=payload 字段存储用户透传信息，可以根据透传内容进行业务操作。
        NSString *payload = [GeTuiSdk handleApplinkFeedback:webUrl];
        if (payload) {
            NSLog(@"[ TestDemo ] 个推APPLink中携带的用户payload信息: %@,URL : %@", payload, webUrl);
            // TODO: 用户可根据具体 payload 进行业务处理
        }
    }
    return YES;
}

//MARK: - GeTuiSdkDelegate


/// [ GTSDK回调 ] SDK启动成功返回cid
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    NSString *msg = [NSString stringWithFormat:@"[ TestDemo ] [GTSdk RegisterClient]:%@", clientId];
    [self.homePage logMsg:msg];
}

/// [ GTSDK回调 ] SDK运行状态通知
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    [[NSNotificationCenter defaultCenter] postNotificationName:GTSdkStateNotification object:self];
}

- (void)GeTuiSdkDidOccurError:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"[ TestDemo ] [GeTuiSdk GeTuiSdkDidOccurError]:%@\n\n",error.localizedDescription];
    [self.homePage logMsg:msg];
}

//MARK: - 通知回调

/// 通知展示（iOS10及以上版本）
/// @param center center
/// @param notification notification
/// @param completionHandler completionHandler
- (void)GeTuiSdkNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification completionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSString *msg = [NSString stringWithFormat:@"[ TestDemo ] [APNs] %@ \n%@", NSStringFromSelector(_cmd), notification.request.content.userInfo];
    [self.homePage logMsg:msg];
    // [ 参考代码，开发者注意根据实际需求自行修改 ] 根据APP需要，判断是否要提示用户Badge、Sound、Alert等
    //completionHandler(UNNotificationPresentationOptionNone); 若不显示通知，则无法点击通知
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
 
/// 收到通知信息
/// @param userInfo apns通知内容
/// @param center UNUserNotificationCenter（iOS10及以上版本）
/// @param response UNNotificationResponse（iOS10及以上版本）
/// @param completionHandler 用来在后台状态下进行操作（iOS10以下版本）
- (void)GeTuiSdkDidReceiveNotification:(NSDictionary *)userInfo notificationCenter:(UNUserNotificationCenter *)center response:(UNNotificationResponse *)response fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSString *msg = [NSString stringWithFormat:@"[ TestDemo ] [APNs] %@ \n%@", NSStringFromSelector(_cmd), userInfo];
    [self.homePage logMsg:msg];
    if(completionHandler) {
        // [ 参考代码，开发者注意根据实际需求自行修改 ] 根据APP需要自行修改参数值
        completionHandler(UIBackgroundFetchResultNoData);
    }
}


/// 收到透传消息
/// @param userInfo    推送消息内容
/// @param fromGetui   YES: 个推通道  NO：苹果apns通道
/// @param offLine     是否是离线消息，YES.是离线消息
/// @param appId       应用的appId
/// @param taskId      推送消息的任务id
/// @param msgId       推送消息的messageid
/// @param completionHandler 用来在后台状态下进行操作（通过苹果apns通道的消息 才有此参数值）
- (void)GeTuiSdkDidReceiveSlience:(NSDictionary *)userInfo fromGetui:(BOOL)fromGetui offLine:(BOOL)offLine appId:(NSString *)appId taskId:(NSString *)taskId msgId:(NSString *)msgId fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // [ GTSDK ]：汇报个推自定义事件(反馈透传消息)，开发者可以根据项目需要决定是否使用, 非必须
    // [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    NSString *msg = [NSString stringWithFormat:@"[ TestDemo ] [APN] %@ \nReceive Slience: fromGetui:%@ appId:%@ offLine:%@ taskId:%@ msgId:%@ userInfo:%@ ", NSStringFromSelector(_cmd), fromGetui ? @"个推消息" : @"APNs消息", appId, offLine ? @"离线" : @"在线", taskId, msgId, userInfo];
    [self.homePage logMsg:msg];
    
    if(completionHandler) {
        // [ 参考代码，开发者注意根据实际需求自行修改 ] 根据APP需要自行修改参数值
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

- (void)GeTuiSdkNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification {
    // [ 参考代码，开发者注意根据实际需求自行修改 ] 根据APP需要自行修改参数值
}

//MARK: - 发送上行消息

/// [ GTSDK回调 ] SDK收到sendMessage消息回调
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(BOOL)isSuccess error:(NSError *)aError {
    NSString *msg = [NSString stringWithFormat:@"[ TestDemo ] [GeTuiSdk DidSendMessage]: \nReceive sendmessage:%@ result:%d error:%@", messageId, isSuccess, aError];
    [self.homePage logMsg:msg];
}


//MARK: - 开关设置

/// [ GTSDK回调 ] SDK设置推送模式回调
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@">>>[GexinSdkSetModeOff]: %@ %@", isModeOff ? @"开启" : @"关闭", [error localizedDescription]];
    [self.homePage logMsg:msg];
    [self.homePage updatePushMode:isModeOff];
}


//MARK: - 别名设置

- (void)GeTuiSdkDidAliasAction:(NSString *)action result:(BOOL)isSuccess sequenceNum:(NSString *)aSn error:(NSError *)aError {
    /*
     参数说明
     isSuccess: YES: 操作成功 NO: 操作失败
     aError.code:
     30001：绑定别名失败，频率过快，两次调用的间隔需大于 5s
     30002：绑定别名失败，参数错误
     30003：绑定别名请求被过滤
     30004：绑定别名失败，未知异常
     30005：绑定别名时，cid 未获取到
     30006：绑定别名时，发生网络错误
     30007：别名无效
     30008：sn 无效 */
    NSString *msg = nil;
    if([action isEqual:kGtResponseBindType]) {
        msg = [NSString stringWithFormat:@"[ TestDemo ] bind alias result sn = %@, code = %@", aSn, @(aError.code)];
    }
    if([action isEqual:kGtResponseUnBindType]) {
        msg = [NSString stringWithFormat:@"[ TestDemo ] unbind alias result sn = %@, code = %@", aSn, @(aError.code)];
    }
    [self.homePage logMsg:msg];
}


//MARK: - 标签设置

- (void)GeTuiSdkDidSetTagsAction:(NSString *)sequenceNum result:(BOOL)isSuccess error:(NSError *)aError {
    /*
     参数说明
     sequenceNum: 请求的序列码
     isSuccess: 操作成功 YES, 操作失败 NO
     aError.code:
     20001：tag 数量过大（单次设置的 tag 数量不超过 100)
     20002：调用次数超限（默认一天只能成功设置一次）
     20003：标签重复
     20004：服务初始化失败
     20005：setTag 异常
     20006：tag 为空
     20007：sn 为空
     20008：离线，还未登陆成功
     20009：该 appid 已经在黑名单列表（请联系技术支持处理）
     20010：已存 tag 数目超限
     20011：tag 内容格式不正确
     */
    NSString *msg = [NSString stringWithFormat:@"[ TestDemo ] GeTuiSdkDidSetTagAction sequenceNum:%@ isSuccess:%@ error: %@", sequenceNum, @(isSuccess), aError];
    [self.homePage logMsg:msg];
}
@end
