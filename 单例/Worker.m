//
//  Worker.m
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/1/7.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import "Worker.h"

@implementation Worker

#pragma mark 从MainSB获得VC
+ (id)MainSB:(NSString *)viewControllerIdentifer{
    
    UIStoryboard *SB = [UIStoryboard storyboardWithName:SBName bundle:nil];
    
    return [SB instantiateViewControllerWithIdentifier:viewControllerIdentifer];
}

#pragma mark 从指定SB获得VC
+ (id)initVC:(NSString *)viewControllerIdentifer fromSB:(NSString *)storyboardName{
    
    UIStoryboard *SB = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    
    return [SB instantiateViewControllerWithIdentifier:viewControllerIdentifer];
}

//判断是否为电话号码 原正则的方法由于经常有新的号段出现，所以不再使用
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    // 11位号码
    if (mobileNum.length == 11)
    {
        // 判断第一位是1
        if ([[mobileNum substringToIndex:1] isEqualToString:@"1"])
        {
            return 1;
        }
    }
    return 0;
}

#pragma mark 去登录(预废除)
+ (void)presentLoginFrom:(UIViewController *)vc
{
    if (!USER.isLogin)
    {
        [vc presentViewController:[self MainSB:SBLoginName] animated:YES completion:nil];
    }
    else
    {
        [MBProgressHUD showMessage:@"您已登录" toView:Window];
    }
    
}

#pragma mark 去登陆（未登陆）
+ (BOOL)gotoLoginIfNotLogin:(UIViewController *)vc
{
    if (!USER.isLogin)
    {
        UINavigationController *navc = [Worker MainSB:SBLoginName];
        
        if (vc)
        {
            [vc presentViewController:navc animated:YES completion:nil];
        }
        else
        {
//            [ROOT_TBC presentViewController:navc animated:YES completion:nil];
        }
        
        
    }
    return USER.isLogin;
}

#pragma mark 去登陆（未登陆）
+ (BOOL)gotoLoginIfNotLogin
{
    // 为登录
    if (!USER.isLogin)
    {
        UIViewController *vc = TopVC.navigationController ? TopVC.navigationController : TopVC;
        
        if ([vc isKindOfClass:[UIAlertController class]]) {
            
            NSLog(@"报幕员：出现了罕见的情况，但不必紧张");
            return USER.isLogin;// 也有可能登陆页正好有个弹窗，不作处理了
        }
        // 如果当前不是登录系列页面，则跳转登录系列
        if (![vc.restorationIdentifier isEqualToString:SBLoginName]) {
            
            UINavigationController *navc = [Worker MainSB:SBLoginName];
            [TopVC presentViewController:navc animated:YES completion:nil];
        }
    }
    NSLog(@"gotoLoginIfNotLogin被驳回，用户已登录%@", USER);
    return USER.isLogin;
}


//========================== 工具箱 ==========================
#pragma mark 时间转换 double
+ (NSString *)stringFromTimeInterval:(double)timeInterval formatterOrNil:(NSString *)formatterStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (formatterStr) {
        
        [formatter setDateFormat:formatterStr];
    }
    else
    {
        [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
    return [formatter stringFromDate:date];
}

#pragma mark 按照格式翻译NSDate
+ (NSString *)stringFromDate:(NSDate *)date formatterOrNil:(NSString *)formatterStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (formatterStr) {
        
        [formatter setDateFormat:formatterStr];
    }
    else
    {
        [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    }
    
    return [formatter stringFromDate:date];
}

#pragma mark 图片image改变大小
+ (UIImage *)changeImage:(UIImage *)image toScale:(CGFloat)scale
{
    NSData *imageData = UIImagePNGRepresentation(image);
    return [UIImage imageWithData:imageData scale:scale];
}

#pragma mark 替换属性字（替换长度范围：1）
+ (NSAttributedString *)replaceWithString:(NSString *)newStr atIndex:(NSInteger)location from:(UILabel *)ATM
{
    NSMutableAttributedString *MAString = [[NSMutableAttributedString alloc] initWithAttributedString:ATM.attributedText];
    [MAString replaceCharactersInRange:NSMakeRange(location, 1) withString:newStr];
    return MAString;
}



#pragma mark AFN报错处理
+ (NSString *)convertErrorMessage:(NSString *)string
{
    if ([string isEqualToString:@"请求超时。"])
    {
        return @"请求超时";
    }
    else if ([string isEqualToString:@"未能读取数据，因为它的格式不正确。"])
    {
        return @"服务器异常";
    }
    else if ([string isEqualToString:@"网络连接已中断。"])
    {
        return @"请检查您的网络";
    }
    else
    {
        return string;
    }
}


#pragma mark 随机验证码
+ (NSString *)generateIdCode:(NSInteger)length
{
    
    NSMutableString *code = [NSMutableString string];
    NSArray *arr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    for (int i = 0; i < length; i++)
    {
        int a = arc4random()%9;// 0~9
        [code appendString:arr[a]];
    }
    return code;
}

#pragma mark 随机字母数字
+ (NSString *)randomCode:(NSInteger)length
{
    
    NSMutableString *code = [NSMutableString string];
    NSArray *arr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    for (int i = 0; i < length; i++)
    {
        int a = arc4random() % (arr.count-1);
        [code appendString:arr[a]];
    }
    return code;
}


#pragma mark 数字化处理(大小限制)
+ (BOOL)inputMathsString:(NSString *)string inRange:(NSRange)range ofText:(NSString *)text withDotLength:(NSInteger)length
{
    //是否允许小数点
    if (length == 0)
    {
        if (![@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@""] containsObject:string])
        {
            [MBProgressHUD showMessage:@"请输入数字" toView:Window];
            return NO;// 拦截原因：非数字 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        }
    }
    else
    {
        if (![@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@".",@""] containsObject:string])
        {
            [MBProgressHUD showMessage:@"请输入数字" toView:Window];
            return NO;// 拦截原因：非数字 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        }
    }
    
    
    
    // 第一个字符是"."
    if (range.location == 0 && [string isEqualToString:@"."]) {
        return NO;
    }
    
    // 第一个是0 后面只能跟"."和删除
    if (range.location == 1 && [[text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]) {
        
        if (![string isEqualToString:@"."] && ![string isEqualToString:@""]) {
            return NO;
        }
        
    }
    
    if ([text containsString:@"."])
    {
        // 只许输入一个点
        if ([string isEqualToString:@"."])
        {
            return NO;
        }
        // 金额小数点后只许输入2位
        NSRange dotRange = [text rangeOfString:@"."];
        
        // 黄金小数点后只许输入2位
        if (text.length - dotRange.location > length)
        {
            return [string isEqualToString:@""] ? YES : NO;// 除了退格键，禁止继续输入
        }
    }
    
    return YES;
}

#pragma mark 弹出输入框
+ (void)showTFAlertTitle:(NSString *)title message:(NSString *)message handle:(void (^)(NSString *text))handle
{
    // 带TF的
    __block UITextField *inputTF;
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [ac addTextFieldWithConfigurationHandler:^(UITextField * textField) {
        
        inputTF = textField;
        textField.placeholder = @"请输入";
    }];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        handle(inputTF.text);
        
    }]];
    
    [[self currentController] presentViewController:ac animated:YES completion:nil];
    
}

#pragma mark 当前主VC
+ (UIViewController *)currentController {
    UIViewController *result = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        
        for (UIWindow *temWin in windows) {
            if (temWin.windowLevel == UIWindowLevelNormal) {
                window = temWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nestResponder = [frontView nextResponder];
    if ([nestResponder isKindOfClass:[UIViewController class]]) {
        result = nestResponder;
    } else {
        result = window.rootViewController;
    }
    return result;
}

#pragma mark json字符串 转 字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    
    return dic;
}

+ (NSString*)Time2String:(NSInteger)nTime
{
    int seconds = (int)nTime/1000;
    int minute = 0;
    if (seconds >= 60) {
        int index = seconds / 60;
        minute = index;
        seconds = seconds - index * 60;
    }
    return [NSString stringWithFormat:@"%02d:%02d", minute, seconds];
}

#pragma mark 数组随机化
+ (NSMutableArray *)randomArray:(NSMutableArray *)arr
{
    for (int n = arr.count-1; n >= 1; n--)
    {
        // 抽签拿一个对象
        int index = arc4random() % n;
        id obj = [arr objectAtIndex:index];
        // 从数组中删掉它
        [arr removeObject:obj];
        // 再把它加到最后面
        [arr addObject:obj];
        
        // n每次减1后，表示还剩n个对象没有被处理过，下一轮对这前n个对象抽签处理
    }
    // 此方法可以申精
    return arr;
}

#pragma mark 倒序排列
+ (NSMutableArray *)reverseArray:(NSMutableArray *)arr
{
    NSMutableArray *newArr = [NSMutableArray new];
    for (NSInteger i = arr.count - 1; i > 0; i--)
    {
        [newArr addObject:arr[i]];
    }
    return newArr;
}
//+ (void)showTFAlert:(UIViewController *)vc handle:(void (^)(NSString *str))handle

#pragma mark 展示欢迎页
+ (void)showWelcomeView:(NSArray *)objects
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    scrollView.contentSize = CGSizeMake(objects.count * Width, Height);
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor lightGrayColor];
    
    [Window addSubview:scrollView];
    
    NSInteger i = 0;
    for (id obj in objects) {
        
        EEImageView *imgView = [[EEImageView alloc] initWithFrame:CGRectMake(i * Width, 0, Width, Height)];
        [scrollView addSubview:imgView];
        // 传入图片就加载图片
        if ([obj isKindOfClass:[UIImage class]]) {
            
            UIImage *img = (UIImage *)obj;
            [imgView setImage:img];
        }
        // 传入字符串就按名字加载本地图片
        else if ([obj isKindOfClass:[NSString class]])
        {
            UIImage *image = [UIImage imageNamed:obj];
            [imgView setImage:image];
        }
        
        // 最后一张图的处理
        if (objects.count == i+1) {
            
          // 点击逐渐隐藏
            [imgView setClickEvent:^{
                
                [UIView animateWithDuration:0.5 animations:^{
                    
                    scrollView.alpha = 0;
                    
                } completion:^(BOOL finished) {
                    
                    [scrollView removeFromSuperview];
                    
                }];
                
            }];
            
        }
        
        i++;
    }
}

#pragma mark 字典转JsonString
+ (NSString *)jsonStringFromNSString:(NSDictionary *)dic
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    return jsonString;
}


#pragma mark - ......::::::: 数据转换 :::::::......

#pragma mark NSData -> 10进制长整型
+ (long)convertDataToLongInt:(NSData *)data
{
    // NSData -> 16进制字符串
    NSString *hexString = [Worker convertDataToHexStr:data];
    
    // 16进制字符串 -> 10进制长整型
    long i = strtoul([hexString UTF8String],0,16);
    
    return i;
}

#pragma mark NSData转16进制字符串
+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

#pragma mark 把数字转化成2、8、16进制数字字符串
+ (NSString *)systemStringFromNumber:(int)n withSystem:(int)system
{
    NSMutableString *mstring = [NSMutableString stringWithFormat:@"X"];
    NSString *bitString = [NSString stringWithFormat:@"0123456789ABCDEF"];
    long long int tmp = n,num = system, p, a, b;
    if(num ==2)
    {
        a = 1;
        b = 1;
    }else if (num == 8)
    {
        a = 7;
        b = 3;
    }else if (num == 16)
    {
        a = 15;
        b = 4;
    }else
    {
        NSLog(@"您输入的进制错误!请输入2,8,16进制!");
        return nil;
    }
    while(tmp!=0)
    {
        p=tmp&a;
        NSString *str1=[NSString stringWithFormat:@"%c",[bitString characterAtIndex:p]];
        [mstring insertString:str1 atIndex:0];
        tmp=tmp>>b;
    }
    NSString *result = [mstring substringWithRange:NSMakeRange(0, [mstring length]-1)];
    
    if (result.length % 2 != 0 ) {
        result = [NSString stringWithFormat:@"0%@",result];// 确保输出的是偶数位
    }
    
    return result;
}



#pragma mark 智能VC跳转
+ (void)showVC:(UIViewController *)vc
{
    // 如果TopVC是导航C 则直接push
    if ([TopVC isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController *)TopVC;
        [nav pushViewController:vc animated:YES];
    }
    // 是TopVC带导航C的VC 则智能push
    else if (TopVC.navigationController)
    {
        // 如果对方是Nav 用present
        if ([vc isKindOfClass:[UINavigationController class]])
            [TopVC presentViewController:vc animated:1 completion:nil];
        // 如果对方不是Nav 用push
        else [TopVC.navigationController pushViewController:vc animated:YES];
    }
    // 如果TopVC是不带导航C的VC 则present
    else if (!TopVC.navigationController)
    {
        [TopVC presentViewController:vc animated:YES completion:nil];
    }
}

+ (void)gotoNewVC:(UIViewController *)newVC fromOldVC:(UIViewController *)oldVC
{
    // 如果是导航C 则直接push
    if ([oldVC isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController *)oldVC;
        [nav pushViewController:newVC animated:YES];
    }
    // 是带导航C的VC 则智能push
    else if (oldVC.navigationController)
    {
        [oldVC.navigationController pushViewController:newVC animated:YES];
    }
    // 如果是不带导航C的VC 则present
    else if (!oldVC.navigationController)
    {
        [oldVC presentViewController:newVC animated:YES completion:nil];
    }
}

#pragma mark 时间戳转友好的倒计时
+ (NSString *)friendlyTimeFromTimeInterval:(long long)timeInterval {
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = timeInterval/1000;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    NSInteger second = time;
    // 转秒
    if (second < 10) {
        return @"刚刚";
    }
    else if (second < 60) {
        return [NSString stringWithFormat:@"%ld秒前",(long)second];
    }
    // 转分钟
    NSInteger minute = time/60;
    if (minute < 60) {
        return [NSString stringWithFormat:@"%ld分钟前",(long)minute];
    }
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",(long)hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前",(long)days];
    }
    //秒转月
    NSInteger months = time/3600/24/30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld月前",(long)months];
    }
    //秒转年
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld年前",(long)years];
}

#pragma mark 当前VC
+ (UIViewController *)theTopVC
{
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [Worker findTopViewController:viewController];
}

+ (UIViewController*)findTopViewController:(UIViewController*)vc {
    
    if (vc.presentedViewController) {
        
        // Return presented view controller
        return [Worker findTopViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [Worker findTopViewController:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [Worker findTopViewController:svc.topViewController];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [Worker findTopViewController:svc.selectedViewController];
        else
            return vc;
        
    } else {
        
        // Unknown view controller type, return last child view controller
        return vc;
        
    }
    
}


#pragma mark - 显示选择照片提示sheet
+ (void)showImgPickerActionSheet
{
    UIViewController *vc = TopVC;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:IS_IPHONE ? 0 : 1];
    UIImagePickerController *imaPic = [[UIImagePickerController alloc] init];
    imaPic.delegate = vc;
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            imaPic.sourceType = UIImagePickerControllerSourceTypeCamera;
            [vc presentViewController:imaPic animated:YES completion:nil];
        }
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            imaPic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [vc presentViewController:imaPic animated:YES completion:nil];
        }
        
    }]];
    
    [vc presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark 从URL分割出参数
+ (NSMutableDictionary *)getParametersFromURL:(NSString *)strUrl
{
    //获取问号的位置，问号后是参数列表
    NSRange range = [strUrl rangeOfString:@"?"];
    
    //获取参数列表
    NSString *propertys = [strUrl substringFromIndex:(int)(range.location+1)];
    
    //进行字符串的拆分，通过&来拆分，把每个参数分开
    NSArray *subArray = [propertys componentsSeparatedByString:@"&"];
    
    //把subArray转换为字典
    //tempDic中存放一个URL中转换的键值对
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:4];
    
    for (int j = 0 ; j < subArray.count; j++)
    {
        //在通过=拆分键和值
        NSArray *dicArray = [subArray[j] componentsSeparatedByString:@"="];
        // 判断是否有一对键值
        if (dicArray.count == 2) {
            //给字典加入元素
            [dic setObject:dicArray[1] forKey:dicArray[0]];
        }
    }
    NSLog(@"打印参数列表生成的字典：\n%@", dic);
    return dic;
}

#pragma mark 生成二维码
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];//通过kvo方式给一个字符串，生成二维码
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];//设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    CIImage *outPutImage = [filter outputImage];//拿到二维码图片
    return [self createNonInterpolatedUIImageFormCIImage:outPutImage withSize:Imagesize waterImageSize:waterImagesize];
}
#pragma mark 生成二维码主方法
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size waterImageSize:(CGFloat)waterImagesize{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    //CGBitmapContextCreate(void * _Nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
    //width：图片宽度像素
    //height：图片高度像素
    //bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    //bitmapInfo：指定的位图应该包含一个alpha通道。
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    //给二维码加 logo 图
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    [outputImage drawInRect:CGRectMake(0,0 , size, size)];
    //logo图
    UIImage *waterimage = [UIImage imageNamed:@"icon_imgApp"];
    //把logo图画到生成的二维码图片上，注意尺寸不要太大（最大不超过二维码图片的%30），太大会造成扫不出来
    [waterimage drawInRect:CGRectMake((size-waterImagesize)/2.0, (size-waterImagesize)/2.0, waterImagesize, waterImagesize)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}

#pragma mark 从URL缓存图片
+ (void)loadImageFromURL:(NSString *)url
                progress:(void (^)(NSInteger receivedSize, NSInteger expectedSize))progress
                 success:(void (^)(UIImage *image, SDImageCacheType cacheType, NSURL *imageURL))success
                 failure:(void (^)(UIImage *image, SDImageCacheType cacheType, NSURL *imageURL, NSError *error))failure
{
    EEImageView *temp = [EEImageView new];
    
    [temp ee_setImageWithURL:url placeholder:nil progress:nil success:^(UIImage *image, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (success) success(image, cacheType, imageURL);
        NSLog(@"Worker：这个图片偷偷的缓存好了%@", url);
        
    } failure:^(UIImage *image, SDImageCacheType cacheType, NSURL *imageURL, NSError *error) {
        
        if (failure) failure(image, cacheType, imageURL, error);
        NSLog(@"Worker：图片缓存失败%@", url);
    }];
}

#pragma mark 从URL获取图片大小
+ (CGSize)imageSizeFromURL:(NSString *)url
{
    NSURL *URL = [NSURL URLWithString:url];
    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)URL, NULL);
    CFDictionaryRef imageMetaData = CGImageSourceCopyPropertiesAtIndex(source,0,NULL);
    NSDictionary *dic = (__bridge_transfer  NSDictionary*)imageMetaData;
    
    CGFloat H = [dic[@"PixelHeight"] floatValue];
    CGFloat W = [dic[@"PixelWidth"] floatValue];
    
    return CGSizeMake(W, H);
}

#pragma mark 判断url是图片
+ (BOOL)URLIsImage:(NSString *)url
{
    BOOL isImage = NO;
    if (([url containsString:@"http"] && [url containsString:@"://"]))
    {
        for (NSString *imageType in @[@"png",@"PNG",@"jpeg",@"JPEG",@"gif",@"GIF"]) {
            if ([url containsString:imageType]) {
                isImage = 1;
                break;
            }
        }
    }
    return isImage;
}

@end
