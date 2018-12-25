//
//  Worker.h
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/1/7.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Worker : NSObject

/** 没登录就去登录 */
+ (BOOL)gotoLoginIfNotLogin:(UIViewController *)vc __attribute__((deprecated("Use gotoLoginIfNotLogin instead.(beta)")));
+ (BOOL)gotoLoginIfNotLogin;

/** 从MainSB获得VC */
+ (id)MainSB:(NSString *)viewControllerIdentifer;
/** 从指定SB获得VC */
+ (id)initVC:(NSString *)viewControllerIdentifer fromSB:(NSString *)storyboardName;

/** 正则判断手机号 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//+ (void)loginWithPhone:(NSString *)phoneNumber password:(NSString*)password;

//+ (void)loginWithPhone:(NSString *)phoneNumber password:(NSString*)password successCallback:(void (^)(id responseObject))success errorCallback:(void (^)(NSError * error)) errorBack;
+ (void)presentLoginFrom:(UIViewController *)vc;
/** 按照格式翻译NSDate */
+ (NSString *)stringFromDate:(NSDate *)date formatterOrNil:(NSString *)formatterStr;

+ (NSString *)stringFromTimeInterval:(double)timeInterval formatterOrNil:(NSString *)formatterStr;

+ (UIImage *)changeImage:(UIImage *)image toScale:(CGFloat)scale;
/** 替换属性字（替换长度范围：1） */
+ (NSAttributedString *)replaceWithString:(NSString *)newStr atIndex:(NSInteger)location from:(UILabel *)ATM;
/** 随机验证码 */
+ (NSString *)generateIdCode:(NSInteger)length;
/** 随机字母数字 */
+ (NSString *)randomCode:(NSInteger)length;

/** 数字化处理(大小限制) */
+ (BOOL)inputMathsString:(NSString *)string inRange:(NSRange)range ofText:(NSString *)text withDotLength:(NSInteger)length;

/** AFN报错处理 */
+ (NSString *)convertErrorMessage:(NSString *)string;
/** 弹输入框 */
+ (void)showTFAlertTitle:(NSString *)title message:(NSString *)message handle:(void (^)(NSString *text))handle;
/** 当前VC */
+ (UIViewController *)currentController;
/** json字符串 转 字典 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/** 毫秒转分钟 */
+ (NSString*)Time2String:(NSInteger)nTime;
/** 数组随机化 */
+ (NSMutableArray *)randomArray:(NSMutableArray *)arr;
/** 倒序排列 */
+ (NSMutableArray *)reverseArray:(NSMutableArray *)arr;
/** 展示欢迎页 传入image或图片名*/
+ (void)showWelcomeView:(NSArray *)arr;
/** 字典转JsonString */
+ (NSString *)jsonStringFromNSString:(NSDictionary *)dic;
/** NSData -> 10进制长整型 */
+ (long)convertDataToLongInt:(NSData *)data;
/** NSData转16进制字符串 */
+ (NSString *)convertDataToHexStr:(NSData *)data;
/** 把数字转化成2、8、16进制数字字符串 */
+ (NSString *)systemStringFromNumber:(int)n withSystem:(int)system;
/** 智能VC跳转 */
+ (void)showVC:(UIViewController *)vc;
+ (void)gotoNewVC:(UIViewController *)newVC fromOldVC:(UIViewController *)oldVC;
/** 时间戳转友好的倒计时 */
+ (NSString *)friendlyTimeFromTimeInterval:(long long)timeInterval;
/** 当前VC */
+ (UIViewController *)theTopVC;
/** 拍照或相册 */
+ (void)showImgPickerActionSheet __attribute__((deprecated("Use VDCameraAndPhotoTool instead.")));
/** 从URL分割出参数 */
+ (NSMutableDictionary *)getParametersFromURL:(NSString *)strUrl;
/** 生成二维码 */
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize;
/** 从URL缓存图片 */
+ (void)loadImageFromURL:(NSString *)url
                progress:(void (^)(NSInteger receivedSize, NSInteger expectedSize))progress
                 success:(void (^)(UIImage *image, SDImageCacheType cacheType, NSURL *imageURL))success
                 failure:(void (^)(UIImage *image, SDImageCacheType cacheType, NSURL *imageURL, NSError *error))failure;


/** 从URL获取图片大小 */
+ (CGSize)imageSizeFromURL:(NSString *)url;
/** 判断url是图片 */
+ (BOOL)URLIsImage:(NSString *)url;
@end
