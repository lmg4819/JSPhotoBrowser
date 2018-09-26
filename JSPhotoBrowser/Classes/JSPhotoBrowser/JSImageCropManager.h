//
//  JSImageCropManager.h
//  Example0
//
//  Created by lmg on 2018/9/21.
//  Copyright © 2018年 lmg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSImageCropManager : NSObject

//裁剪框背景的处理
+ (void)overlayClippingWithView:(UIView *)view cropRect:(CGRect)cropRect containerView:(UIView *)containerView
                 needCircleCrop:(BOOL)needCircleCrop;

/// 获得裁剪后的图片
+ (UIImage *)cropImageView:(UIImageView *)imageView toRect:(CGRect)rect zoomScale:(double)zoomScale containerView:
(UIView *)containerView;

/// 获取圆形图片
+ (UIImage *)circularClipImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
