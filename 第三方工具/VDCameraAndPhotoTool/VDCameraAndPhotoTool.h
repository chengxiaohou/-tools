//
//  CameraAndPhotoTool.h
//  sheet
//
//  Created by lyb on 16/3/22.
//  Copyright © 2016年 lyb. All rights reserved.
//  调用系统相机和相册的工具类

#import <UIKit/UIKit.h>

typedef void(^cameraReturn)(UIImage *image,NSString *videoPath);

@interface VDCameraAndPhotoTool : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/**
 图片选择类型（尚未启用）
 
 - EEImagePickerTypeNone: 什么也不做
 - EEImagePickerTypeTakePhoto: 拍照
 - EEImagePickerTypePickPhoto: 从相册选取照片
 - EEImagePickerTypePickVideo: 从相册选取视频
 */
typedef NS_OPTIONS(NSUInteger, EEImagePickerType) {
    EEImagePickerTypeNone        = 0,
    EEImagePickerTypeTakePhoto   = 1 << 0,
    EEImagePickerTypePickPhoto   = 1 << 1,
    EEImagePickerTypePickVideo   = 1 << 2,
};


/**
 单图选择完成后的处理
 */
@property (nonatomic, copy)cameraReturn finishBack;
/**
 *  单例
 *
 *  @return VDCameraAndPhotoTool对象
 */
+ (instancetype)shareInstance;
/**
 *  调用系统相机录像
 *
 *  @param vc         要调用相机的控制器
 *  @param finishBack 录像完成的回调
 */
- (void)showVideoInViewController:(UIViewController *)vc andFinishBack:(cameraReturn)finishBack;
/**
 *  调用系统相机
 *
 *  @param vc         要调用相机的控制器
 *  @param finishBack 拍照完成的回调
 */
- (void)showCameraInViewController:(UIViewController *)vc andFinishBack:(cameraReturn)finishBack;
/**
 *  调用系统相册
 *
 *  @param vc         要调用相册的控制器
 *  @param finishBack 选择完成的回调
 */
- (void)showPhotoInViewController:(UIViewController *)vc andFinishBack:(cameraReturn)finishBack;

/**
 *  显示相机、录像或相册（弹出alert）
 *
 *  @param vc        控制器
 *  @param finishBack 完成回掉
 */
- (void)showImagePickerController:(UIViewController *)vc andFinishBack:(cameraReturn)finishBack;



/** FromAlbum【橙晓侯】*/
- (void)showAlbumPickerWithFinishBack:(cameraReturn)finishBack;

/**
 TakePhoto + FromAlbum【橙晓侯】
 */
- (void)showImagePickerWithFinishBack:(cameraReturn)finishBack;

/**
 TakePhoto + FromAlbum + 裁宽高比【橙晓侯】
 @param ratio 裁剪框宽高比
 */
- (void)showImagePickerWithFinishBack:(cameraReturn)finishBack cutRatio:(CGFloat)ratio;
@end
