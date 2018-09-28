//
//  JSCommonTool.h
//  Example0
//
//  Created by lmg on 2018/9/20.
//  Copyright © 2018年 lmg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SCCPayLoc(key) NSLocalizedStringWithDefaultValue((key), @"Localizable", [NSBundle bundleWithPath:[[NSBundle mainBundle]pathForResource:@"JSPhotoBrowser" ofType:@"bundle"]]?:[NSBundle mainBundle], nil, nil)

NS_ASSUME_NONNULL_BEGIN

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)

@interface JSCommonTool : NSObject

+ (BOOL)js_isIPhoneX;

+ (CGFloat)js_statusBarHeight;




@end

NS_ASSUME_NONNULL_END
