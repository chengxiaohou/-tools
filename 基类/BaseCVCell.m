//
//  BaseCVCell.m
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/1/12.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import "BaseCVCell.h"

@implementation BaseCVCell

- (void)setCellInfo:(id)info
{
    // 别写在这
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        for (UIView* next = [self superview]; next; next = next.superview)
        {
            if ([next isKindOfClass:[UICollectionView class]]) {
                
                return _collectionView = (UICollectionView *)next;
            }
        }
    }
    return _collectionView;
}

- (UIViewController *)vc
{
    if (!_vc)
    {
        for (UIView* next = [self superview]; next; next = next.superview)
        {
            UIResponder* nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                
                return _vc = (UIViewController *)nextResponder;
            }
        }
    }
    return _vc;
}

- (NSIndexPath *)indexPath
{
    return [self.collectionView indexPathForCell:self];
}

@end
