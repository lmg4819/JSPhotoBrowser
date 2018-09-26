//
//  UIView+JSLayout.h
//  Example0
//
//  Created by lmg on 2018/9/19.
//  Copyright © 2018年 lmg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JSLayout)

@property (nonatomic,assign) CGFloat js_X;
@property (nonatomic,assign) CGFloat js_Y;

@property (nonatomic,assign) CGFloat js_width;
@property (nonatomic,assign) CGFloat js_height;

@property (nonatomic,assign) CGFloat js_centerX;
@property (nonatomic,assign) CGFloat js_centerY;

@property (nonatomic,assign) CGPoint js_origin;
@property (nonatomic,assign) CGSize js_size;

@end

NS_ASSUME_NONNULL_END
