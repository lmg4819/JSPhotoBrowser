//
//  NSBundle+Category.h
//  FBSnapshotTestCase
//
//  Created by lmg on 2018/9/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (Category)

+ (instancetype)js_sharedBundle;

+ (NSString *)js_localizedStringForKey:(NSString *)key;
+ (NSString *)js_localizedStringForKey:(NSString *)key value:(NSString *)value;


@end

NS_ASSUME_NONNULL_END
