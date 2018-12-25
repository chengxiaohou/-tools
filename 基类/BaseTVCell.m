//
//  BaseTVCell.m
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/1/12.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import "BaseTVCell.h"

@implementation BaseTVCell

- (void)setCellInfo:(id)info
{
    // 别写在这
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.window endEditing:YES];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        UIView* next = [self superview];
        while (next) {
            NSLog(@"000 %@", next);
            if ([next isKindOfClass:[UITableView class]]) {
                
                return _tableView = (UITableView *)next;
            }
            next = next.superview;
        }
//        for (UIView* next = [self superview]; next; next = next.superview)
//        {
//            NSLog(@"000 %@", next);
//            if ([next isKindOfClass:[UITableView class]]) {
//                
//                return _tableView = (UITableView *)next;
//            }
//        }
    }
    return _tableView;
}

- (UIViewController *)vc
{
    if (!_vc)// 这里用了懒加载，希望不会出现vc改变的问题
    {
        // 不一定work 因为setcellinfo的时候没有superview
        for (UIView* next = [self superview]; next; next = next.superview)
        {
            UIResponder* nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                
                return _vc = (UIViewController *)nextResponder;
            }
        }
        // 万一没找到就只好用TopVC
        if (!_vc) {
            return _vc = TopVC;
        }
    }
    return _vc;
}

- (NSIndexPath *)indexPath
{
    return [self.tableView indexPathForCell:self];
}
@end
