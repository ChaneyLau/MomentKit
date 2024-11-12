//
//  UIScrollView+Category.m
//  MomentKit
//
//  Created by LEA on 2019/3/26.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "UIScrollView+Category.h"

@implementation UIScrollView (Category)

- (void)scrollToBottomAnimated:(BOOL)animated
{
    CGPoint offset = self.contentOffset;
    offset.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:offset animated:animated];
}

@end
