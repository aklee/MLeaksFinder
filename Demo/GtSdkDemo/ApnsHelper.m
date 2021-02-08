//
//  ApnsHelper.m
//  GtSdkDemo
//
//  Created by ak on 2020/4/14.
//  Copyright © 2020 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

#import "ApnsHelper.h"

@implementation ApnsHelper

+(NSString*)makeMp3FromExt: (float)cnt {
    NSString *path = [[[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.ent.com.getui.demo"] resourceSpecifier] stringByAppendingString:@"Library/Sounds/"];
    return [self mergeVoice:path cnt:cnt];
}

+(NSString*)mergeVoice:(NSString*)libPath cnt:(float)cnt {
    NSArray *nums = @[@"tip", @"tip"];
    NSMutableData *mergeData = [NSMutableData alloc];
    for (int i=0; i<nums.count; i++) {
        //TODO: 需要自行导入资源
//        NSString *mp3Url = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.mp3", nums[i]] ofType:@""];
        NSString *mp3Url = [[NSBundle mainBundle] pathForResource:@"tip" ofType:@"mp3"];
        NSData *data = [[NSData alloc] initWithContentsOfFile: mp3Url];
        [mergeData appendData:data];
    }
    if(mergeData.length == 0) {
        return @"";
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:libPath]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:libPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSString *fileName = [NSString stringWithFormat:@"%d.mp3", [self getFileName]];
    NSString *filePath = [NSString stringWithFormat:@"%@%@", libPath, fileName];
    BOOL result = [mergeData writeToFile:filePath atomically:YES];
    NSLog(@"data length:%@ %@ result:%@ ", @([mergeData length]), filePath,@(result));
    return fileName;
}

+(int)getFileName {
    return arc4random()%100000;
}
@end
