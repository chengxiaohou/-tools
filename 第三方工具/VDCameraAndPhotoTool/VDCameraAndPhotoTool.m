//
//  CameraAndPhotoTool.m
//  sheet
//
//  Created by lyb on 16/3/22.
//  Copyright © 2016年 lyb. All rights reserved.
//

#import "VDCameraAndPhotoTool.h"
#import "UIImage+Extension.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define TakePhoto   @"拍照"
#define TakeVideo   @"录像"
#define FromAlbum   @"从相册选取"

typedef enum {
    
    photoType,
    cameraType,
    videoType
}pickerType;
static VDCameraAndPhotoTool *tool ;

@interface VDCameraAndPhotoTool ()<UIActionSheetDelegate>

@property (nonatomic, strong) UIActionSheet *actionSheet;
@property(nonatomic, weak)UIViewController *fromVc;
@property (nonatomic, strong) UIImagePickerController *picker;
/** 橙晓侯 是否需要裁剪图片 */
@property (assign, nonatomic) BOOL shouldCutImage;
/** 裁剪宽高比例 */
@property (assign, nonatomic) CGFloat cropRatio;

@end


@implementation VDCameraAndPhotoTool

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        tool = [[VDCameraAndPhotoTool alloc] init];
    });
    
    return tool;
}

- (void)showVideoInViewController:(UIViewController *)vc andFinishBack:(cameraReturn)finishBack {
    
    if (finishBack) {
        
        self.finishBack = finishBack;
    }
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self setUpImagePicker:videoType];
    
    [vc presentViewController:self.picker animated:YES completion:nil];//进入照相界面
    [vc.view layoutIfNeeded];
}

- (void)showCameraInViewController:(UIViewController *)vc andFinishBack:(cameraReturn)finishBack {
    
    if (finishBack) {
        
        self.finishBack = finishBack;
    }
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self setUpImagePicker:cameraType];
    
    [vc presentViewController:self.picker animated:YES completion:nil];//进入照相界面
    [vc.view layoutIfNeeded];
}

- (void)showPhotoInViewController:(UIViewController *)vc andFinishBack:(cameraReturn)finishBack{
    
    if (finishBack) {
        
        self.finishBack = finishBack;
    }
    
   [self setUpImagePicker:photoType];
    
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [vc presentViewController:self.picker animated:YES completion:nil];//进入相册界面
    [vc.view layoutIfNeeded];

}

#pragma mark FromAlbum【橙晓侯】
- (void)showAlbumPickerWithFinishBack:(cameraReturn)finishBack
{
    _shouldCutImage = 0;
    self.finishBack = finishBack;
    self.fromVc = TopVC;
    [self showTZPhotoPickerInViewController];
//    [self showPhotoInViewController:self.fromVc andFinishBack:finishBack];
}

#pragma mark TakePhoto + FromAlbum【橙晓侯】
- (void)showImagePickerWithFinishBack:(cameraReturn)finishBack 
{
    _shouldCutImage = 0;
    
    self.finishBack = finishBack;
    
    self.fromVc = TopVC;
    _actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:TakePhoto,FromAlbum, nil];
    
    [_actionSheet showInView:TopVC.view];
}

#pragma mark TakePhoto + FromAlbum + 裁宽高比【橙晓侯】
- (void)showImagePickerWithFinishBack:(cameraReturn)finishBack cutRatio:(CGFloat)ratio
{
    _shouldCutImage = 1;
    _cropRatio = ratio;
    
    self.finishBack = finishBack;
    self.fromVc = TopVC;
    _actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:TakePhoto,FromAlbum, nil];
    [_actionSheet showInView:TopVC.view];
}

#pragma mark TZI 进入相册选择单图
- (void)showTZPhotoPickerInViewController
{
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    imagePicker.allowPickingVideo = 0;
    imagePicker.allowTakePicture = 0;// 不让在相册里拍照
    // 配置裁剪参数
    if (_shouldCutImage)
    {
        imagePicker.allowCrop = 1;
        // 裁剪框
        CGFloat width = Width;
        CGFloat height = Width/_cropRatio;
        CGFloat x = 0;
        CGFloat y = Height/2 - height/2;
        imagePicker.cropRect = CGRectMake(x, y, width, height);
    }
    else
    {
        // 不裁剪的才能选择原图
        imagePicker.allowPickingOriginalPhoto = 1;
    }
    
    MJWeakSelf
    imagePicker.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto)
    {
        // 原图
        if (isSelectOriginalPhoto)
        {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            PHAsset *asset = assets[0];
            // 同步获得图片, 只会返回1张图片
            options.synchronous = YES;
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                if (weakSelf.finishBack)
                {
                    weakSelf.finishBack(result, nil);
                }
            }];
        }
        // 压缩图
        else
        {
            UIImage * result = [photos firstObject];
            result = [weakSelf scaleImage:result toSize:CGSizeMake(result.size.width, (int)(imagePicker.photoWidth * result.size.height / result.size.width))];
            
            if (weakSelf.finishBack)
            {
                weakSelf.finishBack(result,nil);
            }
        }
        
    };
    [self.fromVc presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - 单图拍照回调 imagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    MJWeakSelf
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    // 拍摄结果 图片类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [[TZImageManager manager] savePhotoWithImage:image location:nil completion:^(NSError *error){
            [TZImageManager manager].sortAscendingByModificationDate = 0;//确保第一张图是刚才拍的
            
            [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                
                [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                    
                    TZAssetModel *assetModel = [models firstObject];
                    
                    TZImagePickerController *imagePicker;
                    // 去裁剪
                    if (_shouldCutImage)
                    {
                        //========================== old ==========================
                        // 裁剪回调
                        imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset)
                        {
                            cropImage = [weakSelf scaleImage:cropImage toSize:CGSizeMake(828, (int)(828 * cropImage.size.height / cropImage.size.width))];// 828为默认值

                            if (weakSelf.finishBack)
                            {
                                weakSelf.finishBack(cropImage,nil);
                            }
                        }];
                        // 裁剪框
                        CGFloat width = Width;
                        CGFloat height = Width/_cropRatio;
                        CGFloat x = 0;
                        CGFloat y = Height/2 - height/2;
                        imagePicker.cropRect = CGRectMake(x, y, width, height);
                        //========================== old ==========================
                    }
                    // 不裁剪
                    else
                    {
                        imagePicker = [[TZImagePickerController alloc] initWithSelectedAssets:[NSMutableArray arrayWithArray:@[assetModel.asset]] selectedPhotos:[NSMutableArray arrayWithArray:@[image]] index:0];
                        
                        // 原图可选项
                        imagePicker.allowPickingOriginalPhoto = YES;
                        imagePicker.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                            
                            // 原图
                            UIImage *photo = photos[0];
                            // 压缩图
                            if (!isSelectOriginalPhoto)
                            {
                                photo = [weakSelf scaleImage:photo toSize:CGSizeMake(imagePicker.photoWidth, (int)(imagePicker.photoWidth * photo.size.height / photo.size.width))];
                            }
                            
                            if (weakSelf.finishBack)
                            {
                                weakSelf.finishBack(photo, nil);
                            }
                            [picker dismissViewControllerAnimated:0 completion:nil];
                        };
                        
                    }
                    
                    // 不允许选择视频
                    imagePicker.allowPickingVideo = 0;
                    //=========== 无缝切换 ===========
                    UIViewController *vc = picker.presentingViewController;
                    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
                    blackView.backgroundColor = [UIColor blackColor];
                    [Window addSubview:blackView];// 由于TZImagePickerController会自动dismiss（autoDismiss没啥用），只好如此切换了
                    [picker dismissViewControllerAnimated:0 completion:^{
                        
                        [vc presentViewController:imagePicker animated:0 completion:^{
                            
                            [blackView removeFromSuperview];
                        }];
                    }];
                    
                }];
            }];
        }];
        //=========== 原来的方法保留注释 ===========
        /**
         
         if (_shouldCutImage)
         {
         CGFloat width = [UIScreen mainScreen].bounds.size.width;
         CGFloat height = image.size.height * (width/image.size.width);
         UIImage * orImage = [image resizeImageWithSize:CGSizeMake(width, height)];
         CropImageController * cropVC = [[CropImageController alloc] initWithImage:orImage delegate:self];
         cropVC.cropRatio = _cutRatio;// 输入裁剪宽高比例
         //    con.ovalClip = YES; // 是否切圆形
         [picker presentViewController:cropVC animated:NO completion:nil];
         }
         else
         {
         MJWeakSelf
         [picker dismissViewControllerAnimated:0 completion:^{
         
         if (weakSelf.finishBack)
         {
         weakSelf.finishBack(image,nil);
         }
         }];
         
         }
         
         */
    }
    // 视频
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        
        NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        NSString *urlStr=[url path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            
            //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
        }
    }
    
    
}

#pragma mark CropImageController裁剪回调[上传] 【不再使用，改用TZ】
- (void)cropImageDidFinishedWithImage:(UIImage *)image
{
    if (self.finishBack) {
        
        self.finishBack(image,nil);
    }
}

//视频保存后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {//可以在此解析错误
        
    }else{//保存成功
        
        //录制完之后自动播放
        if (self.finishBack) {
            
            self.finishBack(nil,videoPath);
        }
        
       [self.picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showImagePickerController:(UIViewController *)vc andFinishBack:(cameraReturn)finishBack{
    
    if (finishBack) {
        
        self.finishBack = finishBack;
    }
    
    if (vc) {
        
        self.fromVc = vc;
        _actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:TakePhoto,FromAlbum,TakeVideo, nil];
        [_actionSheet showInView:vc.view];
    }
    
}

- (void)setUpImagePicker:(pickerType )type {
    
    self.picker = nil;
    
    self.picker = [[UIImagePickerController alloc] init];//初始化
    self.picker.delegate = self;
    self.picker.allowsEditing = NO;//设置不可编辑
    
    if (type == photoType) {
        
        //判断用户是否允许访问相册权限
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
            //无权限
            return;
        }
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        self.picker.sourceType = sourceType;
    }else if (type == cameraType){
        //判断用户是否允许访问相机权限
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            //无权限
            return;
        }
        //判断用户是否允许访问相册权限
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
            //无权限
            return;
        }
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.sourceType = sourceType;
        
        
    }else if (type == videoType) {
        //判断用户是否允许访问相机权限
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            //无权限
            return;
        }
        
        //判断用户是否允许访问麦克风权限
        authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            //无权限
            return;
        }

        //判断用户是否允许访问相册权限
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
            //无权限
            return;
        }
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.sourceType = sourceType;
        
        self.picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        self.picker.videoQuality=UIImagePickerControllerQualityTypeIFrame1280x720;
        self.picker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;
       
    }
    
}

#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:TakePhoto])
    {
        [self showCameraInViewController:self.fromVc andFinishBack:nil];
    }
    else if ([title isEqualToString:FromAlbum])
    {
        // 用TZ封装的选择器效果更好
        [self showTZPhotoPickerInViewController];
        // [self showPhotoInViewController:self.fromVc andFinishBack:nil];// 原方法
        
    }
    else if ([title isEqualToString:TakeVideo])
    {
        [self showVideoInViewController:self.fromVc andFinishBack:nil];
    }
}

#pragma mark 从TZ抄来的缩放图片（因为TZ的封装不让用）
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size
{
//    if (image.size.width < size.width) {
//        return image;
//    }
//    UIGraphicsBeginImageContext(size);
//    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    if (!newImage) {
//        NSLog(@"压缩失败");
//    }
//    return newImage;
    if (image.size.width > size.width) {
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    } else {
        return image;
    }
}
@end
