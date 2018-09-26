//
//  JSCommonTool.m
//  Example0
//
//  Created by lmg on 2018/9/20.
//  Copyright © 2018年 lmg. All rights reserved.
//

#import "JSCommonTool.h"
#import <sys/utsname.h>

@implementation JSCommonTool

+ (BOOL)js_isIPhoneX {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]) {
        // 模拟器下采用屏幕的高度来判断
        return (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812)) ||
                CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(812, 375)));
    }
    // iPhone10,6是美版iPhoneX 感谢hegelsu指出：https://github.com/banchichen/TZImagePickerController/issues/635
    BOOL isIPhoneX = [platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone10,6"];
    return isIPhoneX;
}

+ (CGFloat)js_statusBarHeight {
    return [self js_isIPhoneX] ? 44 : 20;
}


@end
