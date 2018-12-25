//
//  CXHCategoryScrollView.h
//  Juan
//
//  Created by 橙晓侯 on 2017/11/18.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXHCategoryScrollView : UIScrollView

typedef void (^didSelectItemBlock)(NSInteger index);
@property (nonatomic, copy) didSelectItemBlock _Nullable didSelectItemBlock;

//========================== CV布局参数 ==========================
/** 每行数量 */
@property (assign, nonatomic) IBInspectable             NSInteger itemPerLine;
/** 最大行数 */
@property (assign, nonatomic) IBInspectable             NSInteger linePerPage;
/** 图片的尺寸 */
@property (assign, nonatomic) IBInspectable             CGSize logoSize;
/** 图片文字的距离 */
@property (assign, nonatomic) IBInspectable             CGFloat logoSpacing;
/** 文字字号 */
@property (assign, nonatomic) IBInspectable             CGFloat titleFont;
/** 文字颜色 */
@property (strong, nonatomic, nullable) IBInspectable   UIColor* titleColor;
/** item（背景方块）的尺寸（填0、-1具有特别含义，见Sudoku布局）
    采用设置itemSize撑起整个控件，而不是直接设置整个控件的宽高，是为了满足可能出现的动态宽高的情况 */
@property (assign, nonatomic) IBInspectable             CGSize itemSize;
/** item背景色 可利用此颜色配合间距实现网格效果 */
@property (strong, nonatomic, nullable) IBInspectable   UIColor* itemColor;
@property (assign, nonatomic) IBInspectable             CGFloat lineSpacing;
@property (assign, nonatomic) IBInspectable             CGFloat itemSpacing;

@property (assign, nonatomic) IBInspectable             CGFloat insetTop;
@property (assign, nonatomic) IBInspectable             CGFloat insetBottom;
@property (assign, nonatomic) IBInspectable             CGFloat insetLeft;
@property (assign, nonatomic) IBInspectable             CGFloat insetRight;
/** cell的圆角 */
@property (assign, nonatomic) IBInspectable             CGFloat CornerRadiusOfCell;
//========================== 其他 ==========================



/**
 设置图片、文字、代理

 @param titles 标题
 @param images 图片名或者URL
 @param didSelectItem 点击回调
 */
- (void)loadDataWithTitles:(NSArray *_Nullable)titles images:(NSArray *_Nullable)images  didSelectItemBlock:(didSelectItemBlock _Nullable )didSelectItem;

@end


