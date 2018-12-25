//
//  UploadObj.m
//  MingPian
//
//  Created by 橙晓侯 on 2017/6/1.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import "UploadObj.h"

@implementation UploadObj

- (instancetype)initWithURL:(NSString *)url isUploaded:(BOOL)isUploaded
{
    self = [super init];
    if (self) {
        _uploadURL = url;
        _isUploaded = isUploaded;
        [self loadImage];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        _theObject = image;
    }
    return self;
}

- (void)setUploadURL:(NSString *)uploadURL
{
    _uploadURL = uploadURL;
    [self loadImage];
}

#pragma mark 偷偷缓存图片（初衷是为了提前加在好有可能要显示的图片，一般是上传图片等使用场景，是否有这个必要还有待观察）
- (void)loadImage
{
    EEImageView *temp = [EEImageView new];
    
    [temp ee_setImageWithURL:_uploadURL placeholder:nil progress:nil success:^(UIImage *image, SDImageCacheType cacheType, NSURL *imageURL) {
        
        _theObject = image;
        NSLog(@"UploadObj：偷偷缓存了图片%@", _uploadURL);
        
    } failure:^(UIImage *image, SDImageCacheType cacheType, NSURL *imageURL, NSError *error) {
        
        NSLog(@"UploadObj：图片缓存失败%@", _uploadURL);
    }];
}

@end
