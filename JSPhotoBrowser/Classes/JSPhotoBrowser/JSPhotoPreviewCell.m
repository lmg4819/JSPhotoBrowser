//
//  JSPhotoPreviewCell.m
//  Example0
//
//  Created by lmg on 2018/9/20.
//  Copyright © 2018年 lmg. All rights reserved.
//

#import "JSPhotoPreviewCell.h"
#import "UIView+JSLayout.h"

@implementation JSPhotoPreviewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.backgroundColor = [UIColor blackColor];
        [self configSubviews];
    }
    return self;
}

- (void)configSubviews
{
    self.previewView = [[JSPhotoPreviewView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.previewView];
    
}

- (void)setAllowCrop:(BOOL)allowCrop
{
    _allowCrop = allowCrop;
    _previewView.allowCrop = allowCrop;
}

- (void)setCropRect:(CGRect)cropRect
{
    _cropRect = cropRect;
    _previewView.cropRect = cropRect;
}

- (void)recoverSubviews
{
    [_previewView recoverSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _previewView.frame = self.bounds;
}

@end

@interface JSPhotoPreviewView ()<UIScrollViewDelegate>

@end

@implementation JSPhotoPreviewView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.bouncesZoom = YES;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        if (@available(iOS 11, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self addSubview:_scrollView];
        
        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = YES;
        _imageContainerView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:_imageContainerView];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = YES;
        [_imageContainerView addSubview:_imageView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap1];

        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
        
    }
    return self;
}

- (void)recoverSubviews
{
    [_scrollView setZoomScale:1.0 animated:NO];
    [self resizeSubviews];
}

- (void)resizeSubviews
{
    _imageContainerView.js_origin = CGPointZero;
    _imageContainerView.js_width = self.scrollView.js_width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.js_height / self.scrollView.js_width) {
        _imageContainerView.js_height = floor(image.size.height / (image.size.width / self.scrollView.js_width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.scrollView.js_width;
        if (height < 1 || isnan(height)) height = self.js_height;
        height = floor(height);
        _imageContainerView.js_height = height;
        _imageContainerView.js_centerY = self.js_height / 2;
    }
    if (_imageContainerView.js_height > self.js_height && _imageContainerView.js_height - self.js_height <= 1) {
        _imageContainerView.js_height = self.js_height;
    }
    CGFloat contentSizeH = MAX(_imageContainerView.js_height, self.js_height);
    _scrollView.contentSize = CGSizeMake(self.scrollView.js_width, contentSizeH);
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.js_height <= self.js_height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
    
    [self refreshScrollViewContentSize];
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        _scrollView.contentInset = UIEdgeInsetsZero;
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)setAllowCrop:(BOOL)allowCrop
{
    _allowCrop = allowCrop;
    _scrollView.maximumZoomScale = allowCrop ? 4.0 : 2.5;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(10, 0, self.js_width - 20, self.js_height);
    [self recoverSubviews];
}

#pragma mark -UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageContainerView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self refreshImageContainerViewCenter];
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [self refreshScrollViewContentSize];
}

#pragma mark -Private

- (void)refreshScrollViewContentSize
{
    if (_allowCrop) {
        // 1.7.2 如果允许裁剪,需要让图片的任意部分都能在裁剪框内，于是对_scrollView做了如下处理：
        // 1.让contentSize增大(裁剪框右下角的图片部分)
        CGFloat contentWidthAdd = self.scrollView.js_width - CGRectGetMaxX(_cropRect);
        CGFloat contentHeightAdd = (MIN(_imageContainerView.js_height, self.js_height) - self.cropRect.size.height) / 2;
        CGFloat newSizeW = self.scrollView.contentSize.width + contentWidthAdd;
        CGFloat newSizeH = MAX(self.scrollView.contentSize.height, self.js_height) + contentHeightAdd;
        _scrollView.contentSize = CGSizeMake(newSizeW, newSizeH);
        _scrollView.alwaysBounceVertical = YES;
        // 2.让scrollView新增滑动区域（裁剪框左上角的图片部分）
        if (contentHeightAdd > 0 || contentWidthAdd > 0) {
            _scrollView.contentInset = UIEdgeInsetsMake(contentHeightAdd, _cropRect.origin.x, 0, 0);
        } else {
            _scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

- (void)refreshImageContainerViewCenter {
    CGFloat offsetX = (_scrollView.js_width > _scrollView.contentSize.width) ? ((_scrollView.js_width - _scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_scrollView.js_height > _scrollView.contentSize.height) ? ((_scrollView.js_height - _scrollView.contentSize.height) * 0.5) : 0.0;
    self.imageContainerView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
}


@end
