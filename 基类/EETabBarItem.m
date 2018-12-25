//
//  EETabBarItem.m
//  MingPian
//
//  Created by 橙晓侯 on 2017/5/10.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import "EETabBarItem.h"

@implementation EETabBarItem

- (void)setImageName:(NSString *)image
{
    [self setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];;
}

- (void)setSelectedImageName:(NSString *)selectedImage
{
    [self setSelectedImage:[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

@end
