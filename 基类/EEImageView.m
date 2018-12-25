//
//  EEImageView.m
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/2/23.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import "EEImageView.h"

@implementation EEImageView

// 据说UIImageView的子类不会调用真正的drawRect
- (void)drawRectByMyself
{
    // 边框
    if (_borderWidth > 0) {
                
        self.layer.borderWidth = _borderWidth;
        self.layer.borderColor = _borderColor.CGColor;
    }
    // 设置半圆角
    if (_halfRadius) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.width/2;
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    
    _cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

#pragma mark 设置点击事件代码块
- (void)setClickEvent:(void (^)(void))clickEvent
{
    _clickEvent = clickEvent;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction:)];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
}

#pragma mark 触发代码块点击事件
- (void)touchAction:(id)sender
{
    _clickEvent();
}

#pragma mark 加载图片【子方法：默认占位图+无进度+无失败】
- (UIImage *)ee_setImageWithURL:(NSString *)url
                        success:(void (^)(UIImage *image, SDImageCacheType cacheType, NSURL *imageURL))success
{
    return [self ee_setImageWithURL:url progress:nil success:success failure:nil];
}

#pragma mark 加载图片【子方法：默认占位图】
- (UIImage *)ee_setImageWithURL:(NSString *)url
               progress:(void (^)(NSInteger receivedSize, NSInteger expectedSize))progress
                success:(void (^)(UIImage *image, SDImageCacheType cacheType, NSURL *imageURL))success
                failure:(void (^)(UIImage *image, SDImageCacheType cacheType, NSURL *imageURL, NSError *error))failure
{
    return [self ee_setImageWithURL:url placeholder:PlaceHolderName progress:progress success:success failure:failure];
}

#pragma mark 加载图片【主方法】
- (UIImage *)ee_setImageWithURL:(NSString *)url placeholder:(NSString *)placeholder
               progress:(void (^)(NSInteger receivedSize, NSInteger expectedSize))progress
                success:(void (^)(UIImage *image, SDImageCacheType cacheType, NSURL *imageURL))success 
                failure:(void (^)(UIImage *image, SDImageCacheType cacheType, NSURL *imageURL, NSError *error))failure
{
    MJWeakSelf
    [self layoutIfNeeded];// 如果用约束，需要立即layout以获得最新frame（起因：SD从内存获取图片缓存速度比默认的layout快。。。）
    [self sd_setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:[UIImage imageNamed:placeholder]
                     options:SDWebImageRetryFailed
                    progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
//                        NSLog(@"EEImageView说道图片加载进度：%.2f", (CGFloat)receivedSize / expectedSize);
                        if (progress)
                            progress(receivedSize, expectedSize);
                        
                        
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        
                        if (!error) {
                            
                            if (success) success(image, cacheType, imageURL);
                            weakSelf.imageURL = imageURL;
                        }
                        else
                        {
                            if (failure) failure(image, cacheType, imageURL, error);
                        }
                        
                    }];
    
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:url]];
    
    // 先从内存找
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key];
    if (cacheImage)
        return cacheImage;
    // 再从磁盘找
    cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    if (cacheImage)
        return cacheImage;
    // 实在没找到
    return nil;
}

//#pragma mark 加载图片回调
//- (void)setImageWithURL:(NSString *)url success:(void (^)(NSURLRequest *request, NSHTTPURLResponse * response, UIImage * image))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
//{
//    [self setImageWithURL:url placeholder:PlaceHolderName success:success failure:failure];
//}

//#pragma mark 加载图片回调 自定占位图
//- (void)setImageWithURL:(NSString *)url placeholder:(NSString *)placeholder success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * image))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
//{
//    MJWeakSelf
//    [self setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
//     
//     placeholderImage:[UIImage imageNamed:placeholder]
//     
//     success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * image) {
//         
//         [weakSelf setImage:image];
//         if (success) {
//             success(request, response, image);
//         }
//         
//     }
//     failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
//         
//         if (failure) {
//             failure(request, response, error);
//         }
//     }];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setBorderColor:(UIColor *)borderColor {

    _borderColor = borderColor;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {

    _borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = borderWidth;
}

- (void)setHalfRadius:(BOOL)halfRadius
{
    _halfRadius = halfRadius;
    [self performSelector:@selector(drawRectByMyself) withObject:self afterDelay:CGFLOAT_MIN];
}
@end
