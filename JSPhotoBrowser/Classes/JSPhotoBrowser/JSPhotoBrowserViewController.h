//
//  JSPhotoBrowserViewController.h
//  Example0
//
//  Created by lmg on 2018/9/19.
//  Copyright © 2018年 lmg. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JSColorMakeWithRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]

NS_ASSUME_NONNULL_BEGIN

@interface JSPhotoBrowserViewController : UIViewController

- (instancetype)initWithPhotos:(NSArray *)photos;
- (NSString *)getImagePathWithImageName:(NSString *)imageName;

@property (nonatomic, assign) NSInteger currentIndex;  //用户点击的图片的索引
@property (nonatomic,assign) BOOL allowCrop;            //允许裁剪,默认为YES
@property (nonatomic,assign) BOOL needCircleCrop;       //需要圆形裁剪框
@property (nonatomic,assign) CGRect cropRect;           //裁剪框的尺寸
@property (nonatomic,assign) NSInteger circleCropRadius;//圆形裁剪框半径大小
@property (nonatomic,copy) void(^doneButtonClickBlockCropMode)(UIImage *cropedImage);



@end

NS_ASSUME_NONNULL_END
