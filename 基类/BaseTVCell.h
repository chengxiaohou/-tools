//
//  BaseTVCell.h
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/1/12.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTVCell : UITableViewCell

/** 所属tableView 实验中，不一定有效 */
@property (strong, nonatomic) UITableView *tableView;
/** 所在indexPath */
@property (strong, nonatomic) NSIndexPath *indexPath;
/** 所属ViewController */
@property (strong, nonatomic) UIViewController *vc;


- (void)setCellInfo:(id)info;

@end
