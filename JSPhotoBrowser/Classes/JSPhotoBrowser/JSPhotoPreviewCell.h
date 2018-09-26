//
//  JSPhotoPreviewCell.h
//  Example0
//
//  Created by lmg on 2018/9/20.
//  Copyright © 2018年 lmg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JSPhotoPreviewView;

@interface JSPhotoPreviewCell : UICollectionViewCell

@property (nonatomic,strong) JSPhotoPreviewView *previewView;
@property (nonatomic, assign) BOOL allowCrop;
@property (nonatomic, assign) CGRect cropRect;

- (void)recoverSubviews;

@end

@interface JSPhotoPreviewView : UIView

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *imageContainerView;
@property (nonatomic, assign) BOOL allowCrop;
@property (nonatomic, assign) CGRect cropRect;

@property (nonatomic, copy) void (^singleTapGestureBlock)(void);

- (void)recoverSubviews;

@end




NS_ASSUME_NONNULL_END
