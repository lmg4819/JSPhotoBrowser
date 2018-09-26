//
//  UIView+JSLayout.m
//  Example0
//
//  Created by lmg on 2018/9/19.
//  Copyright © 2018年 lmg. All rights reserved.
//

#import "UIView+JSLayout.h"

@implementation UIView (JSLayout)

- (CGFloat)js_X
{
    return self.frame.origin.x;
}

- (void)setJs_X:(CGFloat)js_X
{
    CGRect frame = self.frame;
    frame.origin.x = js_X;
    self.frame = frame;
}

- (CGFloat)js_Y
{
    return self.frame.origin.y;
}

- (void)setJs_Y:(CGFloat)js_Y
{
    CGRect frame = self.frame;
    frame.origin.y = js_Y;
    self.frame = frame;
}

- (CGFloat)js_width
{
    return self.frame.size.width;
}

- (void)setJs_width:(CGFloat)js_width
{
    CGRect frame = self.frame;
    frame.size.width = js_width;
    self.frame = frame;
}

- (CGFloat)js_height
{
    return self.frame.size.height;
}

- (void)setJs_height:(CGFloat)js_height
{
    CGRect frame = self.frame;
    frame.size.height = js_height;
    self.frame = frame;
}

- (CGFloat)js_centerX
{
    return self.center.x;
}

- (void)setJs_centerX:(CGFloat)js_centerX
{
    CGPoint center = self.center;
    center.x = js_centerX;
    self.center = center;
}

- (CGFloat)js_centerY
{
    return self.center.y;
}

-(void)setJs_centerY:(CGFloat)js_centerY
{
    CGPoint center = self.center;
    center.y = js_centerY;
    self.center = center;
}

- (CGPoint)js_origin
{
    return self.frame.origin;
}

- (void)setJs_origin:(CGPoint)js_origin
{
    CGRect frame = self.frame;
    frame.origin = js_origin;
    self.frame = frame;
}

- (CGSize)js_size
{
    return self.frame.size;
}

- (void)setJs_size:(CGSize)js_size
{
    CGRect frame = self.frame;
    frame.size = js_size;
    self.frame = frame;
}



@end
