//
//  SDCycleScrollView+EE.m
//  MingPian
//
//  Created by 橙晓侯 on 2017/5/19.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import "SDCycleScrollView+EE.h"

@implementation SDCycleScrollView (EE)

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UICollectionView *mainView = [self valueForKey:@"mainView"];
    
    int itemIndex = (scrollView.contentOffset.x + mainView.width * 0.5) / mainView.width;
    
    NSArray * imagePathsGroup = [self valueForKey:@"imagePathsGroup"];
    int indexOnPageControl = itemIndex % imagePathsGroup.count;
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
        [self.delegate cycleScrollView:self didScrollToIndex:indexOnPageControl];
    }
}
@end
