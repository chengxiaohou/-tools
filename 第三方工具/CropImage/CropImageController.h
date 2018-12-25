//
//  CropImageController.h
//  CropImage
//
//  Created by limuyun on 2017/1/10.
//  Copyright © 2017年 biiway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Crop.h"
@protocol CropImageDelegate <NSObject>

- (void)cropImageDidFinishedWithImage:(UIImage *)image;

@end

@interface CropImageController : UIViewController

@property (nonatomic, weak) id <CropImageDelegate> delegate;
/** 裁剪宽高比 */
@property (assign, nonatomic) CGFloat cropRatio;
//圆形裁剪，默认NO;
@property (nonatomic, assign) BOOL ovalClip;
- (instancetype)initWithImage:(UIImage *)originalImage delegate:(id)delegate;
@end
