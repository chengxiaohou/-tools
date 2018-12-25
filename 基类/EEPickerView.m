//
//  EEPickerView.m
//  MingPian
//
//  Created by 橙晓侯 on 2017/6/22.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import "EEPickerView.h"

@interface EEPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>


@end

@implementation EEPickerView 

#pragma mark 单列
+ (EEPickerView *)singlePickerViewWithStrArr:(NSArray *)strArr
{
    EEPickerView *view = [[EEPickerView alloc] init];
    view.strArr = [NSMutableArray arrayWithArray:strArr];
    view.currentStr = [strArr firstObject];// 使不选择也有个初始值
    view.delegate = view;
    view.componentsCount = 1;
    return view;
}

#pragma mark 多列
+ (EEPickerView *)multiPickerViewWithDatas:(NSArray *)datas componentsCount:(NSInteger)componentsCount
{
    EEPickerView *view = [[EEPickerView alloc] init];
    view.datas = [NSMutableArray arrayWithArray:datas];
//    view.currentStr = [datas firstObject];// 使不选择也有个初始值
    view.delegate = view;
    view.componentsCount = componentsCount;
    return view;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _componentsCount;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // 多列
    if (self.componentsCount > 1)
    {
        return [self listForComponent:component].count;
    }
    // 单列
    return _strArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 多列
    if ((self.componentsCount > 1))
    {
        PickerModel *mod = [self modelForRow:row forComponent:component];
        return mod.name;
    }
    // 单列
    return _strArr[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // 多列
    if ((self.componentsCount > 1))
    {
        // 不是最后一个 则刷新下一级数据
        if (component != _componentsCount - 1)
        {
            [self reloadComponent:component+1];// 刷新
            [self selectRow:0 inComponent:component+1 animated:0];// 下级归零
//            [self reloadAllComponents];
        }
        
        if (_selectCallBack)
            self.selectCallBack([self models], row, component);
        
    }
    // 单列
    else
    {
        _currentStr = _strArr[row];
        self.callback(_currentStr ,row, component);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - ......::::::: 多列数据查询封装 :::::::......
#pragma mark 选中的所有模型
- (NSArray *)models
{
    NSLog(@"找全部mod");
    NSArray *list = _datas;
    NSMutableArray *models = [NSMutableArray new];
    // 遍历targetComponent之前的每一列
    for (int component = 0; component < self.componentsCount; component++)
    {
        // 该列选中的行
        NSInteger row = [self selectedRowInComponent:component];
        PickerModel *mod = list[row];
        [models addObject:mod];
        list = mod.subList;// 传递数据 用于下次遍历
    }
    return models;
}

#pragma mark 找到某列的list
- (NSArray *)listForComponent:(NSInteger)targetComponent
{
    NSLog(@"找list");
    NSArray *list = _datas;
    for (int component = 0; component < targetComponent; component++) {
        
        // 该列选中的行
        NSInteger row = [self selectedRowInComponent:component];
        PickerModel *mod = list[row];
        list = mod.subList;// 传递数据 用于下次遍历
    }
    
    return list;
}

#pragma mark 找到某列某行的Mod
- (PickerModel *)modelForRow:(NSInteger)targetRow forComponent:(NSInteger)targetComponent
{
    NSLog(@"%@", [NSString stringWithFormat:@"%d列 %d行",targetComponent, targetRow]);
    PickerModel *mod;
    NSArray *list = _datas;
    for (int component = 0; component < targetComponent; component++) {
        
        // 该列选中的行
        NSInteger row = [self selectedRowInComponent:component];
        mod = list[row];
        list = mod.subList;// 传递数据 用于下次遍历
    }
    
//    mod = list[targetRow];
//    return mod;
    #warning 注意啦：临时办法
    if (targetRow < list.count) {
        mod = list[targetRow];
        return mod;
    }
    else
    {
        return nil;
    }
}

#pragma mark 用字符串组合名字
- (NSString *)combineNameWithString:(NSString *)str
{
    NSString *name = @"";
    int i = 0;
    for (PickerModel *mod in [self models]) {
        name = [NSString stringWithFormat:@"%@%@%@", name, str, mod.name];
        i++;
    }
    return name;
}


@end
