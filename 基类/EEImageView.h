//
//  EEImageView.h
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/2/23.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import <UIKit/UIKit.h>

//IB_DESIGNABLE
@interface EEImageView : UIImageView

//=========== 边框 ===========
@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;
@property (assign, nonatomic) IBInspectable CGFloat borderWidth;    // 线宽
@property (strong, nonatomic) IBInspectable UIColor *borderColor;
/** 半圆角 */
@property (assign, nonatomic) IBInspectable BOOL halfRadius;

//=========== === ===========
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) CGFloat cd;

/** 点击事件 */
@property (strong, nonatomic) void (^clickEvent)(void);
/** 图片的URL */
@property (strong, nonatomic) NSURL *imageURL;

/** 加载图片回调 */
//- (void)setImageWithURL:(NSString *)url success:(void (^)(NSURLRequest *request, NSHTTPURLResponse * response, UIImage * image))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;

/** 加载图片回调+占位图 */
//- (void)setImageWithURL:(NSString *)url placeholder:(NSString *)placeholder success:(void (^)(NSURLRequest *request, NSHTTPURLResponse * response, UIImage * image))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;

/** 加载图片【子方法：默认占位图】 */
- (UIImage *)ee_setImageWithURL:(NSString *)url
               progress:(void (^)(NSInteger receivedSize, NSInteger expectedSize))progress
                success:(void (^)(UIImage *image, SDImageCacheType cacheType, NSURL *imageURL))success
                failure:(void (^)(UIImage *image, SDImageCacheType cacheType, NSURL *imageURL, NSError *error))failure;

/** 加载图片【主方法】 */
- (UIImage *)ee_setImageWithURL:(NSString *)url placeholder:(NSString *)placeholder
               progress:(void (^)(NSInteger receivedSize, NSInteger expectedSize))progress
                success:(void (^)(UIImage *image, SDImageCacheType cacheType, NSURL *imageURL))success
                failure:(void (^)(UIImage *image, SDImageCacheType cacheType, NSURL *imageURL, NSError *error))failure;

/** 加载图片【子方法：默认占位图+无进度+无失败】 */
- (UIImage *)ee_setImageWithURL:(NSString *)url
                        success:(void (^)(UIImage *image, SDImageCacheType cacheType, NSURL *imageURL))success;
@end
