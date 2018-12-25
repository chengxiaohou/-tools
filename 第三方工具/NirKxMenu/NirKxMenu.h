//
//  NirKxMenu.m
//  NirKxMenu
//
//  Created by Nirvana on 9/25/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KxMenuItem : NSObject

@property (readwrite, nonatomic, strong) UIImage *image;
@property (readwrite, nonatomic, strong) NSString *title;
@property (readwrite, nonatomic, weak) id target;
//@property (readwrite, nonatomic) SEL action; // 修改成代码块了，不再使用action -橙晓侯
@property (readwrite, nonatomic, strong) UIColor *foreColor;
@property (readwrite, nonatomic) NSTextAlignment alignment;
/** 点击事件 */
@property (strong, nonatomic) void (^clickEvent)(void);

+ (instancetype) menuItem:(NSString *) title
                    image:(UIImage *) image
                   target:(id)target
               clickEvent:(void (^)(void))handle;
@end

typedef struct{
    CGFloat R;
    CGFloat G;
    CGFloat B;

}Color;

typedef struct {
    CGFloat arrowSize;
    CGFloat marginXSpacing;
    CGFloat marginYSpacing;
    CGFloat intervalSpacing;
    CGFloat menuCornerRadius;
    Boolean maskToBackground;
    Boolean shadowOfMenu;
    Boolean hasSeperatorLine;
    Boolean seperatorLineHasInsets;
    Color textColor;
    Color menuBackgroundColor;
    
}OptionalConfiguration;


@interface KxMenuView : UIView

@property (atomic, assign) OptionalConfiguration kxMenuViewOptions;

@end

@interface KxMenu : NSObject

+ (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
              menuItems:(NSArray *)menuItems
                withOptions:(OptionalConfiguration) options;

+ (void) dismissMenu;

+ (UIColor *) tintColor;
+ (void) setTintColor: (UIColor *) tintColor;

+ (UIFont *) titleFont;
+ (void) setTitleFont: (UIFont *) titleFont;

@end
