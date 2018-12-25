//
//  STPhotoBrowserController.h
//  STPhotoBrowser
//
//  Created by https://github.com/STShenZhaoliang/STPhotoBrowser.git on 16/1/15.
//  Copyright © 2016年 ST. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STPhotoBrowserController;
@protocol STPhotoBrowserDelegate <NSObject>

- (UIImage *_Nonnull)photoBrowser:(STPhotoBrowserController *_Nullable)browser
          placeholderImageForIndex:(NSInteger)index;

- (NSURL *_Nullable)photoBrowser:(STPhotoBrowserController *_Nullable)browser
     highQualityImageURLForIndex:(NSInteger)index;
@end

@interface STPhotoBrowserController : UIViewController
/** 1.原图片的容器，即图片来源的父视图 */
@property ( nonatomic, weak, nullable)UIView *sourceImagesContainerView;
/** 2.当前的标签 */
@property (nonatomic, assign)NSInteger currentPage;
/** 3.图片的总数目 */
@property (nonatomic, assign)NSInteger countImage;

@property ( nonatomic, weak, nullable) id <STPhotoBrowserDelegate>delegate; //

- (void)show;


/**
 启动图片浏览器【接口】

 @param sourceImagesContainerView 多imageView的父视图；不便传入可不传，只是没有动画
 @param imageCount 图片总数
 @param currentPage 当前index
 @param delegate 代理
 @return STPhotoBrowserController
 */
+ (STPhotoBrowserController *_Nullable)showPhotoBrowserWithSourceImagesContainerView:(UIView *_Nullable)sourceImagesContainerView imageCount:(NSInteger)imageCount currentPage:(NSInteger)currentPage delegate:(id _Nullable )delegate;

@end
