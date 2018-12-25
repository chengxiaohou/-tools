//
//  CXHCategoryScrollView.m
//  Juan
//
//  Created by 橙晓侯 on 2017/11/18.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import "CXHCategoryScrollView.h"

@implementation CXHCategoryScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark 设置图片、文字、代理
- (void)loadDataWithTitles:(NSArray *_Nullable)titles images:(NSArray *_Nullable)images  didSelectItemBlock:(didSelectItemBlock _Nullable )didSelectItem
{
    MJWeakSelf
    _didSelectItemBlock = didSelectItem;
    
    self.pagingEnabled = 1;
    
    // 需要的item数
    NSInteger itemCount = images.count;
    // 计算 每页的item数
    NSInteger itemPerPage = _linePerPage *_itemPerLine;
    // 计算 页数
    NSInteger pageCount = ceil((CGFloat)itemCount / itemPerPage);
    
    NSInteger pageTag = 1000;
    NSInteger indexTag = 10000;
    
    //=========== 布置scrollVIew上的每一页 ===========
    for (int p = 0; p < pageCount; p++) {
        
        UIView *pageView = [UIView new];
        pageView.tag = p + pageTag;
        [self addSubview:pageView];
        
        // 第一页
        if (p == 0)
        {
            [pageView mas_makeConstraints:^(MASConstraintMaker *make)
             {
                 make.top.bottom.left.equalTo(self);
                 make.width.height.equalTo(self);
             }];
        }
        // 最后一页
        else if (p == pageCount-1)
        {
            UIView *leftView = [self viewWithTag:(p-1) + pageTag];
            [pageView mas_makeConstraints:^(MASConstraintMaker *make)
             {
                 make.left.equalTo(leftView.mas_right);
                 make.top.bottom.right.equalTo(self);
                 make.width.height.equalTo(self);
             }];
        }
        // 中间页
        else
        {
            UIView *leftView = [self viewWithTag:(p-1) + pageTag];
            [pageView mas_makeConstraints:^(MASConstraintMaker *make)
             {
                 make.left.equalTo(leftView.mas_right);
                 make.top.bottom.equalTo(self);
                 make.width.height.equalTo(self);
             }];
        }
        
        //=========== 布置单页内容 ===========
        for (int i = 0; i < itemPerPage; i++)
        {
            EEView *view = [[EEView alloc] init];
            view.backgroundColor = _itemColor ? _itemColor : [UIColor whiteColor];
            [pageView addSubview:view];
            NSInteger index = itemPerPage * p + i;
            view.tag = index + indexTag;
            
            UIImageView *imgView = [UIImageView new];
            imgView.clipsToBounds = 1;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            
            UILabel *lb = [UILabel new];
            lb.textAlignment = NSTextAlignmentCenter;
            lb.font = [UIFont systemFontOfSize:_titleFont <= 0 ? 14 : _titleFont];
            lb.textColor = _titleColor ? _titleColor : [UIColor blackColor];
            
            UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[imgView, lb]];
            stackView.axis = UILayoutConstraintAxisVertical;
            stackView.spacing = _logoSpacing;
            [view addSubview:stackView];
            
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.offset(_logoSize.width);
                make.height.offset(_logoSize.height);
            }];
            
            [lb mas_makeConstraints:^(MASConstraintMaker *make)
             {

             }];
            
            [stackView mas_updateConstraints:^(MASConstraintMaker *make) {
               
                make.center.equalTo(view);
            }];
            
            
            //=========== 图片、文字 ===========
            if (index < images.count)
            {
                // 可能是本地图片或网络图片
                UIImage *img = [UIImage imageNamed:images[i]];
                if (img) {
                    imgView.image = img;
                }
                else
                {
                    SetImageViewImageWithURL_P(imgView, titles[i]);
                }
            }
            if (index < titles.count)
            {
                lb.text = titles[i];
            }
            
            //=========== 点击事件 ===========
            [view setClickEvent:^{
                if (weakSelf.didSelectItemBlock)
                {
                    weakSelf.didSelectItemBlock(index);
                }
            }];
        }
        
        // 执行九宫格布局
        [pageView.subviews mas_distributeSudokuViewsWithFixedItemWidth:_itemSize.width fixedItemHeight:_itemSize.height fixedLineSpacing:_lineSpacing fixedInteritemSpacing:_itemSpacing warpCount:_itemPerLine topSpacing:_insetTop bottomSpacing:_insetBottom leadSpacing:_insetLeft tailSpacing:_insetRight];
        
//        [pageView.subviews mas_distributeSudokuViewsWithFixedItemWidth:100 fixedItemHeight:-1 fixedLineSpacing:3 fixedInteritemSpacing:3 warpCount:3 topSpacing:0 bottomSpacing:0 leadSpacing:0 tailSpacing:0];
    }
}

@end
