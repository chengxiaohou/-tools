//
//  UploadObj.h
//  MingPian
//
//  Created by 橙晓侯 on 2017/6/1.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import "BaseObj.h"

@interface UploadObj : BaseObj

/** 上传后得到的地址 */
@property (strong, nonatomic) NSString *uploadURL;
/** 欲上传的对象 */
@property (strong, nonatomic) id theObject;
/** 是否上传成功 */
@property (assign, nonatomic) BOOL isUploaded;

- (instancetype)initWithURL:(NSString *)url isUploaded:(BOOL)isUploaded;
- (instancetype)initWithImage:(UIImage *)image;
@end
