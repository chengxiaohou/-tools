//
//  NSArray+MasonryEE.m
//  Juan
//
//  Created by 橙晓侯 on 2017/10/30.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import "NSArray+MasonryEE.h"

@implementation NSArray (MasonryEE)

- (MAS_VIEW *)star_commonSuperviewOfViews {
    
    
    
    if (self.count == 1) {
        
        return ((MAS_VIEW *)self.firstObject).superview;
        
    }
    
    
    
    MAS_VIEW *commonSuperview = nil;
    
    MAS_VIEW *previousView = nil;
    
    for (id object in self) {
        
        if ([object isKindOfClass:[MAS_VIEW class]]) {
            
            MAS_VIEW *view = (MAS_VIEW *)object;
            
            if (previousView) {
                
                commonSuperview = [view mas_closestCommonSuperview:commonSuperview];
                
            } else {
                
                commonSuperview = view;
                
            }
            
            previousView = view;
            
        }
        
    }
    
    NSAssert(commonSuperview, @"Can't constrain views that do not share a common superview. Make sure that all the views in this array have been added into the same view hierarchy.");
    
    return commonSuperview;
    
}

/**
 
 *  九宫格布局 固定ItemSize 固定ItemSpacing
 *  可由九宫格的内容控制SuperView的大小
 *  如果warpCount大于[self count]，该方法将会用空白的View填充到superview中
 *
 *  @param fixedItemWidth        固定宽度，如果设置成0，则表示自适应
 *  @param fixedItemHeight       固定高度，如果设置成0，则表示自适应；设置成-1，宽高相等
 *  @param fixedLineSpacing      行间距
 *  @param fixedInteritemSpacing 列间距
 *  @param warpCount             折行点
 *  @param topSpacing            顶间距
 *  @param bottomSpacing         底间距
 *  @param leadSpacing           左间距
 *  @param tailSpacing           右间距
 *
 *  @return 一般情况下会返回[self copy], 如果warpCount大于[self count]，则会返回一个被空白view填充过的数组，可以让你循环调用removeFromSuperview或者干一些其他的事情;
 */

- (NSArray *)mas_distributeSudokuViewsWithFixedItemWidth:(CGFloat)fixedItemWidth
                                         fixedItemHeight:(CGFloat)fixedItemHeight
                                        fixedLineSpacing:(CGFloat)fixedLineSpacing
                                   fixedInteritemSpacing:(CGFloat)fixedInteritemSpacing
                                               warpCount:(NSInteger)warpCount
                                              topSpacing:(CGFloat)topSpacing
                                           bottomSpacing:(CGFloat)bottomSpacing
                                             leadSpacing:(CGFloat)leadSpacing
                                             tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 1) {
        return self.copy;
    }
    if (warpCount < 1) {
        NSAssert(false, @"warp count need to bigger than zero");
        return self.copy;
    }
    
    MAS_VIEW *tempSuperView = [self star_commonSuperviewOfViews];
    
    // 排除隐藏的view，实现隐藏特性：隐藏的subview可以不占用高度
    NSMutableArray *tempViews = [NSMutableArray new];
    for (UIView *view in self)
    {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {}];
        if (!view.hidden) {
            [tempViews addObject:view];
        }
    }

//    NSMutableArray *tempViews = self.mutableCopy;
    if (warpCount > self.count) {
        for (int i = 0; i < warpCount - self.count; i++) {
            MAS_VIEW *tempView = [[MAS_VIEW alloc] init];
            [tempSuperView addSubview:tempView];
            [tempViews addObject:tempView];
        }
    }
    
    NSInteger columnCount = warpCount;
    NSInteger rowCount = tempViews.count % columnCount == 0 ? tempViews.count / columnCount : tempViews.count / columnCount + 1;
    
    MAS_VIEW *prev;
    for (int i = 0; i < tempViews.count; i++) {
        
        MAS_VIEW *v = tempViews[i];
        NSInteger currentRow = i / columnCount;
        NSInteger currentColumn = i % columnCount;
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            if (prev) {
                // 固定宽度
                make.width.equalTo(prev);
                make.height.equalTo(prev);
            }
            else
            {
                // 如果写的item高宽分别是0，则表示自适应
                if (fixedItemWidth > 0) {
                    make.width.equalTo(@(fixedItemWidth));
                    make.width.lessThanOrEqualTo(tempSuperView).multipliedBy(3);
                }
                if (fixedItemHeight > 0) {
                    make.height.equalTo(@(fixedItemHeight));
                }
                // 新增 fixedItemHeight为-1表示 设置高等于宽
                if (fixedItemHeight == -1) {
                    make.height.equalTo(v.mas_width);
                }
            }
            
            // 第一行
            if (currentRow == 0) {
                make.top.equalTo(tempSuperView).offset(topSpacing);
            }
            // 最后一行
            if (currentRow == rowCount - 1) {
                // 如果只有一行
                if (currentRow != 0 && i-columnCount >= 0) {
                    make.top.equalTo(((MAS_VIEW *)tempViews[i-columnCount]).mas_bottom).offset(fixedLineSpacing);
                }
                make.bottom.equalTo(tempSuperView).offset(-bottomSpacing);
            }
            // 中间的若干行
            if (currentRow != 0 && currentRow != rowCount - 1) {
                make.top.equalTo(((MAS_VIEW *)tempViews[i-columnCount]).mas_bottom).offset(fixedLineSpacing);
            }
            
            // 第一列
            if (currentColumn == 0) {
                make.left.equalTo(tempSuperView).offset(leadSpacing);
            }
            // 最后一列
            if (currentColumn == columnCount - 1) {
                // 如果只有一列
                if (currentColumn != 0) {
                    make.left.equalTo(prev.mas_right).offset(fixedInteritemSpacing);
                }
                // 仅自适应宽度时需要贴右边界
                if (fixedItemWidth == 0)
                {
                    make.right.equalTo(tempSuperView).offset(-tailSpacing);
                }
                
            }
            // 中间若干列
            if (currentColumn != 0 && currentColumn != warpCount - 1) {
                make.left.equalTo(prev.mas_right).offset(fixedInteritemSpacing);
            }
        }];
        prev = v;
    }
    return tempViews;
}

@end
