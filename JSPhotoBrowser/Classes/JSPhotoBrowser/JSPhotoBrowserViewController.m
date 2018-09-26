//
//  JSPhotoBrowserViewController.m
//  Example0
//
//  Created by lmg on 2018/9/19.
//  Copyright © 2018年 lmg. All rights reserved.
//

#import "JSPhotoBrowserViewController.h"
#import "UIView+JSLayout.h"
#import "JSPhotoPreviewCell.h"
#import "JSCommonTool.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JSImageCropManager.h"

@interface JSPhotoBrowserViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    CGFloat _offsetItemCount;
}

@property (nonatomic,strong) UIView *naviBar;
@property (nonatomic,strong) UIView *cropBgView;
@property (nonatomic,strong) UIView *cropView;

@property (nonatomic,strong) UILabel *indexLabel;

@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIButton *doneButton;

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *layout;

@property (nonatomic,strong) NSArray *photos;

@end

@implementation JSPhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self configCollectionView];
    [self configCustomNaviBar];
    self.view.clipsToBounds = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

-(instancetype)initWithPhotos:(NSArray *)photos
{
    self = [super init];
    if (self) {
        self.photos = [NSArray arrayWithArray:photos];
        self.allowCrop = YES;
        CGFloat cropViewWH = MIN(self.view.js_width, self.view.js_height) / 3 * 2;
        self.cropRect = CGRectMake((self.view.js_width - cropViewWH) / 2, (self.view.js_height - cropViewWH) / 2, cropViewWH, cropViewWH);
    }
    return self;
}

- (void)configCropView
{
    if (self.photos.count == 1 && self.allowCrop) {
        [_cropView removeFromSuperview];
        [_cropBgView removeFromSuperview];
        
        _cropBgView = [UIView new];
        _cropBgView.userInteractionEnabled = NO;
        _cropBgView.frame = self.view.bounds;
        _cropBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_cropBgView];
        [JSImageCropManager overlayClippingWithView:_cropBgView cropRect:self.cropRect containerView:self.view needCircleCrop:self.needCircleCrop];
        
        _cropView = [UIView new];
        _cropView.userInteractionEnabled = NO;
        _cropView.frame = self.cropRect;
        _cropView.backgroundColor = [UIColor clearColor];
        _cropView.layer.borderColor = [UIColor whiteColor].CGColor;
        _cropView.layer.borderWidth = 1.0;
        if (self.needCircleCrop) {
            _cropView.layer.cornerRadius = self.cropRect.size.width/2;
            _cropView.layer.masksToBounds = YES;
        }
        [self.view addSubview:_cropView];
        [self.view bringSubviewToFront:_naviBar];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (_currentIndex) [_collectionView setContentOffset:CGPointMake((self.view.js_width + 20) * _currentIndex, 0) animated:NO];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)configCustomNaviBar{
    _naviBar = [[UIView alloc]initWithFrame:CGRectZero];
    _naviBar.backgroundColor = JSColorMakeWithRGBA(34, 34, 34, 0.7);
    
    _backButton = [[UIButton alloc]initWithFrame:CGRectZero];
    UIImage *image = [UIImage imageNamed:[self getImagePathWithImageName:@"navi_back@2x.png"]];
    [_backButton setImage:image forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _doneButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _doneButton.hidden = self.photos.count!=1;
    
    
    _indexLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _indexLabel.font = [UIFont boldSystemFontOfSize:18];
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    _indexLabel.text = [NSString stringWithFormat:@"%ld/%lu",self.currentIndex+1,(unsigned long)self.photos.count];
    [_naviBar addSubview:_doneButton];
    [_naviBar addSubview:_backButton];
    [_naviBar addSubview:_indexLabel];
    [self.view addSubview:_naviBar];
    
}

- (void)didChangeStatusBarOrientationNotification:(NSNotification *)noti {
    _offsetItemCount = _collectionView.contentOffset.x / _layout.itemSize.width;
}
- (void)doneButtonClick
{
    if (self.allowCrop) {// 裁剪状态
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
        JSPhotoPreviewCell *cell = (JSPhotoPreviewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        UIImage *cropImage = [JSImageCropManager cropImageView:cell.previewView.imageView toRect:self.cropRect zoomScale:cell.previewView.scrollView.zoomScale containerView:self.view];
        if (self.needCircleCrop) {
            cropImage = [JSImageCropManager circularClipImage:cropImage];
        }
        if (self.doneButtonClickBlockCropMode) {
            self.doneButtonClickBlockCropMode(cropImage);
            [self dismiss];
        }
    }
}

- (void)backButtonClick
{
    [self dismiss];
}

- (void)dismiss {
    if (self.navigationController) {
        if (self.navigationController.childViewControllers.count < 2) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)configCollectionView{
    _layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(self.photos.count * (self.view.js_width + 20), 0);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[JSPhotoPreviewCell class] forCellWithReuseIdentifier:@"JSPhotoPreviewCell"];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat statusBarHeight = [JSCommonTool js_statusBarHeight];
    CGFloat statusBarHeightInterval = statusBarHeight - 20;
    CGFloat naviBarHeight = statusBarHeight + 44;
    _naviBar.frame = CGRectMake(0, 0, self.view.js_width, naviBarHeight);
    _backButton.frame = CGRectMake(10, 20+statusBarHeightInterval, 44, 44);
    _doneButton.frame = CGRectMake(self.view.js_width - 56, 20+statusBarHeightInterval, 44, 44);
    _indexLabel.frame = CGRectMake(56, 20+statusBarHeightInterval, self.view.js_width-112, 44);
    _layout.itemSize = CGSizeMake(self.view.js_width+20, self.view.js_height);
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 0;
    _collectionView.frame = CGRectMake(-10, 0, self.view.js_width+20, self.view.js_height);
    [_collectionView setCollectionViewLayout:_layout];
    if (_offsetItemCount > 0) {
        CGFloat offsetX = _offsetItemCount * _layout.itemSize.width;
        [_collectionView setContentOffset:CGPointMake(offsetX, 0)];
    }
    [_collectionView reloadData];
    
    [self configCropView];
}

#pragma mark -UICollectionViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offSetWidth = scrollView.contentOffset.x;
    offSetWidth = offSetWidth +  ((self.view.js_width + 20) * 0.5);
    
    NSInteger currentIndex = offSetWidth / (self.view.js_width + 20);
    
    if (currentIndex < _photos.count && _currentIndex != currentIndex) {
        _currentIndex = currentIndex;
    }
    _indexLabel.text = [NSString stringWithFormat:@"%ld/%lu",self.currentIndex+1,(unsigned long)self.photos.count];
}

#pragma mark -UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JSPhotoPreviewCell" forIndexPath:indexPath];
    id object = self.photos[indexPath.row];
    if ([object isKindOfClass:[NSString class]]) {
        cell.previewView.imageView.image = [UIImage imageWithContentsOfFile:object];
    }else if ([object isKindOfClass:[NSURL class]]){
        [cell.previewView.imageView sd_setImageWithURL:object];
    }else if ([object isKindOfClass:[UIImage class]]){
        cell.previewView.imageView.image = object;
    }
    cell.allowCrop = self.allowCrop;
    cell.cropRect = self.cropRect;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [(JSPhotoPreviewCell *)cell recoverSubviews];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [(JSPhotoPreviewCell *)cell recoverSubviews];
}

#pragma mark -

-(void)setCropRect:(CGRect)cropRect
{
    _cropRect = cropRect;
}

-(void)setCircleCropRadius:(NSInteger)circleCropRadius
{
    _circleCropRadius = circleCropRadius;
    self.cropRect = CGRectMake(self.view.js_width/2 - circleCropRadius, self.view.js_height/2 - circleCropRadius, circleCropRadius * 2, circleCropRadius * 2);
}

-(void)setAllowCrop:(BOOL)allowCrop
{
    _allowCrop = self.photos.count > 1 ? NO : allowCrop;
}

- (NSString *)getImagePathWithImageName:(NSString *)imageName
{
    NSBundle *currentBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[JSPhotoBrowserViewController class]] pathForResource:@"JSPhotoBrowser" ofType:@"bundle"]];
    // 获取当前bundle的名称
    // 获取图片的路径
    NSString *imagePath = [currentBundle pathForResource:imageName ofType:nil];
    
    return imagePath;
}

@end
