//
//  NSBundle+Category.m
//  FBSnapshotTestCase
//
//  Created by lmg on 2018/9/28.
//

#import "NSBundle+Category.h"
#import "JSPhotoBrowserViewController.h"

@implementation NSBundle (Category)

+ (instancetype)js_sharedBundle{
    static NSBundle *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[JSPhotoBrowserViewController class]] pathForResource:@"JSPhotoBrowser" ofType:@"bundle"]];
    });
    return instance;
}

+ (NSString *)js_localizedStringForKey:(NSString *)key value:(NSString *)value
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                language = @"zh-Hans"; // 简体中文
            } else { // zh-Hant\zh-HK\zh-TW
                language = @"zh-Hant"; // 繁體中文
            }
        } else {
            language = @"en";
        }
        
        // 从MJRefresh.bundle中查找资源
        bundle = [NSBundle bundleWithPath:[[self js_sharedBundle] pathForResource:language ofType:@"lproj"]];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}

+ (NSString *)js_localizedStringForKey:(NSString *)key
{
    return [self js_localizedStringForKey:key value:nil];
}

@end
