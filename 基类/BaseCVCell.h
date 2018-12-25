//
//  BaseCVCell.h
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/1/12.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCVCell : UICollectionViewCell

/** 所属tableView */
@property (strong, nonatomic) UICollectionView *collectionView;
/** 所在indexPath */
@property (strong, nonatomic) NSIndexPath *indexPath;
/** 所属ViewController */
@property (strong, nonatomic) UIViewController *vc;

- (void)setCellInfo:(id)info;

@end
