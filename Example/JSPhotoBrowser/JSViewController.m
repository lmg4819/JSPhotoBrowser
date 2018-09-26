//
//  JSViewController.m
//  JSPhotoBrowser
//
//  Created by lmg4819 on 09/25/2018.
//  Copyright (c) 2018 lmg4819. All rights reserved.
//

#import "JSViewController.h"
#import <MyLibrary/SDCycleScrollView.h>
#import <MyLibrary/UIView+SDExtension.h>
#import <JSPhotoBrowser/JSPhotoBrowserViewController.h>
#import <JSPhotoBrowser/UIView+JSLayout.h>

@interface JSViewController ()<SDCycleScrollViewDelegate>
    @property (nonatomic,strong) NSArray *imageNameArray;
    @property (nonatomic,strong) UIImageView *imageView;
    
    @end

@implementation JSViewController
    
- (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:0.99];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64+240, self.view.sd_width, 200)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView];
        self.imageView = imageView;
        
        NSArray *imageNames = @[
                                @"h1.jpg", // 本地图片请填写全名
                                @"h2.jpg",
                                @"h3.jpg",
                                @"h7.png",
                                @"h6@2x.png"
                                ];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSString *tempStr in imageNames) {
            NSString *imagePath = [SDCycleScrollView getImagePathWithImageName:tempStr];
            [tempArray addObject:imagePath];
        }
        
        self.imageNameArray = tempArray;
        
        
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, self.view.sd_width, 180) shouldInfiniteLoop:YES imageNamesGroup:tempArray];
        cycleScrollView.delegate = self;
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        [self.view addSubview:cycleScrollView];
        cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
    }
    
#pragma mark -SDCycleScrollViewDelegate
    /** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
    {
        //    UIImage *image = [UIImage imageNamed:@"005.jpg"];
        JSPhotoBrowserViewController *vc = [[JSPhotoBrowserViewController alloc]initWithPhotos:@[self.imageNameArray[index]]];
        vc.needCircleCrop = NO;
        vc.allowCrop = YES;
        CGFloat cropViewWH = MIN(self.view.js_width, self.view.js_height);
        vc.cropRect = CGRectMake(0, (self.view.js_height - cropViewWH/3*2) / 2, cropViewWH, cropViewWH/3*2);
        __weak typeof(self) weakSelf = self;
        vc.doneButtonClickBlockCropMode = ^(UIImage * _Nonnull cropedImage) {
            weakSelf.imageView.image = cropedImage;
        };
        [self.navigationController pushViewController:vc animated:YES];
        //    NSLog(@"------%ld------",(long)index);
    }
    
    /** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
    {
        //    NSLog(@"======%ld======",(long)index);
    }
    
    @end
